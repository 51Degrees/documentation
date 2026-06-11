#!/usr/bin/env node
// Remove unreferenced CSS selectors from the documentation design-system
// stylesheet (docs-main.css) using PurgeCSS, scanning the HTML that
// Doxygen has actually generated for this build.
//
// This mirrors the website's scripts/purge-css.js, adapted to the
// documentation pipeline:
//
//   * The website's CSS and content (Razor pages) live in the same source
//     tree, so it purges at publish time against the source. The
//     documentation pages are *generated* by Doxygen, so the consuming
//     HTML only exists after the docs build. This script therefore runs
//     inside ci/generate-documentation.ps1, after Doxygen, against the
//     generated tree (gh-pages/<version>).
//
//   * docs-main.css is the full 51Degrees design system. A doxygen page
//     uses only the chrome subset (header/footer/search/sidenav defined
//     in docs/header.html + docs/footer.html) plus whatever the body
//     markup references. Everything else (configurator panels, demo
//     widgets, marketing components, ...) is unused on /documentation/*
//     and is what this removes.
//
//   * The generated *.js (doxygen's navtree/search and the 51Degrees
//     behaviours) is scanned as content too, so class names a script adds
//     at runtime are kept when they appear as string literals. A small
//     standard safelist covers the state classes toggled purely in JS.
//
// Minification is left to the existing csso pass in minify-docs-assets.js,
// which runs immediately after this and produces docs-main.min.css from
// the purged docs-main.css. So the order is purge -> minify.
//
// Usage:
//   node ci/purge-docs-css.js <generated-tree> [--report <path>]
//
// <generated-tree> is the directory to scan and whose docs-main.css
// copies are purged in place (e.g. gh-pages/4.5).

const fs = require('fs')
const path = require('path')
const zlib = require('zlib')
const { PurgeCSS } = require('purgecss')

function arg(name, defaultValue) {
  const idx = process.argv.indexOf('--' + name)
  if (idx >= 0 && process.argv[idx + 1]) return process.argv[idx + 1]
  return defaultValue
}

const ROOT = process.argv[2]
if (!ROOT) {
  console.error('usage: node ci/purge-docs-css.js <generated-tree> [--report <path>]')
  process.exit(2)
}
const rootStat = fs.existsSync(ROOT) ? fs.statSync(ROOT) : null
if (!rootStat || !rootStat.isDirectory()) {
  console.error(`purge-docs-css: "${ROOT}" is not a directory`)
  process.exit(2)
}
const SCRIPT_DIR = __dirname
const REPORT_PATH = path.resolve(arg('report', path.join(SCRIPT_DIR, 'purge-docs-css.report.json')))

// Forward slashes for glob, scoped strictly to the version tree passed in
// so sibling versions already published under gh-pages are left untouched.
const GLOB_ROOT = path.resolve(ROOT).replace(/\\/g, '/')

// Content the design-system classes can be referenced from. The HTML is
// the source of truth (header/footer chrome is baked into every page).
// The JS is scanned so a class a script attaches at runtime is kept when
// it appears as a literal. At this stage the tree holds only the original
// *.js / *.css (the .min.* siblings are produced by the later minify
// pass), so no .min exclusion is needed.
const contentGlobs = [
  GLOB_ROOT + '/**/*.html',
  GLOB_ROOT + '/**/*.js',
]

// Only the unminified design-system stylesheet. `docs-main.css` does not
// match `docs-main.min.css`, and a version-scoped root means we never
// touch other versions' copies.
const cssGlobs = [GLOB_ROOT + '/**/docs-main.css']

;(async () => {
  const result = await new PurgeCSS().purge({
    content: contentGlobs,
    css: cssGlobs,
    safelist: {
      standard: [
        // State classes toggled in JS that may not appear in any static
        // HTML snapshot. No-ops if absent from the CSS, kept if present.
        'active', 'open', 'show', 'hide', 'hidden',
        'is-active', 'is-open', 'is-openable', 'is-visible', 'is-hidden',
      ],
      // Keep every is-/js- state-modifier the design system defines; these
      // are added/removed at runtime by the 51Degrees behaviours (search,
      // sidenav, accordions) and need not be present in a static page.
      greedy: [/^is-/, /^js-/],
    },
    // Conservative: keep all custom properties, @keyframes and @font-face
    // even when no scanned rule references them. Matches the website.
    variables: false,
    keyframes: false,
    fontFace: false,
  })

  if (result.length === 0) {
    console.error('purge-docs-css: no docs-main.css matched under ' + ROOT + '. Nothing purged.')
    process.exit(1)
  }

  const classCount = (s) =>
    new Set((s.match(/\.[a-z][\w-]*/gi) || []).map((x) => x.slice(1))).size

  const report = {
    root: GLOB_ROOT,
    files: [],
    totals: { beforeRaw: 0, afterRaw: 0, beforeGz: 0, afterGz: 0 },
  }

  for (const r of result) {
    const file = r.file
    if (!file || !fs.existsSync(file)) continue
    const before = fs.readFileSync(file, 'utf8')
    const purged = r.css
    fs.writeFileSync(file, purged)

    const beforeGz = zlib.gzipSync(before).length
    const afterGz = zlib.gzipSync(purged).length
    const rel = path.relative(GLOB_ROOT, file).replace(/\\/g, '/')
    report.files.push({
      file: rel,
      bytes: { beforeRaw: before.length, afterRaw: purged.length, beforeGz, afterGz },
      classes: { before: classCount(before), after: classCount(purged) },
    })
    report.totals.beforeRaw += before.length
    report.totals.afterRaw += purged.length
    report.totals.beforeGz += beforeGz
    report.totals.afterGz += afterGz

    const pct = (a, b) => (b > 0 ? ((1 - a / b) * 100).toFixed(1) : '0.0')
    console.log(
      'purge-docs-css: ' + rel + ': ' +
      before.length + ' -> ' + purged.length + ' B raw (-' + pct(purged.length, before.length) + '%), ' +
      beforeGz + ' -> ' + afterGz + ' B gz (-' + pct(afterGz, beforeGz) + '%)'
    )
  }

  fs.mkdirSync(path.dirname(REPORT_PATH), { recursive: true })
  fs.writeFileSync(REPORT_PATH, JSON.stringify(report, null, 2))
})().catch((e) => {
  console.error('purge-docs-css: failed:', e.message)
  process.exit(1)
})

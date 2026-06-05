#!/usr/bin/env node
// Minify every *.js and *.css under <root> in-place by generating a *.min.js
// or *.min.css sibling, then rewrite <script src="*.js"> and
// <link rel="stylesheet" href="*.css"> references in *.html so the pages
// load the minified versions. Clears the Semrush rule 135 ("unminified
// JavaScript and CSS files") findings on the /documentation/* pages of
// 51degrees.com.
//
// Usage: node ci/minify-docs-assets.js <gh-pages-root>
//
// Skips: anything already named *.min.js / *.min.css (or *.min.<anything>.js
// / *.min.<anything>.css), any file whose minified size is not smaller than
// the source (rare but possible for tiny or already-minified files like
// the doxygen-template tabs.css), and any non-.js / non-.css / non-.html
// file. The original *.js / *.css is kept on disk so direct references
// from external callers don't 404.
//
// Re-running is idempotent: existing .min.* siblings are overwritten with
// the freshly minified content, HTML rewrites are no-ops the second time.

const { minify: terserMinify } = require('terser')
const csso = require('csso')
const fs = require('node:fs/promises')
const path = require('node:path')

const TERSER_OPTS = {
  compress: { passes: 2 },
  mangle: true,
  format: { comments: false },
  sourceMap: false,
}

async function walk(dir) {
  const out = []
  for (const entry of await fs.readdir(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name)
    if (entry.isDirectory()) {
      // Skip the gh-pages git internals.
      if (entry.name === '.git') continue
      out.push(...await walk(full))
    } else if (entry.isFile()) {
      out.push(full)
    }
  }
  return out
}

function escapeRegExp(s) {
  return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
}

// Filter helper: candidate source assets are <ext> files that are not
// already an explicit .min.<ext> sibling and aren't dotfiles.
function isCandidate(file, ext) {
  return file.endsWith('.' + ext) &&
    !file.endsWith('.min.' + ext) &&
    !path.basename(file).startsWith('.')
}

// Run a single-extension minify pass. Returns the set of basenames (without
// extension) that got a .min.<ext> sibling so the HTML rewrite step can
// limit its swaps to names we own.
async function minifyExt({ ext, sources, root, label, minifyFn }) {
  const minifiedBases = new Set()
  let totalBefore = 0
  let totalAfter = 0
  for (const src of sources) {
    const original = await fs.readFile(src, 'utf8')
    let minified
    try {
      minified = await minifyFn(original, src)
    } catch (e) {
      console.warn(`  skip ${path.relative(root, src)}: ${label} failed (${e.message})`)
      continue
    }
    if (!minified || minified.length >= original.length) {
      // No benefit; don't emit a .min sibling for this one. Matches the
      // long-standing JS behaviour; the most common cause is files that
      // ship already minified (e.g. the doxygen-template tabs.css).
      continue
    }
    const minPath = src.replace(new RegExp(`\\.${ext}$`), `.min.${ext}`)
    await fs.writeFile(minPath, minified)
    minifiedBases.add(path.basename(src, '.' + ext))
    totalBefore += original.length
    totalAfter += minified.length
  }
  const pct = totalBefore > 0
    ? (100 * (totalBefore - totalAfter) / totalBefore).toFixed(1)
    : '0.0'
  console.log(`  minified ${minifiedBases.size} unique ${ext.toUpperCase()} names: ${totalBefore} -> ${totalAfter} B (-${pct}%)`)
  return minifiedBases
}

async function main() {
  const root = process.argv[2]
  if (!root) {
    console.error('usage: node ci/minify-docs-assets.js <root>')
    process.exit(2)
  }
  const rootStat = await fs.stat(root).catch(() => null)
  if (!rootStat || !rootStat.isDirectory()) {
    console.error(`root "${root}" is not a directory`)
    process.exit(2)
  }

  console.log(`minify-docs-assets: scanning ${path.resolve(root)}`)
  const all = await walk(root)
  const jsSources = all.filter(f => isCandidate(f, 'js'))
  const cssSources = all.filter(f => isCandidate(f, 'css'))
  const htmlFiles = all.filter(f => f.endsWith('.html'))
  console.log(`  found ${jsSources.length} candidate .js files, ${cssSources.length} candidate .css files, ${htmlFiles.length} .html files`)

  // 1a. Minify JS via terser.
  const jsBases = await minifyExt({
    ext: 'js',
    sources: jsSources,
    root,
    label: 'terser',
    minifyFn: async (original) => {
      const result = await terserMinify(original, TERSER_OPTS)
      return result.code
    },
  })

  // 1b. Minify CSS via csso. csso is conservative and doesn't rewrite
  // selectors that look unusual to it, which suits the hand-written
  // doxygen-template stylesheets (tabs.css, navtree.css, search/search.css,
  // jquery-ui.css, ...) better than the more aggressive optimisers.
  const cssBases = await minifyExt({
    ext: 'css',
    sources: cssSources,
    root,
    label: 'csso',
    minifyFn: async (original) => csso.minify(original).css,
  })

  if (jsBases.size === 0 && cssBases.size === 0) {
    console.log('  nothing to rewrite; done')
    return
  }

  // 2. Rewrite asset references in HTML to point at the .min.* siblings.
  //    The regexes are anchored to a word boundary on the basename and to
  //    the .js/.css extension plus an optional query string, so refs like
  //    "../jquery.js", bare "jquery.js" and "tabs.css?v=1" all pick up
  //    the swap. External CDN URLs are left alone because we only swap
  //    basenames we actually emitted (the alternation is built from the
  //    minifiedBases set).
  let htmlRewrites = 0
  let totalSubs = 0
  let jsSwapRe = null
  let cssSwapRe = null
  if (jsBases.size > 0) {
    const jsNames = [...jsBases].map(escapeRegExp).join('|')
    // <script src="..."> form. Matches single or double quotes and a
    // trailing query string (.js?v=2).
    jsSwapRe = new RegExp(
      `(src\\s*=\\s*["'])([^"']*?\\b(?:${jsNames}))\\.js(\\?[^"']*)?(["'])`,
      'gi')
  }
  if (cssBases.size > 0) {
    const cssNames = [...cssBases].map(escapeRegExp).join('|')
    // <link href="..."> form. Doxygen emits stylesheets as
    // <link href="tabs.css" rel="stylesheet" .../> and the custom
    // header.html uses the same attribute order. Match the href= attribute
    // regardless of where rel=stylesheet sits relative to it.
    cssSwapRe = new RegExp(
      `(href\\s*=\\s*["'])([^"']*?\\b(?:${cssNames}))\\.css(\\?[^"']*)?(["'])`,
      'gi')
  }
  for (const f of htmlFiles) {
    const before = await fs.readFile(f, 'utf8')
    let subs = 0
    let after = before
    if (jsSwapRe) {
      after = after.replace(jsSwapRe, (_match, pre, body, query, post) => {
        subs++
        return `${pre}${body}.min.js${query || ''}${post}`
      })
    }
    if (cssSwapRe) {
      after = after.replace(cssSwapRe, (_match, pre, body, query, post) => {
        subs++
        return `${pre}${body}.min.css${query || ''}${post}`
      })
    }
    if (subs > 0) {
      await fs.writeFile(f, after)
      htmlRewrites++
      totalSubs += subs
    }
  }
  console.log(`  rewrote ${htmlRewrites} HTML files with ${totalSubs} ref swaps`)
}

main().catch(e => {
  console.error('minify-docs-assets failed:', e)
  process.exit(1)
})

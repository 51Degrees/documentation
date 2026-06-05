#!/usr/bin/env node
// Minify every *.js under <root> in-place by generating a *.min.js sibling,
// then rewrite <script src="*.js"> references in *.html so the pages load the
// minified versions. Pairs the JS workflow with the existing docs-main.css /
// docs-main.min.css convention so Semrush stops flagging Doxygen-emitted JS
// as "unminified" (rule 135 in the 51degrees.com audit).
//
// Usage: node ci/minify-docs-assets.js <gh-pages-root>
//
// Skips: anything already named *.min.js (or *.min.<anything>.js), any file
// whose minified size would be larger than the source (rare but possible
// for tiny files), and any non-.js / non-.html file. The original *.js is
// kept on disk so direct references from external callers don't 404.
//
// Re-running is idempotent: existing .min.js siblings are overwritten with
// the freshly minified content, HTML rewrites are no-ops the second time.

const { minify } = require('terser')
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
  const jsSources = all.filter(f =>
    f.endsWith('.js') &&
    !f.endsWith('.min.js') &&
    !path.basename(f).startsWith('.'))
  const htmlFiles = all.filter(f => f.endsWith('.html'))
  console.log(`  found ${jsSources.length} candidate .js files, ${htmlFiles.length} .html files`)

  // 1. Generate .min.js siblings. Record basenames (without extension) of
  //    files we actually emitted so the HTML rewrite only touches names we
  //    own; this avoids accidentally rewriting refs to .js assets that for
  //    whatever reason didn't get a .min.js sibling.
  const minifiedBases = new Set()
  let totalBefore = 0
  let totalAfter = 0
  for (const src of jsSources) {
    const original = await fs.readFile(src, 'utf8')
    let minified
    try {
      const result = await minify(original, TERSER_OPTS)
      minified = result.code
    } catch (e) {
      console.warn(`  skip ${path.relative(root, src)}: terser failed (${e.message})`)
      continue
    }
    if (!minified || minified.length >= original.length) {
      // No benefit; don't emit a .min.js for this one.
      continue
    }
    const minPath = src.replace(/\.js$/, '.min.js')
    await fs.writeFile(minPath, minified)
    minifiedBases.add(path.basename(src, '.js'))
    totalBefore += original.length
    totalAfter += minified.length
  }
  const pct = totalBefore > 0
    ? (100 * (totalBefore - totalAfter) / totalBefore).toFixed(1)
    : '0.0'
  console.log(`  minified ${minifiedBases.size} unique JS names: ${totalBefore} -> ${totalAfter} B (-${pct}%)`)

  if (minifiedBases.size === 0) {
    console.log('  nothing to rewrite; done')
    return
  }

  // 2. Rewrite <script src="..."> references in HTML to point at .min.js.
  //    Match basenames (the regex is anchored to a word boundary and a
  //    .js"|.js' suffix), so directory-relative paths like "../jquery.js"
  //    and bare "jquery.js" both pick up the swap.
  const namePattern = [...minifiedBases].map(escapeRegExp).join('|')
  const swapRe = new RegExp(
    `(src\\s*=\\s*["'])([^"']*?\\b(?:${namePattern}))\\.js(["'])`,
    'gi')
  let htmlRewrites = 0
  let totalSubs = 0
  for (const f of htmlFiles) {
    const before = await fs.readFile(f, 'utf8')
    let subs = 0
    const after = before.replace(swapRe, (_match, pre, body, post) => {
      subs++
      return `${pre}${body}.min.js${post}`
    })
    if (subs > 0) {
      await fs.writeFile(f, after)
      htmlRewrites++
      totalSubs += subs
    }
  }
  console.log(`  rewrote ${htmlRewrites} HTML files with ${totalSubs} src swaps`)
}

main().catch(e => {
  console.error('minify-docs-assets failed:', e)
  process.exit(1)
})

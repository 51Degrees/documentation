# `header.html` design notes

Background for the non-obvious shapes in `header.html`. Kept in a sibling
file rather than as HTML comments inside the template so the rationale
doesn't ship into every rendered page.

## Why the brand block is a `<div class="c-brand">` not an `<h1 class="c-brand">`

Every Doxygen-generated page also emits its own page-level `<h1>`
(commonly `<h1 class="g-docs__section-heading">` from the standard
layout). When the masthead brand was also wrapped in `<h1>`, every
rendered page carried two `<h1>` tags.

The Semrush audit of 51degrees.com on 2026-05-22 flagged 220 pages in
`/documentation/*` and 4 in `/device-detection-java/*` as "Multiple h1
tags" purely from this template (Semrush issue 104). Because the
documentation repo's `header.html` is the `HTML_HEADER` for every API
repo's Doxyfile (`HTML_HEADER = ../../documentation/docs/header.html`),
the bad shape multiplied across every public Doxygen page.

The brand element wraps a logo image. It is decorative, not the page
heading, so demoting it to a `<div>` is semantically more accurate.
`role="banner"` keeps the masthead landmark for assistive tech, and
the CSS targets the class (`c-brand`), not the element, so the visual
rendering is unchanged.

## Why the meta description is conditional on `PROJECT_BRIEF`

The Semrush audit flagged 754 `/documentation/*` pages and 564
`/device-detection-java/*` pages with "Missing meta description"
(Semrush issue 106). Doxygen does not emit `<meta name="description">`
by default; the template now synthesises one from Doxygen's
substitutions:

- When `PROJECT_BRIEF` is set (the common case for API repos):
  `<meta name="description"
    content="$title - $projectbrief - 51Degrees documentation."/>`
- When only `PROJECT_NAME` is set:
  `<meta name="description"
    content="$title - $projectname documentation."/>`
- When neither is set: nothing is emitted (better than misleading
  boilerplate).

`$title` is Doxygen's per-page title substitution (the same value
already interpolated into `<title>` below), so each page gets its own
description rather than a project-wide blurb.

## Why the stylesheets come before the scripts and the inline `<style>` block

The doxygen template used to emit `tabs.css` first, then every script
(`jquery.js`, `dynsections.js`, `examplegrabber.js`,
`testedversionsgrabber.js`, `search51.js`, the `$treeview` expansion of
`resize.js` + `navtreedata.js` + `navtree.js` + inline `initResizable`),
and only then the main `$stylesheet` (`docs-main.css`). The render-
blocking scripts in the middle delayed the docs stylesheet by a full
network round trip, so the page painted with only `tabs.css` applied
and re-flowed once `docs-main.css` arrived.

Reordering so all stylesheets (`tabs.css`, `$stylesheet`,
`$extrastylesheet`) precede the scripts lets the browser preload-scan
and request the docs stylesheet in parallel with `tabs.css`, and the
scripts then block on a stylesheet that is already in flight or done.

The inline `<style>` block reserves two layout boxes ahead of asset
arrival to keep Cumulative Layout Shift near zero:

- `.c-brand__image { aspect-ratio: 360/67 }` matches the natural
  dimensions of `/img/logo.png` (the file the website proxy swaps in
  for `logo-51Degrees-Docs.png` on 51degrees.com). The `<img>` element
  also gets matching `width="360" height="67"` attributes for browsers
  that honour the attribute-derived aspect ratio rather than the CSS
  one. Without the reservation the masthead first paints with a zero-
  height image box and snaps down ~35 px when the bytes arrive.
- `.c-sidenav { min-height: 600px }` at viewports below 993px keeps
  the sidenav placeholder tall enough that `navtree.js` filling in the
  tree does not push the main content downwards. Above 993px
  `docs-main.css` already pins `.c-sidenav` to `position: fixed`, so
  no reservation is needed there.

Both rules are inlined into every page rather than added to
`docs-main.css` so they take effect on first paint, before the
external stylesheet finishes loading. The CSS is hand-minified to a
single line to keep the per-page byte cost minimal (the rationale
lives here, not in the template, per the next section).

## Why these notes are not inline comments

A prior version had this rationale as `<!-- ... -->` blocks inside
`header.html`. Doxygen copies HTML comments verbatim into every
rendered page, so two long explanatory blocks added ~1.5 KB per page
to roughly 5,500 generated pages: about 8 MB of bandwidth on every
full crawl, plus the per-visitor cost. Tracked in
[#141](https://github.com/51Degrees/documentation/issues/141).

Keep new design notes in this file; only put pointers in the template.

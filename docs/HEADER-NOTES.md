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
  dimensions of `https://51degrees.com/img/logo.png`, the brand logo the
  masthead `<img>` now references directly (see the masthead section
  below). The `<img>` element
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

## Why hreflang lives in the CI script, not the template

The single hreflang declaration emitted on doxygen pages is
`<link rel="alternate" hreflang="en-US" .../>`, matching the rest of
51degrees.com (single-locale site; no x-default, no other locale).

It is injected by `ci/generate-documentation.ps1` after the canonical
so both declarations share the same `/documentation/<rel>` href and
stay adjacent in `<head>`. The template cannot construct that root-
relative URL by itself (doxygen's `$relpath^` substitution is relative
to the page being rendered, not to `/documentation/`), so doing it in
the script is the only way to keep canonical and hreflang in agreement.

The hreflang is emitted only on the unversioned mirror, never on the
versioned source: the versioned source canonicals at a different URL
(the unversioned one), so emitting a hreflang anchor at that different
URL from the versioned page is the cross-URL mismatch Semrush flags as
a hreflang conflict (rule 24) or an incorrect hreflang link (rule 25).
The mirror is self-canonical, so it carries the locale signal cleanly.
The mirror loop also gates the injection on the existing canonical href
matching the mirror's own URL, so api-repo pages whose template sets a
different consolidation target stay unmodified.

## Why heading rebalancing lives in a CI script, not the template

Doxygen ships the page title at `<h2 class="g-docs__page-title">`
and every section heading at `<h1 class="g-docs__section-heading">`,
and also converts top-level markdown `# Section Title` lines to
plain `<h1>` with no recognisable class. Each rendered page therefore
carries N+1 `<h1>` tags and no `<h1>` for the actual page title,
which Semrush rule 104 ("Multiple H1 tags") flags.

`ci/rebalance-doc-headings.ps1` runs over the gh-pages tree after
the mirror loop and rewrites three things by regex:

1. Promote the page-title `<h2>` to `<h1>` by class.
2. Demote every section-heading `<h1>` to `<h2>` by class.
3. Demote any remaining body-level `<h1>` to `<h2>` (the
   class-less ones doxygen emits for markdown section titles).
   The page-title `<h1>` from pass 1 is preserved because it
   carries `class="g-docs__page-title"`.

Doing this in CI rather than patching the template lets the same
rule apply uniformly across every API repo's doxygen output without
needing each one to re-pull a template change.

## Why `<html>` carries `lang="en"` and the masthead points at the website

Two shapes are set directly in the template so DoxyGen emits them on
every page (this header is the shared `HTML_HEADER` for every API repo's
Doxyfile, so one change covers them all), removing the need for the
51degrees.com reverse proxy to patch the rendered HTML at request time:

- `<html ... lang="en">`. DoxyGen omits `lang`; declaring it once here
  gives every page the document-language signal screen readers and
  search engines expect. The proxy used to inject this per request.

- The masthead links to the website and uses the shared brand logo:
  `<a href="https://51degrees.com/">` wrapping
  `<img src="https://51degrees.com/img/logo.png">`. The URLs are
  absolute (not `$projecturl` / `$relpath^$projectlogo`) so they resolve
  identically whether the page is served through the site or directly
  from gh-pages, and the logo request doubles as the analytics pixel
  when served from 51degrees.com. The proxy used to swap the logo and
  rewrite the home link per request. DoxyGen's own "Main Page" nav links
  stay relative, so in-docs navigation still points at the docs index
  rather than the marketing home.

Canonical, hreflang and the page-title/heading rebalancing stay in CI
(see the sections above) because the template cannot construct those
from DoxyGen substitutions; eliminating the proxy's remaining canonical
/ hreflang / title rewrites needs a feature in the custom 51Degrees
DoxyGen build, not a template change.

## Why mermaid is served from this site and loaded only where it is needed

A fenced mermaid block in a page is written out by Doxygen 1.17.0 as
`<pre class="mermaid">` inside `<div class="mermaidgraph">`, and Doxygen
renders nothing itself, so without a library on the page the block shows
as a code listing. The first page to carry one is
`src/identifiers/pmp/index.md`, whose load process diagram is a mermaid
sequence, and the missing rendering was
[#239](https://github.com/51Degrees/documentation/issues/239).

**The library cannot come from a public content delivery network.**
51degrees.com sends a Content-Security-Policy whose `script-src` is
`'self'`, `https://*.archiebot.com`, `https://*.livewebinar.com`,
`https://cloud.51degrees.com/`, `'unsafe-eval'` and `'unsafe-inline'`,
read from the response headers of
`https://51degrees.com/documentation/index.html` on 15 September 2026. A
script from jsdelivr, cdnjs or unpkg is refused by the browser under that
policy, so it would draw the diagram on the gh-pages preview, which sets
no policy, and fail silently on the published site.

So `mermaid.min.js` is held in this repository, copied into the output by
`HTML_EXTRA_FILES`, and loaded from the page's own origin, which `'self'`
allows. The file is the mermaid 11.17.2 bundle from
`https://cdn.jsdelivr.net/npm/mermaid@11.17.2/dist/mermaid.min.js`, which
is one self-contained file with no dynamic imports, so nothing else has to
be copied beside it. Mermaid is published under the MIT licence and the
bundle carries its own licence notices. It is 3.5 MB on disk and about
960 KB on the wire once compressed, which is why the loader in
`header.html` looks for a diagram first and fetches nothing on a page
without one. The build's minifier skips any file already named `*.min.js`,
so the bundle passes through untouched.

The loader waits for `DOMContentLoaded`, because the header runs before
the body exists and there is nothing to look for yet, and then calls
`mermaid.run()` rather than relying on `startOnLoad`, which fires on an
event that has already passed by the time the script arrives. A diagram
that fails to draw is left as the text of the block, which is the
diagram's own source and is readable, so there is nothing to fall back to
and nothing to report.

Only this repository's Doxyfile copies the bundle. An API repository whose
page carried a mermaid block would ask for a file its own output does not
hold, and the block would stay a code listing, which is what happens
today, so add `mermaid.min.js` to that repository's `HTML_EXTRA_FILES`
when one of its pages needs a diagram.

Checked on 15 September 2026 by building the site with Doxygen 1.17.0, the
version CI downloads, and loading the generated page in Chromium. The
diagram drew as one SVG of 1024 by 1401 pixels, a page with no diagram
fetched the bundle zero times, and the diagram still drew when the
response carried the Content-Security-Policy above.

## Why these notes are not inline comments

A prior version had this rationale as `<!-- ... -->` blocks inside
`header.html`. Doxygen copies HTML comments verbatim into every
rendered page, so two long explanatory blocks added ~1.5 KB per page
to roughly 5,500 generated pages: about 8 MB of bandwidth on every
full crawl, plus the per-visitor cost. Tracked in
[#141](https://github.com/51Degrees/documentation/issues/141).

Keep new design notes in this file; only put pointers in the template.

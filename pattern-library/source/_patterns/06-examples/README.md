# Examples patterns (`pattern-library-examples`)

Shared look-and-feel for the 51Degrees SDK **web examples**. These patterns are
built from the same design tokens as the documentation (`00-abstract`) and
element styles (`01-base`), so an example app matches the docs out of the box.

## Consumable assets

The example repos pull two built files (they do **not** consume Twig/SCSS):

| Asset | Built from | Local path after `npm run build:css` |
|-------|-----------|----------------------------------|
| `examples-main.css` (+ `.min`) | `source/sass/examples-main.scss` | `source/css/examples-main.css` |
| `examples.js` (+ `.min`) | hand-written | `source/js/examples.js` |

These are gitignored build outputs, so they are not committed to the repo.

### Published location (GitHub Release)

The built assets are published as **GitHub Release** assets on the documentation
repo, tagged `examples-assets-v*`. Each `-examples` repo downloads a pinned
version, for example:

```
https://github.com/51Degrees/documentation/releases/download/examples-assets-v1.0.0/examples-main.min.css
https://github.com/51Degrees/documentation/releases/download/examples-assets-v1.0.0/examples.min.js
```

`examples-main.css` and `examples.js` (unminified) are attached to the same
release. A new version is published by pushing an `examples-assets-vX.Y.Z` tag,
or by running the **Publish example assets** workflow
(`.github/workflows/publish-examples-assets.yml`), which builds the CSS/JS and
attaches all four files to the release.

Each `-examples` repo replaces its per-app `wwwroot/css/site.css` (and the
inline view scripts) with these files and updates its markup to the class
contract below.

## Class contract (old example class → new)

| Old (per-repo `site.css`) | New |
|---------------------------|-----|
| `.main` | `.c-eg-page` |
| `.example-alert` | `.c-eg-alert` |
| `<table>` (results/evidence/headers) | `.c-eg-table` + `.c-eg-table__head` / `__cell` / `__cell--key` |
| `.lightgreen` row (evidence used) | `.c-eg-table__row--used` |
| `.lightyellow` row (present) | `.c-eg-table__row--present` |
| zebra rows | `.c-eg-table__row--alt` |
| `.smaller` legend | `.c-eg-legend` + `.c-eg-legend__swatch--used/--present` |
| `.ip-form` | `.c-eg-form` (input `.b-input`, button `.b-btn`) |
| map `#map-section` / `#map` | `.c-eg-map` / `.c-eg-map__canvas` |
| two-column results (mixed) | `.c-eg-columns` |
| collapsible evidence | `.c-eg-details` (native `<details>`) |
| bottom-of-page message | `.c-eg-message` / `.c-eg-message__text` / `.c-eg-message__cta` |

## Pages (one per web example type)

Composed pages in `Examples/Pages` show how a full example app renders:

- `dd-getting-started` — server-side device detection results, evidence, headers, client-side callback section.
- `dd-client-only` — `#content` populated entirely by the JavaScript callback.
- `dd-client-hints` — User-Agent Client Hints with a "make second request" button.
- `ip-getting-started` — IP lookup form, results, evidence, headers, location map.
- `ip-mixed` — two-column device + IP results with a collapsible evidence panel.

Every page ends with the `.c-eg-message` banner, rendered when the view sets `showMessage`
to true (free Lite data file or default resource key). In a real example app, drive the
flag from the data tier or resource key, for example `ShowMessage = engine.DataSourceTier == "Lite"`.

## JavaScript (`fodExamples`)

- `fodExamples.bindDeviceCallback({ targetId })` — device detection: render the
  refined client-side results when `51Degrees.core.js` fires `fod.complete`.
- `fodExamples.initLocationMap({ areasWkt, latitude, longitude })` — IP
  intelligence: draw the Leaflet map (needs Leaflet + wellknown on the page).

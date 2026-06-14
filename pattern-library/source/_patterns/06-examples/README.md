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
| bottom-of-page message | `.c-eg-message` / `.c-eg-message__text` / `.c-eg-message__cta` (see [Message variants](#message-variants)) |

## Pages (one per web example type)

Composed pages in `Examples/Pages` show how a full example app renders:

- `dd-getting-started` — server-side device detection results, evidence, headers, client-side callback section.
- `dd-client-only` — `#content` populated entirely by the JavaScript callback.
- `dd-client-hints` — User-Agent Client Hints with a "make second request" button.
- `ip-getting-started` — IP lookup form, results, evidence, headers, location map.
- `ip-mixed` — two-column device + IP results with a collapsible evidence panel.

Every page ends with the `.c-eg-message` banner, rendered only when a non-paid
resource key or data file is in use. See [Message variants](#message-variants) below.

## Message variants

The banner has three copy variants, all linking to the Contact Us page
(`https://51degrees.com/contact-us`) from an inline text link and a button. Show
the banner **only** when a non-paid resource key or data file is in use.

**Cloud (free-tier cloud examples — getting-started, client-only, client-hints, mixed).**
Cross-sells on-premise. The paid-only cloud examples (TAC lookup, native model) do
**not** show it.

```html
<div class="c-eg-message">
  <p class="c-eg-message__text">Want to try on-premise? <a href="https://51degrees.com/contact-us">Contact us</a> to discuss requirements.</p>
  <a class="b-btn c-eg-message__cta" href="https://51degrees.com/contact-us">Contact us</a>
</div>
```

**On-premise (Lite data file).** Shown when the engine reports the Lite data tier. Generic wording used by the IP intelligence examples.

```html
<div class="c-eg-message">
  <p class="c-eg-message__text">Need more on-premise properties and features? <a href="https://51degrees.com/contact-us">Contact us</a> to explore the options.</p>
  <a class="b-btn c-eg-message__cta" href="https://51degrees.com/contact-us">Contact us</a>
</div>
```

**On-premise device detection (Lite data file).** Same Lite trigger, but the device-detection examples list the paid data file benefits.

```html
<div class="c-eg-message">
  <p class="c-eg-message__text">The paid data file adds daily automatic updates, non-human identification and IP intelligence. <a href="https://51degrees.com/contact-us">Contact us</a> to explore the options.</p>
  <a class="b-btn c-eg-message__cta" href="https://51degrees.com/contact-us">Contact us</a>
</div>
```

Drive the flag from the engine, per SDK:

| SDK | On-premise Lite check | Cloud free-tier examples |
|-----|----------------------|--------------------------|
| .NET | `engine.DataSourceTier == "Lite"` | show (getting-started / client-only / client-hints / mixed) |
| Java | `engine.getDataSourceTier().equals("Lite")` | show |
| Node | `engine.getProduct() === "Lite"` | show |
| PHP | `$engine->engine->getProduct() === "Lite"` | show |
| Python | `engine.engine.getProduct() == "Lite"` | show |

There is no cloud "free vs paid" API, so the cloud banner is shown on the
free-by-design cloud examples and omitted from the paid-only ones.

## Data-file-age warning

Separate from the upgrade banner, the on-premise examples show a stale-data-file
warning (a `.c-eg-alert`) when the loaded data file is older than the age
threshold. This is a distinct message from the upgrade banner and must remain. It
renders as a warning at the **top of the page** — the first child inside
`.c-eg-page`, before the page title — so it is seen before the (possibly stale)
results below it.

## JavaScript (`fodExamples`)

- `fodExamples.bindDeviceCallback({ targetId })` — device detection: render the
  refined client-side results when `51Degrees.core.js` fires `fod.complete`.
- `fodExamples.initLocationMap({ areasWkt, latitude, longitude })` — IP
  intelligence: draw the Leaflet map (needs Leaflet + wellknown on the page).

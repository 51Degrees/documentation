@page Identifiers_PMP PMP (Preference Management Platform)

Lightweight embeddable widget that asks the user for a marketing preference, stores it in `localStorage`, and invokes a publisher-defined continuation URL with that preference - typically the 51Did generation endpoint. The chosen `standard` or `personalized` value is the `id.usage` input for @ref Identifiers_51Did.

## Endpoint

```
GET https://cloud.51degrees.com/api/v4/pmp?resource=<RESOURCE_KEY>
```

Returns the minified locale-resolved bundle. Locale is picked from the `accept-language` query parameter or the `Accept-Language` header, falling back to `en-us`.

## Integration

Add a single `<script>` tag to your page. The cloud endpoint selects the locale bundle from the request, so the same URL works for every language.

```html
<script
  src="https://cloud.51degrees.com/api/v4/pmp?resource=YOUR-RESOURCE-KEY"
  data-action-url="https://cloud.51degrees.com/api/v4/YOUR-RESOURCE-KEY.js?id.usage={preference}"
  data-tcf-vendor="<TCF v2 vendor string>"
  data-brand-name="Your Brand"
  data-brand-terms-url="https://yoursite.com/privacy"
  data-alt-name="Subscribe to remove ads"
  data-alt-url="https://yoursite.com/subscribe"
  data-brand-logo="https://yoursite.com/logo.svg"
  data-show-standard="true">
</script>
```

## Configuration attributes

The full set of attributes the widget reads from its own `<script>` tag.

| Attribute              | Required | Default | Purpose |
|------------------------|----------|---------|---------|
| `data-action-url`      | Yes      | -       | URL invoked on every user choice. `{preference}` is replaced with `standard` or `personalized`. `http(s)` URLs are injected as `<script src>`; `javascript:` URLs run inline. |
| `data-tcf-vendor`      | Yes      | -       | Static TCF v2 consent string. Multi-segment strings (e.g. `core.disclosedvendors`) are accepted - trailing segments are preserved verbatim. |
| `data-brand-name`      | Yes      | -       | Brand shown in the UI. |
| `data-brand-terms-url` | Yes      | -       | Link to the publisher's terms / privacy page. |
| `data-alt-name`        | Yes      | -       | Label for the Alternative button (e.g. "Subscribe to remove ads"). |
| `data-alt-url`         | Yes      | -       | Destination of the Alternative button. `http(s)` URLs navigate the page; `javascript:` URLs run inline. `{preference}` is NOT substituted here. |
| `data-brand-logo`      | No       | -       | URL to the publisher's logo, shown in the dialog header. |
| `data-show-standard`   | No       | `false` | Set to `"true"` to add a Standard marketing button alongside Personalized and the Alternative button. When `false`, only Personalized and Alternative are shown. |

## `id.usage` mapping

| Preference     | Meaning                                              |
|----------------|------------------------------------------------------|
| `standard`     | Frequency capping and measurement only.              |
| `personalized` | All marketing purposes including personalization.    |

The Alternative button (e.g. "Subscribe to remove ads") stores `standard` as the preference, fires `data-action-url` with `id.usage=standard`, then runs `data-alt-url`: for an `http(s)` URL the page navigates to it; for a `javascript:` URL the code runs inline and the page stays on the publisher's site. Users who take this path avoid personalized advertising, but standard marketing tracking still applies.

## Flow

1. The script loads and reads any stored preference from `localStorage`.
2. If none is stored, the dialog is shown.
3. The user chooses; the preference is saved to `localStorage`.
4. `data-action-url` is dispatched with `{preference}` substituted - this is the continuation that drives downstream behaviour (most commonly fetching `/api/v4/<KEY>.js?id.usage={preference}` so 51Did data lands on the page). For `http(s)` URLs PMP injects `<script src="...">`; for `javascript:` URLs the code runs inline.

On subsequent visits steps 2-3 are skipped: PMP reads the stored preference from `localStorage` and goes straight to step 4. So `data-action-url` fires on every page load, not just on the first user choice.

## localStorage

The preference is stored under the key `__51d_pmp_pref` as a JSON object of shape `{v, p, t}` - schema version, preference (`standard` or `personalized`), and a millisecond timestamp:

```json
{ "v": 1, "p": "personalized", "t": 1715980800000 }
```

To re-prompt the user (e.g. a "Change preferences" footer link), remove this key and reload the page:

```javascript
localStorage.removeItem('__51d_pmp_pref');
location.reload();
```


## Cross-references

- @ref Identifiers_51Did - how `id.usage` is consumed. The widget maps the user's choice to an `id.usage` value itself (the *Direct* path under *Setting the usage policy*); a caller who would rather hand the cloud a raw TCF or GPP string and have it derive `id.usage` uses the *Derived from consent* path on the same page.
- @ref Integrations_Prebid - downstream RTB enrichment that consumes the 51Did.

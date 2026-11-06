@page Identifiers_PMP PMP (Preference Management Platform)

PMP is a small embeddable widget that asks a visitor what kind of marketing they want, keeps the answer in a cookie on your domain, and passes the answer to the 51Degrees client script, which sends the answer to the cloud. The answer is one of `non-marketing`, `standard` or `personalized`, which are the three `id.usage` values @ref Identifiers_51Did takes.

## Endpoints

Loading PMP takes two requests. The tag on the page fetches the loader, and the loader works out which bundle the page needs and fetches that.

```
GET https://cloud.51degrees.com/api/v4/pmp/<RESOURCE_KEY>.js
```

That returns the loader, which is about a kilobyte and the same bytes for every caller. The cloud reads only the Resource Key from this address, which is the file name. A query string on it is ignored. Every other setting is a `data-` attribute on the script tag. The cloud does not check this request against the key's domains and does not count it against the key's monthly requests.

```
GET https://cloud.51degrees.com/api/v4/pmp/<RESOURCE_KEY>/<NAME>
```

That returns one built bundle, where `<NAME>` is a locale such as `en-us`, optionally followed by `-nosharing`. The loader picks the language from the visitor's own browser, matching the full tag first, then the language on its own, then falling back to `en-us`, so the language is decided in the browser rather than from a request header. Whether the bundle needs the sharing code comes from `data-use-third-party-cookies` and `data-network-name` on the tag.

This is the request the cloud checks and counts. It is checked against the key's domains, as [the domains a Resource Key accepts](@ref Resource_key_domains) describes, so a page on a domain the key does not cover gets a `401` and no dialog. Every bundle request that reaches the cloud counts as one of the key's monthly requests, as @ref Services_Cloud_Metering sets out, and that includes a browser rechecking its cached copy and being answered `304`. A page view whose bundle comes from the browser's cache without asking uses none, and so does a visitor who leaves before the bundle loads. The requests to the shared store described under @ref Identifiers_PMP_Sharing are not counted.

A License Key never goes on the page. The loader sends none, the bundle request refuses one with `400`, and a script tag with the `data-license-key` attribute stops PMP from starting, with one console error saying so. Where your products need a License Key on top of the Resource Key, add the License Key to the Resource Key when you create it.

## The load process

![How PMP loads and answers](images/pmp-load-process.svg)

1. The tag fetches the loader, and the loader fetches the bundle the page needs.
2. The bundle reads the `__mtm_pref` and `__51d_pmp_share` cookies. An answer marked as shared is checked with the cloud, whose answer decides. An answer this site holds on its own is used without a request. Where this site holds nothing and the visitor has not declined sharing, the cloud is asked for an answer given on another of your sites.
3. With no answer anywhere, the dialog is shown.
4. The visitor answers. The answer is saved to the `__mtm_pref` cookie, the `51d-pmp-preference` event fires on the window, and the dialog collapses to the bubble.
5. Where the answer was Standard or Personalized and sharing applies, a second card asks whether the answer should be used on the group's other sites.
6. `data-action-url` fires where the tag carries one.

On later visits steps 3 to 5 are skipped. The event fires with the stored answer and the bubble is shown, so `data-action-url` fires on every page load rather than only on the first answer.

## In this section

- @subpage Identifiers_PMP_Integration
- @subpage Identifiers_PMP_Configuration
- @subpage Identifiers_PMP_Preferences
- @subpage Identifiers_PMP_Sharing
- @subpage Identifiers_PMP_IsGdpr
- @subpage Identifiers_PMP_CmpWiring
- @subpage Identifiers_PMP_CmpComparison

## Cross-references

- @ref Identifiers_51Did - how `id.usage` is consumed. PMP maps the visitor's choice to an `id.usage` value itself (the *Direct* path under *Setting the usage policy*), and a caller who would rather hand the cloud a raw TCF string and have it derive `id.usage` uses the *Derived from consent* path on the same page.
- @ref DeviceDetection_Features_ThirdPartyCookies - the client script result the second card depends on.
- @ref Integrations_Prebid - downstream RTB enrichment that consumes the 51Did.

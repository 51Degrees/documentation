@page Identifiers_PMP PMP (Preference Management Platform)

PMP is a small embeddable widget that asks a visitor what kind of marketing they want, keeps the answer in a cookie on your domain and announces it on the page. The answer is one of `non-marketing`, `standard` or `personalized`, which are the three `id.usage` values @ref Identifiers_51Did takes.

## Endpoints

A page view makes two requests. The tag on the page fetches the loader, and the loader works out which bundle the page needs and fetches that.

```
GET https://cloud.51degrees.com/api/v4/pmp/<RESOURCE_KEY>.js
```

That returns the loader, which is about a kilobyte and the same bytes for every caller. **The resource key is the file name in the URL and nothing else on this URL is read.** Every other setting is a `data-` attribute on the script tag, so each setting is written in one place and read from one place. Any query string a page adds here is ignored and is carried nowhere. This request is neither checked nor counted, so a visitor who leaves before the page settles costs nothing.

```
GET https://cloud.51degrees.com/api/v4/pmp/<RESOURCE_KEY>/<NAME>
```

That returns one built bundle, where `<NAME>` is a locale such as `en-us`, optionally followed by `-nosharing`. The loader picks the language from the visitor's own browser, matching the full tag first, then the language on its own, then falling back to `en-us`, so the language is decided in the browser rather than from a request header. Whether the bundle needs the sharing code comes from `data-use-third-party-cookies` and `data-network-name` on the tag. The loader adds `license=` where the tag carries `data-license-key`.

The bundle is the request that is checked and counted, because it is what the visitor actually receives. **Your resource key must be registered for the domain the page is on.** The request is checked against the domains the key names, using the `Referer` header and falling back to `Origin`, the same as every other keyed endpoint, and a page on a domain the key does not cover is refused with 401 and no dialog appears. A page that suppresses the `Referer` header, with `<meta name="referrer" content="no-referrer">` or an equivalent policy, is refused for the same reason, because the check has nothing to compare.

**An older form of this endpoint took the resource key as a query parameter, `https://cloud.51degrees.com/api/v4/pmp?resource=<RESOURCE_KEY>`. That address answers 404 now, so a page still carrying it fetches nothing and shows no dialog.** The key also has to be in the URL rather than on the tag, because `data-resource-key` is not read. Two places to write a key meant a page could carry one the cloud never saw, and the refusal that followed was invisible to the page.

## The load process

![How PMP loads and answers](images/pmp-load-process.svg)

1. The tag fetches the loader, and the loader fetches the bundle the page needs.
2. The bundle reads the `__mtm_pref` and `__51d_pmp_share` cookies. An answer marked as shared is checked with the cloud, whose answer decides. An answer this site holds on its own is used without a request. Where this site holds nothing and the visitor has not declined sharing, the cloud is asked for an answer given on another of your sites.
3. With no answer anywhere, the dialog is shown.
4. The visitor answers. The answer is saved to the `__mtm_pref` cookie, announced on the window, and the dialog collapses to the bubble.
5. Where the answer was Standard or Personalized and sharing applies, a second card asks whether the answer should be used on the group's other sites.
6. `data-action-url` fires where the tag carries one.

On later visits steps 3 to 5 are skipped, the stored answer is announced and the bubble is shown, so `data-action-url` fires on every page load rather than only on the first answer.

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

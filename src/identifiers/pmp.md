@page Identifiers_PMP PMP (Preference Management Platform)

PMP is a small embeddable widget that asks a visitor what kind of marketing they want, keeps the answer in `localStorage` and announces it on the page. The answer is one of `non-marketing`, `standard` or `personalized`, which are the three `id.usage` values @ref Identifiers_51Did takes.

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

## Integration

Add one `<script>` tag to your page. The same URL works for every language.

```html
<script
  src="https://cloud.51degrees.com/api/v4/pmp/YOUR-RESOURCE-KEY.js"
  data-tcf-vendor="<TCF v2 vendor string>"
  data-brand-name="Your Brand"
  data-brand-terms-url="https://yoursite.com/privacy"
  data-alt-name="Subscribe to remove ads"
  data-alt-url="https://yoursite.com/subscribe"
  data-brand-logo="https://yoursite.com/logo.svg"
  data-show-standard="true">
</script>
```

### The 51Degrees client script belongs on the page as well

PMP reads two things from the 51Degrees client script, being whether third party cookies work in this browser and whether the General Data Protection Regulation applies, so put the client script on the page too:

```html
<script src="https://cloud.51degrees.com/api/v4/YOUR-RESOURCE-KEY.js" async></script>
```

The two tags can go in either order and both can carry `async`, because the client script listens on the window for PMP's answer whilst PMP watches for the client script's object, which is `fod` unless `data-object-name` says otherwise. The object is the only thing PMP looks at, so it does not matter where the client script came from, and one served by a different 51Degrees cloud, by a proxy of your own or out of a bundle you built yourself all work the same way.

An `async` tag has usually not run at the moment PMP starts, so an object that is not there yet is not an object that is never coming, and PMP waits for it instead of deciding straight away. The wait finishes once your page has loaded, since every tag written into the markup has had its turn by then, and it is capped at 5000 milliseconds for a page whose load event is very late. If nothing has appeared by the end of it, PMP loads the client script itself from the cloud that served PMP, using the resource key it already has, and says so in the console. Writing the tag yourself is still the better option, because then the placement and the timing are yours.

Load the client script once. A second copy runs a second round and creates a second identifier, and the client script itself warns about it.

## Configuration attributes

The attributes PMP reads from its own `<script>` tag.

| Attribute                      | Required | Default | Purpose |
|--------------------------------|----------|---------|---------|
| `data-tcf-vendor`              | Yes      | -       | Static TCF v2 consent string. The core segment on its own is enough, and multi-segment strings such as `core.disclosedvendors` are accepted, with trailing segments preserved as they were given. |
| `data-brand-name`              | Yes      | -       | Brand shown in the dialog. |
| `data-brand-terms-url`         | Yes      | -       | Link to the publisher's terms or privacy page. |
| `data-alt-name`                | Yes      | -       | Label for the Alternative button, for example "Subscribe to remove ads". |
| `data-alt-url`                 | Yes      | -       | What the Alternative button does. An `http(s)` URL navigates the page and a `javascript:` URL runs inline with no navigation. `{preference}` is not substituted here. |
| `data-action-url`              | No       | -       | A hook of your own, invoked on every answer. `{preference}` is replaced with `standard`, `personalized` or `non-marketing`. An `http(s)` URL is injected as `<script src>` and a `javascript:` URL runs inline. Leave it out and there is simply nothing to invoke, with the dialog saving the answer, activating `__tcfapi` and dismissing as usual. See *Where the action URL fits* below. |
| `data-license-key`             | No       | -       | Additional licence key or keys, several separated by `+`, where your products need one on top of the resource key. Anyone reading the page source can see it, exactly as they could when it sat on the URL, so only put one here that you are content to publish. |
| `data-brand-logo`              | No       | -       | URL to the publisher's logo, shown in the dialog header. |
| `data-show-standard`           | No       | `false` | Set to the exact string `true` to offer the Standard option alongside Personalized and the Alternative button. |
| `data-network-name`            | Only when sharing is on | - | The name of the group your sites belong to. The visitor is shown this name as the thing they would be sharing their answer with, so choose one they will already have seen on the sites themselves. It also settles which sites count as one group. See *Sharing an answer across sites* below. |
| `data-network-logo`            | No       | -       | URL to the network's logo, shown in the dialog beside the publisher's own. |
| `data-use-third-party-cookies` | No       | `true`  | Whether a visitor who chose Standard or Personalized may be offered the second card, which shares the answer with the other sites in the group. Nothing but the exact string `false` turns it off, so a mistyped value leaves sharing running instead of switching it off without telling you. |
| `data-object-name`             | No       | `fod`   | What the 51Degrees client script's object is called on this page, which is where the third party cookie result and the GDPR answer are read from. Set it only where the client script was built with the `fod-js-object-name` parameter, and set both to the same name. |

`data-timeout` is no longer read. PMP waits a fixed 1500 milliseconds for the cloud when it reads the shared answer at start up and when it writes one, and no attribute changes that. A page that still sets `data-timeout` gets one console warning per page view, and the attribute can come off the tag.

## Buttons and what each one stores

| Button                                | Shown                              | Stores          |
|---------------------------------------|------------------------------------|-----------------|
| Personalized                          | Always                             | `personalized`  |
| The alternative, named by `data-alt-name` | Always                         | `non-marketing` |
| Standard                              | Only with `data-show-standard="true"` | `standard`   |

Each option explains itself behind a "More information" accordion. There is no close cross on the first dialog, so answering is the only way past it. Once answered, the dialog shrinks to a small bubble in the corner that opens it again, and later visits start at that bubble rather than the full dialog, so the visitor can change their answer whenever they like.

The alternative button is the visitor declining marketing, so it stores `non-marketing`. It fires `data-action-url` with `id.usage=non-marketing`, then runs `data-alt-url`, where an `http(s)` URL navigates the page and a `javascript:` URL runs inline and leaves the visitor on your site.

**The alternative button used to store `standard`, which said the visitor still accepted standard marketing tracking.** It stores `non-marketing` now, so that a publisher reading an answer shared from another site can tell a visitor who declined from one who accepted the lesser of the two kinds.

No TCF consent string is built for `non-marketing`, because the visitor consented to nothing and so nothing is claimed. Whilst that answer stands, `__tcfapi` answers `ping` truthfully, still honours `removeEventListener`, and answers `getTCData` and `addEventListener` with `success: false`. A listener registered before the decline is told once, with `success: false`, that there is no longer any TC data. Choosing Standard or Personalized afterwards restores the full API.

## `id.usage` mapping

| Preference      | Meaning                                              |
|-----------------|------------------------------------------------------|
| `non-marketing` | Analytics, fraud prevention and security only.       |
| `standard`      | Frequency capping and measurement.                   |
| `personalized`  | All marketing purposes including personalization.    |

The question is asked whether or not your resource key carries the 51Did product, because the dialog, the answer, the window event and the consent surface work without it. The product decides what an answer produces rather than whether it can be given. `non-marketing` gets a 51Did whatever the licence holds. `standard` and `personalized` are marketing usages, so the cloud issues no 51Did for either one unless the licence behind the resource key carries the 51Did product, and where it does not the reason comes back in place of the identifier.

## How the answer reaches the cloud

Every answer is announced on the window, whichever path it came by, being a choice, the alternative button, an answer this site already held or one that came back from the shared store:

```javascript
window.addEventListener('51d-pmp-preference', function (event) {
  console.log(event.detail.preference); // standard | personalized | non-marketing
});
```

The 51Degrees client script listens for that event itself and sends the answer to the cloud as `id.usage` on its next request, so a page carrying both needs no code of its own to join them.

A script of yours that starts after PMP has loaded has missed the event, so it asks instead:

```javascript
window.__51d_pmp.preference(); // the value in force, or null
```

The getter answers from memory rather than from storage, the shared store's answer included, and PMP writes nothing new to the browser for either of them.

### Where the action URL fits

`data-action-url` is a hook for your own code, such as an analytics call, and it is not how the answer reaches the cloud:

```html
data-action-url="javascript:yourAnalytics('{preference}')"
```

It used to carry the client script's address with `id.usage={preference}` on it, which loaded that script again on every answer. The client script hears the answer for itself and refreshes now, so it does not need loading again, and an action URL naming the cloud is skipped with a console message where the client script's object is on the page or on its way.

## Flow

1. The tag fetches the loader, and the loader fetches the bundle the page needs.
2. The bundle reads any answer already stored in `localStorage`.
3. With nothing stored, the dialog is shown.
4. The visitor answers. The answer is saved to `localStorage`, announced on the window, and the dialog collapses to the bubble.
5. Where the answer was Standard or Personalized and sharing applies, a second card asks whether the answer should be used on the group's other sites.
6. `data-action-url` fires where the tag carries one.

On later visits steps 3 to 5 are skipped, the stored answer is announced and the bubble is shown, so `data-action-url` fires on every page load rather than only on the first answer.

## Sharing an answer across sites

A visitor who has answered on one website should not have to answer again on every other website in the same group. A second card asks whether the answer should be used elsewhere, and it is offered only where all three of these hold.

1. `data-use-third-party-cookies` is left on, which is the default, and `data-network-name` names the group. Leaving the group unnamed turns sharing off, because a visitor cannot be asked to apply an answer across a group of sites without being told which group, and PMP logs a warning saying so and carries on with the rest of the dialog working.
2. The visitor chose Standard or Personalized. The alternative, being the visitor declining marketing, never leads to the second card.
3. The 51Degrees client script has confirmed that third party cookies work in this browser. The confirmation is `ThirdPartyCookiesEnabled` on the client script's object, so your resource key has to ask for @ref DeviceDetection_Features_ThirdPartyCookies. Once the first card is answered PMP allows 3000 milliseconds for that confirmation to arrive, and without it the second card is skipped and the answer stays with this site alone. A browser that blocks third party cookies, which includes Safari and Firefox, therefore never reaches the second card.

## localStorage

The answer is stored under the key `__51d_pmp_pref` as a JSON object of shape `{v, p, t}`, being the schema version, the preference (`non-marketing`, `standard` or `personalized`) and a millisecond timestamp:

```json
{ "v": 1, "p": "personalized", "t": 1715980800000 }
```

To ask the visitor again, for example from a "Change preferences" footer link, remove this key and reload the page:

```javascript
localStorage.removeItem('__51d_pmp_pref');
location.reload();
```

Clicking the bubble reopens the dialog without clearing anything, so offer that route where the visitor simply wants to change their answer.

## Browser requirement

The bundles are built to ES2020 and nothing transpiles them below it, which covers every browser released since early 2020. Televisions, set-top boxes and games consoles are the ones to watch, as their browsers tend to lag well behind a phone bought at the same time and seldom get updated after the device ships, so check what such a device supports before deploying PMP to it.

## Cross-references

- @ref Identifiers_51Did - how `id.usage` is consumed. PMP maps the visitor's choice to an `id.usage` value itself (the *Direct* path under *Setting the usage policy*), and a caller who would rather hand the cloud a raw TCF or GPP string and have it derive `id.usage` uses the *Derived from consent* path on the same page.
- @ref DeviceDetection_Features_ThirdPartyCookies - the client script result the second card depends on.
- @ref Integrations_Prebid - downstream RTB enrichment that consumes the 51Did.

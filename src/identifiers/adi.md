@page Identifiers_ADI ADI (Ad Inspector)

ADI is a small embeddable widget that puts an icon on every ad a page carries and, when the visitor taps it, tells them in one plain sentence why that ad was served to them. The sentence is read out of the @ref Identifiers_51Did that went into the ad auction, the identifier's signature is checked in the browser against a 51Degrees public key, and the color of the icon says what that check found before anything is tapped.

ADI sits beside @ref Identifiers_PMP. A publisher who has the PMP tag adds the ADI tag the same way, and the two are built, served, counted and translated alike.

## Endpoints

A page view makes two requests for the widget. The tag on the page fetches the loader, and the loader works out which bundle the visitor's language calls for and fetches that.

```
GET https://cloud.51degrees.com/api/v4/adi/<RESOURCE_KEY>.js
```

That returns the loader, which is about a kilobyte and the same bytes for every caller. **The resource key is the file name in the URL and nothing else on this URL is read.** Every other setting is a `data-` attribute on the script tag. This request is neither checked nor counted, so a visitor who leaves before the page settles costs nothing.

```
GET https://cloud.51degrees.com/api/v4/adi/<RESOURCE_KEY>/<NAME>
```

That returns one built bundle, where `<NAME>` is a locale such as `en-us`. The loader picks the language from the visitor's own browser, matching the full tag first, then the language on its own, then falling back to `en-us`, so the language is decided in the browser rather than from a request header. The loader adds `license=` where the tag carries `data-license-key`.

The bundle is the request that is checked and counted, because it is what the visitor receives. **The resource key must be registered for the domain the page is on.** The request is checked against the domains the key names, the same as every other keyed endpoint, and a page on a domain the key does not cover is refused with 401 and no icon appears.

```
GET https://cloud.51degrees.com/api/v4/id/key/<RESOURCE_KEY>
```

The widget asks this endpoint for the public keys 51Dids are signed with. It is described under @ref Identifiers_51Did, and the way ADI calls it is described under *Metering* below.

## Integration

Add one `<script>` tag to the page. The same URL works for every language.

```html
<script
  src="https://cloud.51degrees.com/api/v4/adi/YOUR-RESOURCE-KEY.js"
  data-provider="yoursite.adInspector"
  data-template-url="https://yoursite.com/adi-template.html"
  data-timeout="3000">
</script>
```

Every attribute is optional. A tag carrying only the resource key gets the built-in sentence, the built-in template and the built-in timeout, and finds its ads by the `data-adi` attribute described under *Which elements carry an ad* below.

### The 51Degrees client script

ADI reads nothing from the 51Degrees client script. What it reads are the identifiers the page sent into the ad auction, and those are the page's to hand over. The client script is still what creates them, so a page with ADI carries the client script for the same reason a page with PMP does. See @ref Identifiers_51Did for how the identifier is created and @ref Integrations_Prebid for how it reaches the auction.

## Configuration attributes

The attributes ADI reads from its own `<script>` tag.

| Attribute            | Required | Default | Purpose |
|----------------------|----------|---------|---------|
| `data-provider`      | No       | -       | The name of an object on `window`, dotted paths allowed, that names the page's ad containers and supplies each ad's identifiers and any extra data the template wants. See *The provider* below. Without it ADI finds containers by attribute and reads identifiers off them. The object is looked up each time it is needed, so a page that defines it after the tag has run is still answered. |
| `data-template-url`  | No       | The built-in template | The address of the publisher's own pop-up template, in the template language described under *Templates* below. One URL per tag, so the publisher decides the template's language when they build the tag. Fetched once per page with a cross origin request and no credentials, so the host has to allow it, and a fetch that fails or times out falls back to the built-in template with one console line saying so. Only `http` and `https` addresses and paths on the same site are accepted. |
| `data-timeout`       | No       | `3000`  | Milliseconds ADI waits for an ad's identifiers, for the public key and signature check, and for the provider's extra data, before giving up on that ad. See *The timeout* below. A value that is not a positive whole number keeps the default, with one console line saying so. |
| `data-license-key`   | No       | -       | Additional license key or keys, several separated by `+`, where your products need one on top of the resource key. Anyone reading the page source can see it, so only put one here that you are content to publish. |

The colors, the size and the position of the icon are not configurable.

## Which elements carry an ad

ADI never guesses. A container is an ad slot when either of two things says so.

1. The publisher marks it with a `data-adi` attribute. The identifiers that went into that slot's auction are written on the same element as `data-51did`, one or more 51Dids separated by spaces, by whatever code on the page sent them. That is ordinarily the page's Prebid wrapper reading back the `user.eids` entries it sent with `source` set to `51d.es`.
2. The provider's `slots()` returns it.

An element that comes into view with no identifiers on it and no provider answer within the timeout gets the *No identifier* state, never a guess from elsewhere on the page.

The icon is placed against the container's own box, so a container whose `position` is `static` is given `position: relative`. That is the one style ADI writes on a publisher's element, and it is written only where the element has no positioning of its own. A container whose `data-51did` attribute changes after it has been inspected, which is what a wrapper does when it fills the slot with a new auction, is inspected again with what it now carries. Containers marked `data-adi` that are added to the page later are found as they are added. Containers only the provider names are found when ADI starts and whenever the page calls `window.__51d_adi.rescan()`.

## The provider

`data-provider` names an object with two optional methods. Both are called with the slot element and may answer with a value or a promise.

```javascript
window.yoursite = window.yoursite || {};
window.yoursite.adInspector = {
  // Optional. The elements that carry ads, in addition to any marked
  // with data-adi.
  slots: function () { return document.querySelectorAll('.ad'); },
  // Optional. Called once per slot as it comes into view, and again if
  // the slot is filled afresh.
  describe: function (slot) {
    return {
      identifiers: slot.dataset.eids.split(' '),      // now, or a promise
      data: fetch('/why/' + slot.id).then(r => r.json()) // awaited on tap
    };
  }
};
```

The two answers are awaited at different times.

- `identifiers` is awaited when the slot comes into view, within the timeout, because the icon cannot be colored without them. It may be a list of 51Did strings or one string with several separated by spaces, the same form `data-51did` takes. Where both the attribute and the provider name identifiers, the slot has the union of the two, each once.
- `data` is awaited only when the visitor taps the icon, within the same timeout, and the loading ring shows while it is awaited. Whatever it resolves to is handed to the template under `extra` and nowhere else. **It can add to the sentence and never override it.** The usage, the date, the method and the verdict come from the signed identifier and from the check, and no provider value replaces them.

## The icon

A 20 pixel black circle, 4 pixels in from the top left corner of the ad, inside the booked box, rendered as a button so a keyboard reaches it, with an accessible name for each state in the visitor's language. It appears when the slot comes into view and has identifiers, or the provider has answered. It stays at the top left whatever the language, because it is a position on the ad and not a reading direction.

| State         | Looks | Means |
|---------------|-------|-------|
| Unresolved    | A white arc turning inside the black circle | Identifiers are in hand and the check has not finished |
| Genuine       | Green `#16A34A` | Every identifier's signature verified under a 51Degrees key |
| Invalid       | Red `#E62D39` | At least one identifier's signature did not verify. One forged identifier taints the ad |
| Timeout       | Gray `#919191` | The check could not finish within the timeout, being no key, no answer from the cloud, or a key that could not be used |
| No identifier | A thin white ring on black with nothing inside | The slot carries no 51Did, or every identifier's usage is `non-marketing`, so no marketing preference selected this ad |

Black is `#000000` and white is `#FFFFFF`. All five are fixed. The icon is the same 20 pixels in every state, so the ad never moves as the state changes, and no icon is drawn until the identifiers are in hand, so the visitor never sees one kind of icon replaced by another.

On a page served over plain `http` there is no Web Crypto, so no signature can be checked. ADI writes one console line and draws no icon at all. What ADI looks for is `window.crypto.subtle`, which is the capability itself rather than the scheme, so a page on `localhost` over `http`, which browsers treat as secure, still works.

An identifier whose signature could not be judged, being no published key covering its date, no cloud to ask, or a key that could not be used, is gray rather than red, because "could not check" is not "does not match".

## The pop-up

A tap opens a card holding three things and nothing else.

1. The sentence, or sentences.
2. A link to the terms document the identifier names, read from the identifier and never built by ADI. For identifiers made today that is the versioned text of the [Model Terms for Marketing](https://m4ow.uk/mtm/2.txt). Where the identifier names no document ADI knows, there is no link.
3. A close control.

No identifier is printed and no preference is changed from here. A tap opens the card in every state, not only the genuine one. In the invalid, timeout and no-identifier states the card carries one sentence saying what the icon means and no terms link. The Escape key, the close control and the backdrop all close it, and focus goes back to the icon that opened it.

### The sentence

The built-in English sentence is:

> The advert was selected using your preference for **personalized** marketing provided on **Monday, August 10, 2026 at 9:15 AM** using **a cookie consent dialogue**.

Each bold part comes from the identifier.

| Part | Values | Where it comes from |
|------|--------|---------------------|
| The usage | `standard` or `personalized` | The usage the identifier carries, which is the visitor's answer under the Model Terms for Marketing, described under @ref Identifiers_51Did. |
| The moment | A full date and time with the day of the week, to the minute, in the language of the bundle and the visitor's own time zone | The creation time the identifier carries, to the minute in UTC. That is when the identifier was made, which is the page view it was made on rather than the moment the visitor answered PMP, because neither the identifier nor PMP records the latter. |
| The method | "a cookie consent dialogue" or "a direct question concerning your marketing preference" | Whether the usage was derived from a consent string or stated directly by the caller, which the identifier records. |

Where the slot has several identifiers, one sentence is shown per distinct combination of usage, creation minute and method, in the order the identifiers were given. Where several identifiers share a combination the sentence is shown once and followed by what kinds of identifier were included, being a value derived from the visitor's email address, a random number, or a code for the visitor's device and network. An identifier created for `non-marketing` use produces no sentence, because no marketing preference selected the ad with it.

The sentence does not name the organization the preference was given to. The identifier cannot say, because its license field is encrypted so that nobody can group identifiers by customer.

## Templates

A publisher's own template, named by `data-template-url`, replaces the built-in card and is rendered with the same view. The template language is a small subset of mustache, rendered in the browser, and nothing else is supported.

- `{{name}}` and `{{a.b.c}}`, always HTML escaped. There is no unescaped form, because a template is fetched from a URL and rendered into the page. The `{{{name}}}` and `{{&name}}` forms of full mustache are read as `{{name}}` and escaped like it.
- `{{#name}}...{{/name}}`, shown when the value is true, non-empty, or a non-empty list, repeated per item for a list. `{{.}}` is the current item.
- `{{^name}}...{{/name}}`, shown when it is not.
- `{{! comment }}`.

A name is looked up in the current context first and then in each enclosing one, so `strings.close` reaches the strings from inside `{{#sentences}}`. Only an object's own properties are reachable and a function is never called. A template that cannot be parsed falls back to the built-in template with one console line, the same as one that cannot be fetched.

The view a template is rendered with:

```javascript
{
  sentences: [ { usage: 'personalized', standard: false, personalized: true,
                 when: 'Monday, August 10, 2026 at 9:15 AM',
                 direct: false, consentDialogue: true,
                 kinds: [ { label: 'a random number', emailDerived: false,
                            random: true, device: false, reserved: false } ],
                 kindsText: 'a random number',
                 several: false,
                 text: 'The advert was selected using ...' } ],
  genuine: true, invalid: false, timeout: false, none: false,
  termsUrl: 'https://m4ow.uk/mtm/2.txt',
  strings: { /* every string in the visitor's language */ },
  extra: { /* whatever the provider's data resolved to, or undefined */ }
}
```

The booleans let a template choose its own wording on an enumeration without knowing the language, and `strings` lets it stay translated. `several` says whether more than one identifier shares the sentence, and `kindsText` is the kinds already joined as a list in the bundle's language. `sentences` is empty and `termsUrl` null in every state but genuine.

The built-in card's class names are shortened in the served bundle, so a publisher's template carries its own styling or none.

## The timeout

One wait, `data-timeout`, covers everything an ad waits on: the provider's identifiers once the slot has come into view, the public key and the signature check once the identifiers are in hand, and the provider's extra data once the visitor has tapped the icon. When the wait runs out the icon shows the gray timeout state, or the card renders without the extra data, and nothing is retried. The default is 3000 milliseconds, which covers a key fetch on a slow connection with a signature check after it. A publisher whose provider fetches its identifiers or its extra data from slower systems of their own says so on the tag.

## Verification

Green means the identifier's signature verifies under a 51Degrees signing key and nothing more. The wording says "genuine", never "verified for this device". The creator context check described under @ref Identifiers_51Did, which says whether the identifier is being used where it was created, needs the publisher's server and costs two metered uses per identifier, so it is not what an icon on every ad does.

The signature is checked in the browser with Web Crypto, against the public key in force when the identifier was created. Where the identifier's creation minute is within fifteen minutes of a key period boundary the neighboring key is tried as well, because the creator's clock and the key rollover are not the same clock. An identifier that does not read as a 51Did at all is invalid.

## Metering

Two things cost a use of the resource key, and two things cost nothing.

- The loader costs nothing and is not checked. Any cache may hold it.
- The bundle costs one use per page view, and is the request checked against the domains the key is registered for.
- The public keys cost one use per call. ADI keeps the answer in the browser's `localStorage` under `__51d_adi_keys`, one entry per creator domain, and asks again only where it holds nothing for that domain or an identifier is dated after both the newest key it holds and the moment it last asked. That is once per browser per key period, rather than once per ad.
- The signature check costs nothing, because it runs in the browser.

Two ads carrying the same identifier on one page cost one check, because verdicts are kept per identifier for the page.

## Resource key requirements

The resource key needs nothing beyond what every keyed endpoint needs. It must be registered for the domain the page is on, because the bundle request and the key request are both checked against the domains the key names. No product is required for the public keys, because they are what any verifier of a 51Did reads. The 51Did product, described under @ref Identifiers_51Did, is what the page needs to create the identifiers ADI inspects, and that is a requirement of the client script rather than of ADI.

## Languages

ADI ships the visitor's text in the same 24 languages as PMP and chooses one from the browser's own language list, matching the full tag first, then the language on its own, then falling back to `en-us`. The two words `standard` and `personalized` are the Model Terms for Marketing wording in every language, the same words PMP shows, and they are not reworded. Languages written right to left are supported, and the only thing that changes for them is the writing direction the card sets on its own container, never anything on the page. The console lines are for developers and stay English.

## Caching

The loader is cacheable by anybody for a day, because it is the same bytes for every caller and no request for it is counted. The bundle is cacheable only by the browser that asked for it, also for a day, because the bundle is the request that is counted. During development, a hard reload or disabling the cache in developer tools gets past both.

## One copy on a page

ADI stops, with a console warning and nothing rendered, when `window.__51d_adi` already exists as it starts, which is a second copy of the bundle. Two copies would give every ad two icons and every tap two cards. Load the tag once. `window.__51d_adi` carries one member, `rescan()`, for a page whose provider names new slots after the page settled.

## Browser requirement

The bundles are built to ES2020, the 2020 edition of the JavaScript standard, and are not converted for anything older, which covers every browser released since early 2020. The signature check needs Web Crypto, which browsers provide only on a secure context, so the page must be served over `https`, with `localhost` as the exception browsers make.

## Cross-references

- @ref Identifiers_51Did - the identifier ADI inspects, the usage it carries and the public keys it is checked against.
- @ref Identifiers_PMP - the widget that asks the visitor the question whose answer the sentence reports.
- @ref Integrations_Prebid - how the identifier reaches the ad auction, which is where the page reads it back from.

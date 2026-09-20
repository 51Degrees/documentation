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
| `data-alt-name`                | Yes      | -       | Label for the Alternative button, for example "Subscribe to remove ads". Pressing it sets the visitor's Model Terms for Marketing preference to `non-marketing`, see Buttons and what each one stores below. |
| `data-alt-url`                 | Yes      | -       | What the Alternative button does, after it has recorded `non-marketing` as the visitor's answer. An `http(s)` URL navigates the page and a `javascript:` URL runs inline with no navigation. `{preference}` is not substituted here. |
| `data-action-url`              | No       | -       | A hook of your own, invoked on every answer. `{preference}` is replaced with `standard`, `personalized` or `non-marketing`. An `http(s)` URL is injected as `<script src>` and a `javascript:` URL runs inline. Leave it out and there is simply nothing to invoke, with the dialog saving the answer, activating `__tcfapi` and dismissing as usual. See *Where the action URL fits* below. |
| `data-license-key`             | No       | -       | Additional licence key or keys, several separated by `+`, where your products need one on top of the resource key. Anyone reading the page source can see it, exactly as they could when it sat on the URL, so only put one here that you are content to publish. |
| `data-brand-logo`              | No       | -       | URL to the publisher's logo, shown in the dialog header. |
| `data-dialog-heading`          | No       | -       | Your own wording for the first card's heading, in place of the wording PMP ships for the visitor's language. Leave it out and the shipped wording stands. See *The dialog wording* below. |
| `data-dialog-body`             | No       | -       | Your own wording for the paragraph under that heading, on the same terms as `data-dialog-heading`. |
| `data-show-standard`           | No       | `false` | Set to the exact string `true` to offer the Standard option alongside Personalized and the Alternative button. |
| `data-network-name`            | Only when sharing is on | - | The name of the group your sites belong to. The visitor is shown this name as the thing they would be sharing their answer with, so choose one they will already have seen on the sites themselves. It also settles which sites count as one group. See *Sharing an answer across sites* below. |
| `data-network-logo`            | No       | -       | URL to the network's logo, shown in the dialog beside the publisher's own. |
| `data-cookie-domain`           | No       | -       | The domain the `__mtm_pref` cookie is written on, for a site served under more than one name, for example `.example.com`. Leave it out and the cookie is scoped to the exact host the page was served from. See *The answer your own server can read* below. |
| `data-use-third-party-cookies` | No       | `true`  | Whether a visitor who chose Standard or Personalized may be offered the second card, which shares the answer with the other sites in the group. Nothing but the exact string `false` turns it off, so a mistyped value leaves sharing running instead of switching it off without telling you. |
| `data-object-name`             | No       | `fod`   | What the 51Degrees client script's object is called on this page, which is where the third party cookie result and the GDPR answer are read from. Set it only where the client script was built with the `fod-js-object-name` parameter, and set both to the same name. |

`data-timeout` is no longer read. PMP waits a fixed 1500 milliseconds for the cloud when it reads the shared answer at start up and when it writes one, and no attribute changes that. A page that still sets `data-timeout` gets one console warning per page view, and the attribute can come off the tag.

## The dialog wording

PMP ships the dialog text in 24 languages and chooses one from the browser's own language list, so a visitor reading German is answered in German without you doing anything.

`data-dialog-heading` and `data-dialog-body` replace the heading and the paragraph beneath it where the shipped wording does not suit you. Everything else on the card keeps the shipped text.

### Giving the wording per language

Writing the attribute once replaces that text for every language, which is usually wrong for a site with readers in more than one. Suffix the attribute with a language code to set the wording for that language alone.

```html
<script
  src="https://cloud.51degrees.com/api/v4/pmp/YOUR-RESOURCE-KEY.js"
  data-brand-name="Your Brand"
  data-dialog-heading="Choose your marketing experience"
  data-dialog-heading-fr-ca="Choisissez votre expérience marketing"
  data-dialog-heading-fr="Choisissez votre expérience publicitaire">
</script>
```

PMP reads three candidates in order and takes the first one that is present:

1. the attribute suffixed with the whole code of the language it is running in, such as `data-dialog-heading-fr-ca`
2. the attribute suffixed with the language on its own, such as `data-dialog-heading-fr`
3. the attribute with no suffix, which is the fallback for every language that has no variant of its own

Write none of the three and the shipped wording for that language stands, which is why leaving the attribute off altogether is the right thing to do wherever you are content with what PMP already says.

The match ignores case, so `data-dialog-heading-FR` and `data-dialog-heading-fr` are the same attribute. A code with no region never matches a longer one, so a bundle running as `sw` does not pick up `data-dialog-heading-sw-ke`.

An empty value is an answer rather than an absence, so `data-dialog-body=""` gives a blank paragraph instead of falling back to the shipped text.

### Macros

Any key written in square brackets is replaced when the card is drawn, and that applies to your own wording as much as to the text PMP ships.

| Macro | Replaced with |
|-------|---------------|
| `[networkName]` | The value of `data-network-name`. The shipped text of the second card uses it, that being the card which asks whether the answer should apply across the group's sites. |
| `[brandName]` | The value of `data-brand-name`. |
| `[altName]` | The value of `data-alt-name`, which is the label on the alternative button. |
| `[privacyPolicyLink]` | A link to `data-brand-terms-url`, with the link text in the visitor's own language. |

So a heading written as `Welcome to [networkName]` reaches the visitor as "Welcome to Acme Media" wherever `data-network-name` is `Acme Media`. A key that does not exist is left exactly as you wrote it, brackets included, so a typo shows up on the card rather than quietly disappearing.

Your wording is escaped before it is placed into the card, so markup written into one of these attributes is shown to the visitor as characters instead of becoming part of the page.

### What you cannot reword

The two descriptions behind "More information", which say what Standard and Personalized mean, are not open to being reworded. They are the [Model Terms for Marketing](https://m4ow.uk/mtm/2.txt) wording and those same two words travel onwards as `id.usage`. Were one site able to reword them, two sites could send the same value meaning different things, and nothing reading the answer afterwards could tell the difference.

## Buttons and what each one stores

| Button                                | Shown                              | Stores          |
|---------------------------------------|------------------------------------|-----------------|
| Personalized                          | Always                             | `personalized`  |
| The alternative, named by `data-alt-name` | Always                         | `non-marketing` |
| Standard                              | Only with `data-show-standard="true"` | `standard`   |

Each option explains itself behind a "More information" accordion. There is no close cross on the first dialog, so answering is the only way past it. Once answered, the dialog shrinks to a small bubble in the corner that opens it again, and later visits start at that bubble rather than the full dialog, so the visitor can change their answer whenever they like.

The alternative button sets the visitor's preference under the Model Terms for Marketing to `non-marketing`, the third of the three words those terms define beside `standard` and `personalized`, and that word travels every way the other two do. It is stored, written to the `__mtm_pref` cookie for your own server to read, announced on the window so the 51Degrees client script sends it as `id.usage=non-marketing` and the 51Did carries it, and substituted for `{preference}` in `data-action-url`. Then `data-alt-url` runs, where an `http(s)` URL navigates the page and a `javascript:` URL runs inline and leaves the visitor on your site.

**The alternative button used to store `standard`, which said the visitor still accepted standard marketing tracking.** It stores `non-marketing` now, so that a publisher reading an answer shared from another site can tell a visitor who declined from one who accepted the lesser of the two kinds.

No TCF consent string is built for `non-marketing`, because under TCF the visitor consented to nothing and so nothing is claimed. The Model Terms answer and the TCF consent string are different things, being what the visitor asked for under a contract and a claim of consent, and a decline has the first without the second. Whilst that answer stands, `__tcfapi` answers `ping` truthfully, still honours `removeEventListener`, and answers `getTCData` and `addEventListener` with `success: false`. A listener registered before the decline is told once, with `success: false`, that there is no longer any TC data. Choosing Standard or Personalized afterwards restores the full API.

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
2. The bundle reads any answer already held in the `__mtm_pref` cookie. Where that answer was shared across your sites it asks the cloud, whose answer decides.
3. With nothing stored, the dialog is shown.
4. The visitor answers. The answer is saved to the `__mtm_pref` cookie, announced on the window, and the dialog collapses to the bubble.
5. Where the answer was Standard or Personalized and sharing applies, a second card asks whether the answer should be used on the group's other sites.
6. `data-action-url` fires where the tag carries one.

On later visits steps 3 to 5 are skipped, the stored answer is announced and the bubble is shown, so `data-action-url` fires on every page load rather than only on the first answer.

## Sharing an answer across sites

A visitor who has answered on one website should not have to answer again on every other website in the same group. A second card asks whether the answer should be used elsewhere, and it is offered only where all three of these hold.

1. `data-use-third-party-cookies` is left on, which is the default, and `data-network-name` names the group. Leaving the group unnamed turns sharing off, because a visitor cannot be asked to apply an answer across a group of sites without being told which group, and PMP logs a warning saying so and carries on with the rest of the dialog working.
2. The visitor chose Standard or Personalized. The alternative, being the visitor declining marketing, never leads to the second card.
3. The 51Degrees client script has confirmed that third party cookies work in this browser. The confirmation is `ThirdPartyCookiesEnabled` on the client script's object, so your resource key has to ask for @ref DeviceDetection_Features_ThirdPartyCookies. Once the first card is answered PMP allows 3000 milliseconds for that confirmation to arrive, and without it the second card is skipped and the answer stays with this site alone. A browser that blocks third party cookies, which includes Safari and Firefox, therefore never reaches the second card.

## Where the answer is kept

PMP keeps nothing in `localStorage` or `sessionStorage`. On your side the answer lives in two first party cookies on your domain, both set from the page, both readable by script and neither ever `HttpOnly`:

| Cookie | Value | Meaning |
|--------|-------|---------|
| `__mtm_pref` | `standard`, `personalized` or `non-marketing` | The visitor's answer, and the only place this site keeps it. Described in full under the answer your own server can read, below. |
| `__51d_pmp_share` | `shared` | The visitor agreed to use the answer across your group of sites, so the cookie the cloud holds decides and `__mtm_pref` mirrors it. |
| `__51d_pmp_share` | `declined` | The visitor said only this site, so the cloud is never asked for them here. |
| `__51d_pmp_share` | absent | The visitor has not been asked about sharing, and `__mtm_pref` is this site's own answer. |

The second cookie is PMP's own bookkeeping and your server can ignore it. It exists because `__mtm_pref` is a bare word for other platforms and servers to read, and once it also mirrors a shared answer its absence can no longer mean that the cloud should be asked.

To ask the visitor again, for example from a "Change preferences" footer link, expire both cookies and reload the page:

```javascript
for (const name of ['__mtm_pref', '__51d_pmp_share']) {
  document.cookie = name + '=; Path=/; Expires=Thu, 01 Jan 1970 00:00:00 GMT';
}
location.reload();
```

Add `Domain=` with the value of `data-cookie-domain` where you set that attribute, because a cookie written for a domain is expired only by a matching domain.

Clicking the bubble reopens the dialog without clearing anything, so offer that route where the visitor simply wants to change their answer.

A browser still carrying the `__51d_pmp_pref` key that earlier versions kept in `localStorage` is treated as one that has not answered, so such a visitor is asked once more. Nothing reads or removes the old key.

## The answer your own server can read

A request carries cookies, so the answer is visible to your own server and to anything sitting in front of it. PMP writes it as a first party cookie on your domain, which is also the only place this site keeps it:

```
__mtm_pref=personalized; Path=/; Max-Age=34560000; SameSite=Lax; Secure
```

The value is the bare word, one of `standard`, `personalized` or `non-marketing`, so whatever handles the request can act on it without knowing anything about PMP. The `mtm` in the name is the Model Terms for Marketing, under which the three words are defined. The name has no 51Degrees in it deliberately, so that a platform other than this one can set the same cookie and be understood the same way.

The alternative, being the visitor declining marketing, is written like the other two. A server that sees no cookie cannot tell a visitor who declined from one who was never asked, and those are not the same thing.

`SameSite=Lax` because your server needs the cookie on the ordinary navigation that fetches the page. `Secure` is asked for on https only, since a browser refuses a secure cookie over plain http and drops it altogether. The life is 400 days, which is where Chrome caps a cookie and quietly shortens anything longer.

It is never `HttpOnly`. PMP sets the cookie from the page and reads it back there, and a browser lets a script neither read nor replace a cookie carrying that flag, so a server that also writes `__mtm_pref` must leave the flag off or the visitor's next answer is silently lost. The cookie the cloud keeps on its own domain is the opposite, `HttpOnly` by design, because only the cloud reads it.

### A site served under more than one name

Set `data-cookie-domain` to the domain the cookie should cover, for example `.example.com`. Without it the cookie is scoped to the exact host, so a visitor answering on `www.example.com` is asked again on `example.com`, and the two answers can then disagree with nothing to say which of them came later.

You write it rather than PMP working it out, because scoping a cookie to a whole site means knowing where the registrable part of a name begins and a browser does not tell a page that. A value that is not a domain is refused, and the cookie falls back to the exact host rather than the value reaching the header.

Adding the attribute to a site whose visitors already hold the host-scoped cookie takes that one off before setting the wider one, so the older answer is not left beside the new one under the same name. Both cookies carry the attribute.

### Which answer the cookie carries

Where the answer is shared across sites, which `__51d_pmp_share=shared` records, the cookie the cloud holds decides and this one mirrors it. Every page load then asks the cloud first, so a change the visitor makes on another of your sites arrives here, and where the cloud cannot be reached the mirror stands in for it. Where there is no shared answer, which is a visitor who kept their choice to this site or a browser where third party cookies do not work, this one carries the answer on its own and no request is made.

It is taken off when there is no answer anywhere, so a visitor whose shared answer was cleared does not leave a cookie behind that your server goes on reading, and the `shared` marker goes with it. It is not taken off merely because the cloud could not be reached, since being unable to ask is not the same as being told there is none.

## Browser requirement

The bundles are built to ES2020 and nothing transpiles them below it, which covers every browser released since early 2020. Televisions, set-top boxes and games consoles are the ones to watch, as their browsers tend to lag well behind a phone bought at the same time and seldom get updated after the device ships, so check what such a device supports before deploying PMP to it.

## Cross-references

- @ref Identifiers_51Did - how `id.usage` is consumed. PMP maps the visitor's choice to an `id.usage` value itself (the *Direct* path under *Setting the usage policy*), and a caller who would rather hand the cloud a raw TCF or GPP string and have it derive `id.usage` uses the *Derived from consent* path on the same page.
- @ref DeviceDetection_Features_ThirdPartyCookies - the client script result the second card depends on.
- @ref Integrations_Prebid - downstream RTB enrichment that consumes the 51Did.

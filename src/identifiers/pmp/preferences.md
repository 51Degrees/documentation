@page Identifiers_PMP_Preferences Preferences

## Buttons and what each one stores

| Button                                | Shown                              | Stores          |
|---------------------------------------|------------------------------------|-----------------|
| Personalized                          | Always                             | `personalized`  |
| The alternative, named by `data-alt-name` | Always                         | `non-marketing` |
| Standard                              | Only with `data-show-standard="true"` | `standard`   |

Each option has a description behind an expandable "More information" section. There is no close cross on the first dialog, so answering is the only way past it. Once answered, the dialog shrinks to a small bubble in the corner that opens it again, and later visits start at that bubble rather than the full dialog, so the visitor can change their answer whenever they like.

The alternative button sets the visitor's preference under the Model Terms for Marketing to `non-marketing`, the third of the three words those terms define beside `standard` and `personalized`, and that word travels every way the other two do. PMP writes it to the `__mtm_pref` cookie for your own server to read and substitutes it for `{preference}` in `data-action-url`. It also fires the `51d-pmp-preference` event on the window, so the 51Degrees client script sends it as `id.usage=non-marketing` and the 51Did carries it. Then `data-alt-url` runs, where an `http(s)` URL navigates the page and a `javascript:` URL runs inline and leaves the visitor on your site.

The alternative button stores `non-marketing` rather than `standard`, so that a publisher reading an answer shared from another site can tell a visitor who declined from one who accepted the lesser of the two kinds.

No TCF consent string is built for `non-marketing`, because under TCF the visitor consented to nothing and so nothing is claimed. The Model Terms answer and the TCF consent string are different things, being what the visitor asked for under a contract and a claim of consent, and a decline has the first without the second. Whilst that answer stands, `__tcfapi` answers `ping` truthfully, still honors `removeEventListener`, and answers `getTCData` and `addEventListener` with `success: false`. A listener registered before the decline is told once, with `success: false`, that there is no longer any TC data. Choosing Standard or Personalized afterwards restores the full API.

## `id.usage` mapping

| Preference      | Meaning                                              |
|-----------------|------------------------------------------------------|
| `non-marketing` | Analytics, fraud prevention and security only.       |
| `standard`      | Marketing and other content unrelated to your browsing history or interactions, such as content chosen by time, region and the page in view. |
| `personalized`  | Marketing and other content related to your browsing history or interactions. |

The question is asked whether or not your Resource Key carries the 51Did product, because the dialog, the answer, the window event and the consent surface work without it. The product decides what an answer produces rather than whether it can be given. `non-marketing` gets a 51Did whatever the license holds. `standard` and `personalized` are marketing usages, so the cloud issues no 51Did for either one unless the license behind the Resource Key carries the 51Did product, and where it does not the reason comes back in place of the identifier.

## How the answer reaches the cloud

Every answer fires the `51d-pmp-preference` event on the window, whichever path it came by, being a choice, the alternative button, an answer this site already held or one that came back from the shared store:

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

The getter answers from memory rather than from storage, the shared store's answer included, and neither the event nor the getter writes anything to the browser.

### Where the action URL fits

`data-action-url` is a hook for your own code, such as an analytics call, and it is not how the answer reaches the cloud:

```html
data-action-url="javascript:yourAnalytics('{preference}')"
```

Do not point it at the client script's address. The client script hears the answer for itself and refreshes, so it does not need loading again, and an action URL naming the cloud is skipped with a console message where the client script's object is on the page or on its way.

## Where the answer is kept

PMP keeps nothing in `localStorage` or `sessionStorage`. On your side there are two first party cookies on your domain, both set from the page, both readable by script and neither ever `HttpOnly`:

| Cookie | Value | Meaning |
|--------|-------|---------|
| `__mtm_pref` | `standard`, `personalized` or `non-marketing` | The visitor's answer, and the only place this site keeps it. Described in full under *The answer your own server can read* below. |
| `__51d_pmp_share` | `shared` | The visitor agreed to use the answer across your group of sites, so the cookie the cloud holds decides and `__mtm_pref` mirrors it. |
| `__51d_pmp_share` | `declined` | The visitor said only this site, so the cloud is never asked for them here. |
| `__51d_pmp_share` | absent | The visitor has not been asked about sharing, and `__mtm_pref` is this site's own answer. |

The second cookie is PMP's own bookkeeping and your server can ignore it. It exists because `__mtm_pref` is a bare word for other systems and servers to read, and once that word can be a mirror of a shared answer, the cookie on its own no longer says whether the cloud should be asked again.

To ask the visitor again, for example from a "Change preferences" footer link, expire both cookies and reload the page:

```javascript
for (const name of ['__mtm_pref', '__51d_pmp_share']) {
  document.cookie = name + '=; Path=/; Expires=Thu, 01 Jan 1970 00:00:00 GMT';
}
location.reload();
```

Add `Domain=` with the value of `data-cookie-domain` where you set that attribute, because a cookie written for a domain is expired only by a matching domain.

Clicking the bubble reopens the dialog without clearing anything, so offer that route where the visitor wants to change their answer rather than start again.

## The answer your own server can read

A request carries cookies, so the answer is visible to your own server and to anything sitting in front of it. PMP writes it as a first party cookie on your domain:

```
__mtm_pref=personalized; Path=/; Max-Age=34560000; SameSite=Lax; Secure
```

The value is the bare word, one of `standard`, `personalized` or `non-marketing`, so whatever handles the request can act on it without knowing anything about PMP. The `mtm` in the name is the Model Terms for Marketing, under which the three words are defined. The name has no 51Degrees in it deliberately, so that a system other than PMP can set the same cookie and be understood the same way.

The alternative, being the visitor declining marketing, is written like the other two. A server that sees no cookie cannot tell a visitor who declined from one who was never asked, and those are not the same thing.

`SameSite=Lax` is set because your server needs the cookie on the ordinary navigation that fetches the page. `Secure` is asked for on https only, since a browser refuses a secure cookie over plain http and drops it altogether. The life is 400 days, which is where Chrome caps a cookie and quietly shortens anything longer.

`__mtm_pref` is never `HttpOnly`. PMP sets the cookie from the page and reads it back there, and a browser lets a script neither read nor replace a cookie carrying that flag, so a server that also writes `__mtm_pref` must leave the flag off or the visitor's next answer is silently lost. The one cookie in this design that is `HttpOnly` is a different cookie on a different domain, the copy of a shared answer the cloud keeps on `cloud.51degrees.com` under a name derived from your account, and it carries the flag because only the cloud ever reads it. No page can see that cookie whatever the flag says, and nothing PMP writes on your domain carries it.

### A site served under more than one name

Set `data-cookie-domain` to the domain the cookie should cover, for example `.example.com`. Without it the cookie is scoped to the exact host, so a visitor answering on `www.example.com` is asked again on `example.com`, and the two answers can then disagree with nothing to say which of them came later.

You write it rather than PMP working it out, because scoping a cookie to a whole site means knowing where the registrable part of a name begins and a browser does not tell a page that. A value that is not a domain is refused, and the cookie falls back to the exact host rather than the value reaching the header.

Adding the attribute to a site whose visitors already hold the host-scoped cookie takes that one off before setting the wider one, so the older answer is not left beside the new one under the same name. Both cookies carry the attribute.

### Which answer the cookie carries

Where the answer is shared across sites, which `__51d_pmp_share=shared` records, the cookie the cloud holds decides and this one mirrors it. Every page load then asks the cloud first, so a change the visitor makes on another of your sites arrives here, and where the cloud cannot be reached the mirror stands in for it. Where there is no shared answer, which is a visitor who kept their choice to this site or a browser where third party cookies do not work, this one carries the answer on its own and no request is made.

The cookie is taken off when there is no answer anywhere, so a visitor whose shared answer was cleared does not leave a cookie behind that your server goes on reading, and the `shared` marker goes with it. The cookie is not taken off merely because the cloud could not be reached, since being unable to ask is not the same as being told there is none.

## The consent surface

The standard `__tcfapi` is available to ad tags and other scripts once the visitor has answered, or from the first moment where an answer was already held:

```javascript
__tcfapi('addEventListener', 2, function (tcData, success) {
  // tcData.eventStatus is 'tcloaded' when a consent string is ready,
  // 'cmpuishown' when the dialog is shown again, and
  // 'useractioncomplete' when the visitor has just answered.
  if (!success) return; // no TC data while the alternative answer stands
  console.log(tcData.eventStatus, tcData.tcString);
});
```

The consent string is the publisher's own from `data-tcf-vendor` with the purpose bits, the dates, the CMP id and the policy and vendor list versions rewritten for the answer, so it starts differently from the string on the tag and ends the same, and the vendor consents in it are exactly what the publisher put there. The CMP id it reports is that of a consent management platform currently registered on the IAB Global CMP List, and a different one each UTC day, which is what PMP is meant to do rather than a stand-in for an id of its own. The id written into the consent string and the id `__tcfapi` reports are always the same value for a page, and a page left open past midnight keeps the one it loaded with.

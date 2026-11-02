@page Identifiers_PMP_Integration Integration

## Adding the tag

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

PMP reads two things from the 51Degrees client script, being whether third party cookies work in this browser and whether the General Data Protection Regulation (GDPR) applies. The first decides whether the second card can be offered and the second is what PMP reports as `gdprApplies` through `__tcfapi`, the consent function that ad scripts call. Both come from properties on your Resource Key, `ThirdPartyCookiesEnabled` with `ThirdPartyCookiesEnabledJavaScript` and `IsGdpr`, so ask for those when you create the key and put the client script on the page too:

```html
<script src="https://cloud.51degrees.com/api/v4/YOUR-RESOURCE-KEY.js" async></script>
```

The two tags can go in either order and both can carry `async`, because the client script listens on the window for PMP's answer whilst PMP watches for the client script's object, which is `fod` unless `data-object-name` says otherwise. The object is the only thing PMP looks at, so it does not matter where the client script came from, and one served by a different 51Degrees cloud, by a proxy of your own or out of a bundle you built yourself all work the same way.

An `async` tag has usually not run at the moment PMP starts, so an object that is not there yet is not an object that is never coming, and PMP waits for it instead of deciding straight away. The wait finishes once your page has loaded, since every tag written into the markup has had its turn by then, and it is capped at 5000 milliseconds for a page whose load event is very late. If nothing has appeared by the end of it, PMP loads the client script itself from the cloud that served PMP, using the Resource Key it already has, and says so in the console. Writing the tag yourself is still the better option, because then the placement and the timing are yours.

Load the client script once. A second copy runs a second round and creates a second identifier, and the client script itself warns about it.

## Opening the dialog from your page

```javascript
window.__51d_pmp.open();
```

That shows the dialog again, as it was on the first visit, and is what a "Change preferences" link in a footer calls. The bubble in the corner does the same thing, so the call is only needed for an entry point of your own. `window.__51d_pmp` carries two members, `open()` and `preference()`, and nothing else.

### One copy on a page

PMP checks two things as it starts. If either is true, PMP writes a console warning and renders nothing.

- `window.__51d_pmp` already exists. A second copy of the bundle is on the page. Two copies would give the visitor two dialogs and fire the action URL twice on every answer.
- `window.__tcfapi` already exists and is not PMP's own. Another consent management platform is on the page. PMP is a complete Transparency and Consent Framework implementation of its own, so the two never share a page.

Load the tag once, on a page that runs no other consent tool.

## Caching

The loader is cacheable by anybody for a day, because it is the same bytes for every caller and no request for it is counted against the key's monthly requests. The bundle is cacheable only by the browser that asked for it, also for a day, because the bundle is the request that is counted. During development, a hard reload or disabling the cache in developer tools gets past both, and there are two scripts to get past, the loader and the bundle it pulled in.

## Browser requirement

The bundles are built to ES2020, the 2020 edition of the JavaScript standard, and are not converted for anything older, which covers every browser released since early 2020. Televisions, set-top boxes and games consoles are the ones to watch, as their browsers tend to lag well behind a phone bought at the same time and seldom get updated after the device ships, so check what such a device supports before deploying PMP to it.

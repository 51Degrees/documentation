@page DeviceDetection_Features_ThirdPartyCookies Third-party cookie detection

# Introduction

Third-party cookies are set by a site other than the one the user is visiting. Whether a browser accepts them depends on the browser, its version, and the user's settings.

If your application uses third-party cookies, for example for advertising, analytics, or sign-in, check whether the visitor's browser accepts them so that you can switch to an alternative when it does not.

51Degrees provides a lightweight, stateless mechanism to detect third-party cookie support as part of the cloud service.

# How it works

The generated @ref PipelineApi_Features_ClientSideEvidence "client-side evidence" JavaScript checks whether the browser can send a cookie to a third-party domain.

## Two-origin architecture

The detection requires two distinct origins:

1. **Origin A** - The customer's website (e.g., `example.com`)
2. **Origin B** - The third-party detection endpoint (e.g., `cloud.51degrees.com`)

## Detection flow

1. The user's page on Origin A includes the 51Degrees @ref PipelineApi_Features_ClientSideEvidence "client-side evidence" JavaScript. This JavaScript can be served from either Origin A (first-party) or Origin B (third-party) - the serving location does not affect the detection.
2. The JavaScript contains a detection snippet that always makes a request to the third-party endpoint (Origin B) to check cookie support.
3. When the third-party endpoint receives the initial request, it sets a detection cookie: `51D_ThirdPartyCookiesEnabled=true` with `SameSite=None; Secure` attributes.
4. If the browser supports third-party cookies, it stores the cookie.
5. The JavaScript makes a subsequent callback request to Origin B with credentials.
6. The endpoint answers `{"status": true}` when the cookie came back with the request and `{"status": false}` when it did not. The JavaScript asks twice before it treats the cookie as blocked.
7. The JavaScript records the answer as `51D_ThirdPartyCookiesEnabled`, set to `True`, `False`, or `Unknown` when the endpoint could not be reached, and sends that value as evidence with the callback, so `ThirdPartyCookiesEnabled` takes the same value.

The key point is that regardless of where the JavaScript is served from, the detection snippet inside always communicates with a third-party domain to test cross-origin cookie behavior.

## Cookie attributes

The detection cookie uses specific attributes required for cross-site delivery in modern browsers:

| Attribute | Value | Purpose |
|-----------|-------|---------|
| Name | `51D_ThirdPartyCookiesEnabled` | Identifies the detection cookie |
| SameSite | `None` | Required for cross-site cookie delivery |
| Secure | `true` | Required when SameSite=None |
| Max-Age | `5` | Minimal cookie persistence (5 seconds) |
| Path | `/` | Available across all paths |

# Properties

The following properties are available after detection. On the client side, these properties can be retrieved in the callback passed to `fod.complete`:

```javascript
fod.complete(function(data) {
  if (data.device.thirdpartycookiesenabled) {
    console.log("Third-party cookies enabled: " + data.device.thirdpartycookiesenabled);
  }
});
```

## ThirdPartyCookiesEnabled

A string value indicating whether third-party cookies are enabled in the user's browser. Until the JavaScript in `ThirdPartyCookiesEnabledJavaScript` has run, the value is the likely status for the browser.

| Value | Meaning |
|-------|---------|
| `True` | Third-party cookies are enabled, and the JavaScript has confirmed it |
| `False` | Third-party cookies are not enabled, and the JavaScript has confirmed it |
| `ProbablyTrue` | Third-party cookies are enabled by default for this browser, and the JavaScript has not confirmed it |
| `ProbablyFalse` | Third-party cookies are not enabled by default for this browser, and the JavaScript has not confirmed it |
| `Unknown` | The status is not known, either for this browser by default or because the JavaScript could not complete its check |

## ThirdPartyCookiesEnabledJavaScript

A JavaScript snippet for client-side detection. This property is populated only when server-side detection was not conclusive (e.g., on the first request before the callback). When server-side detection succeeds, this property is empty, eliminating the need for additional client-side detection logic.

# Integration

Third-party cookies detection is automatically performed when using the 51Degrees @ref PipelineApi_Features_ClientSideEvidence "client-side evidence" JavaScript integration.

**Note:** If you are using the 51Degrees Cloud service, you need a Resource Key that includes the `ThirdPartyCookiesEnabled` and `ThirdPartyCookiesEnabledJavaScript` properties. The @ref Services_Configurator "Resource Key guide" shows how to create one.

After the JavaScript callback to the cloud service, the response includes the cookie detection result alongside the other device detection properties.

## Custom endpoint configuration

By default, the detection snippet calls `https://cloud.51degrees.com/api/v4/3pc`. If you host the cloud service yourself (see @ref Services_Cloud_SelfHostedDocker) or need to use a different endpoint, put the endpoint on a different domain from your pages, not on a subdomain of your own site. A browser treats a cookie from your own site as a first-party cookie, so the check would report third-party cookies as enabled even when the browser blocks them. Then set the `window.fodTpcEndpoint` global variable to the full address of the endpoint before loading the JavaScript:

```html
<script>
  window.fodTpcEndpoint = "https://your-custom-3pc-detection-endpoint";
</script>
<script src="51Degrees.core.js"></script>
```

This allows you to point the detection to your own hosted instance while maintaining the third-party cookie detection functionality.

# Browser support considerations

Modern browsers have varying levels of third-party cookie support:

- **Safari**: Blocks third-party cookies by default via Intelligent Tracking Prevention (ITP).
- **Firefox**: Blocks third-party tracking cookies by default via Enhanced Tracking Protection (ETP).
- **Chrome**: Google no longer plans to phase out third-party cookies, and users can block them in Chrome's settings. Chrome Incognito mode blocks third-party cookies by default.
- **Edge**: Follows similar patterns to Chrome with configurable tracking prevention levels.

This detection feature allows your application to adapt to the user's actual browser configuration rather than relying on browser identification alone.

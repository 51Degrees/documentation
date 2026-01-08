@page DeviceDetection_Features_ThirdPartyCookies Third-Party Cookies Detection

# Introduction

Third-party cookies are cookies set by a domain other than the one the user is currently visiting. Web browsers have been increasingly restricting third-party cookies due to privacy concerns, with many browsers now blocking them by default or planning to phase them out.

For businesses that rely on third-party cookies for functionality such as cross-site tracking, personalization, or analytics, it is important to know whether a user's browser supports third-party cookies. This allows applications to adapt their behavior accordingly, such as falling back to alternative methods when third-party cookies are unavailable.

51Degrees provides a lightweight, stateless mechanism to detect third-party cookie support as part of the cloud service.

# How It Works

The detection mechanism relies on verifying whether the browser can send cookies to a third-party domain. This is achieved through generated @ref PipelineApi_Features_ClientSideEvidence "client-side evidence" JavaScript that contains special detection snippets.

## Two-Origin Architecture

The detection requires two distinct origins:

1. **Origin A** - The customer's website (e.g., `example.com`)
2. **Origin B** - The third-party detection endpoint (e.g., `cloud.51degrees.com`)

## Detection Flow

1. The user's page on Origin A includes the 51Degrees @ref PipelineApi_Features_ClientSideEvidence "client-side evidence" JavaScript. This JavaScript can be served from either Origin A (first-party) or Origin B (third-party) - the serving location does not affect the detection.
2. The JavaScript contains a detection snippet that always makes a request to the third-party endpoint (Origin B) to check cookie support.
3. When the third-party endpoint receives the initial request, it sets a detection cookie: `51D_ThirdPartyCookiesEnabled=true` with `SameSite=None; Secure` attributes.
4. If the browser supports third-party cookies, it stores the cookie.
5. The JavaScript makes a subsequent callback request to Origin B with credentials.
6. If the cookie was stored and sent with the callback, the server detects it and sets `ThirdPartyCookiesEnabled` to `True` in the response.
7. If the cookie was not sent (third-party cookies blocked), the server sets `ThirdPartyCookiesEnabled` to `False`.

The key point is that regardless of where the JavaScript is served from, the detection snippet inside always communicates with a third-party domain to test cross-origin cookie behavior.

## Cookie Attributes

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

A boolean value indicating whether third-party cookies are supported by the user's browser.

| Value | Meaning |
|-------|---------|
| `True` | Third-party cookies are enabled and working |
| `False` | Third-party cookies are blocked or unavailable |

## ThirdPartyCookiesEnabledJavascript

A JavaScript snippet for client-side detection. This property is populated only when server-side detection was not conclusive (e.g., on the first request before the callback). When server-side detection succeeds, this property is empty, eliminating the need for additional client-side detection logic.

# Integration

Third-party cookies detection is automatically performed when using the 51Degrees @ref PipelineApi_Features_ClientSideEvidence "client-side evidence" JavaScript integration.

**Note:** If you are using the 51Degrees Cloud service, you need to create a resource key that includes the `ThirdPartyCookiesEnabled` and `ThirdPartyCookiesEnabledJavascript` properties. Use the @ref Services_Configurator "Configurator" to create or update your resource key with these properties enabled.

When the JavaScript is loaded and makes its callback to the cloud service, the detection happens transparently. The results are available in the response data alongside other device detection properties.

## Custom Endpoint Configuration

By default, the detection snippet communicates with `cloud.51degrees.com`. If you are hosting your own 51Degrees cloud service or need to use a different endpoint, you can customize the third-party cookie detection endpoint by setting the `window.fodTpcEndpoint` global variable before loading the JavaScript:

```html
<script>
  window.fodTpcEndpoint = "https://your-custom-3pc-detection-endpoint";
</script>
<script src="51Degrees.core.js"></script>
```

This allows you to point the detection to your own hosted instance while maintaining the third-party cookie detection functionality.

# Browser Support Considerations

Modern browsers have varying levels of third-party cookie support:

- **Safari**: Blocks third-party cookies by default via Intelligent Tracking Prevention (ITP).
- **Firefox**: Blocks third-party tracking cookies by default via Enhanced Tracking Protection (ETP).
- **Chrome**: Planning to phase out third-party cookies (check current status as this is evolving). Note that Chrome Incognito mode blocks third-party cookies by default.
- **Edge**: Follows similar patterns to Chrome with configurable tracking prevention levels.

This detection feature allows your application to adapt to the user's actual browser configuration rather than relying on browser identification alone.

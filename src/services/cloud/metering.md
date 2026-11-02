@page Services_Cloud_Metering Which requests count

Every Resource Key has a monthly allowance of requests, set by the plan behind it, and a License Key used on its own counts against the subscription it belongs to in the same way. This page says which calls to the cloud count against that allowance and which do not.

# The rules

- A call counts once when the service runs it through its pipeline with your key. The size of the answer and the number of properties in it make no difference.
- A call the service refuses before running the pipeline is not counted. That covers every CORS preflight, which is an `OPTIONS` request, and every request to an endpoint that needs a key sent with no key at all, which is refused with `401`.
- A loader script is never counted, because it is the same bytes for every caller and names the key only so that the bundle request can carry it. The bundle request that follows is the one that counts.
- A page view where the visitor leaves before the bundle loads uses no request.
- Caching reduces what you use. Most answers are `Cache-Control: private` for 1800 seconds, so a browser can reuse an answer without a second request, and the loaders can be cached by anyone for a day.

# Every endpoint

| Endpoint | Counted | Notes |
|---|---|---|
| `/api/v4/<key>.json` and `/api/v4/json` | Yes | One per call, with a Resource Key or with a License Key and `values`. |
| `/api/v4/<key>.js` and `/api/v4/js` | Yes | One per call. Each call the script then makes back to the cloud is a further request. |
| `/api/v4/accessibleproperties` | Yes | One per call. |
| `/api/v4/evidencekeys` | Only with a key | Counted when a Resource Key or a License Key is sent, because the answer is then narrowed to that key's properties. Not counted without one. |
| `/api/v4/pmp/<key>.js` and `/api/v4/adi/<key>.js` | No | The loaders. |
| `/api/v4/pmp/<key>/<name>` and `/api/v4/adi/<key>/<name>` | Yes | The bundles, one per page view. |
| `/api/v4/pmp/pref` | No | The shared answer store. The key identifies the caller and is not charged. |
| `/api/v4/id/key` | Yes | One per call. ADI keeps the answer in the browser, so it asks about once per key period rather than once per ad. |
| `/api/v4/id/verify` | Yes | One per call. |
| `/api/v4/id/verify-context` and `/api/v4/id/verify-full` | Yes | One per call. The device and network check inside the call is not a second request. |
| `/api/v4/id/redeem` | Yes | One per call, so a verification followed by its redemption is two. |
| `/api/v4/attestation/verify` | Yes | One per call. |
| `/owid/api/v3/public-key` | Yes | One per call. |
| `/owid/api/v3/verify` | No | Needs no key. |
| `/api/v4/resource`, `/api/v4/3pc`, `/api/info/*`, `/api/metadata/*` and `/api/v4/oauth/*` | No | Need no key. |
| `/cdn/*` | No | Not charged to any key. |

# Find out more

- @ref Services_Cloud_ResourceKeys, for the two kinds of key and the domains a key accepts
- @ref Services_Cloud_Overview, for the caching rules
- @ref Identifiers_PMP and @ref Identifiers_ADI, for the loader and bundle requests
- [Pricing](https://51degrees.com/pricing), for the allowance each plan gives

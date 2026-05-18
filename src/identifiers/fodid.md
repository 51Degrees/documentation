@page Identifiers_51DiD 51DiD (51Degrees Identifier)

A signed, probabilistic identifier encoded as an <a href="https://github.com/SWAN-community/owid/blob/main/explainer.md">OWID - Open Web ID</a>, the SWAN community schema that defines the binary layout, signature, and verification rules. Derived from three inputs:

- The **Device ID** - a `Hardware-Platform-Browser-IsCrawler` tuple where each component is the profile ID assigned by Device Detection. See the [property dictionary](https://51degrees.com/developers/property-dictionary?item=Metrics%7CAll) for the `DeviceId` property and @ref DeviceDetection_Overview for how it is produced.
- The **client IP** of the request.
- The **usage purpose** declared per request (see `id.usage` below).

Returned by the V4 cloud JSON endpoint when the Resource Key includes the relevant properties.

## Properties

| Property             | Scope                                          |
|----------------------|------------------------------------------------|
| `fodid.idprobglobal` | Unique across all callers from device+network. |
| `fodid.idproblic`    | Unique only across the caller's License Key.   |

## Request inputs

- **Evidence** - Device Detection evidence (User-Agent / UA-CH) AND client IP (`client-ip` query parameter, `client-ip` HTTP header, or the server-supplied client IP).
- **Usage policy** - the `id.usage` value, one of `non-marketing` | `standard` | `personalized`. May be passed as a query parameter or HTTP request header.

## Usage policies and licensing

| `id.usage`     | Requires                                |
|----------------|-----------------------------------------|
| `non-marketing`| `fodid.*` on the Resource Key only.     |
| `standard`     | License Key carries `CloudV5FODiD`.     |
| `personalized` | License Key carries `CloudV5FODiD`.     |

`CloudV5FODiD` is gated by Know Your Customer (KYC) checks and contractual Model Terms preventing the 51DiD being treated as personal data by the recipient once it leaves the cloud service. `non-marketing` 51DiDs are provided under legitimate interest and must not leave the customer environment.

If `id.usage` is omitted, or set to `standard` / `personalized` while the License Key lacks `CloudV5FODiD`, the `fodid.*` properties are returned with a no-value reason rather than throwing. Any value other than the three listed above is rejected as an invalid usage.

## Example

```
GET /api/v4/json?resource=<RESOURCE_KEY>
    &user-agent=iPhone
    &client-ip=203.0.113.42
    &id.usage=standard
```

Response:

```json
{
  "fodid": {
    "idprobglobal": "<base64-encoded signed 51DiD>",
    "idproblic":    "<base64-encoded signed 51DiD>"
  }
}
```

## Use cases

- **Marketing** - PMP captures the user's preference and feeds it as `id.usage`; the 51DiD is consumed by Prebid / RTB enrichment. See @ref Identifiers_PMP and @ref DeviceDetection_OtherIntegrations_Prebid.
- **Non-marketing** - the integrator sets `id.usage=non-marketing` server-side for fraud, bot or suspicious-activity detection (for example, the suspicious-activity module in the 51Degrees WordPress plugin). The identifier never leaves the customer environment.

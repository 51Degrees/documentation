@page Identifiers_51DiD 51DiD (51Degrees Identifier)

A signed, probabilistic identifier encoded as an <a href="https://github.com/SWAN-community/owid/blob/main/explainer.md">OWID - Open Web ID</a>, the SWAN community schema that defines the binary layout, signature, and verification rules.

Derived from three inputs:

- The **Device ID** - a `Hardware-Platform-Browser-IsCrawler` tuple where each component is the profile ID assigned by Device Detection. See the [property dictionary](https://51degrees.com/developers/property-dictionary?item=Metrics%7CAll) for the `DeviceId` property and @ref DeviceDetection_Overview for how it is produced.
- The **client IP** of the request.
- The **usage purpose** declared per request (see *Usage flags* below).

51DiDs are produced only by the V4 cloud JSON endpoint when the Resource Key includes the relevant properties. **The 51DiD is not available in the on-premise pipeline:** every identifier is signed with a private ECDSA P-256 key held only by 51Degrees' cloud service, so that recipients can verify authenticity without trusting the caller. An on-premise pipeline never holds the signing key and so cannot mint a valid 51DiD.

## Usage flags

The 51DiD payload starts with a one-byte **flags** field that records which usage purposes the cloud was allowed to derive the identifier for. Three flags are defined:

| Flag             | Purpose                                                          |
|------------------|------------------------------------------------------------------|
| `non-marketing`  | Analytics, fraud prevention and security only.                   |
| `standard`       | Standard advertising and audience measurement.                   |
| `personalized`   | Personalised advertising and targeted content.                   |

The flags are hierarchical -- `personalized` implies `standard`, and `standard` implies `non-marketing` -- mirroring the kind of consent tier a user dialog typically offers (a single tier per visitor that covers every use below it).

**Only `non-marketing` global 51DiDs are available in the free tier.** Issuing a 51DiD for `standard` or `personalized` purposes requires a **Special license key** on the Resource Key -- see *Usage policies and licensing* below.

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
| `standard`     | Special license key required.           |
| `personalized` | Special license key required.           |

`standard` and `personalized` 51DiDs are issued under contractual Model Terms that prevent the identifier being treated as personal data by the recipient once it leaves the cloud service, and are gated by Know Your Customer (KYC) checks before the Special license key is granted. Contact 51Degrees to apply.

`non-marketing` 51DiDs are provided under legitimate interest and must not leave the customer environment.

If `id.usage` is omitted, or set to `standard` / `personalized` while the Resource Key lacks the Special license key, the `fodid.*` properties are returned with a no-value reason rather than throwing. Any value other than the three listed above is rejected as an invalid usage.

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
    "idprobglobal": "AzUxZC5lcwBzGTMAJQAAAAHWTQAAr193zLwxDrchR2XHYmoTzJML7fAB60rimQeTd2WuHMPoQ4Bz56QhxhXoAynWyaAE8kWo8DO92y9LPLdatHSVaCdSioL7JaMg8S2DV36ehXIZc0HhdqteyARmOnRS7o8j",
    "idproblic":    "..."
  }
}
```

Open the example value in the [51DiD inspector](https://51degrees.com/developers/51did-inspector?51did=AzUxZC5lcwBzGTMAJQAAAAHWTQAAr193zLwxDrchR2XHYmoTzJML7fAB60rimQeTd2WuHMPoQ4Bz56QhxhXoAynWyaAE8kWo8DO92y9LPLdatHSVaCdSioL7JaMg8S2DV36ehXIZc0HhdqteyARmOnRS7o8j) to unpack the OWID envelope, see the parsed flags, licenseId and 32-byte hash, and verify the ECDSA P-256 signature against the issuer's published public key.

## Comparing two 51DiDs

A 51DiD is an OWID envelope wrapping a probabilistic identifier payload. Two responses for the same device + IP + usage will differ at the byte level because the envelope embeds a freshly minted timestamp and signature each time. To decide whether two 51DiDs **identify the same caller**, compare only the 32-byte hash inside the payload, never the full base64 value.

Two responses to the same device + IP + `id.usage=non-marketing`, returned a few seconds apart:

```
51DiD A (base64) : AzUxZC5lcwBzGTMAJQAAAAHWTQAAr193zLwxDrchR2XHYmoTzJML7fAB60rimQeTd2WuHMPoQ4...
51DiD B (base64) : AzUxZC5lcwCxHzMAJQAAAAHWTQAAr193zLwxDrchR2XHYmoTzJML7fAB60rimQeTd2WuHMPoQ4...
                              ^^^^^^                                                ^^^^^^^^
                              date differs                              signature differs further down
```

Unpacked with the `FiftyOne.Did` NuGet (see [51Degrees/pipeline-dotnet#299](https://github.com/51Degrees/pipeline-dotnet/pull/299)):

```csharp
var a = new FodId(idprobglobalA);
var b = new FodId(idprobglobalB);

// Wrapper bytes (Domain, Date, Signature) ARE different:
Console.WriteLine(a.Date == b.Date);          // false
Console.WriteLine(a.Signature.SequenceEqual(b.Signature)); // false

// Payload hashes (the probabilistic identifier) ARE the same:
Console.WriteLine(a.Hash.SequenceEqual(b.Hash));           // true
```

Use `FodId.Hash` (32 bytes, SHA-256) as the cache / dedup key. The same hash means the same caller under the same usage policy on the same License Key (for `idproblic`) or across all callers (for `idprobglobal`).

## Validation

A 51DiD recipient should verify the signature before trusting the identifier. Two options:

1. **Cloud endpoint.** Send the base64 value to the verification endpoint on the V4 cloud and get back a parsed payload only if the signature checks out. Simple, no key handling, but every call is metered against the Resource Key.
2. **Local verification using the published public key.** Fetch 51Degrees' public ECDSA P-256 key once, cache it, and verify in-process for every received identifier. No metering. The `FiftyOne.Did` NuGet exposes the inherited `Owid.VerifyAsync` method that takes the public key PEM and returns a boolean -- see the package's `FodIdTests.cs` for a worked example.

In both cases, validation only confirms the identifier was minted by 51Degrees and has not been tampered with. It does not certify that the device + IP + usage inputs were truthful: that trust lives in the operational contract with the issuing 51Degrees cloud, not in the signature.

## Use cases

- **Marketing** - PMP captures the user's preference and feeds it as `id.usage`; the 51DiD is consumed by Prebid / RTB enrichment. See @ref Identifiers_PMP and @ref DeviceDetection_OtherIntegrations_Prebid.
- **Non-marketing** - the integrator sets `id.usage=non-marketing` server-side for fraud, bot or suspicious-activity detection (for example, the suspicious-activity module in the 51Degrees WordPress plugin). The identifier never leaves the customer environment.

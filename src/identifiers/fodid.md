@page Identifiers_51Did 51Did (51Degrees Identifier)

A signed envelope, encoded as an <a href="https://github.com/SWAN-community/owid/blob/main/explainer.md">OWID - Open Web ID</a> (the SWAN community schema that defines the binary layout, signature, and verification rules), wrapping a **probabilistic value** that two recipients can compare to decide whether they have observed the same browser instance under the same usage purpose.

## Terminology

The two layers are distinct and the documentation below uses the words deliberately.

- The **51Did** is the **identifier**, the whole base64 OWID envelope (version, domain, date, payload, signature). It changes byte-for-byte every time the cloud issues one, even for the same inputs, because the date and signature change with each call.
- The **probabilistic value** is one of the fields *inside* the payload (a 32-byte hash). It is stable across reissues for the same device + IP + usage: if two 51Dids were issued for the same inputs, their probabilistic values are equal even though the wrapping identifiers differ.

Comparing two browsers means comparing the probabilistic values carried inside their identifiers, never the identifiers themselves. Calling either layer "the identifier" without qualification leads to incorrect comparisons; calling the inner field "the probabilistic identifier" is the same confusion in a different costume.

Derived from three inputs:

- The **Device ID** - a `Hardware-Platform-Browser-IsCrawler` tuple where each component is the profile ID assigned by Device Detection. See the [property dictionary](https://51degrees.com/developers/property-dictionary?item=Metrics%7CAll) for the `DeviceId` property and @ref DeviceDetection_Overview for how it is produced.
- The **client IP** of the request.
- The **usage purpose** declared per request (see *Usage flags* below).

51Dids are produced only by the cloud JSON endpoint when the Resource Key includes the relevant properties. **The 51Did is not available in the on-premise pipeline:** every identifier is signed with a private ECDSA P-256 key held only by 51Degrees' cloud service, so that recipients can verify authenticity without trusting the caller. An on-premise pipeline never holds the signing key and so cannot create a valid 51Did.

## Usage flags

The 51Did payload starts with a one-byte **flags** field that records which usage purposes the cloud was allowed to derive the identifier for. Three flags are currently defined:

| Flag             | Purpose                                                          |
|------------------|------------------------------------------------------------------|
| `non-marketing`  | Analytics, fraud prevention and security only.                   |
| `standard`       | Standard advertising and audience measurement.                   |
| `personalized`   | Personalised advertising and targeted content.                   |

The flags are hierarchical -- `personalized` implies `standard`, and `standard` implies `non-marketing` mirroring the kind of consent tier a user dialog typically offers (a single tier per visitor that covers every use below it).

**Only `non-marketing` global 51Dids are available in the free tier.** Issuing a 51Did for `standard` or `personalized` purposes requires a **Special license key** to be added to the Resource Key -- see *Usage policies and licensing* below.

## Properties

Each property returns a full 51Did identifier (the OWID envelope, signed). The probabilistic value inside has the scope described in the table.

| Property             | Scope of the probabilistic value inside        |
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

`standard` and `personalized` 51Dids are issued under contractual Model Terms that govern how the data can be used once it leaves the cloud service, and are gated by Know Your Customer (KYC) checks before the Special license key is granted. Contact 51Degrees to apply.

`non-marketing` 51Dids are provided under legitimate interest and must not leave the customer environment.

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

Open the example value in the [51Did inspector](https://51degrees.com/developers/51did-inspector?51did=AzUxZC5lcwBzGTMAJQAAAAHWTQAAr193zLwxDrchR2XHYmoTzJML7fAB60rimQeTd2WuHMPoQ4Bz56QhxhXoAynWyaAE8kWo8DO92y9LPLdatHSVaCdSioL7JaMg8S2DV36ehXIZc0HhdqteyARmOnRS7o8j) to unpack the OWID envelope, see the parsed flags, licenseId and 32-byte hash, and verify the ECDSA P-256 signature against the issuer's published public key.

## 51Did readers

A 51Did is a binary OWID envelope wrapping a 51Degrees payload (see *Terminology* above for the wrapper-vs-value distinction). Unpacking the payload, comparing two 51Dids, or verifying the signature in your own code needs a reader that understands both layers. 51Degrees publishes a reader per platform; pick whichever matches your stack.

| Platform | Package          | Distribution                                           |
|----------|------------------|--------------------------------------------------------|
| .NET     | `FiftyOne.Did`   | <https://www.nuget.org/packages/FiftyOne.Did>          |

Readers for other platforms are on the roadmap and will be added to this table as they are released.

## Comparing two 51Dids

Two 51Dids issued for the same device + IP + usage will differ at the byte level because the envelope embeds a fresh timestamp and signature on each call. The byte-level difference is in the **identifier** (the wrapper); the **probabilistic value** carried inside is stable across reissues. To decide whether the two refer to the same browser instance, compare the probabilistic values, never the full base64 identifiers.

The probabilistic value is one of the fields the reader exposes after parsing the payload (per platform, named `Hash` in .NET to reflect that it is a 32-byte SHA-256). Treat it as the cache / dedup key.

Two responses to the same device + IP + `id.usage=non-marketing`, returned a few seconds apart:

```
51Did A (base64) : AzUxZC5lcwBzGTMAJQAAAAHWTQAAr193zLwxDrchR2XHYmoTzJML7fAB60rimQeTd2WuHMPoQ4...
51Did B (base64) : AzUxZC5lcwCxHzMAJQAAAAHWTQAAr193zLwxDrchR2XHYmoTzJML7fAB60rimQeTd2WuHMPoQ4...
                              ^^^^^^                                                ^^^^^^^^
                              date differs                              signature differs further down
```

Unpacked with the [.NET reader](https://www.nuget.org/packages/FiftyOne.Did):

```csharp
var a = new FodId(idprobglobalA);
var b = new FodId(idprobglobalB);

// Wrapper bytes (Domain, Date, Signature) ARE different; the
// identifier itself is not stable across reissues:
Console.WriteLine(a.Date == b.Date);          // false
Console.WriteLine(a.Signature.SequenceEqual(b.Signature)); // false

// The probabilistic value inside the payload IS stable; this is
// what you actually compare:
Console.WriteLine(a.Hash.SequenceEqual(b.Hash));           // true
```

Use `FodId.Hash` (32 bytes, SHA-256, the probabilistic value) as the cache / dedup key. The same value means the same browser instance under the same usage policy on the same License Key (for `idproblic`) or across all callers (for `idprobglobal`).

## Validation

A 51Did recipient can optionally verify the signature before trusting the identifier. Two options:

1. **Cloud endpoint.** Send the base64 value to the verification endpoint on the V4 cloud and get back a parsed payload only if the signature checks out. Simple, no key handling, but every call is metered against the Resource Key.
2. **Local verification using the published public key.** Fetch 51Degrees' public ECDSA P-256 key once, cache it, and verify in-process for every received identifier. No metering. Each platform reader (see *51Did readers* above) exposes an in-process verify method that takes the public key PEM and returns a boolean. The .NET reader's method is the inherited `Owid.VerifyAsync`.

In both cases, validation only confirms the identifier was created by 51Degrees and has not been tampered with. It does not certify that the device + IP + usage inputs were truthful: that trust lives in the operational contract with the issuing 51Degrees cloud, not in the signature.

## Use cases

- **Marketing** - PMP captures the user's preference and feeds it as `id.usage`; the 51Did is consumed by Prebid / RTB enrichment. See @ref Identifiers_PMP and @ref DeviceDetection_OtherIntegrations_Prebid.
- **Non-marketing** - the integrator sets `id.usage=non-marketing` server-side for fraud, bot or suspicious-activity detection (for example, the suspicious-activity module in the 51Degrees WordPress plugin). The identifier never leaves the customer environment.

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

## Identifier types

The value inside the envelope comes in three types. Bits 6-7 of the payload flags byte (see *Payload layout* below) record which one a given 51Did carries.

- **Probabilistic** - a 32-byte SHA-256 derived from the Device ID and the client IP. The same device on the same network produces the same value for every caller, with no inputs beyond the usual Device Detection evidence and `id.usage`. This is the value the rest of this page uses in its examples.
- **Random** - a fresh, server-generated 16-byte GUID rather than a derived hash. The cloud neither stores nor echoes it, so it is not stable across calls. No inputs beyond `id.usage` are needed.
- **Hashed Email** - a 32-byte SHA-256 of a caller-supplied email and a SWAN salt, `SHA-256(lowercase(trim(email)) || saltBytes)`. The same email and salt always produce the same value for every caller, which makes it interoperable with the SWAN SID concept. Requires the `id.email` and `id.salt` inputs described under *Request inputs*.

Each type is offered in two scopes: **global** (one value across all callers) and **lic** (scoped to your License Key), see *Properties*.

## Usage flags

The 51Did payload starts with a one-byte **flags** field that records which usage purposes the cloud was allowed to derive the identifier for. Three flags are currently defined:

| Flag             | Purpose                                                          |
|------------------|------------------------------------------------------------------|
| `non-marketing`  | Analytics, fraud prevention and security only.                   |
| `standard`       | Standard advertising and audience measurement.                   |
| `personalized`   | Personalised advertising and targeted content.                   |

The flags are hierarchical, `personalized` implies `standard`, and `standard` implies `non-marketing` mirroring the kind of consent tier a user dialog typically offers (a single tier per visitor that covers every use below it).

**Only `non-marketing` global 51Dids are available in the free tier.** Issuing a 51Did for `standard` or `personalized` purposes requires a **Special license key** to be added to the Resource Key, see *Usage policies and licensing* below.

## Properties

Each property returns a full 51Did identifier (the OWID envelope, signed). The value inside (its type and scope) is described in the table.

| Property             | Type          | Scope                                          |
|----------------------|---------------|------------------------------------------------|
| `fodid.idprobglobal` | Probabilistic | Unique across all callers from device+network. |
| `fodid.idproblic`    | Probabilistic | Unique only across the caller's License Key.   |
| `fodid.idrandglobal` | Random        | Unique across all callers.                     |
| `fodid.idrandlic`    | Random        | Unique only across the caller's License Key.   |
| `fodid.idhemglobal`  | Hashed Email  | Unique across all callers.                     |
| `fodid.idhemlic`     | Hashed Email  | Unique only across the caller's License Key.   |

## Request inputs

- **Evidence** - Device Detection evidence (User-Agent / UA-CH) AND client IP (`client-ip` query parameter, `client-ip` HTTP header, or the server-supplied client IP).
- **Usage policy** - the request's `id.usage` value. Supplied either directly or derived by the cloud from a consent string; see *Setting the usage policy* below.
- **`id.email`** (Hashed Email only) - raw email address. The cloud trims and lowercases it; no other transforms.
- **`id.salt`** (Hashed Email only) - URL-safe base64 of the 2-byte SWAN salt (4 nibbles encoding the 4x4 salt grid selection), e.g. `Npw`.

If a Hashed Email property is requested without `id.email` or `id.salt`, the property is returned with a no-value reason naming the missing input; the supplied values are never echoed back. The raw `id.email` value is used only to compute the hash; it is not logged, not shared in usage statistics, and not retained.

## Setting the usage policy

The cloud accepts two ways to decide a request's `id.usage` value. The *Direct* path can set any of the three values described under *Usage flags*; the *Derived from consent* path only ever produces `standard` or `personalized` (or no value), never `non-marketing`.

### Direct - your integration owns the mapping

Your integration decides the value and tells the cloud what to do by passing an explicit `id.usage` (`non-marketing`, `standard` or `personalized`) as a query parameter or HTTP request header. You own the mapping from whatever preference or consent surface you use to one of these three values, and the cloud just acts on what you supply. This is the path @ref Identifiers_PMP takes: the widget captures the user's choice and fires the request with `id.usage` already set.

### Derived from consent - the cloud maps a TCF or GPP string for you

Instead of deciding the value yourself, pass the raw IAB consent string and let the cloud derive `id.usage` from the consented purposes. Two evidence parameters are accepted:

- `tcstring` - an IAB TCF v2 TCString, from the PMP widget or any TCF-aware CMP.
- `gpp` - an IAB GPP string. When a GPP string carries a decodable EU TCF v2 section it takes precedence over `tcstring`; a GPP string with no TCF section (for example a US-only string) is ignored and the cloud falls back to `tcstring`.

The cloud parses the string and checks the consented [IAB TCF v2 purposes](https://iabeurope.eu/iab-europe-transparency-consent-framework-policies/) against the definitions below, adding the matching `id.usage`:

| `id.usage`     | Required IAB TCF v2 purposes              |
|----------------|-------------------------------------------|
| `personalized` | 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12     |
| `standard`     | 1, 7, 8, 9, 10                            |

`personalized` is tried first, then `standard`. If neither set is fully satisfied the cloud adds no `id.usage`, the `fodid.*` properties return a no-value reason, and no identifier is issued for advertising use the consent does not permit. Purposes 2, 7, 8, 9, 10 and 11 may be satisfied by a legitimate-interest bit as well as a consent bit; the remaining purposes (1, 3, 4, 5, 6, 12) require an explicit consent bit, because IAB Policy forbids claiming them under legitimate interest.

**Direct intent always wins.** If `id.usage` is present on the request (query or header) the cloud uses it and ignores any `tcstring` or `gpp`; derivation runs only when no explicit value was supplied. Malformed consent strings are ignored rather than rejected.

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

The resource key can also be sent as a header instead of in the URL:

```
GET /api/v4/json?user-agent=iPhone&client-ip=203.0.113.42&id.usage=standard
X-51D-Resource-Key: <RESOURCE_KEY>
```

License-key-only callers (no resource key) must list the 51Did properties they want via `values`, e.g. `values=fodid.idprobglobal` (or `fodid.idproblic`), since they have no Resource Key with a baked-in property list (see @ref Services_Cloud_ResourceKeys).

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

## Payload layout

The payload header is shared by every identifier type; bits 6-7 of the flags byte select the type and the length of the value that follows.

| Offset | Length | Field                                                          |
|--------|--------|----------------------------------------------------------------|
| 0      | 1      | Flags: bits 0-2 usage tier, bits 6-7 identifier type           |
| 1      | 4      | LicenseId (uint32, little-endian)                              |
| 5      | 16/32  | Value: GUID (Random) or SHA-256 (Probabilistic, Hashed Email)  |

| Bits 6-7 | Type          | Payload length |
|----------|---------------|----------------|
| `00`     | Probabilistic | 37             |
| `01`     | Random        | 21             |
| `10`     | Hashed Email  | 37             |
| `11`     | Reserved      | n/a            |

Identifiers issued before the type tag existed have bits 6-7 zeroed and decode as Probabilistic.

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

### Verifying the creator context

Signature verification (above) confirms an identifier is an authentic 51Degrees 51Did. A separate check, **creator context** verification (context for short), confirms the 51Did is being presented from the browser and connection it was created on. The creator context is what the 51Degrees cloud, as the creator of the identifier, recorded about the creating request when it issued the identifier. It is checked only within the 51Degrees service, which alone holds the key the context is made under, and every check is metered against the Resource Key. Identifiers issued by the 51Degrees cloud carry a creator context from the release that introduces it, and an identifier created before that reports `nocontext`.

The check is made in two steps, so that the answer never exists in the browser in a form the browser can read, alter or forge.

![Two-step creator context verification](images/51did-two-step-verification.svg)

- **Step one.** The page calls `verify-context` (or `verify-full`) from the visitor's browser with the 51Did and the page's [Resource Key](https://51degrees.com/documentation/4.4/_info__resource_keys.html), and receives `{ "result": "..." }`, an opaque sealed value. The call must come from the browser presenting the identifier, because the service compares the identifier against the connection making the call. It reads the JSON response cross-origin, so use a `fetch` rather than a script tag or a pixel.
- The page passes the 51Did and the sealed result to your server as part of its normal request, for example with the form post or the purchase the identifier is being trusted for.
- **Step two.** Your server calls `redeem` with the 51Did it holds, the sealed result, and a licence key of the account whose Resource Key made the verification (required wherever the account holds licence keys, and never placed in a page), and receives the verdict. Where the context is a `mismatch` it also receives a `factors` object naming which factor differed.

Each verification produces a fresh sealed result that can be redeemed once, within ten seconds of the verification. A later attempt answers `expired`, a second attempt answers `replayed`, and a result presented with the wrong 51Did, licence key or challenge, or altered in any way, answers `unreadable` without saying which was wrong. Two fields describe the redemption itself, being `verifiedAt`, when the verification happened, and `secondsSinceVerified`, how long ago that was in whole seconds by the service's clock. A `challenge` value given at step one, for example your own transaction identifier, must be given again at step two, which ties the result to one transaction.

The endpoints on the V4 cloud, all of which take the identifier as the `51did` parameter on the query string, in a form, or as the route `51did/<value>`:

- `GET`/`POST` `/api/v4/id/verify` returns `{ "valid": <bool> }`, the signature result only (unchanged).
- `GET`/`POST` `/api/v4/id/verify-context` returns `{ "result": "..." }`, a sealed context result.
- `GET`/`POST` `/api/v4/id/verify-full` returns `{ "result": "..." }`, a sealed result that carries the signature result as well as the context result, so one call and one redemption give both.
- `GET`/`POST` `/api/v4/id/redeem` takes `51did`, `result`, `license` and optionally `challenge`, and returns `{ "signature": "verified" | "invalid", "context": "...", "factors": { ... }, "verifiedAt": "...", "secondsSinceVerified": <int> }`.

All four require a Resource Key and are metered against it. A call with no Resource Key, or whose Resource Key lacks the entitlement, returns `401`. A `license` parameter may add entitlement but is not an alternative to the Resource Key.

The `context` result values:

| Value | Meaning |
|-------|---------|
| `verified` | The 51Did is being presented from the browser and connection it was created on. |
| `mismatch` | At least one factor of the presenting browser or connection differs from the one recorded at creation. `factors` says which. |
| `nocontext` | The 51Did carries no creator context to check, for example one created before the capability was released, or by a deployment that has it switched off. |
| `notcheckable` | The 51Did carries a creator context that this service cannot check, for example one made under a key this service does not hold, or in a newer format than this service understands. |

`nocontext` and `notcheckable` are normal outcomes rather than errors. A self-hosted deployment that has the creator context switched off reports `nocontext` for every identifier it creates, and a service that predates the creator context does not offer `verify-context`, `verify-full` or `redeem` at all and answers `404` to them, which means the host does not support the creator context. An integration should treat both as "no context available" and fall back to the signature check.

A `mismatch` is accompanied by a `factors` object, a breakdown across six independent factors named `transport`, `device`, `browser`, `browserip`, `connectionip` and `asn`, each `verified` or `mismatch`. It is there to help you locate an integration problem (for example a call made from a server rather than the presenting browser shows the transport, device and connection factors as `mismatch`, the server having its own connection and device); treat the top-level `context` value as the result. Nothing about what a factor is made of is exposed, only whether it matched.

Read together with the signature, the states that matter are:

| `signature` | `context` | Meaning |
|-------------|-----------|---------|
| `verified` | `verified` | Authentic identifier presented from its creation context. |
| `verified` | `mismatch` | Authentic identifier presented from a different context. A replay indicator, and also what a legitimate backend caller verifying out of context sees, and that caller knows which situation it is in. |
| `verified` | `nocontext` or `notcheckable` | Authentic identifier with no context this service can check. Rely on the signature alone. |
| `invalid` | any | The envelope has been altered or corrupted. A creator context cannot be forged, because it is made under a key only 51Degrees holds, so a `verified` context on an `invalid` signature means the context data is intact and something else in the envelope is not. |

Local public-key verification (option 2 above) covers the signature only. The creator context check exists nowhere but the 51Degrees service, and is available self-hosted through the bespoke Docker solution for identifiers that deployment creates.

A long-lived identifier that still verifies from its creation context is the strongest signal of a stable, real user, and age cannot be manufactured. This makes context verification well suited to a render-time check: place the 51Did from a bid request into the creative, verify it from the rendering browser, send the 51Did and the sealed result to your own endpoint, and redeem them there. A `context` of `mismatch` means the paid impression rendered somewhere other than the browser the bid described.

### Fetching the public key for local verification

Local verification (option 2 above) fetches the key from the OWID creator endpoint, `GET /owid/api/v3/creator`. The response carries the current signing key in `publicKeySPKI` (PEM).

Signing keys belong to periods of a schedule, and a 51Did is signed with the key of the period its creation falls in, so a 51Did issued in an earlier period was signed with an earlier key. To fetch the key that was in force when a 51Did was created, pass its date: `GET /owid/api/v3/creator?date=<minutes>`. The `date` is the same value the OWID envelope carries in its Date field, minutes since `2020-01-01T00:00:00Z` (see the [OWID explainer](https://github.com/SWAN-community/owid/blob/main/explainer.md), "Data Structure" section). The endpoint returns the signing key whose period was in force at `date`; if `date` predates every known key it returns `404`, and a `date` that is not an unsigned 32-bit integer returns `400`.

### Fetching every public key at once

The `/creator` endpoint above returns one key per request. A verifier that wants the whole set of signing keys can pull them from the 51Did key endpoint:

```
GET https://cloud.51degrees.com/api/v4/id/key?resource=<RESOURCE_KEY>
```

The response is a JSON array, one entry per signing key, where `startsAt` is the start of the period the key signs for (it is in force from then until the next key's `startsAt`) and `created` is when the key was generated, which is always earlier because the schedule is generated ahead of time:

```json
[
  { "startsAt": "2026-03-09T00:00:00.0000000Z", "created": "2026-03-08T04:00:00.0000000Z", "publicKey": "-----BEGIN PUBLIC KEY-----\n...\n-----END PUBLIC KEY-----" }
]
```

To fetch only the keys whose period starts on or after a moment, add an ISO 8601 UTC timestamp: `GET .../api/v4/id/key/datetime/2026-03-09T00:00:00Z?resource=<RESOURCE_KEY>`. The response then holds only keys whose `startsAt` is on or after that timestamp, which includes the keys scheduled for the coming weeks. This endpoint takes an ISO 8601 timestamp, not the minutes-since-2020 value that `/creator?date=` uses. Unlike `/creator`, it needs a Resource Key and is metered.

## Use cases

- **Marketing** - PMP captures the user's preference and feeds it as `id.usage`; the 51Did is consumed by Prebid / RTB enrichment. See @ref Identifiers_PMP and @ref Integrations_Prebid.
- **Non-marketing** - the integrator sets `id.usage=non-marketing` server-side for fraud, bot or suspicious-activity detection (for example, the suspicious-activity module in the 51Degrees WordPress plugin). The identifier never leaves the customer environment.

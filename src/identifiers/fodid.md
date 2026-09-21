@page Identifiers_51Did 51Did (51Degrees Identifier)

A signed envelope, encoded as an <a href="https://github.com/SWAN-community/owid/blob/main/explainer.md">OWID - Open Web ID</a> (the SWAN community schema that defines the binary layout, signature, and verification rules), wrapping a **probabilistic value** that two recipients can compare to decide whether they have observed the same browser instance under the same usage purpose.

## Terminology

The two layers are distinct and the documentation below uses the words deliberately.

- The **51Did** is the **identifier**, the whole base64 OWID envelope (version, domain, date, payload, signature). It changes byte-for-byte every time the cloud issues one, even for the same inputs, because the date and signature change with each call.
- The **match key** is the part of the payload that is stable and comparable, being the bytes after the flags byte and the License Id, which for the probabilistic type is a 32-byte hash. It is the same across reissues for the same device + IP + usage, meaning that if two 51Dids were issued for the same inputs, their match keys are equal even though the wrapping identifiers differ. Every reader exposes it under that name, `MatchKey` in .NET. Earlier text and an older .NET property called it the probabilistic value, or `Hash`, and those mean the same bytes.

Comparing two browsers means comparing the match keys carried inside their identifiers, never the identifiers themselves. The envelope also carries the identifier's creation time, to the minute in UTC, so how old a 51Did is can be read from the identifier with no other call. Calling either layer "the identifier" without qualification leads to incorrect comparisons, and calling the inner field "the probabilistic identifier" is the same confusion under another name. The three levels, the byte layout and what every reader must and must not expose are set out in the [51Did specification](https://github.com/51Degrees/specifications/tree/main/did-specification), which this page summarises.

Derived from three inputs:

- The **Device ID** - a `Hardware-Platform-Browser-IsCrawler` tuple where each component is the profile ID assigned by Device Detection. See the [property dictionary](https://51degrees.com/developers/property-dictionary?item=Metrics%7CAll) for the `DeviceId` property and @ref DeviceDetection_Overview for how it is produced.
- The **client IP** of the request.
- The **usage purpose** declared per request (see *Usage flags* below).

51Dids are produced only by the cloud JSON endpoint when the Resource Key includes the relevant properties. **The 51Did is not available in the on-premise pipeline:** every identifier is signed with a private ECDSA P-256 key held only by 51Degrees' cloud service, so that recipients can verify authenticity without trusting the caller. An on-premise pipeline never holds the signing key and so cannot create a valid 51Did.

## Identifier types

The value inside the envelope comes in three types. Bits 6-7 of the payload flags byte (see *Payload layout* below) record which one a given 51Did carries.

- **Probabilistic** - a 32-byte SHA-256 derived from the Device ID and the client IP. The same device on the same network produces the same value for every caller, with no inputs beyond the usual Device Detection evidence and `id.usage`. This is the value the rest of this page uses in its examples.
- **Random** - a fresh, server-generated 16-byte GUID rather than a derived hash. The cloud neither stores nor echoes it, so it is not stable across calls. No inputs beyond `id.usage` are needed.
- **Hashed Email** - a 32-byte SHA-256 of a caller-supplied email and a 2-byte salt, `SHA-256(lowercase(trim(email)) || saltBytes)`. The same email and salt always produce the same value for every caller. Requires the `id.email` input described under *Request inputs*, with the salt taken from `id.salt` or falling back to a salt configured by 51Degrees.

Each type is offered in two scopes: **global** (one value across all callers) and **lic** (scoped to your License Key), see *Properties*.

## Usage flags

The 51Did payload starts with a one-byte **flags** field that records which usage purposes the cloud was allowed to derive the identifier for. Three flags are currently defined:

| Flag             | Purpose                                                          |
|------------------|------------------------------------------------------------------|
| `non-marketing`  | Analytics, fraud prevention and security only.                   |
| `standard`       | Marketing and other content unrelated to your browsing history or interactions, such as content chosen by time, region and the page in view. |
| `personalized`   | Marketing and other content related to your browsing history or interactions. |

The flags are hierarchical, in that `personalized` implies `standard` and `standard` implies `non-marketing`, mirroring the kind of consent tier a user dialog typically offers (a single tier per visitor that covers every use below it).

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
- **Usage policy** - the request's `id.usage` value. Supplied either directly or derived by the cloud from a consent string, as described under *Setting the usage policy* below.
- **`id.email`** (Hashed Email only) - raw email address. The cloud trims and lowercases it and applies no other transform.
- **`id.salt`** (Hashed Email only) - URL-safe base64 of a 2-byte salt chosen by the caller, e.g. `Npw`. When the request does not supply one, a salt configured by 51Degrees is used instead.

If a Hashed Email property is requested without `id.email`, or with an `id.salt` value that is not valid URL-safe base64 of 2 bytes, the property is returned with a no-value reason naming the problem. An invalid salt is never silently replaced, as re-salting would hand the caller a different identifier with nothing to say why. The supplied values are never echoed back. The raw `id.email` value is used only to compute the hash, and it is not logged, not shared in usage statistics, and not retained.

## When the identifier is created

A 51Did is created against the device as the cloud has fully resolved it, and on a web page part of that resolution comes from scripts the page runs. An iPhone's request headers name only the generic model and a script names the exact one, and a Chromium browser keeps details out of its headers that a script can read. The 51Degrees client script runs those scripts and sends what they collected with its next request.

So a request from a browser page that still owes any of those results creates nothing. The identifier properties come back with no value, and `fodid.idprobglobalnullreason`, or the reason property beside whichever identifier was asked for, says the page has not finished running its snippets, naming what is still to run and what to send. The client script's next request, carrying the results, is the one that creates the identifier, and the client script reports complete only after that. Two consequences follow.

- Wait for the client script's completion signal before reading the identifier or placing it anywhere. A header wrapper or auction library running on a fixed timer must give that signal enough time to arrive on a slow connection, or the first auction leaves without an identifier.
- A server calling the JSON endpoint on a visitor's behalf is not a browser page and is not held to this, as long as it names its own software in its `User-Agent` and passes the visitor's `User-Agent` as the `user-agent` parameter. A server that sends the visitor's `User-Agent` as its own request header is judged to be a browser page and is asked for snippet results it can never send.

The same rule applies to verifying the creator context, described under *Validation*, where a verification that carries none of what the page collected is answered with an error naming the values to send rather than a verdict.

## Setting the usage policy

The cloud accepts two ways to decide a request's `id.usage` value. The *Direct* path can set any of the three values described under *Usage flags*, whereas the *Derived from consent* path only ever produces `standard` or `personalized` (or no value), never `non-marketing`.

### Direct - your integration owns the mapping

Your integration decides the value and tells the cloud what to do by passing an explicit `id.usage` (`non-marketing`, `standard` or `personalized`) as a query parameter or HTTP request header. You own the mapping from whatever preference or consent surface you use to one of these three values, and the cloud acts on what you supply. This is the path @ref Identifiers_PMP takes. PMP captures the user's choice and announces it on the page, and the 51Degrees client script hears it and sends it as `id.usage` on its next request.

### Derived from consent - the cloud maps a TCF or GPP string for you

Instead of deciding the value yourself, pass the raw IAB consent string and let the cloud derive `id.usage` from the consented purposes. Two evidence parameters are accepted:

- `tcstring` - an IAB TCF v2 TCString, from the PMP widget or any TCF-aware CMP.
- `gpp` - an IAB GPP string. When a GPP string carries a decodable EU TCF v2 section it takes precedence over `tcstring`, and a GPP string with no TCF section (for example a US-only string) is ignored and the cloud falls back to `tcstring`.

The cloud parses the string and checks the consented [IAB TCF v2 purposes](https://iabeurope.eu/iab-europe-transparency-consent-framework-policies/) against the sets below, which are Appendix 1 of the [Model Terms for Marketing](https://m4ow.uk/mtm/2.txt), adding the matching `id.usage`:

| `id.usage`     | Required IAB TCF v2 purposes              |
|----------------|-------------------------------------------|
| `personalized` | 1, 2, 3, 4, 5, 6, 7, 8, 11                |
| `standard`     | 1, 2, 7, 8, 11                            |

`personalized` is tried first, then `standard`. If neither set is fully satisfied the cloud adds no `id.usage`, the `fodid.*` properties return a no-value reason, and no identifier is issued for advertising use the consent does not permit. Purposes 2, 7, 8 and 11 may be satisfied by a legitimate-interest bit as well as a consent bit, whereas purposes 1, 3, 4, 5 and 6 require an explicit consent bit, because IAB Policy forbids claiming them under legitimate interest.

**Direct intent always wins.** If `id.usage` is present on the request (query or header) the cloud uses it and ignores any `tcstring` or `gpp`, and derivation runs only when no explicit value was supplied. Malformed consent strings are ignored rather than rejected.

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

The payload header is shared by every identifier type, and bits 6-7 of the flags byte select the type and the length of the value that follows.

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

A 51Did is a binary OWID envelope wrapping a 51Degrees payload (see *Terminology* above for the wrapper-vs-value distinction). Unpacking the payload, comparing two 51Dids, or verifying the signature in your own code needs a reader that understands both layers. 51Degrees publishes a reader per platform, so pick whichever matches your stack.

| Platform | Package                           | Distribution                                                       |
|----------|-----------------------------------|--------------------------------------------------------------------|
| .NET     | `FiftyOne.Did`                    | <https://www.nuget.org/packages/FiftyOne.Did>                      |
| Java     | `com.51degrees:pipeline.did`      | <https://central.sonatype.com/artifact/com.51degrees/pipeline.did> |
| Node.js  | `fiftyone.pipeline.did`           | <https://www.npmjs.com/package/fiftyone.pipeline.did>              |
| Python   | `fiftyone-pipeline-did`           | <https://pypi.org/project/fiftyone-pipeline-did/>                  |
| PHP      | `51degrees/fiftyone.pipeline.did` | <https://packagist.org/packages/51degrees/fiftyone.pipeline.did>   |

Every reader exposes the same surface, set out in the [package surface](https://github.com/51Degrees/specifications/blob/main/did-specification/package-surface.md) part of the specification. It parses the envelope, exposes the match key, the usage, the creation time and the signature, verifies the signature against a public key, and keeps the byte offsets out of its public surface so that application code never reads the layout by hand. The .NET package is the reference implementation.

## Comparing two 51Dids

Two 51Dids issued for the same device + IP + usage will differ at the byte level because the envelope embeds a fresh timestamp and signature on each call. The byte-level difference is in the **identifier** (the wrapper), whereas the **match key** carried inside is stable across reissues. To decide whether the two refer to the same browser instance, compare the match keys, never the full base64 identifiers.

The match key is one of the fields the reader exposes after parsing the payload, as `MatchKey` in every language. Treat it as the key for caching and for spotting duplicates.

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

// The match key inside the payload IS stable; this is what you
// actually compare:
Console.WriteLine(a.MatchKey.SequenceEqual(b.MatchKey));   // true
```

Use `FodId.MatchKey` (32 bytes for the probabilistic and hashed email types) as the key for caching and for spotting duplicates. The same value means the same browser instance under the same usage policy on the same License Key (for `idproblic`) or across all callers (for `idprobglobal`).

## Validation

Two things about a 51Did can be checked. The signature says whether the identifier is an authentic 51Degrees 51Did that has not been altered, and the creator context says whether it is being presented from the browser and connection it was created on. They are independent, and the second is described after the first.

A 51Did recipient can verify the signature before trusting the identifier. Two options:

1. **Cloud endpoint.** Send the base64 value to the verification endpoint on the V4 cloud and get back a parsed payload only if the signature checks out. Simple, no key handling, but every call is metered against the Resource Key.
2. **Local verification using the published public key.** Fetch 51Degrees' public ECDSA P-256 key once, cache it, and verify in-process for every received identifier. No metering. Each platform reader (see *51Did readers* above) exposes an in-process verify method that takes the public key PEM and returns a boolean. The .NET reader's method is the inherited `Owid.VerifyAsync`.

In both cases, signature validation only confirms the identifier was created by 51Degrees and has not been tampered with. It does not certify that the device + IP + usage inputs were truthful, because that trust lives in the operational contract with the issuing 51Degrees cloud, not in the signature.

### Verifying the creator context

The creator context is what the 51Degrees cloud, as the creator of the identifier, recorded about the creating request when it issued the identifier. Verifying it confirms the 51Did is being presented from the browser and connection it was created on. It is checked only within the 51Degrees service, which alone holds the key the context is made under, and every check is metered against the Resource Key. Identifiers issued by the 51Degrees cloud have carried a creator context since release 4.4.37, and one created before that, or by a self-hosted deployment with the creator context switched off, reports `nocontext`.

The check is made in two steps, so that the verdict never exists in the browser in a form the browser can read, alter or forge.

![Two-step creator context verification](images/51did-two-step-verification.svg)

- **Step one.** The page calls `verify-context` (or `verify-full`) from the visitor's browser with the 51Did and the page's [Resource Key](https://51degrees.com/documentation/4.4/_info__resource_keys.html), and receives `{ "result": "..." }`, an opaque sealed value and nothing else. The call must come from the browser presenting the identifier, because the service compares the identifier against the connection making the call, so use a `fetch` that reads the JSON response rather than a script tag or a pixel. The page may also pass a `challenge`, a single-use value your server issued for this transaction, which is folded into the result.
- The page passes the 51Did and the sealed result to your server as part of its normal request, for example with the form post or the purchase the identifier is being trusted for.
- **Step two.** Your server calls `redeem` with the 51Did it holds, the sealed result, a licence key of the account whose Resource Key made the verification (required wherever the account holds licence keys, and never placed in a page) and, where a `challenge` was given at step one, the same value again, and receives the verdict.

The endpoints on the V4 cloud, all of which take the identifier as the `51did` parameter on the query string, in a form, or as the route `51did/<value>`:

- `GET`/`POST` `/api/v4/id/verify` returns `{ "valid": <bool> }`, the signature result only, readable at once.
- `GET`/`POST` `/api/v4/id/verify-context` returns `{ "result": "..." }`, a sealed context result.
- `GET`/`POST` `/api/v4/id/verify-full` returns `{ "result": "..." }`, a sealed result carrying the signature result as well as the context result, so one call and one redemption give both.
- `GET`/`POST` `/api/v4/id/redeem` takes `51did`, `result`, `license` and optionally `challenge`, and returns `{ "signature": "verified" | "invalid", "context": "...", "factors": { ... }, "verifiedAt": "...", "secondsSinceVerified": <int> }`.

All four require a Resource Key and are metered against it. A call with no Resource Key, or whose Resource Key lacks the entitlement, returns `401`. A `license` parameter may add entitlement but is not an alternative to the Resource Key. Every call is one use, so checking the creator context from a browser costs two uses, one for the verification and one for the redemption, whereas checking the signature alone with `verify` costs one. The self-hosted container does not count uses per call.

**Send what the page collected.** The context is compared against the device as the cloud has fully resolved it, exactly as the identifier was created against it (see *When the identifier is created*). After the client script reports complete, include every value it stored, such as `51D_ProfileIds`, `51D_ScreenPixelsWidth` and, on a Chromium browser, `51D_GetHighEntropyValues`, as parameters on the verification request. A page's verification that carries none of them, where the device then differs and the same browser made the request, is answered with a `400` naming the values to send rather than a verdict. If collection cannot complete, for example because the client script failed to load, do not verify and do not report a mismatch. Report that the check did not complete, which is not evidence either way.

The `context` values:

| Value | Meaning |
|-------|---------|
| `verified` | The 51Did is being presented from the browser and connection it was created on. |
| `mismatch` | At least one factor of the presenting browser or connection differs from the one recorded at creation. `factors` says which. |
| `misconfigured` | The service that checked the identifier could not complete the check, and the reason is that service rather than the identifier. Nothing a caller sends can produce it. Where some factors were compared, `factors` marks the rest `misconfigured` and shows the outcome of the ones it could check. Not a mismatch, and not to be treated as one. Against your own hosted service, its start-up log names the setting to change. |
| `invaliddate` | The identifier claims a creation date the scheme could not have produced, being in the future or before the creator context existed, so the identifier is fabricated and nothing is wrong with the service. |
| `nocontext` | The 51Did carries no creator context to check, being one created before release 4.4.37 or by a deployment with the creator context switched off. Normal rather than an error, and it says nothing about whether the identifier is genuine, which the signature answers on its own. |

Where `context` is `mismatch`, or `misconfigured` with some factors compared, `factors` breaks the comparison down across nine independent factors named `transport`, `device`, `browserip`, `connectionip`, `asn`, `platformname`, `platformversion`, `browsername` and `browserversion`, each `verified`, `mismatch` or `misconfigured`. It is there to help you locate a problem and to weigh a mismatch. A call made from a server rather than the presenting browser, for example, shows the transport, device and connection factors as `mismatch`, the server having its own connection and device. Nothing about what a factor is made of is exposed, only whether it matched. Treat the top-level `context` value as the result.

Read together with the signature:

| `signature` | `context` | Meaning |
|-------------|-----------|---------|
| `verified` | `verified` | Authentic identifier presented from its creation context. |
| `verified` | `mismatch` | Authentic identifier presented from a different context. What a replay looks like, and also what a legitimate server verifying out of context sees, and that server knows which situation it is in. |
| `verified` | `nocontext` or `misconfigured` | Authentic identifier with no context this service could check. Rely on the signature alone. |
| `invalid` | any | The envelope has been altered or corrupted. A creator context cannot be forged, because it is made under a key only 51Degrees holds, so a `verified` context on an `invalid` signature means the context data is intact and something else in the envelope is not. |

**The redemption itself.** A sealed result redeems once, within ten seconds of the verification, and each verification produces a fresh one. The window is the anti-replay window of TLS 1.3, which QUIC mandates ([RFC 8446 section 8.3](https://www.rfc-editor.org/rfc/rfc8446#section-8.3)), so the trade-off between clock error, network variation and replay exposure has already been argued, and it is a constant of the service that cannot be widened by configuration. Every clock involved is a server clock, so the visitor's browser clock plays no part. In the genuine flow the two steps happen moments apart within one page transaction, so the window costs nothing. `verifiedAt` and `secondsSinceVerified` describe the verification you have just made and let your server apply a stricter rule of its own without any clock work. They say nothing about the identifier's age, which comes from the identifier itself.

| Response | Meaning | What to do |
| --- | --- | --- |
| `context` of `expired`, with `verifiedAt` and `secondsSinceVerified` | Genuine but older than ten seconds | Treat as unverified, and if this recurs in a genuine flow redeem sooner after the page verifies |
| `context` of `replayed` | Already redeemed on this service instance | Treat as unverified, because something presented the same result twice |
| `context` of `unreadable` | Not a result sealed for this 51Did, licence key and challenge, or altered | Treat as unverified. The service does not say which was wrong |
| `unconfirmed` (HTTP 503) | The instance could not confirm first use | Retry, as it is neither a replay nor a forgery |
| HTTP 400 naming the values to send, such as `51D_ProfileIds` | A page verified before sending what its scripts collected | Send the values the client script collected and verify again |
| HTTP 400 naming a payload status | The 51Did is not a shape the scheme produces | Treat as unverified, and check what produced the value you sent |

The record of redemptions is held in memory per service instance rather than across regions, as TLS 1.3 notes of its own record in distributed deployments, so two redemptions of one result routed to two instances can both succeed within the window. If your flow must be single use everywhere, route redemptions for one transaction to one place or keep your own short-lived record of results already redeemed.

**Identifiers issued before release 4.4.37.** Treat a 51Did the 51Degrees cloud issued with a creator context before that release as unverified and use a newly created 51Did in its place. Those identifiers no longer verify.

**A mismatch is not always a problem.** The match key is what is stable, and nothing about the creator context changes it. What can change is the connection the visitor arrives on, so a mismatch says the visitor is arriving differently from before, not that the identifier is fake. A privacy relay service changes the address and the operator together. A home or mobile connection changes its address and keeps its operator, so `browserip` and `connectionip` mismatch with `asn` verified. A browser or operating system upgrade changes a version and keeps the name, so `browserversion` or `platformversion` mismatches with `browsername` and `platformname` verified. Read the factors with the identifier's age, which the identifier carries to the minute:

| Age of the 51Did | What a mismatch suggests |
| --- | --- |
| Seconds to minutes | Treat seriously. The visitor has not moved network, no relay has rotated and no browser has updated in that time, so the likeliest explanation is that the identifier is being presented from somewhere other than where it was created. |
| Hours to a day | Worth weight. A relay rotation or a new address is possible, a browser upgrade unlikely. |
| Days to weeks | Weak on its own. Address changes and browser upgrades are both routine over this span. |
| A month or more | Expect mismatches. A verified context after this long is a strong positive, whereas a mismatch is close to uninformative on its own. |

Match your response to what you are about to do rather than to the verdict alone. For frequency capping, measurement and reporting, an address change or an upgrade is no reason to discard the identifier. For personalisation and audience selection, carry on and lower any confidence you keep. For signing in, changing an account or taking payment, ask for a second factor of your own on an address change or an upgrade, and refuse on a changed browser name, platform name or device, or on several unrelated factors at once. An identifier made minutes ago deserves the stricter response, and one made a month ago the more lenient. The service never withholds a verdict because of the identifier's age. It reports what matched and what did not, and the decision is yours.

**What the identifier does not tell you about its creator.** Every 51Did carries a small field 51Degrees uses to know which of its own customers created the identifier, for support and billing. It is encrypted, it changes as 51Degrees rotates the secret behind it, and it also depends on the identifier itself, so two identifiers from the same customer carry different values. A recipient cannot group identifiers by the customer that created them, cannot tell whether two came from the same customer, and cannot work out who any customer is.

Local public-key verification (option 2 above) covers the signature only. The creator context check exists nowhere but the 51Degrees service, and is available self-hosted through the bespoke Docker solution for identifiers that deployment creates. A self-hosted instance running without TLS capture still serves the whole flow for identifiers created and verified on that same instance, which is intended for local testing, and reports through its health check that it is not capturing, so the fault reaches whoever runs the deployment rather than the caller.

A long-lived identifier that still verifies from its creation context is the strongest signal of a stable, real user, and age cannot be manufactured. This makes context verification well suited to a render-time check. Place the 51Did from a bid request into the creative, verify it from the rendering browser, send the 51Did and the sealed result to your own endpoint, and redeem them there. A `context` of `mismatch` on an identifier made minutes earlier means the paid impression rendered somewhere other than the browser the bid described.


### Fetching the public key for local verification

Local verification (option 2 above) fetches the key from the OWID creator endpoint, `GET /owid/api/v3/creator`. The response carries the current signing key in `publicKeySPKI` (PEM).

Signing keys belong to periods of a schedule, and a 51Did is signed with the key of the period its creation falls in, so a 51Did issued in an earlier period was signed with an earlier key. To fetch the key that was in force when a 51Did was created, pass its date on every request, as `GET /owid/api/v3/creator?date=<minutes>`. The `date` is the same value the OWID envelope carries in its Date field, minutes since `2020-01-01T00:00:00Z` (see the [OWID explainer](https://github.com/SWAN-community/owid/blob/main/explainer.md), "Data Structure" section). The endpoint returns the signing key whose period was in force at `date`. If `date` predates every known key it returns `404`, and a `date` that is not an unsigned 32-bit integer returns `400`.

### Fetching every public key at once

The `/creator` endpoint above returns one key per request. A verifier that wants the whole set of signing keys can pull them from the 51Did key endpoint:

```
GET https://cloud.51degrees.com/api/v4/id/key?resource=<RESOURCE_KEY>
```

The response is a JSON array, one entry per signing key:

```json
[
  { "created": "2026-03-08T00:00:00.0000000Z", "publicKey": "-----BEGIN PUBLIC KEY-----\n...\n-----END PUBLIC KEY-----" }
]
```

To fetch only the keys created since you last pulled, add an ISO 8601 UTC timestamp, as `GET .../api/v4/id/key/datetime/2026-03-08T00:00:00Z?resource=<RESOURCE_KEY>`. The response then holds only keys created on or after that timestamp. This endpoint takes an ISO 8601 timestamp, not the minutes-since-2020 value that `/creator?date=` uses. Unlike `/creator`, it needs a Resource Key and is metered.

## Use cases

- **Marketing** - PMP captures the user's preference and feeds it as `id.usage`, and the 51Did is consumed by Prebid / RTB enrichment. See @ref Identifiers_PMP and @ref Integrations_Prebid.
- **Non-marketing** - the integrator sets `id.usage=non-marketing` server-side for fraud, bot or suspicious-activity detection (for example, the suspicious-activity module in the 51Degrees WordPress plugin). The identifier never leaves the customer environment.

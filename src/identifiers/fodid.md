@page Identifiers_51Did 51Did (51Degrees Identifier)

A signed envelope, encoded as an <a href="https://github.com/SWAN-community/owid/blob/main/explainer.md">OWID - Open Web ID</a> (the SWAN community schema that defines the binary layout, signature, and verification rules), wrapping a **probabilistic value** that two recipients can compare to decide whether they have observed the same browser instance under the same usage purpose.

## Terminology

The two layers are distinct and the documentation below uses the words deliberately.

- The **51Did** is the **identifier**, the whole base64 OWID envelope (version, domain, date, payload, signature). It changes byte-for-byte every time the cloud issues one, even for the same inputs, because the signature differs on every call and the date states the minute the identifier was made.
- The **probabilistic value** is the **match key** of a Probabilistic 51Did, one of the fields *inside* the payload (32 bytes, a SHA-256 digest). The match key is the stable comparable part of any 51Did, and the name is the one the [Model Terms for Marketing](https://m4ow.uk/mtm/2.txt) use. It is stable across reissues for the same device + IP + usage: if two 51Dids were issued for the same inputs, their probabilistic values are equal even though the wrapping identifiers differ.
- The **date** in the envelope is the minute the cloud made the identifier, in UTC, held as whole minutes since `2020-01-01T00:00:00Z`. Read how old an identifier is from it. Two identifiers issued in the same minute share a date and still differ in their signatures. Cloud releases up to and including 4.4.33 stated midnight on the day of issue instead, so an identifier from those releases carries a date up to a day earlier than the moment it was made, and anything judging age from the date must allow for that.

Comparing two browsers means comparing the probabilistic values carried inside their identifiers, never the identifiers themselves. Calling either layer "the identifier" without qualification leads to incorrect comparisons; calling the inner field "the probabilistic identifier" is the same confusion in a different costume.

Derived from three inputs:

- The **Device ID** - a `Hardware-Platform-Browser-IsCrawler` tuple where each component is the profile ID assigned by Device Detection. See the [property dictionary](https://51degrees.com/developers/property-dictionary?item=Metrics%7CAll) for the `DeviceId` property and @ref DeviceDetection_Overview for how it is produced.
- The **client IP** of the request.
- The **usage purpose** declared per request (see *Usage flags* below).

51Dids are produced only by the cloud JSON endpoint when the Resource Key includes the relevant properties. **The 51Did is not available in the on-premise pipeline:** every identifier is signed with a private ECDSA P-256 key held only by 51Degrees' cloud service, so that recipients can verify authenticity without trusting the caller. An on-premise pipeline never holds the signing key and so cannot create a valid 51Did.

## Identifier types

The value inside the envelope comes in three types. Bits 6-7 of the payload flags byte (see *Payload layout* below) record which one a given 51Did carries.

- **Probabilistic** - a 32-byte SHA-256 derived from the Device ID and the client IP. The same device on the same network produces the same value for every caller, with no inputs beyond the usual Device Detection evidence and `id.usage`. This is the value the rest of this page uses in its examples.
- **Random** - a fresh, server-generated 16-byte GUID rather than a match key derived from the inputs. The cloud neither stores nor echoes it, so it is not stable across calls. No inputs beyond `id.usage` are needed.
- **Hashed Email** - a 32-byte SHA-256 of a caller-supplied email and a 2-byte salt, `SHA-256(lowercase(trim(email)) || saltBytes)`. The same email and salt always produce the same value for every caller. Requires the `id.email` input described under *Request inputs*, with the salt taken from `id.salt` or falling back to a salt configured by 51Degrees.

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
- **`id.salt`** (Hashed Email only) - URL-safe base64 of a 2-byte salt chosen by the caller, e.g. `Npw`. When the request does not supply one, a salt configured by 51Degrees is used instead.

If a Hashed Email property is requested without `id.email`, or with an `id.salt` value that is not valid URL-safe base64 of 2 bytes, the property is returned with a no-value reason naming the problem; an invalid salt is never silently replaced, as re-salting would hand the caller a different identifier with nothing to say why. The supplied values are never echoed back. The raw `id.email` value is used only to compute the hash; it is not logged, not shared in usage statistics, and not retained.

## Setting the usage policy

The cloud accepts two ways to decide a request's `id.usage` value. The *Direct* path can set any of the three values described under *Usage flags*; the *Derived from consent* path only ever produces `standard` or `personalized` (or no value), never `non-marketing`.

### Direct - your integration owns the mapping

Your integration decides the value and tells the cloud what to do by passing an explicit `id.usage` (`non-marketing`, `standard` or `personalized`) as a query parameter or HTTP request header. You own the mapping from whatever preference or consent surface you use to one of these three values, and the cloud just acts on what you supply. This is the path @ref Identifiers_PMP takes, where the visitor's answer reaches the cloud as a stated `id.usage`, and on a browser page it is the client script that sends it rather than your own code. See *How the answer reaches the cloud from a browser page* below.

### Derived from consent - the cloud maps a TCF string for you

Instead of deciding the value yourself, pass the raw IAB consent string and let the cloud derive `id.usage` from the consented purposes. One evidence parameter is accepted:

- `tcstring` - an IAB TCF v2 TCString, from the PMP or any TCF-aware CMP.

An IAB GPP string is not read, because the Model Terms for Marketing at <https://m4ow.uk/mtm/2.txt> do not map the Global Privacy Platform onto the usage values. A request whose only signal is a GPP string therefore produces no 51Did, whichever sections that string carries, and a TCF string sent beside one is read as usual. This is not a special case, it is the same position as a TCF string that grants too little for either usage, where the signal is real and simply does not say what the usage values say.

The cloud parses the string and checks the consented [IAB TCF v2 purposes](https://iabeurope.eu/iab-europe-transparency-consent-framework-policies/) against the definitions below, adding the matching `id.usage`:

| `id.usage`     | Required IAB TCF v2 purposes      |
|----------------|-----------------------------------|
| `personalized` | 1, 2, 3, 4, 5, 6, 7, 8, 11        |
| `standard`     | 1, 2, 7, 8, 11                    |

These two sets are Appendix 1 of the [Model Terms for
Marketing](https://m4ow.uk/mtm/2.txt), which is the contract every party
sending or receiving a 51Did is bound by, so they are what the appendix
says rather than a 51Degrees choice. Cloud releases up to and including
4.4.33 used different sets. Their standard set asked for 9 and 10, which
the appendix does not list, and did not ask for 2 or 11, which it does, so
a consent string that was exactly the appendix's standard marketing signal
produced no identifier at all. Special Purpose 2, which the appendix also
lists, is deliberately not required, because a special purpose carries no
consent or objection signal in a TCString and a check on it could never
fail.

`personalized` is tried first, then `standard`. If neither set is fully satisfied the cloud adds no `id.usage`, the `fodid.*` properties return a no-value reason, and no identifier is issued for advertising use the consent does not permit. Purposes 2, 7, 8, 9, 10 and 11 may be satisfied by a legitimate interest
bit as well as a consent bit. Within the two sets above that leaves 1, 3,
4, 5 and 6 needing an explicit consent bit, because IAB Policy forbids
claiming those under legitimate interest. Purposes 9, 10 and 12 are no
longer required by either set, so a consent string that omits them is
unaffected.

**A stated usage is read first.** Where `id.usage` is present on the request, as a query parameter or as a header, the cloud uses it and never examines a consent string sent beside it. Derivation runs only when no usage was stated. A malformed consent string is ignored rather than rejected, and the identifier records which of the two routes the usage came by, which is the signal source flag described under *Payload layout*.

## How the answer reaches the cloud from a browser page

On a page carrying the 51Degrees client script, the script gathers the visitor's answer itself and sends it. **You write no code for this**, and you no longer reload the script with an answer in its URL.

The block that does this is rendered into your script only when your Resource Key includes the `fodid.*` properties, so a key without them gets the script exactly as it was.

### The two sources, in order

1. **The 51Degrees Preference Management Platform**, if it is on the page. The script reads the answer in force through the platform's getter, listens for the platform's window event, and falls back to the platform's own stored answer. All three answers count, `non-marketing` included, and each is sent as a stated `id.usage`. See @ref Identifiers_PMP.
2. **A Transparency and Consent Framework consent management platform**, through `window.__tcfapi`. The script registers a listener at construction and takes the string from a callback reporting `tcloaded` or `useractioncomplete`, sending it as `tcstring`. See @ref Identifiers_PMP_CmpWiring.

The first source that has an answer wins and the rest are ignored, and the cloud applies the same order when the request arrives. A Global Privacy Platform string is never read by either side, because the Model Terms for Marketing at <https://m4ow.uk/mtm/2.txt> do not map it.

The script never maps a consent string to a usage itself. That happens in the cloud, in one place, so the two can never drift apart.

### The identifier is created last

The common case is the late answer, where the visitor answers after the script has already loaded.

1. The first request carries whatever was available when the script was built. On the common path that is no answer, so no 51Did is created and the response lists the snippets to run.
2. The snippets run in the browser, and their results are kept alongside a record of what the request carried.
3. The visitor answers. The script wakes up, sees an answer it did not have before, and makes one more request carrying the usage **and every snippet result**.
4. The cloud creates the 51Did on that request, against a device it has finished resolving rather than against a header only guess.

### `refresh()`

`refresh()` is a method on the page object, beside `complete` and `onChange`, that sends the current inputs again.

```{js}
fod.refresh();
```

You rarely need it. The script calls it itself when a preference platform delivers an answer, which is the case it exists for. Call it yourself only when something your own page controls has changed what the next request should carry, for example an email address you supply for the Hashed Email identifier.

What it does and does not do is worth knowing.

- It does **not** run the snippets again. They read the device rather than the answer, so the stored results are sent as they are, which is exactly what makes the new request the one carrying everything.
- It does nothing while a round is already in progress. The answer is carried by that round's own next request instead, and a request is made afterwards only where one is still needed.
- It does nothing when nothing has changed since the last request.
- It stops at the maximum number of exchanges the cloud allows for one page view, which is ten. At that point the page view is finished, because the cloud stops listing snippets at the same number, and a further call writes this line to the console and does nothing else. There is no way to raise it from the page.

```
51Degrees: the maximum of 10 iterations for this page view has been reached, refresh() does nothing.
```

### A Change of Answer

A visitor who answers again produces a new request, a fresh 51Did carrying the new usage, and a call to any function registered with `onChange`.

Two identifiers issued in one page view are never identical byte for byte, even for identical inputs, because the signature carries a fresh random value each time. The page object holds whichever response arrived last, so read the identifier after the refresh you made has completed.

### The Record of What Was Sent

The script keeps the inputs of its last request in session storage on your own origin, as a plain string, under the object's name followed by `_inputs`, which is `fod_inputs` unless you renamed the object. Its job is to make sure a stored answer is never reused for a different request. A different usage, consent string, salt, Resource Key or set of page values is a different request and produces a fresh one.

Three things follow.

- It is deliberately not hashed. A hash would be read as a privacy measure and it is not one. Session storage on your origin is reachable by you and by 51Degrees, being the joint controllers of it, and by nobody else.
- Where your page supplies `id.email`, that value is part of the record. Say so in your privacy notice, which @ref Identifiers_PMP_Privacy covers.
- Two 51Degrees integrations on one origin must use different object names, or each clears the other's record on every page view.

## Usage policies and licensing

| `id.usage`     | Requires                                |
|----------------|-----------------------------------------|
| `non-marketing`| `fodid.*` on the Resource Key only.     |
| `standard`     | Special license key required.           |
| `personalized` | Special license key required.           |

`standard` and `personalized` 51Dids are issued under contractual Model Terms that govern how the data can be used once it leaves the cloud service, and are gated by Know Your Customer (KYC) checks before the Special license key is granted. Contact 51Degrees to apply.

`non-marketing` 51Dids are provided under legitimate interest and must not leave the customer environment.

If `id.usage` is omitted, or set to `standard` / `personalized` while the Resource Key lacks the Special license key, the `fodid.*` properties are returned with a no-value reason rather than throwing. Any value other than the three listed above is rejected as an invalid usage.

**So a key without the Special license key creates only `non-marketing`
51Dids.** The Special license key is the licence key carrying the 51Did
product, and where no licence key carrying that product reaches the cloud,
on the Resource Key or beside it on the request, `id.usage=non-marketing`
creates a 51Did as usual and `standard` or `personalized` create none at
all. The @ref Identifiers_PMP asks the visitor the question whatever the
key is entitled to, so on such a key only the alternative answer, which
sends `non-marketing`, creates an identifier.

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

Open the example value in the [51Did inspector](https://51degrees.com/developers/51did-inspector?51did=AzUxZC5lcwBzGTMAJQAAAAHWTQAAr193zLwxDrchR2XHYmoTzJML7fAB60rimQeTd2WuHMPoQ4Bz56QhxhXoAynWyaAE8kWo8DO92y9LPLdatHSVaCdSioL7JaMg8S2DV36ehXIZc0HhdqteyARmOnRS7o8j) to unpack the OWID envelope, see the parsed flags, licenseId and 32-byte match key, and verify the ECDSA P-256 signature against the issuer's published public key.

## Payload layout

The payload header is shared by every identifier type; bits 6-7 of the flags byte select the type and the length of the value that follows.

| Offset | Length | Field                                                                                              |
|--------|--------|----------------------------------------------------------------------------------------------------|
| 0      | 1      | Flags: bits 0-2 usage tier, bit 3 signal source, bits 4-5 payload version, bits 6-7 identifier type |
| 1      | 4      | LicenseId (uint32, little-endian)                                                                  |
| 5      | 16/32  | Value: GUID (Random) or SHA-256 (Probabilistic, Hashed Email)                                      |

**Bit 3 is the signal source.** It is set when the cloud derived the usage from a consent string, and clear when the caller stated the usage directly with `id.usage`. A 51Did created from an answer given to the @ref Identifiers_PMP therefore has the bit clear, and one created from a consent management platform's string has it set. It records where the answer came from and nothing about who the visitor is.

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

Two 51Dids issued for the same device + IP + usage differ at the byte level because the envelope carries a signature that differs on every call, and a date that states the minute of issue. The byte-level difference is in the **identifier** (the wrapper); the **probabilistic value** carried inside is stable across reissues. To decide whether the two refer to the same browser instance, compare the probabilistic values, never the full base64 identifiers.

The probabilistic value is the match key, one of the fields the reader exposes after parsing the payload (`MatchKey` in .NET). Treat it as the cache and dedup key.

Two responses to the same device + IP + `id.usage=non-marketing`, returned in different minutes:

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

// Wrapper bytes (Date, Signature) ARE different; the identifier
// itself is not stable across reissues. The dates differ here
// because the two were issued in different minutes:
Console.WriteLine(a.Date == b.Date);          // false
Console.WriteLine(a.Signature.SequenceEqual(b.Signature)); // false

// The probabilistic value inside the payload IS stable; this is
// what you actually compare:
Console.WriteLine(a.MatchKey.SequenceEqual(b.MatchKey));   // true
```

Use `FodId.MatchKey` (32 bytes, SHA-256) as the cache and dedup key. It is
called the match key because that is the term the [Model Terms for
Marketing](https://m4ow.uk/mtm/2.txt) use for the stable comparable part.
`Hash` was the property's earlier name. Package versions 4.5.85 to
4.5.90 carried it as a deprecated alias and version 4.5.97, the current
one, no longer has it, so code written against `Hash` must move to
`MatchKey`. The same value means the same browser instance under the same usage policy on the same License Key (for `idproblic`) or across all callers (for `idprobglobal`).

## Validation

A 51Did recipient can optionally verify the signature before trusting the identifier. Two options:

1. **Cloud endpoint.** Send the base64 value to the verification endpoint on the V4 cloud and get back a parsed payload only if the signature checks out. Simple, no key handling, but every call is metered against the Resource Key.
2. **Local verification using the published public key.** Fetch
   51Degrees' public ECDSA P-256 key, hold it for the span the answer says
   it covers, and verify in process for every received identifier. The
   signature check itself is in process and is not metered, though the
   request that fetches the key needs a Resource Key or a Licence Key and
   is metered like any other, so the saving is one fetch per key rather
   than one call per identifier. Each platform reader (see *51Did readers*
   above) exposes an in process verify method that takes the public key PEM
   and returns a boolean. The .NET reader's method is the inherited
   `Owid.VerifyAsync`.

In both cases, validation only confirms the identifier was created by 51Degrees and has not been tampered with. It does not certify that the device + IP + usage inputs were truthful: that trust lives in the operational contract with the issuing 51Degrees cloud, not in the signature.

### Fetching the public key for local verification

Local verification (option 2 above) fetches the key from the OWID public
key endpoint.

```
GET https://cloud.51degrees.com/owid/api/v3/public-key?resource=<RESOURCE_KEY>
```

The answer is `application/json`.

```json
{
  "format": "spki",
  "publicKey": "-----BEGIN PUBLIC KEY-----\n...\n-----END PUBLIC KEY-----",
  "validFrom": "2026-09-07T00:00:00Z",
  "validTo": "2026-09-14T00:00:00Z"
}
```

- `format` is the encoding of `publicKey`, so a caller never has to work
  out what it was given. The only value defined is `spki`, a Subject
  Public Key Info PEM.
- `publicKey` is the key in that encoding.
- `validFrom` is the moment the key came into force and `validTo` the
  moment the next key starts, so the key covers `validFrom` up to but not
  including `validTo`. `validTo` is `null` for the newest key the
  schedule holds, which nothing later has been scheduled after.

Hold the key against the span the answer states, not against the date you
asked for. Every identifier dated inside that span verifies under the same
key, so one request serves a whole period instead of one request per
identifier.

The `format` parameter is optional and the only accepted value is `spki`,
which is what a request naming no format receives. `format=pkcs`, which
clients built against the earlier answer sent, and any other value are
answered `400`.

**This is a change to the wire format.** Cloud releases up to and
including 4.4.33 answered `text/plain` with the PEM and nothing else. A
client written against that cannot read the new answer, so a verifier
that fetches keys must be upgraded in step with the cloud release. A
client can tell which answer it has from the `Content-Type` header, and
the `51D-Version` response header names the release that answered.

The signing key rotates, so a 51Did issued before the latest rotation was
signed with an older key. To fetch the key that was in force when a 51Did
was created, pass its date.

```
GET https://cloud.51degrees.com/owid/api/v3/public-key?date=<minutes>&resource=<RESOURCE_KEY>
```

The `date` is the value the OWID envelope carries in its Date field,
minutes since `2020-01-01T00:00:00Z` (see the [OWID
explainer](https://github.com/SWAN-community/owid/blob/main/explainer.md),
"Data Structure" section).

The endpoint returns the key **in force** at that moment, being the one
whose period started latest on or before it. It is not selected by when
the key material was generated, which is months before a key comes into
force, because the schedule is written thirteen weeks ahead. A
`date` later than the moment of the request is read as that moment and
returns the current key, because a key whose period has not started has
signed nothing. A `date` before every known key returns `404`, and a
`date` that is not an unsigned 32 bit integer returns `400`.

The endpoint needs a Resource Key or a Licence Key and is metered per
call, like the other v4 endpoints.

### Fetching every public key at once

The `public-key` endpoint above returns one key per request. A verifier that wants the whole set of signing keys can pull them from the 51Did key endpoint:

```
GET https://cloud.51degrees.com/api/v4/id/key?resource=<RESOURCE_KEY>
```

The response is a JSON array, one entry per signing key:

```json
[
  {
    "startsAt": "2026-09-07T00:00:00.0000000Z",
    "weekStart": "2026-09-07T00:00:00.0000000Z",
    "created": "2026-06-08T04:01:12.0000000Z",
    "publicKey": "-----BEGIN PUBLIC KEY-----\n...\n-----END PUBLIC KEY-----"
  }
]
```

- `startsAt` is when the key comes into force, and is the field to select
  on. A key stays in force until the next entry's `startsAt`.
- `weekStart` is a legacy duplicate of `startsAt`, from when the schedule
  was fixed at one week. It is due to be dropped, so do not read it.
- `created` is when the key material was generated. **It is not when the
  key came into force.** The schedule is written thirteen weeks ahead,
  one new week each Monday, so every entry's `created` is about three
  months before its own `startsAt`, and entries written in the same run
  share a `created`. Anything that selects a key by `created` will be
  wrong by months.
- `publicKey` is the key as an SPKI PEM.

To fetch only the part of the schedule you do not already hold, add an ISO
8601 UTC timestamp.

```
GET https://cloud.51degrees.com/api/v4/id/key/datetime/2026-09-07T00:00:00Z?resource=<RESOURCE_KEY>
```

The response then holds only the keys whose period **starts** at or after
that timestamp, so poll with the newest `startsAt` you already hold rather
than the newest `created`. Polling on `created` silently misses keys. This
endpoint takes an ISO 8601 timestamp, not the minutes since 2020 value
that `public-key?date=` uses. Unlike `public-key`, it needs a Resource
Key, because a Licence Key alone is answered `401` here, and it is
metered.

## Use cases

- **Marketing** - the PMP captures the visitor's answer, the client script sends it as `id.usage`, and the 51Did is consumed by Prebid and RTB enrichment. See @ref Identifiers_PMP and @ref Integrations_Prebid.
- **Non-marketing** - the integrator sets `id.usage=non-marketing` server-side for fraud, bot or suspicious-activity detection (for example, the suspicious-activity module in the 51Degrees WordPress plugin). The identifier never leaves the customer environment.

## Find Out More

- Asking the visitor the question: @ref Identifiers_PMP
- Running a consent management platform instead: @ref Identifiers_PMP_CmpWiring
- What to tell your visitors: @ref Identifiers_PMP_Privacy
- Passing the identifier into header bidding: @ref Integrations_Prebid
- The Model Terms for Marketing, version 2, which bind every recipient: <https://m4ow.uk/mtm/2.txt>
- The byte layout, written up in full: <https://github.com/51Degrees/specifications/tree/main/did-specification>
- The OWID envelope the identifier is wrapped in: <https://github.com/SWAN-community/owid>
- The client script that gathers the answer: <https://github.com/51Degrees/javascript-templates>
- The .NET reader: <https://www.nuget.org/packages/FiftyOne.Did>
- Build or check a Resource Key: <https://configure.51degrees.com/>
- Ask us about the licence key the marketing usages need: <https://51degrees.com/contact-us>

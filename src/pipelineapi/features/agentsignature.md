@page PipelineApi_Features_AgentSignature Agent Signatures

# Introduction

An **agent** is a program that fetches pages on someone's behalf, such as a
search crawler or an assistant acting for a user, rather than a person using
a browser. Most agents can only be recognized by what they say about
themselves, and anything an agent says about itself can be copied by
something else.

**Web Bot Auth** is an IETF protocol that lets an agent prove who it is
instead. The agent holds a private key, publishes the matching public key at
an address on its own website, and signs each request it sends. A website
can then check the signature against the published key. A signature either
checks out or it does not, and it cannot be produced without the private
key, so this is the one signal in bot detection that is proof rather than
inference.

The **agent signatures** @flowelement reads the three request headers that a
signed request carries, checks the signature, and adds an @elementdata to
the @flowdata saying what the signature proves. A signed request looks like
this, wrapped here for width, as the real headers are each on one line:

```
Signature-Agent: sig="https://signer.example.com"
Signature-Input: sig=("@authority" "signature-agent";key="sig");
    created=1700000000;expires=1700011111;keyid="ba3e64==";
    tag="web-bot-auth"
Signature: sig=:abc==:
```

- `Signature-Agent` says where the agent publishes its keys.
- `Signature-Input` says which parts of the request the agent signed, when
  the signature was made, when it stops being valid, and which key was used.
- `Signature` carries the signature itself.

Three more terms are used below. A **directory** is the small JSON document
that an agent publishes at a well known address on its site, holding the
public keys it signs with. A **thumbprint** is a short fingerprint of a
public key, worked out from the key itself, which is how the request names
the key it used without sending the whole key. The **signature base** is the
exact block of text the agent signed, which the element rebuilds from the
parts of the request the agent said it covered.

Only a handful of agents sign today, OpenAI's ChatGPT agent among them, so
almost every request reports the `Absent` status. An absent signature is
never evidence against a request.

The element asks for every request header as @evidence, because a signature
may cover any header and only a covered part of the request the element can
see can be checked. Two headers matter beyond the three above, being
`header.host` and `header.protocol`, because a signature normally covers
the authority of the request, meaning the host the request was sent to, and
the authority has to be rebuilt from those two before the signature can be
checked. The @webintegration adds every header automatically.

The standards behind this feature are the IETF Web Bot Auth protocol draft,
[draft-ietf-webbotauth-httpsig-protocol-00](https://datatracker.ietf.org/doc/draft-ietf-webbotauth-httpsig-protocol/),
with its companion drafts for the
[key directory](https://datatracker.ietf.org/doc/html/draft-meunier-webbotauth-httpsig-directory)
and the
[agent card](https://datatracker.ietf.org/doc/html/draft-meunier-webbotauth-registry-03),
built on
[RFC 9421](https://datatracker.ietf.org/doc/html/rfc9421) for HTTP message
signatures and [RFC 8941](https://datatracker.ietf.org/doc/html/rfc8941) for
the header syntax.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/pipeline-elements/agent-signature-element.md#)
for more technical details.

# Properties {#AgentSignature_Properties}

The element adds twelve properties. Every one of them can report that it has
no value together with a message saying why, so a detail that was not sent
never looks like an answer. Only `AgentSignature` and `AgentSignatureReason`
always have a value.

| Property                     | Type      | When it has a value                                                                                                                                       |
| ---------------------------- | --------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `AgentSignature`             | String    | Always. One of `Absent`, `Invalid`, `Unverified`, `Timeout` and `Verified`.                                                                                |
| `AgentSignatureReason`       | String    | Always. One of the seventeen reason codes below.                                                                                                           |
| `AgentSignatureAgent`        | String    | Whenever the `Signature-Agent` header was present and could be read. Holds the value exactly as the agent sent it, for example `https://chatgpt.com`.       |
| `AgentSignatureKeyId`        | String    | Whenever the signature carried a `keyid` parameter, which is the thumbprint of the key used.                                                               |
| `AgentSignatureAlgorithm`    | String    | Whenever the signature or the published key says which algorithm was used. Holds the algorithm settled on, or the one the agent asked for where 51Degrees does not verify it. |
| `AgentSignatureCreated`      | Date and time | Whenever the signature carried a `created` parameter.                                                                                                      |
| `AgentSignatureExpires`      | Date and time | Whenever the signature carried an `expires` parameter.                                                                                                     |
| `AgentSignatureNonce`        | String    | Whenever the agent sent a `nonce`. Checking that a nonce is never reused is your job, see [What is not covered](@ref AgentSignature_NotCovered).                      |
| `AgentSignaturePurpose`      | String    | Once the key directory has been read, and only where the directory or the agent card says what the keys are for, for example `ai`, `rag` or `tdm`.         |
| `AgentSignatureName`         | String    | Only where an agent card was found. Holds the name the agent gives itself.                                                                                 |
| `AgentSignatureProductToken` | String    | Only where an agent card was found. Holds the name the agent answers to in a robots.txt file, which you can compare with `CrawlerProductTokens`.            |
| `AgentSignatureCardUrl`      | String    | Only where an agent card was found. Holds the address of the card.                                                                                         |

An agent card is a JSON document in which an agent says who it is, what it
is for and where its keys are. A card is read when the `Signature-Agent`
header points at one, or when you configure a registry of cards, see
[Configuration](@ref AgentSignature_Configuration). No card is read by default, so the last
three properties usually have no value with the message 'No agent card
available'.

Configured registries are read once for the life of the process, in the
background, the first time a card could be used. A registry or card that
cannot be fetched at that point is not tried again, so a fault at start
up, for example a firewall blocking the request or the registry being
briefly unreachable, leaves the three card properties without values
until the process restarts, even once the fault has been dealt with.
This is unlike the keys themselves, which are re-fetched and recover on
their own, see [How keys are fetched and cached](@ref AgentSignature_Caching).
The trade is deliberate because a card never changes the signature
status, only the description reported alongside it, so a stale or
missing card costs detail rather than correctness.

# Statuses

`AgentSignature` reports one of five values.

- **Absent** The request carried no signature headers. This is the ordinary
  case and it is never evidence against a request.
- **Invalid** The request carried a signature and something about the
  signature or the headers carrying it is wrong.
- **Unverified** The request carried a signature that could not be checked.
  This is not evidence against the agent, because the agent may be signing
  correctly while its key cannot be reached.
- **Timeout** The agent's key directory was still being fetched when the
  wait ran out. The fetch keeps running, so a later request from that agent
  finds the result.
- **Verified** The signature checked out against a key the agent publishes.

`AgentSignatureReason` says why, and reports one of seventeen values.

| Reason code            | Status     | What it means                                                                                                                             |
| ---------------------- | ---------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `NoSignature`          | Absent     | Neither the `Signature` header nor the `Signature-Input` header was in the request.                                                        |
| `Malformed`            | Invalid    | One of the two headers arrived without the other, or one of the three headers could not be read.                                           |
| `TagMismatch`          | Invalid    | The request was signed, but no signature in it was made for automated agent traffic, meaning none carried the `web-bot-auth` tag.          |
| `MissingParameter`     | Invalid    | The signature left out one of the three parameters it must carry, which are `created`, `expires` and `keyid`.                              |
| `Expired`              | Invalid    | The signature had already expired, or it was valid for longer than the maximum lifetime you configured.                                    |
| `NotYetValid`          | Invalid    | The signature was created further into the future than the clock skew allows, so either the agent's clock or yours is wrong.               |
| `NoAgent`              | Unverified | The signature named no agent, so there was nowhere to fetch a key from.                                                                    |
| `InlineDirectory`      | Unverified | The agent sent its key set inside the request itself, in a `data:` URI, rather than publishing the key set at an address the agent controls. A key sent with the request proves only that the sender holds the matching private key, so an inline key set is refused unless you turn `SetAllowInlineDirectory` on. |
| `UnboundSignature`     | Invalid    | The signature covered neither the authority nor the target address of the request, so nothing ties the signature to the request it arrived on, and one captured on another site could be replayed here. |
| `ComponentUnavailable` | Unverified | The signature covered part of the request that cannot be rebuilt from the @evidence the @Pipeline holds, see [What is not covered](@ref AgentSignature_NotCovered). |
| `DirectoryPending`     | Timeout    | The agent's key directory had not arrived when the wait ran out.                                                                           |
| `DirectoryUnavailable` | Unverified | The agent's key directory could not be fetched or could not be read.                                                                       |
| `UnknownKey`           | Invalid    | The key directory was read and holds no key with the key id the signature named, which is evidence that the key was withdrawn.             |
| `KeyExpired`           | Invalid    | The key was found, but the agent's own directory says the key was not valid at the moment the signature was made.                          |
| `UnsupportedAlgorithm` | Unverified | The signature uses an algorithm 51Degrees does not verify. The three that are verified are `ed25519`, `rsa-pss-sha512` and `ecdsa-p256-sha256`. |
| `SignatureMismatch`    | Invalid    | The signature did not check out against the key the agent publishes, so the request was not sent by the holder of that key.                |
| `Verified`             | Verified   | The signature checked out against a key the agent publishes.                                                                               |

Reason codes are exposed as constants, so you can compare against them in
code without writing the text out.

# Configuration {#AgentSignature_Configuration}

The feature is provided by a @flowelement you add to the @Pipeline, and the
defaults are chosen so that nothing needs to be set for it to work.

| Option                          | Default                        | What it does                                                                                                                                            |
| ------------------------------- | ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `SetHttpClient`                 | a client the element owns      | The client used to fetch key directories, agent cards and registries. The element's own client does not follow redirects. A client you supply is used exactly as you built it and is not disposed of by the element, because you own it. |
| `SetCacheSize`                  | 1000                           | How many agents' key directories are held in memory at once.                                                                                            |
| `SetCacheLifetime`              | 24 hours                       | How long a fetched key directory is reused for. This matches the caching period the drafts recommend a directory is published with.                      |
| `SetNegativeCacheLifetime`      | 5 minutes                      | How long a failed fetch is remembered for, so that an outage at one agent does not cause a fetch on every request.                                       |
| `SetWaitBudget`                 | 350 milliseconds               | How long a request waits for a key directory before it reports `Timeout`.                                                                                |
| `SetFetchTimeout`               | 5 seconds                      | The time limit on one fetch of a key directory, a card or a registry.                                                                                    |
| `SetClockSkew`                  | 60 seconds                     | The tolerance on `created` and `expires`, which allows for clocks that differ a little.                                                                  |
| `SetMaxLifetime`                | zero, meaning no limit         | Rejects a signature valid for longer than this, reporting `Invalid` with the `Expired` reason. There is no limit by default because the protocol draft only recommends one, of 24 hours. |
| `SetRegistry`                   | none                           | Adds a registry of agent cards, being a text document listing one card address per line. Call it more than once to add more than one registry. Registries are read once for the life of the process, so a read that fails for any reason is not retried until a restart, see [Agent cards](@ref AgentSignature_Properties). |
| `SetAllowLegacySignatureAgent`  | true                           | Whether the older form of the `Signature-Agent` header, a bare quoted string rather than a list, is accepted.                                            |
| `SetAllowInlineDirectory`       | false                          | Whether a key set carried inside the request in a `data:` URI is accepted. Leave this off wherever requests arrive from the public internet, and turn it on only where every caller is already trusted, such as a test harness. |
| `SetMaxResponseBytes`           | 262,144                        | The most that is read from a key directory, agent card or registry response before the fetch is abandoned. The address fetched is chosen by whoever sent the request, so the size is held down. |

Every period is checked when the element is built, and a negative period or
one longer than a year is refused there rather than surfacing on a request
later.

Every option except `SetHttpClient` can also be set from a @Pipeline
configuration file by naming the option without its `Set` prefix, in the
same way as the other elements. The client is the exception because a
configuration file holds text and a client cannot be written as text.

# How keys are fetched and cached {#AgentSignature_Caching}

An agent's public keys live on the agent's own website, so 51Degrees has to
fetch them. The first time a signed request arrives from an agent that this
@Pipeline has not seen before, the keys are not held yet and a request over
the network has to be made.

That fetch does not hold up your page. The request waits for the fetch only
for the wait budget, 350 milliseconds by default. If the keys have not
arrived by then, the request reports `Timeout` with the `DirectoryPending`
reason and carries on through the @Pipeline, while the fetch keeps running
in the background. The next request from that agent, moments later, finds
the keys already there and reports `Verified`.

**This means the very first request from a new agent can report `Timeout`,
and that is deliberate rather than a fault.** The alternative would be to
hold a page open while a third party's server answers, which is not a
trade a website should have to make. Treat `Timeout` as 'not yet known',
the same way you would treat `Unverified`, and not as a failed check.

The rest of the caching behavior:

- A burst of requests from one agent starts one fetch, not one fetch per
  request, however many arrive at once.
- Keys are reused for 24 hours by default, or for a shorter period where the
  agent's own server asks for one.
- Once keys are older than that period, the next request that needs them
  starts a fresh fetch and is answered from the keys already held while the
  fresh copy arrives, so a refresh never causes a delay.
- A refresh that fails leaves the keys already held in place. A directory
  that cannot be reached is not evidence against an agent, and the protocol
  draft is explicit about this.
- Keys held on to while refreshes keep failing answer for at most one
  further caching period and then stop answering. Taking a directory
  offline is how an agent withdraws a stolen key, so keys that answered
  for ever would make withdrawal impossible.
- A refresh that succeeds and no longer lists the key changes the answer to
  `Invalid` with the `UnknownKey` reason, because an agent that removes a
  key from its published directory has withdrawn that key.
- A fetch that fails is remembered as a failure for 5 minutes, so an outage
  at one agent does not cause a fetch on every request that arrives during
  it.
- The number of agents held is capped, 1000 by default, because the address
  the keys are fetched from is chosen by whoever sends the request.

The address the keys are fetched from also comes from the request, so the
element checks an address before making a request to it rather than
trusting it:

- Keys are only ever fetched over HTTPS. The protocol draft permits plain
  HTTP and 51Degrees does not, because a key fetched over plain HTTP proves
  nothing about who published it.
- An address carrying user information before an `@`, or written as an IP
  address in a range that only appears inside a network, such as a
  loopback, private, link local, carrier grade or IPv6 unique local range,
  is refused, because a sender-chosen address in one of those ranges is how
  a server is made to fetch its own internal services.
- Redirects are not followed on directory and agent card fetches, so the
  document read is always the one at the address that was checked.
- No more than `SetMaxResponseBytes` is read from any response, so a
  request cannot point the element at an endless document.

# How the element is verified {#AgentSignature_HowVerified}

The element is checked against the standards and against the agents
signing today, not only against its own fixtures.

- The worked examples printed in
  [RFC 9421](https://www.rfc-editor.org/rfc/rfc9421) itself are asserted
  character for character against the signature base the element
  rebuilds, so any drift from the standard fails a test.
- The [structured field test suite](https://github.com/httpwg/structured-field-tests)
  published by the HTTP working group, over a thousand cases, runs
  against the header parsing and the strict serialisation.
- The test vectors Cloudflare publishes in their
  [web-bot-auth](https://github.com/cloudflare/web-bot-auth) project
  verify, so the element agrees with their reference implementation.
- Live interoperability tests fetch the key directories Cloudflare and
  OpenAI publish for their real agents, read keys from them, and verify
  a freshly signed request against Cloudflare's Web Bot Auth research
  service, so the element is checked against the services on the wire,
  not only against copies. These tests need the network, so the suite
  runs them only when the environment variable
  `FIFTYONE_AGENT_SIGNATURE_NETWORK_TESTS` is set to `1`.

# What is not covered {#AgentSignature_NotCovered}

- **Checking that a nonce is never reused is your job.** A signed request
  may carry a `nonce`, which is a value the agent should never use twice.
  Noticing a repeat means storing every nonce seen for as long as a
  signature stays valid, and only you know how much traffic you take and how
  long you are willing to remember. 51Degrees reports the value through
  `AgentSignatureNonce` and leaves the decision to you.
- **Signatures covering more of the request than the headers, the host and
  the scheme cannot be checked yet.** A signature says which parts of the
  request it covers, and those parts have to be rebuilt exactly before the
  signature can be checked. The @webintegration puts every request header
  into @evidence, so any header a signature covers is available, and the
  authority and the scheme can both be rebuilt from `header.host` and
  `header.protocol`. The request method, path and query string are not in
  @evidence today, so a signature covering `@target-uri`, `@method`,
  `@path` or `@query` reports `Unverified` with the `ComponentUnavailable`
  reason. Signatures covering those components are rare in practice,
  because the protocol draft requires a signer to cover the authority or
  the target address and its own example covers nothing beyond the
  authority. Adding the request method, path and query string to web
  evidence is
  [pipeline-dotnet issue 374](https://github.com/51Degrees/pipeline-dotnet/issues/374).
- **The 51Degrees cloud service does not offer these properties yet.** The
  feature is on-premise only for now, because verification needs to fetch
  the agent's keys from the machine that took the request.

`IsCrawler` and the other crawler properties are a separate thing and the
two work together. `IsCrawler` says what an agent declares about itself, and
`AgentSignature` says what an agent has proved. See
[Crawlers](@ref DeviceDetection_Features_Crawlers) for the crawler
properties.

# Example

@startsnippets
@grabexample{pipeline-dotnet,_agent_signature_2_program_8cs,.NET}
@grabbedexample
@endsnippets

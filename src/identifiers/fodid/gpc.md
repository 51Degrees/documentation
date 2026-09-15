@page Identifiers_51Did_Gpc Global Privacy Control

Global Privacy Control is a signal a browser or an extension sends on the
visitor's behalf, as the `Sec-GPC` request header and as
`navigator.globalPrivacyControl` on the page. The @ref Identifiers_51Did
ignores it.

# What Ignoring It Means

The usage of a 51Did comes from one of exactly two places, being an
`id.usage` your integration states on the request or a Transparency and
Consent Framework string the cloud reads a usage out of. Global Privacy
Control is neither, so it sets no usage and changes none.

Three things follow.

- A request carrying the `Sec-GPC` header and nothing else creates no
  51Did, because no usage was stated and none could be worked out. The
  response has no `fodid` section at all, which is what any request with no
  usage gets.
- A request carrying the header beside a stated usage or a consent string
  creates exactly the identifier that usage or string calls for. The header
  neither blocks it nor changes it.
- The value inside the identifier is the same either way. A probabilistic
  51Did is built from the device, the client IP address and the usage, and
  the header is none of those, so it moves nothing.

The 51Degrees client script does not read `navigator.globalPrivacyControl`
either, and neither does the Preference Management Platform.

# Acting On It Yourself

A publisher who wants the signal to change what happens acts on it in their
own code, before asking the cloud for an identifier. The decision is the
publisher's, because what the signal means for a site depends on where that
site operates and on what the site does with the identifier afterwards.

Two ways to act on it, both entirely in your hands.

- **Do not ask for the identifier.** A request that states no usage
  produces no 51Did, so leaving the usage off is all that is needed. On a
  browser page the visitor is never asked the question, so nothing is
  answered and nothing is created.
- **State the usage you want.** Send `id.usage=non-marketing` and the
  identifier carries that usage, which covers analytics, fraud prevention
  and security only. A `non-marketing` identifier is provided under
  legitimate interest, is not created under the Model Terms for Marketing
  and must not leave your own environment. The value is available on any
  resource key that carries the `fodid.*` properties.

Whichever you choose, the identifier records only the usage that reached the
cloud. It says nothing about the signal you acted on.

# Find Out More

- The identifier, its inputs and its usage values: @ref Identifiers_51Did
- Stating the usage from the visitor's answer: @ref Identifiers_51Did_Pmp
- Reading a usage out of a consent string: @ref Identifiers_51Did_Tcf
- What each usage permits, in the Model Terms for Marketing, version 2:
  <https://m4ow.uk/mtm/2.txt>
- The Model Terms for Marketing explainer: <https://m4ow.uk/mtm>
- Global Privacy Control, the specification and the organisation behind it:
  <https://globalprivacycontrol.org>
- The W3C draft of the specification: <https://w3c.github.io/gpc/>

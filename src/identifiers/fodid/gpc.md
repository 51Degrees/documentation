@page Identifiers_51Did_Gpc Global Privacy Control

Global Privacy Control is a signal a browser or an extension sends on the visitor's behalf, as the `Sec-GPC` request header and as `navigator.globalPrivacyControl` on the page. It asks a business not to sell or share the visitor's personal information. From 1 January 2027 California requires browser makers to offer the setting (AB 566), so the share of visits that send the signal will rise.

A publisher using PMP and the 51Did under the Model Terms for Marketing meets the signal by design, and still asks every visitor how they want to be marketed to. Nothing in the integration changes for a visitor who sends the signal, and the cloud does not read it.

## What the cloud does with the signal

Nothing. The usage of a @ref Identifiers_51Did comes from one of two places, being an `id.usage` your integration states on the request or a Transparency and Consent Framework (TCF) string the cloud reads a usage out of. Global Privacy Control is neither, so the signal sets no usage and changes none.

- A request with the `Sec-GPC` header and nothing else creates no 51Did, because no usage was stated and none could be worked out. The response has no `fodid` section at all, which is what any request with no usage gets.
- A request with the header beside a stated usage or a consent string creates exactly the identifier that usage or string calls for.
- The 51Degrees client script does not read `navigator.globalPrivacyControl`, and neither does PMP.

A request that states no usage creates no identifier, so a publisher whose own code chooses to act on the signal has only to leave the usage off.

## Why nothing needs to act on it

The Model Terms for Marketing explainer sets out the position under United States law in its section 6, at <https://m4ow.uk/mtm>. The clause numbers below are from the terms at <https://m4ow.uk/mtm/2.txt>.

1. The signal is a request to opt out of the sale or sharing of personal information under the California Consumer Privacy Act (Civil Code 1798.135(b)(1) and regulation 7025). It does not apply to collecting data, to processing it, or to asking the visitor a question.
2. Personal information excludes deidentified information (1798.140(v)(3)), meaning data that the holder takes reasonable measures to keep from being associated with a consumer or household, publicly commits not to reidentify, and binds every recipient to treat the same way (1798.140(m)).
3. Covered Data under the Model Terms meets that test by contract. Each recipient warrants it has no means to identify anyone (clause 7.1), may not acquire them (7.2), publishes the commitment (7.4) and may only pass data to parties bound by the same terms (5.1 and 5.2). A Transaction is therefore neither a sale nor a share, and the regulations do not require a business that does not sell or share to treat the signal as an opt-out request (7025(c)(1)).
4. The call that creates the 51Did is processing by a service provider on the publisher's behalf, so it is not a sale or a share, whatever evidence the request sends.
5. PMP asks every visitor the same question in the same way, and never because of the signal, so the question is not content shown "in response to" the signal (7025(f)(3)) and the experience is the same for everyone (7025(f)(2)). The regulations let a person's direct choice override the signal (7025(c)(3)), and a publisher may offer its own choice in place of one sent by a browser.
6. Standard marketing is not cross-context behavioral advertising, so only the Personalized answer rests on point 3 at all.

Everything rests on point 3, which is what the Model Terms are built around.

## Find out more

- The Model Terms for Marketing explainer, section 6, The position under United States law: <https://m4ow.uk/mtm>
- The Model Terms for Marketing, version 2: <https://m4ow.uk/mtm/2.txt>
- The identifier, its inputs and its usage values: @ref Identifiers_51Did
- Stating the usage from the visitor's answer: @ref Identifiers_51Did_Pmp
- Reading a usage out of a consent string: @ref Identifiers_51Did_Tcf
- Global Privacy Control, the specification and the organization behind it: <https://globalprivacycontrol.org>
- The W3C draft of the specification: <https://w3c.github.io/gpc/>
- The California Consumer Privacy Act regulations, with regulation 7025 on opt-out preference signals: <https://cppa.ca.gov/regulations/>

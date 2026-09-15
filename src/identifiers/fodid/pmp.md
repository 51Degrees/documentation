@page Identifiers_51Did_Pmp The Preference Management Platform Answer

The 51Degrees Preference Management Platform asks the visitor the Model
Terms for Marketing question and keeps the answer. That answer reaches the
cloud as a stated `id.usage`, so the cloud works nothing out and the
@ref Identifiers_51Did records that the usage was stated.

The platform itself, being the tag, the dialog and the shared answer, is
@ref Identifiers_PMP. This page is the part between the answer and the
identifier.

# The Three Answers and the Usage Each Creates

| The visitor's answer | Sent as | What the identifier carries |
|---|---|---|
| Personalized | `id.usage=personalized` | Personalised advertising and targeted content. |
| Standard | `id.usage=standard` | Standard advertising and audience measurement. |
| The alternative button | `id.usage=non-marketing` | Analytics, fraud prevention and security only. |

All three are answers and each one creates a 51Did carrying that usage. The
alternative button is not a refusal and not a failure path, so an identifier
follows it like the other two. What the two marketing usages permit is set
out in the Model Terms for Marketing, version 2, at
<https://m4ow.uk/mtm/2.txt>, and the scheme behind them is explained at
<https://m4ow.uk/mtm>. A `non-marketing` identifier is provided under
legitimate interest rather than under those terms and must not leave your
own environment.

# How the Answer Reaches the Cloud

You write no code for this.

1. The visitor answers the dialog. The platform stores the answer,
   announces it on the window as a `51d-pmp-preference` event and holds it
   behind `window.__51d_pmp.preference()`.
2. The 51Degrees client script hears the announcement, or reads the getter
   where the answer was already in force when the script was built, and
   asks the cloud again.
3. That request carries `id.usage` and every value the script's snippets
   produced, so the identifier is created after everything else about the
   page is known.

The platform also serves a Transparency and Consent Framework surface of
its own, so the client script can see both an answer and a string on the
same page. The script asks the platform first and the framework second, and
the cloud applies the same order when the request arrives, so the answer is
what travels and the string beside it is never examined. That is why an
identifier made on a page running this platform records a stated usage. The
other order, where a string is all there is, is
@ref Identifiers_51Did_Tcf.

# The Identifier Says the Usage Was Stated

Bit 3 of the flags byte is the signal source bit, described under *Payload
layout* on @ref Identifiers_51Did. It is clear on an identifier made from an
answer given to this platform, because the caller stated the usage, and set
on one whose usage 51Degrees worked out from a consent string.

The bit does not grade the two routes. It tells a recipient which one
happened, which nothing else in the identifier says, because the same usage
is reachable either way.

# The Licence Key the Marketing Answers Need

`standard` and `personalized` need the Special license key on your resource
key, which 51Degrees grants after the checks described under *Usage policies
and licensing* on @ref Identifiers_51Did. `non-marketing` needs only the
`fodid.*` properties on the key.

**A key without that licence still shows the dialog and still asks the
question.** What changes is which answer produces an identifier.
Personalized and Standard then produce none, with the `fodid.*` properties
coming back with a reason naming the missing product, while the alternative
button produces a `non-marketing` identifier as usual. Check the key before
reading anything into how few identifiers a site produces.

# Find Out More

- The platform, the dialog and the shared answer: @ref Identifiers_PMP
- How the platform compares with a consent management platform:
  @ref Identifiers_PMP_CmpComparison
- The three answers, where each is kept and how to read the one in force:
  @ref Identifiers_PMP_Preferences
- The identifier, its inputs and its payload: @ref Identifiers_51Did
- Reading a usage out of a consent string instead:
  @ref Identifiers_51Did_Tcf
- What to tell your visitors: @ref Identifiers_PMP_Privacy
- The Model Terms for Marketing, version 2: <https://m4ow.uk/mtm/2.txt>
- The Model Terms for Marketing explainer: <https://m4ow.uk/mtm>
- The client script that carries the answer to the cloud:
  <https://github.com/51Degrees/javascript-templates>
- Build or check a resource key: <https://configure.51degrees.com/>
- Ask us about the licence key the marketing usages need:
  <https://51degrees.com/contact-us>

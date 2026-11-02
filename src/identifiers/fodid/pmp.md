@page Identifiers_51Did_Pmp The PMP answer

PMP asks the visitor the Model Terms for Marketing question and keeps the answer. That answer reaches the cloud as a stated `id.usage`, so the cloud works nothing out and the @ref Identifiers_51Did records that the usage was stated.

PMP itself, being the tag, the dialog and the shared answer, is @ref Identifiers_PMP. This page is the part between the answer and the identifier.

## The three answers and the usage each creates

| The visitor's answer | Sent as | What the usage covers |
|---|---|---|
| Personalized | `id.usage=personalized` | Marketing and other content related to the visitor's browsing history or interactions. |
| Standard | `id.usage=standard` | Marketing and other content unrelated to the visitor's browsing history or interactions, such as content chosen by time, region and the page in view. |
| The alternative button | `id.usage=non-marketing` | Analytics, fraud prevention and security only. |

All three are answers, and each one creates a 51Did with that usage. The alternative button is not a refusal and not a failure path, so an identifier follows it like the other two. What the two marketing usages permit is set out in the Model Terms for Marketing, version 2, at <https://m4ow.uk/mtm/2.txt>, and the scheme behind them is explained at <https://m4ow.uk/mtm>. A `non-marketing` identifier is covered by your agreement with 51Degrees under the published [General Terms and Conditions](https://51degrees.com/terms/general-terms-and-conditions/20261019) and [Cloud Services Terms](https://51degrees.com/terms/cloud-services-terms/20260323).

## How the answer reaches the cloud

You write no code for this.

1. The visitor answers the dialog. PMP stores the answer, fires the `51d-pmp-preference` event on the window, which includes the answer, and holds the answer behind `window.__51d_pmp.preference()`.
2. The 51Degrees client script hears the event, or reads the getter where the answer was already in force when the script was built, and asks the cloud again.
3. That request carries `id.usage` and every value the script's snippets produced, so the identifier is created after everything else about the page is known.

PMP also serves a Transparency and Consent Framework (TCF) surface of its own, so the client script can see both an answer and a string on the same page. The script takes PMP's answer first and the framework's string second, and the cloud applies the same order when the request arrives, so the answer is what travels and the string beside it is never examined. That is why an identifier made on a page running PMP records a stated usage. The other order, where a string is all there is, is @ref Identifiers_51Did_Tcf.

## The identifier says the usage was stated

Bit 3 of the flags byte, described under *Payload layout* on @ref Identifiers_51Did, says how the usage was arrived at. It is clear on an identifier made from an answer given to PMP, because the caller stated the usage, and set on one whose usage 51Degrees worked out from a consent string.

The bit does not grade the two routes. It tells a recipient which one happened, which nothing else in the identifier says, because the same usage is reachable either way.

## The License Key the marketing answers need

`standard` and `personalized` need a License Key that carries the 51Did product, which 51Degrees grants after its know your customer checks, as *Usage policies and licensing* on @ref Identifiers_51Did describes. `non-marketing` needs only the `fodid.*` properties on the key.

**A key without that license still shows the dialog and still asks the question.** What changes is which answer produces an identifier. Personalized and Standard then produce none, with the `fodid.*` properties coming back with a reason naming the missing product, while the alternative button produces a `non-marketing` identifier as usual. Check the key before reading anything into how few identifiers a site produces.

## Find out more

- PMP, the dialog and the shared answer: @ref Identifiers_PMP
- How PMP compares with a consent management platform: @ref Identifiers_PMP_CmpComparison
- The three answers, where each is kept and how to read the one in force: @ref Identifiers_PMP_Preferences
- The identifier, its inputs and its payload: @ref Identifiers_51Did
- Reading a usage out of a consent string instead: @ref Identifiers_51Did_Tcf
- The Model Terms for Marketing, version 2: <https://m4ow.uk/mtm/2.txt>
- The Model Terms for Marketing explainer: <https://m4ow.uk/mtm>
- The client script that carries the answer to the cloud: <https://github.com/51Degrees/javascript-templates>
- Ask us about the License Key the marketing usages need: <https://51degrees.com/contact-us>

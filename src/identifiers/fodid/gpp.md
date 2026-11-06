@page Identifiers_51Did_Gpp Global Privacy Platform and US Privacy strings

Neither a Global Privacy Platform string nor a US Privacy string is read when the cloud decides the usage of a @ref Identifiers_51Did. The Model Terms for Marketing map the IAB Europe Transparency and Consent Framework (TCF) and nothing else, so no section of either string says what the usage values say.

The Global Privacy Platform is the IAB Tech Lab container that carries several consent signals in one string, one section per signal. The US Privacy string is the older signal written for the California Consumer Privacy Act, which IAB Tech Lab deprecated on 31 January 2024 and tells its users to replace with the Global Privacy Platform.

## What happens to a request with one

A request whose only consent signal is one of these strings gets no usage from the string, so the response has no `fodid` section at all, with no property, no reason and no warning, the same as a request with no signal. That holds for every section of a Global Privacy Platform string, the United States national section included, and whether the string is sent as `gpp` or `gppstring`.

A TCF string sent beside one is read exactly as it is read on its own, so a page whose consent platform emits both keeps working. That reading is @ref Identifiers_51Did_Tcf.

Neither name is listed in the service's evidence keys, so a client that builds its request from that list stops sending them.

## Why the terms decide this

The usage inside a 51Did says what a recipient of the identifier may do with it, and that meaning comes from the Model Terms for Marketing rather than from 51Degrees. The text in force is version 2, at <https://m4ow.uk/mtm/2.txt>, with the scheme explained at <https://m4ow.uk/mtm>. Appendix 1 of that text maps the TCF purposes onto standard marketing and personalized marketing, and maps no other signal, so a Global Privacy Platform string can be a real signal and still say nothing a usage could be built from.

This is not a special case for the Global Privacy Platform. A TCF string that grants too little for either usage produces no identifier either, for the same reason, which is that the signal does not say what the usage values say.

Mapping the Global Privacy Platform needs a new version of the Model Terms and a cloud release that reads it, so there is no setting on a Resource Key or a parameter on a request that turns this on.

## If a Global Privacy Platform string is all you have

Two routes lead to an identifier.

- **Ask the visitor the Model Terms question.** PMP asks it in the visitor's own language, and the answer reaches the cloud as a stated usage. See @ref Identifiers_51Did_Pmp and @ref Identifiers_PMP.
- **Run a TCF consent management platform.** Its string is read as it always was, whether or not a Global Privacy Platform string is sent beside it. See @ref Identifiers_51Did_Tcf.

Where your own code decides the usage instead, it states the value on the request as `id.usage` and you own that mapping, which is the direct path under *Setting the usage policy* on @ref Identifiers_51Did. The two marketing usages still need a License Key that carries the 51Did product, and the Model Terms still govern what a recipient may do with the identifier that comes back.

## Checking what a service reads

Earlier releases of the cloud service read the European section of a Global Privacy Platform string sent as `gpp`, so a page that relied on that gets no identifier once the service it calls has been upgraded. Ask the service what it reads.

```
GET https://cloud.51degrees.com/api/v4/evidencekeys
```

The answer lists the evidence keys the service accepts. A service listing `query.gpp` still reads a Global Privacy Platform string, and a service whose list does not carry that key reads none.

## Find out more

- The consent string the cloud does read: @ref Identifiers_51Did_Tcf
- The visitor's answer sent as a stated usage: @ref Identifiers_51Did_Pmp
- The identifier, its inputs and its payload: @ref Identifiers_51Did
- Passing the identifier into header bidding: @ref Integrations_Prebid
- The Model Terms for Marketing, version 2: <https://m4ow.uk/mtm/2.txt>
- The Model Terms for Marketing explainer: <https://m4ow.uk/mtm>
- IAB Tech Lab, the Global Privacy Platform: <https://github.com/InteractiveAdvertisingBureau/Global-Privacy-Platform>
- IAB Tech Lab, the US Privacy string: <https://github.com/InteractiveAdvertisingBureau/USPrivacy>
- IAB Europe, the Transparency and Consent Framework: <https://iabeurope.eu/transparency-consent-framework/>

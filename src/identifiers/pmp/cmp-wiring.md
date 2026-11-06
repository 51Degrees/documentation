@page Identifiers_PMP_CmpWiring Using a consent management platform instead

This page is for a site that already runs a consent management platform from another vendor and wants 51Degrees identifiers alongside it. PMP is not part of that arrangement.

## PMP and a consent management platform never share a page

PMP is a technically complete implementation of the Transparency and Consent Framework (TCF), and it deliberately does not follow the framework's policies. It asks its own question about the usages the Model Terms for Marketing define, rather than running the framework's consent flow.

So a site running a consent management platform does not add PMP. Both want to own `window.__tcfapi`, and only one of them can. PMP checks as it starts, and where it finds a `__tcfapi` that is not its own it writes a warning to the console and stops rather than replacing it.

A site with a consent management platform keeps everything else, being the 51Degrees client script, the consent string, the usage derived from it and the 51Did. What it does not get is the answer shared across a group of sites and the second card that offers it, because both belong to PMP.

## Load order

The 51Degrees client script reads your consent management platform through `window.__tcfapi`, and it registers its listener once, as it starts.

- **Your platform's stub must come before the 51Degrees script tag.** Every consent management platform ships one, and the TCF specification already requires it to be first on the page. The stub queues the registration.
- **The consent management platform itself may load later.** That is the normal case, and it works because the stub holds the registration until the platform takes over and then calls back.
- **A missing stub cannot recover on the same page view.** If `__tcfapi` is absent when the client script starts and PMP is not on the page, the script logs one warning. Add the platform's stub before the client script and reload the page.

  ```
  51Degrees: no preference platform was found on this page. A platform's stub must precede this script. No 51Did will be created until a platform answers.
  ```

  That warning is the only signal, so read the console when a page produces no identifier.

```html
<!-- 1. Your consent management platform's own stub. -->
<script>/* your platform's __tcfapi stub */</script>

<!-- 2. The 51Degrees client script. -->
<script async src="https://cloud.51degrees.com/api/v4/YOUR-RESOURCE-KEY.js"></script>

<!-- 3. Your consent management platform itself, whenever it arrives. -->
<script async src="https://your-cmp.example.com/cmp.js"></script>
```

## How the answer reaches the cloud

You write no code for this. The client script registers with `__tcfapi('addEventListener', 2, ...)` and calls neither `ping` nor `getTCData`, which version 2.2 of the framework deprecates. It takes the string from a callback reporting `tcloaded` or `useractioncomplete`, sends it to the cloud as `tcstring`, and the cloud derives the usage from the purposes the string grants. Where the platform has not called back within ten seconds, the script writes a console message saying the call is treated as no answer, and nothing else changes.

- **No string means no identifier.** Until your platform delivers one, the client script sends no answer, so no 51Did is created. A visitor who never answers your dialog produces no identifier at all.
- **A string that grants too little produces no identifier either.** The cloud tries `personalized` first, then `standard`, and where neither set of purposes is fully granted it adds no usage, so the response carries no `fodid` section at all, exactly as it does for a page whose platform has not answered. The purpose sets, and what the cloud does with a string, are on @ref Identifiers_51Did_Tcf.

An identifier created this way records that its usage was derived rather than stated, in bit 3 of the flags byte. See *Payload layout* on @ref Identifiers_51Did.

## Passing IsGdpr to your consent management platform

`IsGdpr` says whether the visit comes from a place where the General Data Protection Regulation (GDPR) applies, worked out by the cloud from the request's country. What it is, and how to get it onto the page, is on @ref Identifiers_PMP_IsGdpr.

Read it from the client script's object with `onChange`, which is called each time the cloud's answers change.

```js
fod.onChange(function (data) {
    var applies = data.derived && data.derived.isgdpr; // true, false or absent
});
```

The value is a boolean. `derived.isgdpr` is absent when your Resource Key does not ask for `IsGdpr`, so test for it rather than assuming it is there.

**Your consent management platform's own setting always wins.** Whether to take `IsGdpr` or your platform's own way of deciding where GDPR applies is your decision, and the outcome is yours either way. Where you choose your platform's own detection, `IsGdpr` is not used. Passing it is a convenience rather than a requirement, and 51Degrees does not decide for you what your consent surface reports. For the call itself, use your platform's own documentation, because the method for saying whether GDPR applies belongs to each vendor and differs between them.

## Find out more

- What `IsGdpr` is and how to get it on the page: @ref Identifiers_PMP_IsGdpr
- What the cloud does with a consent string, purpose by purpose: @ref Identifiers_51Did_Tcf
- The identifier, the usage values and how a consent string maps to one: @ref Identifiers_51Did
- PMP for a site that does not run a consent management platform: @ref Identifiers_PMP
- How PMP compares with a consent management platform, feature by feature: @ref Identifiers_PMP_CmpComparison
- Header bidding with the identifier: @ref Integrations_Prebid
- How the client script gathers page values: @ref PipelineApi_Features_ClientSideEvidence
- The client script itself: <https://github.com/51Degrees/javascript-templates>
- The Model Terms for Marketing, version 2: <https://m4ow.uk/mtm/2.txt>

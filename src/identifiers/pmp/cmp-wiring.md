@page Identifiers_PMP_CmpWiring Using a Consent Management Platform Instead

This page is for a site that already runs a third party consent management
platform and wants 51Degrees identifiers alongside it. The Preference
Management Platform is not part of that arrangement.

# The Two Never Share a Page

The Preference Management Platform is a technically complete implementation
of the Transparency and Consent Framework, and it deliberately does not
follow the Framework's Policies. It asks its own question about the Model
Terms usages rather than running the Framework's own consent flow.

So a site running a consent management platform does not add the Preference
Management Platform. Both want to own `window.__tcfapi`, and only one of
them can. The Preference Management Platform checks at start up, and where
it finds a `__tcfapi` that is not its own it writes a warning to the console
and stops rather than replacing it.

What a consent management platform site keeps is the whole of the rest,
being the 51Degrees client script, the consent string, the usage derived
from it and the 51Did. What it does not get is the answer shared across a
group of sites and the second card that offers it, because both belong to
the Preference Management Platform.

# Load Order

The 51Degrees client script reads your consent management platform through
`window.__tcfapi`, and it registers its listener when it is built.

- **Your platform's inline stub must come before the 51Degrees script tag.**
  Every consent management platform ships one, and the Framework's own
  specification already requires it to be first on the page. The stub queues
  anything asked of it.
- **The platform itself may load later.** That is the normal case and it
  works, because the stub holds the registration until the real
  implementation takes over and then calls back.
- **A missing stub has no recovery on that page view.** The client script
  registers once. Where nothing answers to `__tcfapi` at that moment, and
  the Preference Management Platform is not on the page either, the script
  writes one warning to the console and nothing recovers it.

  ```
  51Degrees: no preference platform was found on this page. A platform's stub must precede this script. No 51Did will be created until a platform answers.
  ```

  That warning is the only signal you get, so read the console when a page
  produces no identifier.

```{html}
<!-- 1. Your consent management platform's own stub. -->
<script>/* your platform's __tcfapi stub */</script>

<!-- 2. The 51Degrees client script. -->
<script async src="https://cloud.51degrees.com/api/v4/YOUR-RESOURCE-KEY.js">
</script>

<!-- 3. Your consent management platform itself, whenever it arrives. -->
<script async src="https://your-cmp.example.com/cmp.js"></script>
```

# How the Answer Reaches the Cloud

You write no code for this. The client script asks the Framework for the
current string, using only the calls the specification requires of every
consent management platform, being `ping`, `addEventListener` and the
callback's `tcString` and `eventStatus`. It takes the string from a callback
reporting `tcloaded` or `useractioncomplete`, sends it to the cloud as
`tcstring`, and the cloud derives the usage from the purposes the string
grants.

Two consequences are worth stating plainly.

- **No string means no identifier.** Until your platform delivers one, the
  client script sends no answer, so no 51Did is created. A visitor who never
  answers your dialog produces no identifier at all, which is the intended
  outcome.
- **A string that grants too little produces no identifier either.** The
  cloud tries `personalized` first, then `standard`, and where neither set
  of purposes is fully granted it adds no usage and the 51Did properties
  come back with a reason rather than a value. The purpose sets are listed
  under 'Setting the usage policy' on @ref Identifiers_51Did.

The identifier created this way records that the usage was derived from a
consent string rather than stated directly, which is what the signal source
flag carries. See @ref Identifiers_51Did.

# Passing IsGdpr to Your Consent Management Platform

`IsGdpr` tells you whether the visit comes from a place where the General
Data Protection Regulation applies, worked out by the cloud from the
request's country. What it is and how to get it onto the page is on
@ref Identifiers_PMP_IsGdpr.

Read it from the client script's object with `onChange`, which is called
each time the cloud's answers change.

```{js}
fod.onChange(function (data) {
    var applies = data.derived && data.derived.isgdpr; // true, false or absent
});
```

The value is a boolean. The whole `derived` section is absent when your
resource key does not request `IsGdpr`, so test for it rather than assuming
it is there.

**Your consent management platform's own setting always wins.** Whether to
take `IsGdpr` or to use your platform's own way of deciding where the
Regulation applies is your decision, and the outcome is yours either way.
Where you choose your platform's own detection, `IsGdpr` is simply unused.
Passing it is a convenience, not a requirement, and 51Degrees does not
decide for you what your consent surface reports.

<!--
The worked example below is a placeholder. IsGdpr does not reach the cloud
until the change that carries it has been released, so the example cannot
be written against a running service and proved. It is held back
deliberately rather than written from the design, because a worked example
nobody has run is worse than none. Replace this section with the example
once the property is live.
-->

**The worked example is not written yet.** `IsGdpr` reaches the cloud in a
release that is still in progress, so an example showing the call into a
stubbed consent management platform would be untested, and an example nobody
has run is worse than none. The principle above is settled and will not
change. For the call itself, use your consent management platform's own
documentation, because the method for setting whether the Regulation applies
is theirs and differs between vendors.

# Find Out More

- What `IsGdpr` is and how to get it on the page:
  @ref Identifiers_PMP_IsGdpr
- The identifier, the usage values and how a consent string maps to one:
  @ref Identifiers_51Did
- The platform for a site that does not run a consent management platform:
  @ref Identifiers_PMP
- Header bidding with the identifier: @ref Integrations_Prebid
- How the client script gathers page values:
  @ref PipelineApi_Features_ClientSideEvidence
- The client script itself:
  <https://github.com/51Degrees/javascript-templates>
- The Model Terms for Marketing, version 2: <https://m4ow.uk/mtm/2.txt>

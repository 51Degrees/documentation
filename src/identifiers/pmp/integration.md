@page Identifiers_PMP_Integration Integration

Two script tags make a complete integration. One is the Preference
Management Platform, which asks the visitor the question. The other is the
51Degrees client script, which gathers the page's values and asks the cloud
for its answers, including the @ref Identifiers_51Did.

You write no code to join the two. The client script listens for the
platform's answer by itself, and the platform reads two values back from the
client script, being whether third party cookies work and whether the visit
is one where the General Data Protection Regulation applies.

# The Two Tags

```{html}
<!-- The Preference Management Platform. Every setting is an attribute. -->
<script src="https://cloud.51degrees.com/api/v4/pmp"
    data-resource-key="YOUR-RESOURCE-KEY"
    data-tcf-vendor="[YOUR TCF VENDOR STRING]"
    data-brand-name="Your Brand"
    data-brand-terms-url="https://yoursite.com/privacy"
    data-alt-name="Subscribe"
    data-alt-url="https://yoursite.com/subscribe"
    data-network-name="Your Group">
</script>

<!-- The 51Degrees client script. -->
<script async src="https://cloud.51degrees.com/api/v4/YOUR-RESOURCE-KEY.js">
</script>
```

The platform's own URL names the loader and carries nothing else. Every
setting, the resource key included, is a `data-` attribute on the tag, so
each setting is written once and read from one place. The full list is on
@ref Identifiers_PMP_Configuration.

Your resource key must be registered for the domain the page is served
from. The request for the platform's bundle is checked against the domains
the key names, the same as every other keyed endpoint, so a page on a domain
the key does not cover is refused and no dialog appears. A page that
suppresses the `Referer` header, with `<meta name="referrer"
content="no-referrer">` or an equivalent policy, is refused for the same
reason, because the check has nothing to compare.

# Load Order Does Not Matter

Put the two tags in whichever order suits your page. The platform's bundle
is loaded asynchronously, so it can finish before or after the client
script whatever the order of the tags, and both sides are built for that.

- The client script takes any answer that is already in force when it is
  built, and otherwise waits for the platform to announce one.
- The platform announces every answer on the window, whether it came from
  the visitor just now, from this site's storage, or from the answer shared
  across your group.

# When the Page Has No Client Script

The platform adds one. This is the normal, expected behaviour and it is a
convenience, so that a publisher who wants the dialog and nothing else still
gets a working integration.

The platform needs the client script for two things, being the third party
cookie result that decides whether the second card is worth offering, and
the `IsGdpr` value that sets what its own Transparency and Consent Framework
surface reports. Rather than keeping a second way of finding those out, it
uses the one the client script already has.

When it finds no client script object on the page, the platform builds the
script's URL from the cloud that served the platform and the resource key it
already holds, adds the tag, and writes a line in the browser console saying
the script was not present and that it is adding it, naming the object. The
message never prints your resource key or your licence key.

Two things follow from that.

- **Put the client script tag on the page yourself when you want control of
  its parameters.** The tag the platform adds carries the defaults. Your own
  tag can set the object name, turn cookies on with
  `fod-js-enable-cookies=true`, add a licence key, or sit wherever in the
  page you want it. The platform sees your object and adds nothing.
- **Load the client script once.** Loading it twice replaces the first
  instance and its state, and the script says so in the console. The
  platform adds a tag only where there is no object at all, so it never
  causes this.

  ```
  51Degrees: fod already exists on this page. Loading the script twice replaces it. Load it once and call fod.refresh() to update.
  ```

Where the platform can work out neither a cloud origin nor a resource key,
which happens when a build is opened from disk rather than served, it writes
a warning saying the third party cookie result and `IsGdpr` are unavailable
and carries on. The dialog still works and the visitor is still asked.

# The Object Name

The client script publishes everything it gets from the cloud on one page
object. That object is named `fod` unless you name it something else with
`fod-js-object-name` on the script's URL.

The platform has to know the name to find the object, so tell it with the
optional `data-object-name` attribute. Leave the attribute out and `fod` is
used, which is what almost every page wants.

```{html}
<script src="https://cloud.51degrees.com/api/v4/pmp"
    data-resource-key="YOUR-RESOURCE-KEY"
    data-object-name="fiftyone"
    ...>
</script>

<script async
  src="https://cloud.51degrees.com/api/v4/YOUR-RESOURCE-KEY.js?fod-js-object-name=fiftyone">
</script>
```

Every console message the platform writes names whichever object name is in
force, so a page using a different name reads messages about that name and
not about `fod`.

Two 51Degrees integrations on one site must use different object names, or
each will read the other's stored values.

# The Action URL Is an Optional Hook

`data-action-url` is fired every time the visitor answers, with
`{preference}` replaced by `standard`, `personalized` or `non-marketing`.
Use it for your own purposes, for example to tell your analytics that an
answer was given.

It is no longer how the client script is loaded. The client script hears the
answer through the platform's event and refreshes itself, so pointing the
action URL at the script's own URL would load a second copy of the script,
which replaces the first and warns in the console. Where the action URL
names the cloud script and the object already exists, the platform skips it
for that reason.

Leaving `data-action-url` out writes a warning to the console and changes
nothing else. The answer is still stored, still announced, and the dialog
still closes as it should.

# What You Get Back

The client script publishes the cloud's answers on the page object once it
has them. Read them from your own code with the `complete` callback.

```{js}
fod.complete(function (data) {
    // The identifier, once an answer has been given and every
    // other value has been resolved.
    console.log(data.fodid.idprobglobal);
});
```

The 51Did section is present only when your resource key includes the 51Did
properties. The part of the client script that gathers the visitor's answer
is included only for a key that carries them too, so a page whose key has no
51Did properties gets the same script it has always had.

# Find Out More

- What the three answers mean and how to read the one in force:
  @ref Identifiers_PMP_Preferences
- Every attribute the platform reads: @ref Identifiers_PMP_Configuration
- Sharing an answer across your sites: @ref Identifiers_PMP_Sharing
- The identifier the answer leads to: @ref Identifiers_51Did
- How the client script gathers page values: @ref PipelineApi_Features_ClientSideEvidence
- The client script itself:
  <https://github.com/51Degrees/javascript-templates>
- The cloud endpoints, including every parameter of the client script's URL:
  <https://cloud.51degrees.com/api-docs/index.html>
- Build or check a resource key: <https://configure.51degrees.com/>

@page Identifiers_PMP_Integration Integration

Two script tags make a complete integration. One is the Preference
Management Platform, which asks the visitor the question. The other is the
51Degrees client script, which gathers the page's values and asks the cloud
for its answers, including the @ref Identifiers_51Did.

You write no code to join the two. The client script listens for the
PMP's answer by itself, and the PMP reads two values back from the
client script, being whether third party cookies work and whether the visit
is one where the General Data Protection Regulation applies.

# The Two Tags

```{html}
<!-- The Preference Management Platform. The resource key is the file
     name and every other setting is an attribute. -->
<script src="https://cloud.51degrees.com/api/v4/pmp/YOUR-RESOURCE-KEY.js"
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

The resource key is the file name in the PMP's own URL, which is the shape
every other keyed request takes, and it is read from there and from nowhere
else. Every other setting is a `data-` attribute on the tag, so each setting
is written once and read from one place. The full list is on
@ref Identifiers_PMP_Configuration.

Up to 4.4.37 the key was the `data-resource-key` attribute and the URL was
`/api/v4/pmp` with nothing after it. Neither is served now. Two places to
write a key meant a page could carry one the cloud never saw, and the
refusal that followed was invisible to the page, so a tag in the old shape
is answered 404 on its first request instead.

Your resource key must be registered for the domain the page is served
from. The request for the PMP's bundle is checked against the domains
the key names, the same as every other keyed endpoint, so a page on a domain
the key does not cover is refused and no dialog appears. A page that
suppresses the `Referer` header, with `<meta name="referrer"
content="no-referrer">` or an equivalent policy, is refused for the same
reason, because the check has nothing to compare.

# Load Order Does Not Matter

Put the two tags in whichever order suits your page. The PMP's bundle
is loaded asynchronously, so it can finish before or after the client
script whatever the order of the tags, and both sides are built for that.

- The client script takes any answer that is already in force when it is
  built, and otherwise waits for the PMP to announce one.
- The PMP announces every answer on the window, whether it came from
  the visitor just now, from this site's storage, or from the answer shared
  across your group.

# When the Page Has No Client Script

The PMP adds one. This is the normal, expected behaviour and it is a
convenience, so that a publisher who wants the dialog and nothing else still
gets a working integration.

The PMP needs the client script for two things, being the third party
cookie result that decides whether the second card is worth offering, and
the `IsGdpr` value that sets what its own Transparency and Consent Framework
surface reports. Rather than keeping a second way of finding those out, it
uses the one the client script already has.

**The PMP looks for the client script's page object and for nothing else.**
The object is `fod`, or the name `data-object-name` gives. Where the script
came from decides nothing, so a client script served by another 51Degrees
cloud, by a proxy of your own or from a bundle of your own making all
count, because each of them leaves the object.

A client script tag is ordinarily asynchronous, as the tag above is
written, so it has usually not run when the PMP starts, and an object that
is not there yet is not an object that is not coming. The PMP waits for one
to appear, looking every 50 milliseconds, adds nothing while it waits, and
says so in the console.

```
Waiting for the 51Degrees client script to leave 'fod' on this page before adding one, because a tag the page carries is ordinarily asynchronous and may not have run yet. The wait ends when the page has loaded, and after 5000 milliseconds at the latest.
```

The wait ends at the page's load event, by which time every tag the page's
markup carries has run whatever address it names, and after five seconds
at the latest on a page whose load event is very late or never comes.
Where the page has already loaded when the PMP starts, nothing waits and
the script is added straight away.

Only when no object has appeared by then does the PMP build the script's
URL from the cloud that served the PMP and the resource key it already
holds, add the tag as an asynchronous script, and write a line in the
console saying that it did. That message never prints your resource key or
your licence key.

```
There is no client script object named 'fod' on this page, so the client script is being added from the cloud that served this one. Put the script tag on the page to decide for yourself where it sits and when it runs.
```

Where your content security policy names a nonce, the tag the PMP adds
carries the same nonce the PMP's own tag has, so the policy is
satisfied without being loosened.

Three things follow from that.

- **Put the client script tag on the page yourself when you want control of
  its parameters.** The tag the PMP adds carries the defaults. Your own
  tag can set the object name, turn cookies on with
  `fod-js-enable-cookies=true`, add a licence key, or sit wherever in the
  page you want it. The PMP finds its object and adds nothing, and the
  sooner the object is there the sooner the second card can be offered,
  which @ref Identifiers_PMP_Sharing explains.
- **Load the client script once.** Loading it twice replaces the first
  instance and its state, and the script says so in the console. The PMP
  never causes this on a page whose object is there by the time the page
  has loaded, because it adds a script only where none has appeared by
  then.

  ```
  51Degrees: fod already exists on this page. Loading the script twice replaces it. Load it once and call fod.refresh() to update.
  ```

- **Keep `data-object-name` and `fod-js-object-name` the same.** The PMP
  looks for the object under the name it was told, so where your own tag
  was built with another name it finds nothing, adds a client script under
  the name it was told once the page has loaded, and the page then runs
  two client scripts and creates two identifiers.

Where the PMP can work out neither a cloud origin nor a resource key,
which happens when a build is opened from disk rather than served, it writes
a warning saying the third party cookie result and `IsGdpr` are unavailable
and carries on. The dialog still works and the visitor is still asked,
although with nothing to confirm that third party cookies work there is no
second card.

# The Object Name

The client script publishes everything it gets from the cloud on one page
object. That object is named `fod` unless you name it something else with
`fod-js-object-name` on the script's URL.

The PMP has to know the name to find the object, so tell it with the
optional `data-object-name` attribute. Leave the attribute out and `fod` is
used, which is what almost every page wants.

```{html}
<script src="https://cloud.51degrees.com/api/v4/pmp/YOUR-RESOURCE-KEY.js"
    data-object-name="fiftyone"
    ...>
</script>

<script async
  src="https://cloud.51degrees.com/api/v4/YOUR-RESOURCE-KEY.js?fod-js-object-name=fiftyone">
</script>
```

Every console message the PMP writes names whichever object name is in
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
answer through the PMP's event and refreshes itself, so pointing the
action URL at the script's own URL would load a second copy of the script,
which replaces the first and warns in the console. Where the action URL
names the cloud script and the client script's object is on the page or on
its way, the PMP skips it and says so in the console.

Leaving `data-action-url` out means nothing is fired and nothing is written
to the console. The answer is still stored, still announced, and the dialog
still closes as it should.

# What You Get Back

The client script publishes the cloud's answers on the page object once it
has them. Read them from your own code with `onChange`, which is called
each time those answers change.

```{js}
fod.onChange(function (data) {
    // The identifier, once an answer has been given and every
    // other value has been resolved.
    if (data.fodid) {
        console.log(data.fodid.idprobglobal);
    }
});
```

Use `onChange` rather than `complete` for the identifier and for anything
that arrives with it, because the identifier is created in a later round,
on the request carrying the visitor's answer, and a `complete` callback
registered after the first round has ended is called once, straight away,
and never again.

The 51Did section is present only when your resource key includes the 51Did
properties. The part of the client script that gathers the visitor's answer
is included only for a key that carries them too, so a page whose key has no
51Did properties gets the same script it has always had.

# Find Out More

- What the three answers mean and how to read the one in force:
  @ref Identifiers_PMP_Preferences
- Every attribute the PMP reads: @ref Identifiers_PMP_Configuration
- Sharing an answer across your sites: @ref Identifiers_PMP_Sharing
- The identifier the answer leads to: @ref Identifiers_51Did
- How the client script gathers page values: @ref PipelineApi_Features_ClientSideEvidence
- The client script itself:
  <https://github.com/51Degrees/javascript-templates>
- The cloud endpoints, including every parameter of the client script's URL:
  <https://cloud.51degrees.com/api-docs/index.html>
- Build or check a resource key from the ready made list:
  <https://configure.51degrees.com/YldpCKbW>, and
  @ref Configurator_SharedList "what the Configurator adds when it opens"

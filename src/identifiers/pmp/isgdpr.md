@page Identifiers_PMP_IsGdpr IsGdpr

`IsGdpr` answers one question, being whether this visit comes from a place
where the General Data Protection Regulation applies. The Preference
Management Platform uses it to set what its Transparency and Consent
Framework surface reports to the advertising code on your page.

# Where the Value Comes From

It is a derived property, which means the cloud works it out from other
values rather than reading it from a data file. The input is the country the
request's IP address resolves to, and the answer is `true` for the European
Economic Area, the United Kingdom and the French outermost regions, and
`false` everywhere else, including an address that cannot be placed at all.

Two things have to be true for a page to have the value.

1. Your resource key requests `IsGdpr` by name. Add it to the key with the
   configurator like any other property.
2. The 51Degrees client script is on the page, because that is what brings
   the value into the browser.

Read it from the page object once the client script's first round has
finished.

```{js}
fod.complete(function (data) {
    console.log(data.derived.isgdpr); // true or false
});
```

`derived` is the section of the client script's response that holds
properties the cloud worked out rather than looked up. The value is a real
boolean, `true` or `false`, so a plain truth test on it is right. The whole
section is absent when the key does not request the property, so test that
it is there before reading it.

Do not carry that habit to the third party cookie result. The other value
the platform reads from the client script,
`device.thirdpartycookiesenabled`, is a **string** carrying `'True'` or
`'False'`, so a plain truth test on that one is wrong. See
@ref Identifiers_PMP_Sharing.

# What the Platform Does With It

At start up the platform reads `derived.isgdpr` from the client script's
object and sets `gdprApplies` on its own Framework surface from it. Where
your page carries no client script, the platform adds one, which is on
@ref Identifiers_PMP_Integration.

Where the value cannot be had, the platform writes a warning to the console
naming the reason, being either that `IsGdpr` is not in the response and
should be added to the resource key, or that there is no client script
object on the page, and leaves `gdprApplies` reporting `true`. Nothing else
changes.

# The Dialog Is Shown Either Way

**A `false` value does not stop the dialog and does not stop a 51Did being
created.** The question the platform asks is not a request for consent under
the General Data Protection Regulation. It is the Model Terms for Marketing
usage, which is a contractual question, and the answer is what a recipient
of a 51Did is allowed to act on wherever the visitor is. `gdprApplies` is
only what the Framework surface reports to the other code on your page.

# On a Site Running a Consent Management Platform

There the value is yours to use. You either pass `IsGdpr` into your consent
management platform or use that platform's own way of deciding, and the
outcome is yours. The Preference Management Platform is not on such a page
at all, so the two paths never meet. See @ref Identifiers_PMP_CmpWiring.

# Find Out More

- Wiring the value into a consent management platform:
  @ref Identifiers_PMP_CmpWiring
- Putting the two tags on the page: @ref Identifiers_PMP_Integration
- The Framework surface the value is reported on:
  @ref Identifiers_PMP_Preferences
- Look up any property, including this one:
  <https://51degrees.com/developers/property-dictionary>
- Build or check a resource key: <https://configure.51degrees.com/>
- The Model Terms for Marketing, version 2: <https://m4ow.uk/mtm/2.txt>

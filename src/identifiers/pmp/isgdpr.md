@page Identifiers_PMP_IsGdpr IsGdpr

`IsGdpr` answers one question, being whether this visit comes from a place
where the General Data Protection Regulation applies. The Preference
Management Platform uses it to set what its Transparency and Consent
Framework surface reports to the advertising code on your page.

# Where the Value Comes From

`IsGdpr` is a derived property, which means the cloud works it out from other
values rather than reading it from a data file. The input is the country the
request's IP address resolves to, and the answer is `true` for the European
Economic Area, the United Kingdom and the French outermost regions, and
`false` everywhere else, including an address that cannot be placed at all.

**The value is a default and not a determination.** The property's own published
description says it is "a default for a caller that knows nothing about its
own position, and not a determination, because the regulation also reaches
an organisation by where it is established". A publisher established in the
European Union is within scope while serving a visitor in the United States,
and `IsGdpr` answers `false` for that visit. Where you know your own
position, act on what you know.

Two things have to be true for a page to have the value.

1. Your resource key requests the property. Add `IsGdpr` to the key with the
   configurator like any other property. Where you list properties yourself
   with `values` instead, give the qualified name, `derived.IsGdpr`, because
   a derived property asked for by its bare name is dropped and answered
   with a warning that reads like an entitlement problem and is not one. See
   @ref Services_Cloud_Overview.
2. The 51Degrees client script is on the page, because that is what brings
   the value into the browser.

Read it from the page object with `onChange`, which is called each time the
cloud's answers change, so a value that arrives in a later round reaches you
as well.

```{js}
fod.onChange(function (data) {
    if (data.derived) {
        console.log(data.derived.isgdpr); // true or false
    }
});
```

`derived` is the section of the client script's response that holds
properties the cloud worked out rather than looked up. The value is a real
boolean, `true` or `false`, so a plain truth test on it is right. The whole
section is absent when the key does not request the property, so test that
it is there before reading it.

Do not carry that habit to the third party cookie result. The other value
the PMP reads from the client script,
`device.thirdpartycookiesenabled`, is a **string** carrying `'True'` or
`'False'`, so a plain truth test on that one is wrong. See
@ref Identifiers_PMP_Sharing.

# What the PMP Does With It

At start up the PMP reads `derived.isgdpr` from the client script's
object and sets `gdprApplies` on its own Framework surface from it. Where
no client script object appears on your page by the time it has loaded,
the PMP adds a client script, and where one appears it reads that one,
which is on @ref Identifiers_PMP_Integration.

Where the value cannot be had, the PMP writes a warning to the console
naming the reason, and leaves `gdprApplies` reporting `true`. Nothing else
changes. The reason is one of three.

- `IsGdpr` is not in the response, so add it to the resource key.
- `IsGdpr` is in the response with no value for this visitor, and the
  cloud's reason is in `fod.derived.isgdprnullreason` on the page.
- There is no client script object on the page.

# The Dialog Is Shown Either Way

**A `false` value does not stop the dialog and does not stop a 51Did being
created.** The question the PMP asks is not a request for consent under
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
- Build or check a resource key from the ready made list:
  <https://configure.51degrees.com/YldpCKbW>, and
  @ref Configurator_SharedList "what the Configurator adds when it opens"
- The Model Terms for Marketing, version 2: <https://m4ow.uk/mtm/2.txt>

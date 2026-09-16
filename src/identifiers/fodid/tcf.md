@page Identifiers_51Did_Tcf Transparency and Consent Framework Strings

This page is for a site whose consent management platform produces a TC
string, which is how the IAB Europe Transparency and Consent Framework
records what a visitor consented to. The cloud reads that string, works out
the usage of the @ref Identifiers_51Did from the purposes the string grants,
and records inside the identifier that the usage came that way.

Putting a consent management platform and the 51Degrees client script on
a page is @ref Identifiers_PMP_CmpWiring. This page is what the cloud does
with the string once it arrives.

# Sending the String

Send it as `tcstring`, either as a query parameter or as a field of the same
name in a form post. Both reach the service as the same evidence, so either
transport does the job. There is no header form, so a request header named
`tcstring` is not read.

```
GET /api/v4/json?resource=<RESOURCE_KEY>
    &user-agent=iPhone
    &client-ip=203.0.113.42
    &tcstring=<TC_STRING>
```

On a browser page you send nothing yourself. The 51Degrees client script
asks your consent management platform through `window.__tcfapi`, takes the
string from a callback reporting `tcloaded` or `useractioncomplete`, and
sends it as `tcstring` on its next request.

# The Purposes Each Usage Needs

The cloud decodes the string and compares the purposes it grants with the
two sets below. `personalized` is tried first and `standard` second, so a
string that satisfies both produces `personalized`.

| `id.usage`     | IAB TCF v2 purposes the string must grant |
|----------------|-------------------------------------------|
| `personalized` | 1, 2, 3, 4, 5, 6, 7, 8, 11                |
| `standard`     | 1, 2, 7, 8, 11                            |

Those two sets are Appendix 1 of the Model Terms for Marketing, the contract
every party sending or receiving a 51Did is bound by. The text in force is
version 2, at <https://m4ow.uk/mtm/2.txt>, and the scheme behind it is
explained at <https://m4ow.uk/mtm>. The sets say what the appendix says
rather than what 51Degrees chose, so they change when the appendix changes
and not before.

Purposes 2, 7, 8, 9, 10 and 11 may be satisfied by a legitimate interest bit
as well as by a consent bit. Within the two sets above that leaves 1, 3, 4,
5 and 6 needing an explicit consent bit, because IAB Policy forbids claiming
those under legitimate interest.

Special Purpose 2, which the appendix lists beside both sets, is not
checked. A special purpose carries no consent or objection bit in a TC
string, so a check on it could never fail.

`non-marketing` is never derived from a string. The appendix maps the
framework's purposes onto the two marketing usages and onto nothing else, so
the third usage only ever arrives stated, which is how the Preference
Management Platform sends every answer it holds. See
@ref Identifiers_51Did_Pmp.

# A String That Grants Too Little

Where the purposes satisfy neither set, the cloud adds no usage. Nothing
then asks for a 51Did, so the response carries no `fodid` section at all, no
property, no reason and no warning. A string the service cannot decode is
ignored in the same way, and so is a request carrying no string.

The response is therefore the same whether the visitor granted too little,
answered nothing or was never asked. On a browser page that shows as
`fod.fodid` being absent, so test for it before reading an identifier out of
it.

# A Stated Usage Wins

Where the request states `id.usage`, as a query parameter, a form field or a
header, the cloud acts on that value and never examines a consent string
sent beside it. Working the usage out from a string happens only where no
usage was stated. The client script applies the same order on the page,
asking the Preference Management Platform first and a consent management
platform second.

# What the Identifier Records

A 51Did made from a string has bit 3 of its flags byte set, which is the
signal source bit described under *Payload layout* on
@ref Identifiers_51Did. Clear means the caller stated the usage and set
means 51Degrees worked it out from a consent string. A recipient cannot tell
those two apart from the usage itself, because the same usage is reachable
either way, and the bit sits inside the signed payload so nobody can change
it afterwards.

The identifier carries neither the string nor the purposes. It carries the
usage and the bit that says where the usage came from.

# The Licence Key the Marketing Usages Need

A usage worked out from a string is licensed exactly as one you state.
`standard` and `personalized` need the Special license key on the resource
key, and without it the `fodid.*` properties come back with a reason naming
the missing product rather than with an identifier. `non-marketing` needs
only the `fodid.*` properties on the key, and no consent string produces it.
See *Usage policies and licensing* on @ref Identifiers_51Did.

# Find Out More

- Wiring a consent management platform to the client script:
  @ref Identifiers_PMP_CmpWiring
- The identifier, its inputs and its payload: @ref Identifiers_51Did
- The answer sent as a stated usage instead: @ref Identifiers_51Did_Pmp
- Why a Global Privacy Platform string is not read:
  @ref Identifiers_51Did_Gpp
- The Model Terms for Marketing, version 2: <https://m4ow.uk/mtm/2.txt>
- The Model Terms for Marketing explainer: <https://m4ow.uk/mtm>
- IAB Europe, the Transparency and Consent Framework:
  <https://iabeurope.eu/transparency-consent-framework/>
- IAB Europe, the Framework Policies, which say which purposes may be
  claimed under legitimate interest:
  <https://iabeurope.eu/iab-europe-transparency-consent-framework-policies/>
- IAB Tech Lab, the TC string format and the consent management platform
  API:
  <https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework>
- The client script that gathers the string:
  <https://github.com/51Degrees/javascript-templates>

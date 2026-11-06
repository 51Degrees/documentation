@page Identifiers_PMP_IsGdpr Does GDPR apply

The consent surface reports `gdprApplies`, which says whether the General Data Protection Regulation (GDPR) applies to the visit, and PMP takes the answer from `IsGdpr` on the client script's object. That property is worked out from the visitor's country, true for the European Economic Area, the United Kingdom and the French outermost regions and false everywhere else, an address that cannot be placed included. It is a good default and not a determination, because GDPR also reaches a publisher by where the publisher is established, so a publisher established in the European Union is within scope while serving a visitor in the United States and this answers false for that request. A publisher who knows their own position should say so rather than take this.

PMP depends on three properties from the client script, so ask for all three when you create the Resource Key. Where the key does not carry one of them PMP says so in the console once per page view, and everything else carries on working, so the console is the only place the gap shows.

| Property | What is lost without it |
|---|---|
| `IsGdpr` | The consent surface reports that GDPR applies, for every visitor everywhere. |
| `ThirdPartyCookiesEnabled` | Nothing can ever confirm that third party cookies work, so the second card is never offered. |
| `ThirdPartyCookiesEnabledJavaScript` | Third party cookies are never measured, only guessed from the browser's name, and a guess confirms nothing, so the second card is never offered. |

The dialog is shown either way. The question PMP asks is the Model Terms usage, which is a contract and not a consent under GDPR, so a false answer changes what the consent surface reports and changes nothing about what the visitor is asked.

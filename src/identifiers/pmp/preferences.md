@page Identifiers_PMP_Preferences Preferences

The Preference Management Platform holds one answer per visitor. This page
covers what the three answers mean, where the answer is kept, and the three
ways your page can read it.

# The Three Answers

| Answer | Value | What it allows |
|---|---|---|
| Personalized | `personalized` | Everything Standard allows, and personalized advertising and content on top of it. |
| Standard | `standard` | Frequency capping and measurement. No personalization. |
| The alternative button | `non-marketing` | No marketing. The visitor takes whatever you offer instead, for example a subscription. |

The three names are the cloud's own `id.usage` values, so the answer needs
no translation on its way to the service. What each one permits, and what a
recipient of a 51Did may do with it, is set out in the Model Terms for
Marketing, version 2, at <https://m4ow.uk/mtm/2.txt>. That address names
version 2 on purpose. A link to a document that can be edited afterwards
could never prove what a visitor's answer meant at the time it was given.

**The alternative answer is an answer, not a refusal.** The visitor has
decided, and `non-marketing` records the decision. It creates a 51Did in the
same way the other two do, carrying the `non-marketing` usage, and it fires
the action you configured for the alternative button. Recording it is what
lets another site in your group offer its own alternative rather than asking
a question the visitor has already answered.

There is no fourth answer. The dialog has no close cross, so a visitor
cannot leave the first card unanswered, and the platform never invents an
answer on a visitor's behalf.

# Where the Answer Is Kept

The answer lives in exactly one place, so there is nothing to keep in step
and no stale copy to go wrong.

| Third party cookies | The visitor's answer to the second card | Where the answer lives |
|---|---|---|
| Confirmed to work | Use it across the group | The cloud's cookie only |
| Confirmed to work | Only this site | This site's `localStorage` only |
| Not confirmed | Never asked | This site's `localStorage` only |

Not confirmed covers a browser that blocks third party cookies, a result that
is not known, and a confirmation that did not arrive within the three seconds
the platform waits, all set out on @ref Identifiers_PMP_Sharing. A write to the cloud that
is refused, or not confirmed within 1500 milliseconds, also leaves the answer
in this site's `localStorage`.

An answer that has moved to the cloud's cookie stays there, because the second
card is offered only to a visitor who has not already shared. Clearing that
cookie is what lets the visitor be asked again, which
@ref Identifiers_PMP_Sharing sets out.

The local key is `__51d_pmp_pref` and it holds a small JSON object, being
the schema version, the answer and the time it was given in milliseconds.

```{json}
{ "v": 1, "p": "personalized", "t": 1715980800000 }
```

A visitor who was offered the second card and chose to keep the answer to
this site is recorded under a second key, `__51d_pmp_share_declined`, so
that the shared answer is not read for them on this site again. The two keys
are kept apart because the answer itself is removed once it moves to the
shared store.

To ask the visitor again, for example from a 'Change preferences' link,
remove the keys and reload.

```{js}
localStorage.removeItem('__51d_pmp_pref');
localStorage.removeItem('__51d_pmp_share_declined');
location.reload();
```

Both keys belong to this site, so removing them asks again only where the
answer lives here, and where the answer moved to the group's shared store
the cloud's cookie has to go as well, which @ref Identifiers_PMP_Sharing
describes.

Reopening the dialog does not need a reload. Call the platform's own method
and the visitor gets the dialog back with their current answer shown.

```{js}
window.__51d_pmp.open();
```

# Reading the Answer From Your Page

There are three ways in, and they exist because a page cannot know whether
the platform's bundle has loaded yet.

## The Window Event

Every answer is announced on the window as a `CustomEvent` named
`51d-pmp-preference`, with the value in `detail.preference`. It fires on a
fresh answer from the dialog, on the answer found in this site's storage
when the page loads, and on an answer that comes back from the group's
shared store.

```{js}
window.addEventListener('51d-pmp-preference', function (e) {
    console.log(e.detail.preference); // standard, personalized or non-marketing
});
```

Register the listener before the platform's tag if you can. The event fires
once per answer coming into force, so a listener registered afterwards can
miss the announcement and should read the getter as well.

## The Getter

```{js}
var answer = window.__51d_pmp && window.__51d_pmp.preference();
// 'standard', 'personalized', 'non-marketing', or null when nobody has answered
```

The getter answers from memory, straight away, with whatever the platform
found when it started, this site's storage and the group's shared answer
included. The object exists only once the bundle has loaded, so test for it.

## The Transparency and Consent Framework Surface

The platform exposes a `window.__tcfapi` function, which is how advertising
code on the page normally asks about consent, and it answers the standard
`ping`, `getTCData`, `addEventListener` and `removeEventListener` commands.

```{js}
__tcfapi('addEventListener', 2, function (tcData, success) {
    if (success) {
        console.log(tcData.eventStatus, tcData.tcString);
    }
});
```

The string it hands out is built from the vendor string you supply in
`data-tcf-vendor`. The platform sets the purpose bits from the visitor's
answer and the time fields, and copies everything else through unchanged,
so a validator sees your own vendor set exactly as you encoded it.

| The visitor's answer | Purpose consents set |
|---|---|
| Personalized | 1, 2, 3, 4, 5, 6, 7, 8, 11 |
| Standard | 1, 2, 7, 8, 11 |

After the alternative answer the surface answers `addEventListener` and
`getTCData` with `success` false, and `ping` reports that no string is
loaded. That is only the framework's way of describing an answer that grants
no purposes, and it is not the platform failing and not the visitor
declining to answer. The 51Degrees client script never reads that as the
answer, because it takes the answer from the platform itself, where
`non-marketing` is a value like any other. Choosing Standard or Personalized
afterwards restores the full surface.

# The Platform Is Not a Consent Management Platform

The Preference Management Platform is a technically complete implementation
of the Transparency and Consent Framework, and it deliberately does not
follow the Framework's Policies. It asks its own question, in its own words,
about the Model Terms usages.

So a site that runs a consent management platform does not add this one.
The two never share a page, they would fight over `window.__tcfapi`, and
the platform stops with a console warning when it finds a foreign
`__tcfapi` already installed rather than replacing it. Where the Framework's
Policies are what you need, run a consent management platform and wire the
51Degrees client script to it instead, which is
@ref Identifiers_PMP_CmpWiring.

# Changing an Answer

A visitor can reopen the dialog from the bubble at any time and answer
differently. When they do, the platform announces the new answer, the
51Degrees client script asks the cloud again, and a fresh 51Did is created
carrying the new usage. Page code registered through the client script's
`onChange` callback is called with the new data. The identifier issued
before the change is not withdrawn, and what a recipient may do with either
of them is what the Model Terms say.

# Find Out More

- The identifier each answer leads to: @ref Identifiers_51Did
- Putting the two tags on the page: @ref Identifiers_PMP_Integration
- Carrying one answer across your sites: @ref Identifiers_PMP_Sharing
- Running a consent management platform instead:
  @ref Identifiers_PMP_CmpWiring
- How the platform compares with a consent management platform, feature by
  feature: @ref Identifiers_PMP_CmpComparison
- What to tell your visitors in your privacy notice:
  @ref Identifiers_PMP_Privacy
- The Model Terms for Marketing, version 2: <https://m4ow.uk/mtm/2.txt>
- The client script that listens for the answer:
  <https://github.com/51Degrees/javascript-templates>

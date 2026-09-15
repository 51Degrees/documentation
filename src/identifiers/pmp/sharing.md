@page Identifiers_PMP_Sharing Sharing an Answer Across Your Sites

A visitor who has answered on one of your websites should not have to answer
again on the next one. The Preference Management Platform can offer to carry
one answer across a group of sites you name, so the question is asked once.

This is a feature of this platform. A site running a third party consent
management platform neither reads nor writes the shared answer and never
sees the second card. Nothing stops another vendor implementing the same
exchange, because the endpoint and the rules are described here.

# Naming the Group

`data-network-name` is the name of the group your sites belong to, for
example `Axel Springer` for Politico and Business Insider. It does two jobs.

- **It is what the visitor is told.** The second card names the group, so a
  visitor is asked about a name they recognise from the sites themselves
  rather than about 'other websites'.
- **It decides which sites share an answer.** Together with the licence key
  behind your resource key, which the cloud resolves on its own side and
  which never reaches the browser, it names the cookie the answer is held
  in.

The name is trimmed, its inner runs of whitespace are collapsed to one
space, and it is put into a standard Unicode form, so two of your sites
writing the same name reach the same answer. Leave the attribute out and
sharing is turned off, with a warning in the console, because a visitor
cannot be asked to apply an answer across a group without being told which
group.

# The Second Card

The second card is offered when all three of these hold.

1. You left `data-use-third-party-cookies` on, which is its default, and you
   named the group. Only the exact string `false` turns sharing off, so a
   typo leaves it on rather than quietly removing it.
2. The visitor answered Standard or Personalized on the first card. The
   alternative answer never leads to the second card.
3. Third party cookies are confirmed to work in the visitor's browser. The
   51Degrees client script confirms them by testing the cookie, and only a
   tested `'True'` counts. A `'False'`, a result that is not known, the
   likely status the script starts with and no result at all each mean no
   second card. For the platform to have a tested result, your resource key
   has to carry `ThirdPartyCookiesEnabled` and
   `ThirdPartyCookiesEnabledJavaScript` beside it, so a key missing either
   one never shows the second card, and the console names the missing
   property.

The cards stack rather than replacing each other, so the answered first card
collapses to its question and answer and stays on screen above the card
being answered, and clicking it goes back.

## When the Second Card Waits

**When your configuration allows third party cookies and the browser may
support them, the platform waits up to three seconds (3000 milliseconds)
for the 51Degrees client script to confirm that third party cookies work.
If they are not confirmed in that time, the second card is not shown and
the answer stays with this site.**

The three seconds start when the visitor answers the first card. The waiting
ring covers the cards for as long as the wait lasts, and while it does the
cards are darkened and nothing on them can be pressed. The time is set once
when the platform is built, it is the same on every page, and no attribute
changes it.

<!--
For maintainers. The three seconds are a build constant of the platform,
compiled into every bundle as __ThirdPartyCookieWaitMs__, with the reason for
the value written beside it in the platform source. It is not configurable,
on James Rosewell's decisions of 15 September 2026. Change this page, the
configuration page and the load process diagram whenever that value
changes.
-->

The wait is for that confirmation and nothing else. The second card never
waits for the 51Did, for the client script's refresh or for `IsGdpr`, which
all carry on beside it.

**It can only happen where your configuration uses third party cookies**,
being `data-use-third-party-cookies` not set to `false` and
`data-network-name` present. Where sharing is not configured there is no
second card, so there is nothing to confirm, no ring and no wait.

Only a tested result confirms anything. The client script's first response
can carry only the likely status for the browser, beside the snippet that
tests the cookie, and the tested result follows once that snippet has run,
so a likely `'True'` is not a confirmation. The tested result arrives with
the first response that carries it, even one in the middle of a round, so a
round that is still going on to create the 51Did never holds the second card
back.

In practice the wait nearly always means the platform added the client
script itself, because the page carries no client script tag, and the
script has not tested the cookie by the time the visitor clicks. A page's
own client script tag that has not tested it yet is waited for in the same
way, because what the platform waits on is the missing result and not who
added the script. Putting the tag on the page yourself lets it start sooner,
which makes the wait less likely.

Nothing waits where the question is already settled when the visitor answers
the first card, and the platform decides at once.

- **The client script has already tested the cookie**, which is the ordinary
  case. A tested `'True'` shows the second card straight away, and a tested
  `'False'` means no second card.
- **The device data says the browser cannot support third party cookies.**
  There is no second card.
- **Your resource key does not carry `ThirdPartyCookiesEnabled` or
  `ThirdPartyCookiesEnabledJavaScript`**, so the cookie is never tested.
  There is no second card, and the console names the missing property.
- **The snippet that tests the cookie is held back until something asks for
  it, or the client script's round ended without running it**, so no tested
  result is coming. There is no second card.
- **The client script can never answer**, because it failed to load, ran and
  left no object behind, or the object name belongs to something else on the
  page. There is no second card.

When third party cookies are confirmed during the wait, the ring goes and the
second card follows. When anything else settles the question during the
wait, or the three seconds pass first, the ring goes, the dialog closes to
the bubble and the answer stays with this site. Reopening the dialog during
the wait abandons it.

# How the Third Party Cookie Result Is Known

The 51Degrees client script already measures it and publishes it as
`device.thirdpartycookiesenabled` on the page object, so the platform reads
it from there rather than probing on its own account.

```{js}
fod.onChange(function (data) {
    if (data.device) {
        console.log(data.device.thirdpartycookiesenabled);
    }
});
```

`onChange` is called each time the cloud's answers change, so the tested
result reaches you in whichever response carries it. A `complete` callback
registered after the first round has ended is called once, straight away,
and never again, so it can miss that result.

The value is measured once the client script has run the snippet that tests
it, and before that it reports the likely answer for the browser. Where your
page carries no client script tag the platform adds one so that it has this
answer, and where a tag is there it waits for that tag to run rather than
adding a second copy, which is described on
@ref Identifiers_PMP_Integration.

Browsers that block third party cookies, which includes Safari and Firefox
with their default settings, never show the second card, because the test
never confirms that third party cookies work there.

## It Is a String, So Do Not Test It for Truth

`device.thirdpartycookiesenabled` is a **string**, not a boolean. It carries
`'True'` or `'False'`, and it can also carry `'Unknown'` or
`'NotSupported'`, while the whole `device` section is absent when your
resource key does not ask for the property. The property is declared a
string in the device detection data, and the cloud lower cases the names of
things in its JSON and never their values, so the capital letter is real.

Every non-empty string is truthy in JavaScript, so this reads the wrong way
round for a visitor whose browser blocks third party cookies.

```{js}
// Wrong. 'False' is a non-empty string, so this branch is taken.
if (data.device.thirdpartycookiesenabled) { ... }
```

Compare the text instead, and treat anything that is neither `'True'` nor
`'False'` as not knowing rather than as a no.

```{js}
fod.onChange(function (data) {
    var said = data.device && data.device.thirdpartycookiesenabled;
    said = typeof said === 'string' ? said.trim().toLowerCase() : said;
    if (said === 'true') {
        // Third party cookies work.
    } else if (said === 'false') {
        // They do not.
    } else {
        // 'Unknown', 'NotSupported', or the property is not on the key.
    }
});
```

`derived.isgdpr` is the other way about. It is a real boolean, because the
cloud works it out rather than reading it from the data file, so a plain
truth test on that one is right. The two properties differ and it is worth
checking which you are reading. See @ref Identifiers_PMP_IsGdpr.

# Where the Answer Is Held

The platform reads this site's own storage first and asks the cloud only
where this site holds nothing, so a visitor who kept their answer to this
site is never read from the group's store. When the visitor says the answer
should apply across the group, the platform asks the cloud to hold it and,
once the cloud confirms, removes the copy on this site, so from then on the
shared value is the one that answers on every site in the group. A later
change of answer goes to the shared store while sharing is on, and is kept
in this site's storage instead only where the cloud refuses the write, which
leaves the newer answer with this site rather than losing it. The table of
where an answer lives is on @ref Identifiers_PMP_Preferences.

**There is no way back through the dialog.** The second card is offered only
to a visitor who has not already shared, so once a visitor has agreed to
carry their answer across the group the card never comes back to ask again,
and nothing else in the dialog turns sharing off. A visitor who wants their
answer to stop being shared needs two things to happen.

1. The third party cookie the group's store uses has to be cleared, which is
   the `51D_PmpPreference_<code>` cookie described below. A visitor can clear
   it in their browser, and your page can ask the cloud to remove it with the
   `DELETE` call under *Letting a Visitor Start Again*.
2. The question is then asked again on the next visit, the second card is
   offered again, and answering **Only this site** keeps the answer to this
   site alone.

The cloud sets a cookie named `51D_PmpPreference_<code>` on its own domain.
It carries one of the three values and nothing else, with no timestamp and
nothing that varies from one visitor to another.

The `<code>` is twenty two characters derived from the group's name and your
licence key, so your visitors' answers are yours. Two points follow.

- The licence key never reaches the browser. The cloud works the name out
  from the entitlement behind your resource key on its own side.
- The name being hard to guess is not what keeps one customer out of
  another's answers. The check of the page's origin against the domains
  registered on the key is what does that, and it is applied to reads as
  well as writes. **A key that registers no domains is accepted from any
  page.** Register your domains on the key if you care, and you should.

A page on your domain cannot read or write a cookie on the cloud's domain,
so the platform goes through the cloud instead.

# The Shared Store Endpoint

```
GET    /api/v4/pmp/pref?resource=<key>&network=<group>
POST   /api/v4/pmp/pref        form fields: preference, resource, network
DELETE /api/v4/pmp/pref?resource=<key>&network=<group>
```

Every call is a cross origin request made with credentials, so the browser
sends the cloud's own cookie. `GET` answers
`{ "preference": <value or null> }`. `POST` stores one of the three values
and answers the same shape so the caller can confirm it. `DELETE` removes
it. Anything but the three values is refused and nothing is written.

Both the resource key and the group's name are required on the read as well
as the write. The write needs the key because a form post is sent by the
browser whether or not the sender may read a word of the reply, so without
it any page on the web could set a visitor's answer for every publisher at
once. The read needs it because the answer is held per publisher, and a
resource key sits in the markup of every page that uses it, so an unchecked
read would tell any page whether this visitor had answered for a named
competitor.

A write or a delete that is refused answers 401 and says why. A read that is
refused answers 200 with `{ "preference": null }`, so a caller who may not
ask does not learn that there is something to ask for.

The platform waits up to 1500 milliseconds for the cloud on each read and
each write, and that time covers reading the reply as well as receiving it.
A read with no reply by then is given up and counts as no shared answer, so
the dialog is shown. A write with no confirmation by then counts as refused,
and the answer is kept with this site instead. The time is set once when the
platform is built and no attribute changes it.

The endpoint is not metered. The key says who is asking rather than being
billed for.

## Letting a Visitor Start Again

The platform does not call `DELETE` and shows no button for it. Whether to
offer one, and what it looks like, is yours to decide.

```{js}
await fetch(
  'https://cloud.51degrees.com/api/v4/pmp/pref'
    + '?network=' + encodeURIComponent(networkName)
    + '&resource=' + encodeURIComponent(resourceKey),
  { method: 'DELETE', credentials: 'include', mode: 'cors' });
```

`credentials: 'include'` is not optional. Without it the browser sends no
cookie, so the cloud is asked to remove a cookie it cannot see and the call
does nothing while looking as though it worked. The answer is 200 with
`{ "preference": null }`, which is also what a call finds where nothing was
held, so calling it twice is not an error.

# Find Out More

- What to tell your visitors about the shared answer:
  @ref Identifiers_PMP_Privacy
- The three answers and where each is kept:
  @ref Identifiers_PMP_Preferences
- Putting the two tags on the page: @ref Identifiers_PMP_Integration
- Every attribute the platform reads: @ref Identifiers_PMP_Configuration
- The identifier the answer leads to: @ref Identifiers_51Did
- The Model Terms for Marketing, version 2: <https://m4ow.uk/mtm/2.txt>
- The cloud endpoints: <https://cloud.51degrees.com/api-docs/index.html>

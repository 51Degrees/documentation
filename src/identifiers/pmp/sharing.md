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
3. The 51Degrees client script has not said that third party cookies are
   blocked. A `'False'` withholds the card, and a `'True'` or a result that
   is not known offers it. For the platform to have the result at all, your
   resource key has to carry `ThirdPartyCookiesEnabled` and
   `ThirdPartyCookiesEnabledJavaScript` beside it.

The cards stack rather than replacing each other, so the answered first card
collapses to its question and answer and stays on screen above the card
being answered, and clicking it goes back.

## When the Second Card Waits

The second card follows the first at once, except in one case, and the
reason is that the platform needs the third party cookie result at the
moment the visitor answers the first card. That result arrives through the
client script's `complete` callback. **Where the client script has not
called `complete` yet when the visitor answers, the platform shows its
waiting ring over the cards and waits for it**, for no longer than
`data-timeout` milliseconds, and then decides.

That case nearly always means the platform added the client script itself,
because the page carries no client script tag, and the script has not
finished its first round by the time the visitor clicks. A page's own client
script tag that is still finishing its first round at the click is waited
for in the same way, because what the platform waits on is the missing
answer and not who added the script. Putting the tag on the page yourself
lets it start sooner, which makes the wait less likely.

There is no wait wherever there is nothing to wait for.

- The result is already known when the visitor answers.
- The client script finished its round without the property, which is what
  happens when your resource key does not carry `ThirdPartyCookiesEnabled`.
  The result is then not known and never will be, so the card is offered at
  once.
- The client script can never answer, because it failed to load, ran and
  left no object behind, or the object name belongs to something else on
  the page. The card is offered at once.

When the answer arrives during the wait the ring goes and the platform
decides on it. When `data-timeout` passes first, the ring goes and the card
is offered, as it is for any result that is not known. Reopening the dialog
during the wait abandons it.

A write that the cloud refuses keeps the answer with this site, so the most
an unknown result can cost a visitor is a question whose answer is then kept
in the other place.

# How the Third Party Cookie Result Is Known

The 51Degrees client script already measures it and publishes it as
`device.thirdpartycookiesenabled` on the page object, so the platform reads
it from there rather than probing on its own account.

```{js}
fod.complete(function (data) {
    console.log(data.device.thirdpartycookiesenabled);
});
```

The value is measured once the client script has run the snippet that tests
it, and before that it reports the likely answer for the browser. Where your
page carries no client script tag the platform adds one so that it has this
answer, and where a tag is there it waits for that tag to run rather than
adding a second copy, which is described on
@ref Identifiers_PMP_Integration.

Browsers that block third party cookies, which includes Safari and Firefox
with their default settings, answer `'False'` and never show the second
card, provided your resource key carries the property.

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
fod.complete(function (data) {
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

When the visitor says the answer should apply across the group, the platform
asks the cloud to hold it and, once the cloud confirms, removes the copy on
this site. From then on every change the visitor makes, on this site or any
other in the group, goes to the cloud. The table of where an answer lives is
on @ref Identifiers_PMP_Preferences.

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

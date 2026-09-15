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
3. Third party cookies are known to work between the page and the cloud.

**Nothing waits between the two cards.** The second card follows the first
at once. The cards stack rather than replacing each other, so the answered
first card collapses to its question and answer and stays on screen above
the card being answered, and clicking it goes back.

Where the third party cookie result is not yet known when the visitor
answers the first card, the second card is still offered. If the write then
turns out to be impossible, the answer stays with this site, which is the
same outcome as a refused write.

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
page carries no client script the platform adds one so that it has this
answer, which is described on @ref Identifiers_PMP_Integration.

Browsers that block third party cookies, which includes Safari and Firefox
with their default settings, simply never show the second card.

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

@page Identifiers_PMP_Sharing Sharing an answer across your sites

A visitor who has answered on one website should not have to answer again on every other website in the same group. A second card asks whether the answer should be used elsewhere, and it is offered only where all three of these hold.

1. `data-use-third-party-cookies` is left on, which is the default, and `data-network-name` names the group. Leaving the group unnamed turns sharing off, because a visitor cannot be asked to apply an answer across a group of sites without being told which group. Nothing is logged and nothing else changes, the tag loads, the dialog draws, the cookie is written and the event fires, so the only sign is that the second card never appears, which a publisher who has never seen the second card cannot notice. Check the attribute name before anything else.
2. The visitor chose Standard or Personalized. The alternative, being the visitor declining marketing, never leads to the second card.
3. The 51Degrees client script has confirmed that third party cookies work in this browser. The confirmation is `ThirdPartyCookiesEnabled` on the client script's object, so your resource key has to carry both properties described under @ref DeviceDetection_Features_ThirdPartyCookies. Once the first card is answered PMP allows 3000 milliseconds for that confirmation to arrive, and without it the second card is skipped and the answer stays with this site alone. A browser that blocks third party cookies, Safari among them, therefore never reaches the second card.

## Nobody can join your group by naming it

The name you give in `data-network-name` is public. It is in the markup of every site that uses it and the visitor is shown it on the second card, because they are being asked whether to share their answer with a group they recognize. What stops somebody else putting your group's name on their own site and reading your visitors' answers is the license key behind your resource key.

The shared answer is held in a cookie on the 51Degrees domain, and its name is worked out from two things, being your group's name and the license key behind the resource key the request came with. The license key is looked up by the service on its own side and never reaches the browser, so the name cannot be worked out by anybody who does not hold your license. Somebody using your group's name with their own resource key reaches a cookie of their own, and never yours. Nothing of theirs arrives in yours either.

Your resource key is in the markup too. What stops that key being used from another site is the domain check described under *Endpoints* in @ref Identifiers_PMP, which applies to reading and writing the shared answer as well as to fetching the bundle, so register your domains on the key. A key that names no domains is accepted from any page.

Within your own account the group name is what separates one audience from another, so use different names where two sets of sites should not share an answer, and the same name everywhere the answer should travel.

## The shared store

The bundle reads and writes the shared answer through `https://cloud.51degrees.com/api/v4/pmp/pref`, a credentialed cross-origin request that the cloud answers with the page's origin echoed back. `GET` answers `{ "preference": <state or null> }`, `POST` with a form field `preference` stores one of `non-marketing`, `standard` or `personalized` and answers the same shape so PMP can confirm it, and `DELETE` removes it. Anything but those three values is refused with `400` and nothing is written.

Every call names your resource key, as a `resource` query parameter on the read and a `resource` form field on the write, and your group, as `network`, which PMP takes from `data-network-name`. A call that names no group is refused with `400`. A refused write or delete answers `401` and says why, whilst a refused read answers `200` with `{ "preference": null }`, so a page that may not ask does not learn that there is something to ask for.

### Letting a visitor start again

A shared answer applies on every site in the group until the visitor clears the cloud's cookies, and PMP shows no button to take it back. Whether to offer one is yours to decide. To offer one, remove the shared answer from the page:

```javascript
await fetch(
  'https://cloud.51degrees.com/api/v4/pmp/pref'
    + '?network=' + encodeURIComponent(networkName)
    + '&resource=' + encodeURIComponent(resourceKey),
  { method: 'DELETE', credentials: 'include', mode: 'cors' });
```

`credentials: 'include'` is needed, because without it the browser sends no cookie and the call removes nothing whilst looking as though it worked. The answer is `200` with `{ "preference": null }`, which is also what a call finds where nothing was held, so calling it twice does no harm. Then expire the two cookies on your own site as *Where the answer is kept* in @ref Identifiers_PMP_Preferences describes, and reload the page.

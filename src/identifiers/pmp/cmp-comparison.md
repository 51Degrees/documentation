@page Identifiers_PMP_CmpComparison Compared With a Consent Management Platform

The Preference Management Platform follows the technical schema of the
Transparency and Consent Framework and presents itself to the vendors and
tags on your page as a consent management platform. It installs
`window.__tcfapi`, the `__tcfapiLocator` frame and the cross frame message
handler, and it hands out a TC string in the framework's format, so
advertising code that already reads a consent management platform reads the
platform the same way.

It does not follow the Transparency and Consent Framework Policies of IAB
Europe. It is not registered with IAB Europe as a consent management
platform, it does not present the framework's purposes and vendors to the
visitor, and it does not run the framework's consent flow. It asks one
question of its own instead, which is how the visitor wants their data used
for marketing.

What the answers to that question mean is set by the Model Terms for
Marketing. The Model Terms prescribe, in Appendix 1, how the framework's
purposes map onto the two marketing types, standard marketing and
personalized marketing, and those two types are two of the three answers
the platform offers. The text in force is version 2, at
<https://m4ow.uk/mtm/2.txt>, and the platform's purpose sets are built from
that appendix. The rest of the scheme, being who the parties are, what a
receiver may do and why the protection is a contract rather than a property
of the identifier, is in the explainer at <https://m4ow.uk/mtm>, and this
page does not repeat it.

# The Sources

- IAB Europe, the Transparency and Consent Framework:
  <https://iabeurope.eu/transparency-consent-framework/>
- IAB Europe, the Framework Policies, which the platform does not follow:
  <https://iabeurope.eu/iab-europe-transparency-consent-framework-policies/>
- IAB Europe, the framework for consent management platforms, which is
  where registration is described: <https://iabeurope.eu/tcf-for-cmps/>
- IAB Europe, the list of registered consent management platforms:
  <https://iabeurope.eu/cmp-list/>
- IAB Europe, the Global Vendor List: <https://iabeurope.eu/vendor-list-tcf/>
- IAB Tech Lab, the technical specifications:
  <https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework>
- IAB Tech Lab, the TC string and vendor list formats, version 2:
  <https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/TCFv2/IAB%20Tech%20Lab%20-%20Consent%20string%20and%20vendor%20list%20formats%20v2.md>
- IAB Tech Lab, the CMP API, version 2:
  <https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/TCFv2/IAB%20Tech%20Lab%20-%20CMP%20API%20v2.md>
- The Model Terms for Marketing, version 2, the text in force:
  <https://m4ow.uk/mtm/2.txt>
- The Model Terms for Marketing explainer: <https://m4ow.uk/mtm>

# The Platform Against a Consent Management Platform

| | A consent management platform under the Framework Policies | The Preference Management Platform |
|---|---|---|
| Who sets the policy | IAB Europe, through the Transparency and Consent Framework Policies. | The Model Terms for Marketing, version 2. The platform follows the framework's technical schema and not its Policies. |
| Registration with IAB Europe | Required. IAB Europe's page for consent management platforms says that "CMPs must register to participate in the TCF", and a registered platform appears on the CMP list with a CMP ID of its own. | None. The platform is not registered and has no CMP ID of its own. It uses an ID chosen at random each day from IAB Europe's list of registered consent management platforms, writes that ID into the TC string and reports the same ID through `__tcfapi`. *The CMP ID* below gives the reason. |
| The question asked | Transparency and choices about the vendors the publisher has chosen to work with and the purposes each vendor wants to use, as IAB Europe's page for consent management platforms describes it. The Framework Policies say the choice on a purpose is to consent or to object, depending on the legal basis for the processing, and the CMP API specification says the Global Vendor List sets what must be disclosed to the visitor. | One question, in the visitor's own language, with up to three answers, being Personalized, Standard where you turn it on, and the alternative you configure. The purposes behind the two marketing answers are fixed by Appendix 1 of the Model Terms and the visitor does not pick among them. |
| Refusal | IAB Europe says the framework lets a user grant or withhold consent and object to processing. The CMP API specification has the platform capture those choices in a TC string and answer the scripts calling it with that string whenever the user has confirmed their choices. | There is no close cross and no reject button. The alternative button records `non-marketing`, which is an answer and not a refusal. No TC string is built for it, and the surface answers `getTCData` and `addEventListener` with `success` false until the visitor chooses Standard or Personalized. |
| Storage | Left to the platform. The TC string and vendor list formats specification, which the CMP API specification points to, says the storage used for a TC string is up to the consent management platform, cookie or not, and IAB Europe's page for consent management platforms says the same. In apps the CMP API specification names `IABTCF_TCString` and `IABTCF_gdprApplies`, among other keys, in `NSUserDefaults` or `SharedPreferences`. | The answer, one of three words, in this site's `localStorage` under `__51d_pmp_pref`, or in the cloud's own cookie when the visitor agrees to share it across your group. The TC string is built in memory from that answer on every page load and is never written to a cookie or to storage. |
| The identifier created | None of its own. On a page running a consent management platform the 51Degrees client script sends the TC string to the cloud, which derives the usage from the purposes granted, and the 51Did records that with the signal source bit set. | Every answer, `non-marketing` included, reaches the cloud as a stated `id.usage`, sent by the 51Degrees client script, and the 51Did records that the usage was stated directly, so the signal source bit is clear. |
| The legal basis of the answer | Consent or legitimate interests, which the Framework Policies name as the two lawful grounds under Article 6 of the General Data Protection Regulation that the framework supports. The CMP API specification has the platform obtain consent or register objections, and gives the framework's objective as helping everyone in the advertising chain comply with that Regulation and the ePrivacy Directive. | The Model Terms usage, which is a contract between the parties handling the identifier and not a consent under the Regulation. The dialog is shown whether or not the Regulation applies to the visit, and `gdprApplies` only changes what the surface reports. |
| What a vendor on the page receives | The TC string and the `TCData` object through `__tcfapi`, carrying that vendor's own consent and legitimate interest signals as the user set them. | The same surface and the same string format. The purpose consents come from the visitor's answer, the legitimate interest bits are set for purposes 2, 7, 8, 9, 10 and 11, and every vendor signal, special feature and publisher field is copied from the string you supply in `data-tcf-vendor` exactly as you encoded it. The platform decides nothing per vendor. |

# The CMP ID

The platform is not registered with IAB Europe, so it has no CMP ID of its
own. It uses an ID chosen at random each day from IAB Europe's list of
registered consent management platforms, writes that ID into the TC string,
and reports the same ID through `__tcfapi`.

The reason is that the CMP ID in a TC string is checked against that list.
The TC string and vendor list formats specification says, in its
[Global CMP List section](https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/TCFv2/IAB%20Tech%20Lab%20-%20Consent%20string%20and%20vendor%20list%20formats%20v2.md#global-cmp-list-specification),
that vendors use the list to decide whether the CMP ID they find in a
string is valid, so a string that follows the technical specification but
carries an ID that is not on the list is rejected. An ID taken from the
list prevents that.

51Degrees would support a change by IAB Europe requiring consent management
platforms to sign the TC string cryptographically, with the signer
identified by a decentralised domain name tied to the operator, being a
domain the operator controls rather than a number handed out from one
central list. A receiver could then tell who made a string, instead of
trusting an ID that anyone can copy. Every 51Did is already signed in that
way. Each one is an OWID, a signed envelope naming the domain of the
organisation that created it, and a receiver checks the signature against
the public key that domain publishes. See @ref Identifiers_51Did and
<https://github.com/SWAN-community/owid>.

# Framework Features and How the Platform Implements Them

| Feature of a consent management platform | How the Preference Management Platform implements it |
|---|---|
| The `__tcfapi` stub that queues calls until the platform loads | Implemented. Installed when the bundle runs. `ping` is answered at once and every other call is queued until the string is ready, then answered in order. |
| The `__tcfapiLocator` frame | Implemented. A hidden frame of that name is added to the body, or on `DOMContentLoaded` where the body is not parsed yet, and never added twice. |
| Cross frame calls by `postMessage` | Implemented. A `__tcfapiCall` message is passed to `__tcfapi` and answered with a `__tcfapiReturn` message carrying the same `callId`. |
| `ping` | Implemented. Reports `cmpStatus`, `cmpLoaded`, `displayStatus`, `apiVersion` `2.3`, `cmpVersion` 1, `cmpId`, `gvlVersion`, `tcfPolicyVersion` and `gdprApplies`. |
| `addEventListener` | Implemented. A listener registered once the string is ready is called at once with `tcloaded`. One registered before that is called when the string becomes ready, and not straight away with a loading status. |
| `removeEventListener` | Implemented, and still answered after the alternative answer, so a listener registered earlier can be taken off. |
| `getTCData` | Implemented, although the specification deprecated the command in version 2.2. The purpose consents come from the visitor's answer and every other field is decoded from the string. |
| `getVendorList` | Not implemented. Refused with `success` false. |
| `getInAppTCData` | Not implemented. The platform runs on web pages. |
| Any other command | Refused with `success` false. |
| Events | `tcloaded` when the string is ready, and again when `gdprApplies` changes. `useractioncomplete` on each answer. `cmpuishown` when the dialog is reopened while a string exists, so not on the first showing and not after the alternative answer. |
| `gdprApplies` | Reported `true` until `IsGdpr` on the client script's object says otherwise, and a consumer already told `tcloaded` is told again with the corrected value. The dialog is shown either way. See @ref Identifiers_PMP_IsGdpr. |
| CMP ID and CMP version | No ID of its own. An ID chosen at random each day from IAB Europe's list of registered consent management platforms, written into the string and reported by the surface, for the reason under *The CMP ID* above. `cmpVersion` is reported as 1 and the string's own version field is whatever `data-tcf-vendor` carries. |
| Policy version and vendor list version | The `tcfPolicyVersion` and `vendorListVersion` read from the Global Vendor List when the bundle was built, reported by `ping` and `getTCData`. The string's own version fields are whatever `data-tcf-vendor` carries. |
| The Global Vendor List | Not fetched at run time and not shown to the visitor. The build reads the list for the two version numbers and nothing else. |
| Vendors | Not chosen by the platform. Vendor consents, vendor legitimate interests and any disclosed vendors segment are copied from `data-tcf-vendor` unchanged. You generate that string with the framework's own tools to match the vendors you have contracted. |
| Purposes | Set from the answer, by Appendix 1 of the Model Terms. Standard consents to purposes 1, 2, 7, 8 and 11. Personalized consents to purposes 1, 2, 3, 4, 5, 6, 7, 8 and 11. Purposes 9, 10 and 12 are never consented. |
| Legitimate interest | The bits for purposes 2, 7, 8, 9, 10 and 11 are set on both marketing answers, meaning no objection is recorded. There is no separate objection control. |
| Special features and special purposes | Special feature opt-ins are copied from `data-tcf-vendor`. Special purposes carry no consent or objection signal in a TC string. |
| Publisher restrictions and the publisher segment | The publisher segment, where the string carries one, is copied through and its consents reported. `publisher.restrictions` is always reported empty. |
| Publisher country code | Copied from `data-tcf-vendor` and reported as `publisherCC`, and `AA` where the string could not be decoded. |
| Consent language and consent screen | Not rewritten, so the string carries whatever `data-tcf-vendor` says. The dialog's own language is the one the loader chose for the visitor. |
| Created and last updated | Both set to the moment the string is built, which is every page load and every new answer. |
| Storing the TC string | Not stored. The string is rebuilt from the answer on every page load. |
| A second layer with per purpose and per vendor controls, and stacks | Not implemented. The dialog offers the three answers and nothing per purpose or per vendor. |
| Withdrawing or changing an answer | The bubble reopens the dialog at any time. A new answer is stored, a new string is built, and `useractioncomplete` follows. |
| One platform per page | The platform stops with a console warning when a `__tcfapi` that is not its own is already installed, and never replaces it. See @ref Identifiers_PMP_CmpWiring. |

# Find Out More

- Running a consent management platform instead of the platform:
  @ref Identifiers_PMP_CmpWiring
- The three answers, where they are kept and how to read them:
  @ref Identifiers_PMP_Preferences
- What `gdprApplies` is set from: @ref Identifiers_PMP_IsGdpr
- The identifier, the signal source bit and the purpose sets the cloud
  applies to a consent string: @ref Identifiers_51Did
- The Model Terms for Marketing, version 2: <https://m4ow.uk/mtm/2.txt>
- The Model Terms for Marketing explainer: <https://m4ow.uk/mtm>
- The client script that carries the answer to the cloud:
  <https://github.com/51Degrees/javascript-templates>

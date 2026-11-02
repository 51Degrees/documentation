@page Identifiers_PMP_Configuration Configuration attributes

The attributes PMP reads from its own `<script>` tag.

| Attribute                      | Required | Default | Purpose |
|--------------------------------|----------|---------|---------|
| `data-tcf-vendor`              | Yes      | -       | Static IAB Transparency and Consent Framework (TCF) v2 consent string, generated once with TCF tools with your vendor consents in it. PMP takes the core segment and rewrites only the purpose bits and the dates for each answer, so the string it publishes starts differently from the one you gave and ends the same, and multi-segment strings such as `core.disclosedvendors` are accepted with the trailing segments kept as given. **Leave it off and nothing warns you.** The dialog, the cookie, the event and the getter all work, and `getTCData` reports the right purposes with an empty `tcString`, so a check that reads purposes passes with no consent string behind it. |
| `data-brand-name`              | Yes      | -       | Brand shown in the dialog. |
| `data-brand-terms-url`         | Yes      | -       | Link to the publisher's terms or privacy page. |
| `data-brand-icon`              | No       | -       | URL of the icon on the floating button the dialog collapses to. An SVG served from your own origin keeps the page free of outside requests. Without it a gear symbol is shown. |
| `data-alt-name`                | Yes      | -       | Label for the Alternative button, for example "Subscribe to remove ads". Pressing it sets the visitor's Model Terms for Marketing preference to `non-marketing`. See *Buttons and what each one stores* in @ref Identifiers_PMP_Preferences. |
| `data-alt-url`                 | Yes      | -       | What the Alternative button does, after it has recorded `non-marketing` as the visitor's answer. An `http(s)` URL navigates the page and a `javascript:` URL runs inline with no navigation. `{preference}` is not substituted here. |
| `data-action-url`              | No       | -       | A hook of your own, invoked on every answer. `{preference}` is replaced with `standard`, `personalized` or `non-marketing`. An `http(s)` URL is injected as `<script src>` and a `javascript:` URL runs inline. Leave it out and nothing is invoked, with the dialog saving the answer, activating `__tcfapi` and dismissing as usual. See *Where the action URL fits* in @ref Identifiers_PMP_Preferences. |
| `data-brand-logo`              | No       | -       | URL to the publisher's logo, shown in the dialog header. |
| `data-dialog-heading`          | No       | -       | Your own wording for the first card's heading, in place of the wording PMP ships for the visitor's language. Leave it out and the shipped wording stands. See *The dialog wording* below. |
| `data-dialog-body`             | No       | -       | Your own wording for the paragraph under that heading, on the same terms as `data-dialog-heading`. |
| `data-show-standard`           | No       | `false` | Set to the exact string `true` to offer the Standard option alongside Personalized and the Alternative button. |
| `data-network-name`            | Only when sharing is on | - | The name of the group your sites belong to. The visitor is shown this name as the thing they would be sharing their answer with, so choose one they will already have seen on the sites themselves. The name also settles which sites count as one group. See @ref Identifiers_PMP_Sharing. |
| `data-network-logo`            | No       | -       | URL to the network's logo, shown in the dialog beside the publisher's own. |
| `data-cookie-domain`           | No       | -       | The domain the `__mtm_pref` cookie is written on, for a site served under more than one name, for example `.example.com`. Leave it out and the cookie is scoped to the exact host the page was served from. See *The answer your own server can read* in @ref Identifiers_PMP_Preferences. |
| `data-use-third-party-cookies` | No       | `true`  | Whether a visitor who chose Standard or Personalized may be offered the second card, which shares the answer with the other sites in the group. Nothing but the exact string `false` turns it off, so a mistyped value leaves sharing running rather than silently switching it off. |
| `data-object-name`             | No       | `fod`   | What the 51Degrees client script's object is called on this page, which is where the third party cookie result and the GDPR answer are read from. Set it only where the client script was built with the `fod-js-object-name` parameter, and set both to the same name. |

A License Key never goes on the page. The loader sends none, the bundle request refuses one with `400`, and a tag carrying `data-license-key` stops PMP from starting, with one console error saying so. Where your products need a License Key on top of the Resource Key, add the License Key to the Resource Key when you create it.

PMP waits 1500 milliseconds for the cloud when it reads the shared answer at start up and when it writes one, and no attribute changes that. A tag carrying `data-timeout` gets one console warning per page view.

## The dialog wording

PMP ships the dialog text in 24 languages and chooses one from the browser's own language list, so a visitor reading German is answered in German without you doing anything.

`data-dialog-heading` and `data-dialog-body` replace the heading and the paragraph beneath it where the shipped wording does not suit you. Everything else on the card keeps the shipped text.

### Giving the wording per language

Writing the attribute once replaces that text for every language, which is usually wrong for a site with readers in more than one. Suffix the attribute with a language code to set the wording for that language alone.

```html
<script
  src="https://cloud.51degrees.com/api/v4/pmp/YOUR-RESOURCE-KEY.js"
  data-brand-name="Your Brand"
  data-dialog-heading="Choose your marketing experience"
  data-dialog-heading-fr-ca="Choisissez votre expérience marketing"
  data-dialog-heading-fr="Choisissez votre expérience publicitaire">
</script>
```

PMP reads three candidates in order and takes the first one that is present:

1. the attribute suffixed with the whole code of the language it is running in, such as `data-dialog-heading-fr-ca`
2. the attribute suffixed with the language on its own, such as `data-dialog-heading-fr`
3. the attribute with no suffix, which is the fallback for every language that has no variant of its own

Write none of the three and the shipped wording for that language stands.

The match ignores case, so `data-dialog-heading-FR` and `data-dialog-heading-fr` are the same attribute. A code with no region never matches a longer one, so a bundle running as `sw` does not pick up `data-dialog-heading-sw-ke`.

An empty value is an answer rather than an absence, so `data-dialog-body=""` gives a blank paragraph instead of falling back to the shipped text.

### Macros

Any key written in square brackets is replaced when the card is drawn, and that applies to your own wording as much as to the text PMP ships.

| Macro | Replaced with |
|-------|---------------|
| `[networkName]` | The value of `data-network-name`. The shipped text of the second card, which asks whether the answer should apply across the group's sites, uses it. |
| `[brandName]` | The value of `data-brand-name`. |
| `[altName]` | The value of `data-alt-name`, which is the label on the alternative button. |
| `[privacyPolicyLink]` | A link to `data-brand-terms-url`, with the link text in the visitor's own language. |

So a heading written as `Welcome to [networkName]` reaches the visitor as "Welcome to Acme Media" wherever `data-network-name` is `Acme Media`. A key that does not exist is left exactly as you wrote it, brackets included, so a typo shows up on the card rather than quietly disappearing.

Your wording is escaped before it is placed into the card, so markup written into one of these attributes is shown to the visitor as characters instead of becoming part of the page.

### What you cannot reword

The two descriptions behind "More information", which say what Standard and Personalized mean, cannot be reworded. They are the [Model Terms for Marketing](https://m4ow.uk/mtm/2.txt) wording and those same two words travel onwards as `id.usage`. Were one site able to reword them, two sites could send the same value meaning different things, and nothing reading the answer afterwards could tell the difference.

## Languages

The loader picks the bundle's language from the visitor's own browser, matching the full tag first, then the language on its own, then falling back to `en-us`, so a browser asking for `de-AT` is served German and one asking for a language PMP does not have is served English. Where two files share a language the one that sorts first serves a request for the bare language, so `pt` is served Brazilian Portuguese, `es` European Spanish and `zh` Simplified Chinese. Languages written right to left are supported, and the only thing that changes for them is the writing direction the widget sets on its own container, never anything on your page. The two descriptions of Standard and Personalized are the Model Terms wording in every language, translated under legal review rather than as ordinary copy.

@page Identifiers_PMP_Configuration Configuration Attributes

Every setting is a `data-` attribute on the one `<script>` tag you write,
the resource key included. The tag's URL names the loader and nothing else,
so each setting is written in one place and read from one place. The loader
copies your attributes onto the bundle it pulls in, so you never write any
of them twice.

# The Attributes

| Attribute | Required | Default | What it does |
|---|---|---|---|
| `data-resource-key` | Yes | none | The resource key the cloud knows you by. It must be registered for the domain the page is served from, or the request for the bundle is refused and no dialog appears. |
| `data-tcf-vendor` | Yes | none | Your own Transparency and Consent Framework vendor string. The platform sets the purpose bits and the time fields from the visitor's answer and copies everything else through unchanged. A multi part string such as `core.disclosedvendors` is accepted and the trailing parts are preserved. |
| `data-brand-name` | Yes | none | Your brand, shown in the dialog. |
| `data-brand-terms-url` | Yes | none | Your privacy or terms page, linked from the dialog. |
| `data-alt-name` | Yes | none | The label on the alternative button, for example 'Subscribe' or 'Remove ads'. |
| `data-alt-url` | Yes | none | What the alternative button does. An `http` or `https` URL navigates the page. A `javascript:` URL runs inline and the page stays where it is. |
| `data-network-name` | When sharing | none | The name of the group your sites belong to. Required for the second card, because a visitor has to be told which sites an answer would apply to. Leaving it out turns sharing off with a warning. See @ref Identifiers_PMP_Sharing. |
| `data-object-name` | No | `fod` | The name of the 51Degrees client script's page object, so the platform can find it. Leave it out unless your client script tag sets `fod-js-object-name` to something else. Every console message names whichever name is in force. |
| `data-action-url` | No | none | A hook of your own, fired on every answer, with `{preference}` replaced by `standard`, `personalized` or `non-marketing`. An `http` or `https` URL is added as a script tag, a `javascript:` URL runs inline. Leaving it out means nothing is fired, and nothing else changes. |
| `data-license-key` | No | none | Further licence keys, several separated by `+`, where your products need one on top of the resource key. Anyone reading the page can see it, exactly as they could when it sat on a URL. |
| `data-brand-logo` | No | none | Your logo, shown in the dialog's header. |
| `data-brand-icon` | No | a gear symbol | The round icon on the bubble the dialog collapses to. |
| `data-network-logo` | No | none | The group's logo, shown beside your own. |
| `data-show-standard` | No | `false` | Set to `true` to offer Standard alongside Personalized and the alternative. |
| `data-use-third-party-cookies` | No | `true` | Whether a visitor who chose Standard or Personalized may be offered the second card. Only the exact string `false` turns it off, so a typo leaves it on rather than quietly removing it. Where it is on and `data-network-name` is present, the second card is shown only where the client script confirms that third party cookies work, and where the client script is still testing the cookie when the first card is answered, the platform waits up to three seconds for that confirmation. Turning it off, or leaving out `data-network-name`, means there is no second card and nothing ever waits between the cards. The platform learns whether third party cookies work from the client script's `device.thirdpartycookiesenabled`, which is a string rather than a boolean, so read @ref Identifiers_PMP_Sharing before testing that value in code of your own. |

A URL attribute that is neither a path nor an `http` or `https` address is
refused and logged, so a `data:` or `vbscript:` URL never reaches the page.
`data-alt-url` and `data-action-url` also accept `javascript:`, because
running your own code inline is what they are for.

# How Long the Platform Waits

No attribute sets how long the platform waits. Both times are set once when
the platform is built and are the same on every page.

| What the platform waits for | For up to | When the time runs out |
|---|---|---|
| The cloud, when the group's shared answer is read at start up and when a visitor's answer is written to it | 1500 milliseconds | A read counts as no shared answer and the dialog is shown. A write counts as refused and the answer is kept with this site. |
| The client script to confirm that third party cookies work, once the first card is answered, and only where sharing is configured and the cookie is still being tested | 3000 milliseconds (three seconds) | There is no second card and the answer stays with this site. See @ref Identifiers_PMP_Sharing. |

A page that still sets `data-timeout` gets one warning in the console saying
that the attribute is no longer read, and the attribute is ignored.

<!--
For maintainers. The two times are the build constants sharedStoreTimeoutMs
and thirdPartyCookieWaitMs in pmp/build-constants.yaml in the cloud
repository, compiled into every bundle as __SharedStoreTimeoutMs__ and
__ThirdPartyCookieWaitMs__, with the reason for each value written beside
it. The data-timeout attribute was removed on James Rosewell's decision of
15 September 2026. Change this table, the sharing page and the load process
diagram whenever either value changes.
-->

# The Two URL Attributes

The two attributes look alike and do different jobs.

| | `data-action-url` | `data-alt-url` |
|---|---|---|
| When it fires | On every answer, including the alternative | Only when the alternative button is clicked |
| `http` or `https` | Added to the page as a script tag | The page navigates to it |
| `javascript:` | Run inline | Run inline, with no navigation |
| `{preference}` | Replaced by the answer | Not replaced |

Because `data-action-url` fires on the alternative as well, the alternative
usually wants either a navigation or an inline call, and not both an
analytics call and a navigation, since the action URL already covers the
analytics half.

`{preference}` is replaced with a bare word, so quote it yourself inside a
`javascript:` payload.

```{html}
<!-- Wrong, becomes pmpDone(standard) and throws. -->
data-action-url="javascript:pmpDone({preference})"

<!-- Right, becomes pmpDone('standard'). -->
data-action-url="javascript:pmpDone('{preference}')"
```

# A Complete Tag

```{html}
<script src="https://cloud.51degrees.com/api/v4/pmp"
    data-resource-key="YOUR-RESOURCE-KEY"
    data-tcf-vendor="[YOUR TCF VENDOR STRING]"
    data-brand-name="Your Brand"
    data-brand-logo="https://yoursite.com/logo.svg"
    data-brand-terms-url="https://yoursite.com/privacy"
    data-alt-name="Subscribe"
    data-alt-url="https://yoursite.com/subscribe"
    data-network-name="Your Group"
    data-show-standard="true">
</script>
```

# Find Out More

- Putting the tags on the page: @ref Identifiers_PMP_Integration
- The three answers and how to read the one in force:
  @ref Identifiers_PMP_Preferences
- The second card and the shared answer: @ref Identifiers_PMP_Sharing
- The identifier the answer leads to: @ref Identifiers_51Did
- The parameters of the client script's own URL:
  <https://cloud.51degrees.com/api-docs/index.html>
- Build or check a resource key: <https://configure.51degrees.com/>

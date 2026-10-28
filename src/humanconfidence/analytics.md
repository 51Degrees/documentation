@page Services_Cloud_HumanConfidenceAnalytics Add Human Confidence to Google Analytics

Google Analytics 4 leaves out the crawlers on the IAB's list of known bots and counts every other visit as a user. AI agents that drive a real browser load the page, run the JavaScript, and fire the tag like anyone else, so they are counted too.

Send Human Confidence and the crawler properties to Google Analytics 4 as one event, register them as custom dimensions, and your reports separate people from crawlers and from agents that hide. Nothing changes for your visitors, so this is a good place to start before you add the gate in @ref Services_Cloud_HumanConfidence.

**Get a License Key with Human Confidence:** [buy the Pro plan online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp). Human Confidence is in the Pro plan and above. [Compare plans](https://51degrees.com/pricing).

# What to send

| Property | What it tells you | Example values | Event parameter |
| -------- | ----------------- | -------------- | --------------- |
| HumanConfidence | How confident you can be that a person is viewing the page. | High, Medium, Low, Unknown | `derived_humanconfidence` |
| IsCrawler | Whether the request says it is an automated process. | true, false | `device_iscrawler` |
| CrawlerName | Which crawler. | OpenAI GPTBot, NotCrawler | `device_crawlername` |
| CrawlerUsage | What the crawler uses your content for. | Train, Input, Index, Search, N/A | `device_crawlerusage` |
| IsArtificialIntelligence | Whether the crawler works for an AI-related purpose. | True, False, N/A | `device_isartificialintelligence` |

Each parameter name is the engine, then the property, in lower case. The [51Degrees WordPress plugin](https://wordpress.org/plugins/51degrees-optimize-by-device-location/) uses the same names on the same `fod` event, so one set of custom dimensions works for WordPress and hand-coded sites alike.

# Step 1. Create a Resource Key

Human Confidence needs the Pro plan or above, which you can [buy online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp). See [plans and prices](https://51degrees.com/pricing).

Create a Resource Key at https://configure.51degrees.com with the License Key from your plan, and choose these properties.

- `derived.HumanConfidence`
- `device.IsVisibleJavaScript`
- `device.HasWebDriverJavaScript`
- `device.IsCrawler`
- `device.CrawlerName`
- `device.CrawlerUsage`
- `device.IsArtificialIntelligence`

Make a key for this job alone. The browser runs a script for some of the properties on the key before the values are ready, so every extra property delays the event.

This key is only used in the browser, so you can limit it to your own domains, and nobody else can spend your requests.

# Step 2. Send one event to Google Analytics 4

Add the 51Degrees script below your Google tag (gtag.js), with your Resource Key in place of `RESOURCE_KEY`. When the script has finished, `fod.complete` hands your function the values, and the function sends them to Google Analytics 4 as one event named `fod`.

```html
<script src="https://cloud.51degrees.com/api/v4/RESOURCE_KEY.js"></script>
<script>
  var fodSent = false;
  fod.complete(function (data) {
    // Send once, even if the values are refreshed later.
    if (fodSent) return;
    fodSent = true;
    var device = data.device, derived = data.derived;
    gtag('event', 'fod', {
      derived_humanconfidence: derived.humanconfidence,
      device_iscrawler: String(device.iscrawler),
      device_crawlername: device.crawlername,
      // A list for most crawlers, sent as one comma-separated value.
      device_crawlerusage: String(device.crawlerusage),
      device_isartificialintelligence: String(device.isartificialintelligence)
    });
  });
</script>
```

The event carries no page view, so it sits beside the tag you already have and changes none of your existing reports.

While you test, add `debug_mode: true` to the event's parameters and watch the `fod` event arrive in DebugView, under Admin and then Data display. Take it out before you go live.

# Step 3. Register each parameter as a custom dimension

In Google Analytics 4, go to Admin, then Data display, then Custom definitions, and create one custom dimension for each parameter in the table. Set the scope to Event and use the parameter name exactly as it appears in the table. A standard property allows 50 event-scoped custom dimensions, so the five here leave plenty of room.

Values start to show in reports 24 to 48 hours after the first events arrive.

# Step 4. Build the reports

Add HumanConfidence as a secondary dimension to any report, or build an exploration on it.

- Filter to High and your conversion rate is the rate for people. The gap between that and the unfiltered rate is the traffic that isn't.
- Look at Medium and Low by page to see what that traffic reads and whether it is growing.
- Use CrawlerName, CrawlerUsage, and IsArtificialIntelligence to see which crawlers read which pages and what for, then set your robots.txt rules from your own numbers.

![Monthly visits by Human Confidence on a demonstration site, May to September, with known crawlers removed](images/human-confidence-analytics.svg)

The chart shows the kind of report you get, from a demonstration site with known crawlers removed. Low and Medium grew from July while High fell.

# Crawlers that never run the page

Many crawlers don't run JavaScript, so they never reach the tag, and Google Analytics 4 never sees them. IsCrawler catches the ones that do run it, and then you choose.

- Keep them in your reports to see which AI crawlers read your content, and what for.
- Leave them out by sending the event only when `device.iscrawler` is false.

An agent that hides what it is gets an event either way, and Human Confidence is how you tell it apart from a person.

# Other analytics tools

Any analytics tool that accepts custom dimensions or event properties works the same way. Read the values inside `fod.complete` and pass them to your tool's own call in place of `gtag`.

On WordPress, the free [51Degrees WordPress plugin](https://wordpress.org/plugins/51degrees-optimize-by-device-location/) does steps 2 and 4 from a settings page. Enter your Resource Key, connect Google Analytics 4, choose the properties, and it sends the `fod` event on every page. Register the custom dimensions as in step 3.

# Universal Analytics

Google retired Universal Analytics in July 2024. The `custom_map` setting in our 2019 guides, [How to: 51Degrees + Google Analytics](https://51degrees.com/blog/how-to-51degrees-google-analytics) and [How deep are you diving into Google Analytics?](https://51degrees.com/blog/how-deep-are-you-diving-into-google-analytics), no longer works, and the steps on this page replace it.

# Find out more

- @ref Services_Cloud_HumanConfidence, to act on the answer on your server
- [Human Confidence in the property dictionary](https://51degrees.com/developers/property-dictionary?item=Derived%7CHuman%20Detection)
- @ref PipelineApi_Features_ClientSideEvidence, for how the 51Degrees script works in the browser
- [Plans and prices](https://51degrees.com/pricing)

**Get a License Key with Human Confidence:** [buy the Pro plan online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp). Human Confidence is in the Pro plan and above. [Compare plans](https://51degrees.com/pricing).

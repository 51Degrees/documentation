@page HumanConfidence_Analytics Human and bot traffic in your analytics

Analytics tools count a visit once the tag fires. Most leave out crawlers that announce themselves and count everything else. An AI agent driving a real browser loads the page and runs the JavaScript like anyone else, so it's counted as a user, and a rise in visits may have nothing to do with people.

You can split that out yourself by sending Human Confidence and the crawler properties to your analytics as custom dimensions. Then you can filter any report by them. We record it this way for every visit to 51degrees.com.

**Get a License Key with Human Confidence:** [buy the Pro plan online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp), or [compare plans](https://51degrees.com/pricing).

# What to send

| Property | What it tells you | Example values | Custom dimension name |
| -------- | ----------------- | -------------- | --------------------- |
| HumanConfidence | How likely it is that a person is looking at the page. | High, Medium, Low, Unknown | `derived_humanconfidence` |
| IsCrawler | Whether the request says it's an automated process. | true, false | `device_iscrawler` |
| CrawlerName | Which crawler. | OpenAI GPTBot, NotCrawler | `device_crawlername` |
| CrawlerUsage | What the crawler uses your content for. | Train, Input, Index, Search, N/A | `device_crawlerusage` |
| IsArtificialIntelligence | Whether the crawler works for an AI purpose. | True, False, N/A | `device_isartificialintelligence` |

Each name is the engine, then the property, in lower case. The [51Degrees WordPress plugin](https://wordpress.org/plugins/51degrees-optimize-by-device-location/) uses the same names, so a WordPress site and a hand-coded one can share one set of dimensions.

What your tool calls a custom dimension varies. Matomo calls it a custom dimension, Adobe Analytics uses an eVar or a prop, and Google Analytics 4 takes an event parameter that you register as a custom dimension.

# Get the values into the page

1. [Create a Resource Key from this link](https://configure.51degrees.com/AQRVdgJ-Hdo_5wU130g). It opens with the properties in the table, and the ones Human Confidence needs, already ticked. Add the License Key from your plan.
2. The key sits in your page where anyone can read it, so limit it to your own domains. Otherwise someone else could use it and spend your requests.
3. Add the 51Degrees script after your analytics tag and pick up the values when it finishes.

```html
<script src="https://cloud.51degrees.com/api/v4/RESOURCE_KEY.js"></script>
<script>
  var fodSent = false;
  fod.complete(function (data) {
    // Send once, even if the values are refreshed later.
    if (fodSent) return;
    fodSent = true;
    var values = {
      derived_humanconfidence: data.derived.humanconfidence,
      device_iscrawler: String(data.device.iscrawler),
      device_crawlername: data.device.crawlername,
      // A list for most crawlers, sent as one comma-separated value.
      device_crawlerusage: String(data.device.crawlerusage),
      device_isartificialintelligence: String(data.device.isartificialintelligence)
    };
    // Pass values to your analytics tool here.
  });
</script>
```

4. Hand `values` to whatever call your tool uses for custom dimensions or event properties. For GA4 that's one `gtag` event, and @ref HumanConfidence_GoogleAnalytics walks through it.

# What to look at

Put Human Confidence next to the reports you already read.

- Filter conversions to High to get a conversion rate for people, and compare it with your overall rate.
- Chart Medium and Low by month and by page, alongside High.
- Use CrawlerName, CrawlerUsage and IsArtificialIntelligence to see which crawlers read which pages, and whether they index, train or answer questions with them. Then set your robots.txt rules from what you see.

![Monthly visits by Human Confidence on a demonstration site, May to September, with known crawlers removed](images/human-confidence-analytics.svg)

This chart comes from a demonstration site, with known crawlers removed. From July, Low and Medium grew and High fell.

# Crawlers that never run the page

Plenty of crawlers don't run JavaScript. They never reach your tag, so your analytics never counts them. IsCrawler picks up the ones that do run it. You can keep them in, to see which AI crawlers read your pages, or send the values only when `device.iscrawler` is false. Either way, an agent that hides what it is still gets counted. Filter on Human Confidence to separate those visits from people.

# Find out more

- @subpage HumanConfidence_GoogleAnalytics
- @ref Services_Cloud_HumanConfidence, to act on the value on your server
- @ref PipelineApi_Features_ClientSideEvidence, for how the 51Degrees script works in the browser
- [Human Confidence in the property dictionary](https://51degrees.com/developers/property-dictionary?item=Derived%7CHuman%20Detection)

Human Confidence needs the Pro plan or above, which you can [buy online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp).

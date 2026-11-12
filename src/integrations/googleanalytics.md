@page Integrations_GoogleAnalytics Google Analytics 4 (GA4)

Send 51Degrees properties to Google Analytics 4 as custom dimensions, and you can break down any GA4 report by them. You can see the device, what it cost when it came out and how old it is, the browser and operating system, the country and region of the visitor's IP address, whether the visit is a crawler, and Human Confidence, which says how confident 51Degrees is that a person is viewing the page.

Google Analytics 4 already filters some bot traffic. Google says GA4 automatically excludes "traffic from known bots and spiders", identified "using a combination of Google research and the International Spiders and Bots List, maintained by the Interactive Advertising Bureau" ([Google Analytics Help, known bot-traffic exclusion](https://support.google.com/analytics/answer/9888366), and the [IAB/ABC International Spiders and Bots List](https://www.iab.com/guidelines/iab-abc-international-spiders-bots-list/)). You can't turn that off, and GA4 won't tell you how much it excluded. Everything else is counted as users, including AI agents driving a real browser, because they load the page and fire the tag just as a person's browser would. The crawler properties and Human Confidence let you look at that traffic yourself.

For other analytics tools, see @ref HumanConfidence_Analytics.

# The properties

Pick the ones you want. Each is sent as an event parameter named after the element and the property, in lower case. The plan is the lowest one that includes the property, and every higher plan includes it too. [Compare plans](https://51degrees.com/pricing).

| Parameter | Property | What it holds | Plan |
| --- | --- | --- | --- |
| `device_devicetype` | DeviceType | The type of device, such as Desktop, SmartPhone or Tablet | Free |
| `device_iscrawler` | IsCrawler | True when the traffic identifies itself as a crawler | Free |
| `device_crawlername` | CrawlerName | The crawler's name, or NotCrawler | Free |
| `device_crawlerusage` | CrawlerUsage | What the crawler reads content for, such as search, AI indexing, AI model training or archiving, sent as one comma-separated value | Free |
| `device_hardwarevendor` | HardwareVendor | The company that makes the device or mainly sells it, such as Samsung | Essentials |
| `device_hardwarename` | HardwareName | The device's marketing names, such as Xperia Z5 | Essentials |
| `device_releaseage` | ReleaseAge | The age of the device in months since it was released | Essentials |
| `device_browsername` | BrowserName | The name of the browser | Essentials |
| `device_platformname` | PlatformName | The name of the operating system | Essentials |
| `device_isartificialintelligence` | IsArtificialIntelligence | True when the crawler works for an AI purpose, going by its CrawlerUsage | Essentials |
| `device_priceband` | PriceBand | The device's recommended retail price when it was released, as a range in US dollars | Pro |
| `derived_humanconfidence` | HumanConfidence | How confident 51Degrees is that a person is viewing the page, High, Medium, Low or Unknown | Pro |
| `ip_countrycode` | CountryCode | The 2-character ISO 3166-1 code of the country the IP address is in | Pro |
| `ip_state` | State | The top-level subdivision, such as a US state or a UK country | Pro |
| `ip_region` | Region | The subdivision one level below State | Pro |

The last three come from @ref IpIntelligence_Overview, which looks up the visitor's IP address, so the visitor is never asked to share their location.

# Step 1. Create a Resource Key

[Create a Resource Key from this link](https://51degrees.com/configure/AQRVdgJ-Hdo_5wU130g). It opens with Human Confidence, the properties Human Confidence needs, and the crawler properties already ticked. Tick the other properties you want from the table, untick Human Confidence if your plan doesn't include it, and add the License Key from your plan.

Select only the properties you will send. HardwareName, PriceBand, and ReleaseAge depend on the detected model. For some devices, including iPhones, the client script gathers additional evidence before sending the event.

The key sits in your page where anyone can read it, so limit it to your own domains, otherwise someone else could spend your requests.

# Step 2. Send one event to GA4

Add the 51Degrees script below your Google tag (gtag.js), with your Resource Key in place of `RESOURCE_KEY`. When the script finishes, `fod.complete` passes the values to your function, and the function sends them to GA4 as one event called `fod`. A property that isn't on your key is left out of the event.

```html
<script src="https://cloud.51degrees.com/api/v4/RESOURCE_KEY.js"></script>
<script>
  var fodSent = false;
  fod.complete(function (data) {
    // Send once, even if the values are refreshed later.
    if (fodSent) return;
    fodSent = true;
    var params = {};
    // Adds a value when the key includes the property. A list, such as
    // HardwareName or CrawlerUsage, becomes one comma-separated value.
    function add(element, property) {
      var values = data[element];
      if (values && values[property] !== undefined && values[property] !== null) {
        params[element + '_' + property] = String(values[property]);
      }
    }
    ['devicetype', 'iscrawler', 'crawlername', 'crawlerusage',
     'hardwarevendor', 'hardwarename', 'releaseage', 'browsername',
     'platformname', 'isartificialintelligence', 'priceband']
      .forEach(function (property) { add('device', property); });
    add('derived', 'humanconfidence');
    ['countrycode', 'state', 'region']
      .forEach(function (property) { add('ip', property); });
    gtag('event', 'fod', params);
  });
</script>
```

The event doesn't include a page view.

While testing, add `debug_mode: true` to the event parameters and watch for `fod` in DebugView (Admin, then Data display). Take it out before you go live.

# Step 3. Register the custom dimensions

In GA4, go to Admin, then Data display, then Custom definitions. Create a custom dimension for each parameter you send, with Event scope and the parameter name exactly as it is in the table, for example `device_priceband`.

A standard GA4 property allows 50 event-scoped custom dimensions. Expect the values in reports 24 to 48 hours after the first events.

# Step 4. Build the reports

Add any of the custom dimensions as a secondary dimension on a report, or build an exploration around them. Some places to start:

- Conversion rate by price band or by device age, to see whether people on newer or more expensive devices behave differently.
- Engagement by country and region, from the visitor's IP address.
- Crawlers by name and usage, page by page, to see which ones read what.
- A conversion rate filtered to Human Confidence High covers the visits most likely to be people. Break Medium and Low down by page to see which pages they visit and how that changes month to month. There are more ideas in @ref HumanConfidence_Analytics.

# WordPress

You don't need the code on WordPress. The free [51Degrees WordPress plugin](https://wordpress.org/plugins/51degrees-optimize-by-device-location/) connects to GA4 from its Google Analytics tab and tracks the properties on your Resource Key as custom dimensions. For that connection the key has to be limited to your domains. The steps are in @ref DeviceDetection_OtherIntegrations_Wordpress.

# Find out more

- [The property dictionary](https://51degrees.com/developers/property-dictionary), for every property and the plan it needs
- @ref HumanConfidence_Analytics, for any analytics tool
- @ref IpIntelligence_Overview, for the country, state and region of an IP address
- @ref Services_Cloud_HumanConfidence, to act on Human Confidence on your server

[Compare plans](https://51degrees.com/pricing). The Pro plan, which includes Human Confidence, can be [bought online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp). Ask us about the Bespoke plan, which adds every property and on-premise use, through the [contact page](https://51degrees.com/contact-us).

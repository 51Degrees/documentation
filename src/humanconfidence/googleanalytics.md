@page HumanConfidence_GoogleAnalytics Google Analytics 4 (GA4): human and bot traffic

Google Analytics 4 already filters some bot traffic. Google says GA4 automatically excludes "traffic from known bots and spiders", identified "using a combination of Google research and the International Spiders and Bots List, maintained by the Interactive Advertising Bureau" ([Google Analytics Help, known bot-traffic exclusion](https://support.google.com/analytics/answer/9888366), and the [IAB/ABC International Spiders and Bots List](https://www.iab.com/guidelines/iab-abc-international-spiders-bots-list/)). You can't turn that off, and GA4 won't tell you how much it excluded. Everything else is counted as users, including AI agents driving a real browser, because they load the page and fire the tag just as a person's browser would.

This page sends Human Confidence and the crawler properties to GA4 as one event, registered as custom dimensions. You can then filter bot traffic in Google Analytics yourself and compare human and bot traffic in any GA4 report. For other analytics tools, see @ref HumanConfidence_Analytics.

**Get a License Key with Human Confidence:** [buy the Pro plan online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp) for the cloud service, or [talk to us](https://51degrees.com/contact-us) about the Bespoke plan to run it on your own servers in a Docker container. [Compare plans](https://51degrees.com/pricing).

# Step 1. Create a Resource Key

[Create a Resource Key from this link](https://configure.51degrees.com/AQRVdgJ-Hdo_5wU130g). It opens with the properties this page sends, and the ones Human Confidence needs, already ticked. Add the License Key from your plan.

Don't add other properties to this key. Several of them wait for a script in the browser, and each one delays the event.

The key sits in your page where anyone can read it, so limit it to your own domains, otherwise someone else could spend your requests.

# Step 2. Send one event to GA4

Add the 51Degrees script below your Google tag (gtag.js), with your Resource Key in place of `RESOURCE_KEY`. When the script finishes, `fod.complete` passes the values to your function, and the function sends them to GA4 as one event called `fod`.

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

The event doesn't include a page view.

While testing, add `debug_mode: true` to the event parameters and watch for `fod` in DebugView (Admin, then Data display). Take it out before you go live.

# Step 3. Register the custom dimensions

In GA4, go to Admin, then Data display, then Custom definitions. Create a custom dimension for each parameter, with Event scope and the parameter name exactly as sent:

- `derived_humanconfidence`
- `device_iscrawler`
- `device_crawlername`
- `device_crawlerusage`
- `device_isartificialintelligence`

A standard GA4 property allows 50 event-scoped custom dimensions. Expect the values in reports 24 to 48 hours after the first events.

# Step 4. Build the reports

Add HumanConfidence as a secondary dimension on any report, or build an exploration around it. A conversion rate filtered to High counts people only. Break Medium and Low down by page to see which pages they visit and how that changes month to month. There are more report ideas in @ref HumanConfidence_Analytics.

# WordPress

You don't need the code on WordPress. The free [51Degrees WordPress plugin](https://wordpress.org/plugins/51degrees-optimize-by-device-location/) connects to GA4 from its Google Analytics tab and tracks the properties on your Resource Key as custom dimensions. For that connection the key has to be limited to your domains. The steps are in @ref DeviceDetection_OtherIntegrations_Wordpress.

# Find out more

- @ref HumanConfidence_Analytics, for any analytics tool
- @ref Services_Cloud_HumanConfidence, to act on the value on your server
- [Human Confidence in the property dictionary](https://51degrees.com/developers/property-dictionary?item=Derived%7CHuman%20Detection)

Human Confidence needs the Pro plan, which you can [buy online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp), or the Bespoke plan for your own servers. Ask us about Bespoke through the [contact page](https://51degrees.com/contact-us).

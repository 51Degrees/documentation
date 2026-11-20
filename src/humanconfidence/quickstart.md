@page HumanConfidence_Quickstart Human Confidence quick start

# Getting started with Human Confidence

Human Confidence comes from the 51Degrees cloud service. It isn't in the on-premise data files.

**Get a License Key with Human Confidence:** [buy the Pro plan online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp) for the cloud service, or [talk to us](https://51degrees.com/contact-us) about the Bespoke plan to run it on your own servers in a Docker container. [Compare plans](https://51degrees.com/pricing).

## Choose your integration

### Analytics
**Best for:** Finding out how much of your traffic is people before you change anything

**Benefits:**
- **No server changes** - The script and your analytics tag both run in the browser
- **Any analytics tool** - GA4, Matomo, Adobe Analytics or anything else that takes custom dimensions

**Things to consider:**
- **Reports only** - Visitors aren't stopped or challenged
- **JavaScript only** - Crawlers that don't run JavaScript don't fire your tag either

**Guide:** @ref HumanConfidence_Analytics, with @ref Integrations_GoogleAnalytics for GA4

---

### Server
**Best for:** Deciding what each visit gets, for example a product page, an article, a listing, a form, or an API

**Benefits:**
- **Server-side decision** - Your server gets the level from the cloud, so a browser can't change it
- **No SDK needed** - Use the single-file Node.js, PHP, and Python examples to call the cloud over HTTPS

**Things to consider:**
- **Holding page** - A visitor you haven't checked yet waits a few seconds on a holding page while the script and its tests run
- **License Key on the server** - Your server uses it to redeem the sealed value the browser carries
- **Network dependency** - The server calls the cloud once and caches the value for 30 minutes. If the cloud can't be reached, the examples let the request through and try again next time

**Guide:** @ref Services_Cloud_HumanConfidence

---

## Quick start

1. [Create a Resource Key from this link](https://configure.51degrees.com/AQRVdgJ-fPDE5gU130g). It opens with the properties Human Confidence needs already ticked. Check that HumanConfidenceSource is ticked too, and tick it if it isn't. Add the License Key from your plan and create the key.
2. Open `https://cloud.51degrees.com/api/v4/YOUR_RESOURCE_KEY.json` in a browser to check the key. You should see something like this. The level comes from the request alone, so the source is Passive, and with no script run it's Medium at most.
   ```json
   "derived": {
     "humanconfidence": "Medium",
     "humanconfidencesource": "Passive"
   }
   ```
3. Add the script to a page, with your Resource Key in place of `YOUR_RESOURCE_KEY`, and read the values once the script has finished.
   ```html
   <script src="https://cloud.51degrees.com/api/v4/YOUR_RESOURCE_KEY.js"></script>
   <script>
     fod.complete(function (data) {
       if (data.derived.humanconfidencesource === 'Active') {
         // A sealed value. Only your server can redeem it for the level.
         console.log('Active');
       } else {
         console.log('Passive: ' + data.derived.humanconfidence);
       }
     });
   </script>
   ```
4. Load the page in your browser and look at the console. It shows Active when your browser answered the tests. The level is then sealed, and your server gets it from the cloud, as @ref Services_Cloud_HumanConfidence shows. It shows Passive and a level when the tests didn't run.

---

## Find out more

- @ref HumanConfidence_Overview
- @ref Services_Cloud_ResourceKeys
- @ref PipelineApi_Features_ClientSideEvidence, for how the 51Degrees script works in the browser
- [Human Confidence in the property dictionary](https://51degrees.com/developers/property-dictionary?item=Derived%7CHuman%20Detection)

Human Confidence needs the Pro plan, which you can [buy online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp), or the Bespoke plan for your own servers. Ask us about Bespoke through the [contact page](https://51degrees.com/contact-us).

@page HumanConfidence_Quickstart Human Confidence Quick Start

# Getting Started with Human Confidence

Human Confidence comes from the 51Degrees cloud. There is no on-premise version.

**Get a License Key with Human Confidence:** [buy the Pro plan online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp). Human Confidence is in the Pro plan and above. [Compare plans](https://51degrees.com/pricing).

## Choose Your Integration

### Analytics
**Best for:** Measuring how much of your traffic is people before you change anything

**Benefits:**
- **No server changes** - The 51Degrees script and your analytics tag do the work in the browser
- **Nothing changes for visitors** - Every visit is served as before
- **Any analytics tool** - Google Analytics 4, or any tool that accepts custom dimensions

**Things to consider:**
- **Reports only** - Nothing is blocked or challenged
- **Browser only** - Visits that never run JavaScript never reach your analytics tag

**Guide:** @ref Services_Cloud_HumanConfidenceAnalytics

---

### Server
**Best for:** Deciding what each visit gets before you send a page, a price, or an API answer

**Benefits:**
- **Decided on your server** - Anything a browser sends could be forged, so the decision is made server side
- **No 51Degrees software on your server** - One server file in Node.js, PHP, or Python, and the 51Degrees cloud
- **Your rules** - You choose what High, Medium, and Low get

**Things to consider:**
- **Holding page** - A visitor the server has not checked yet gets a short holding page while the 51Degrees script runs
- **Network dependency** - Your server calls the cloud when it first sees a visitor and keeps the answer in the session for 30 minutes. If the cloud cannot answer, the examples let the visitor through and check again on the next request

**Guide:** @ref Services_Cloud_HumanConfidence

**Licensing:** Requires the Pro plan or above. [Buy the Pro plan online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp).

---

## Quick start

1. Get a License Key that includes Human Confidence by [buying the Pro plan online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp), or any plan above it.
2. Create a Resource Key at https://configure.51degrees.com with that License Key, and choose these properties.
   - `derived.HumanConfidence`
   - `device.IsVisibleJavaScript`
   - `device.HasWebDriverJavaScript`
3. Check the key. Open `https://cloud.51degrees.com/api/v4/YOUR_RESOURCE_KEY.json` in a browser. The answer includes the lines below. Unknown is expected at this point, because the 51Degrees script has not run in a page yet.
   ```json
   "derived": {
     "humanconfidence": "Unknown"
   }
   ```
4. Add the 51Degrees script to your page, with your Resource Key in place of `YOUR_RESOURCE_KEY`, and read the answer when the script has finished.
   ```html
   <script src="https://cloud.51degrees.com/api/v4/YOUR_RESOURCE_KEY.js"></script>
   <script>
     fod.complete(function (data) {
       console.log(data.derived.humanconfidence);
     });
   </script>
   ```
5. Use the answer. To measure, send it to your analytics with @ref Services_Cloud_HumanConfidenceAnalytics. To act on it, have your server ask the cloud with @ref Services_Cloud_HumanConfidence.

A Resource Key is public, so it is safe in a page. Keep your License Key secret and off every page.

---

## Find out more

- @ref HumanConfidence_Overview
- @ref Services_Cloud_ResourceKeys
- @ref PipelineApi_Features_ClientSideEvidence, for how the 51Degrees script works in the browser
- [Human Confidence in the property dictionary](https://51degrees.com/developers/property-dictionary?item=Derived%7CHuman%20Detection)

**Get a License Key with Human Confidence:** [buy the Pro plan online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp). [Compare plans](https://51degrees.com/pricing).

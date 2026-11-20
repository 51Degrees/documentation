@page HumanConfidence_Overview Human Confidence overview

# Introduction

Human Confidence tells you how likely it is that a person is looking at the page. The value for each visit is High, Medium, or Low, or Unknown where there is insufficient evidence to give a rating.

It comes from the 51Degrees cloud as the property `derived.HumanConfidence`, on the Pro plan, our cloud service, and on the Bespoke plan for your own servers. A second property, `derived.HumanConfidenceSource`, says how it was worked out.

**Get a License Key with Human Confidence:** [buy the Pro plan online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp) for the cloud service, or [talk to us](https://51degrees.com/contact-us) about the Bespoke plan to run it on your own servers in a Docker container. [Compare plans](https://51degrees.com/pricing).

To try it, follow the [Quick Start](@ref HumanConfidence_Quickstart).

---

## The values

| Value | Meaning | What websites usually do |
| ----- | ------- | ------------------------ |
| High | High confidence that a person is reading the page. | Let the request through. |
| Medium | Mixed signals. Could be a person, could be a script. | Serve the page, or challenge with a CAPTCHA or a sign-in first. |
| Low | Almost certainly no person is reading it. | Refuse the request, or serve a version of the page made for machines. |
| Unknown | There is insufficient evidence to give a rating. | Treat it as Medium. |

---

## Passive and active

**Passive.** The cloud works out a level from the request alone, such as the browser's age and the connection it arrives on. It answers straight away, on the first request, before any JavaScript runs. A request can't show whether the browser window is in view. So a passive level is Medium at most until the 51Degrees script has run. `HumanConfidenceSource` is Passive, and `HumanConfidence` is the level.

**Active.** When a page runs the 51Degrees script, the browser also answers tests that check it's what it says it is. The cloud judges the answers and returns Human Confidence as a sealed value. `HumanConfidenceSource` is Active. The browser can carry the sealed value, but it can't read or change it. Your server sends it back to the cloud with its License Key and gets the level. A sealed value redeems once, within 10 seconds. @ref Services_Cloud_HumanConfidence shows how.

So read `HumanConfidenceSource` before you read `HumanConfidence` as a level. Never trust a level the browser sends to your server, because a browser can send anything. Trust a level your server got from the cloud.

---

## Two ways to use it

**Measure.** Send Human Confidence to your analytics as a custom dimension and your reports show how much of your traffic is likely to be people. Nothing changes for your visitors. The browser can send only a passive level, so visits that ran the tests are counted as Active, with their level kept for your server. The steps for any analytics tool are in @ref HumanConfidence_Analytics, and there's a separate page for Google Analytics 4, @ref Integrations_GoogleAnalytics.

**Act.** Your server gets Human Confidence from the cloud before it sends a page and decides what to send. It redeems the sealed value when the browser ran the tests, and asks the cloud for a passive level when it didn't. See @ref Services_Cloud_HumanConfidence for the code.

You can do either on its own, or measure first and act once you know your numbers.

---

## Crawlers that say what they are

Search engines and other crawlers that name themselves don't need Human Confidence. The crawler properties identify them by name and by what they use your content for, and those properties are on every plan, including the free one.

Human Confidence needs the Pro plan, which you can [buy online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp), or the Bespoke plan for your own servers. Ask us about Bespoke through the [contact page](https://51degrees.com/contact-us).

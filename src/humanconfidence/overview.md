@page HumanConfidence_Overview Human Confidence Overview

# Introduction

Human Confidence tells you how likely it is that a person is looking at the page. Every visit gets High, Medium or Low. If the 51Degrees script never ran in the browser, the value is Unknown.

It comes from the 51Degrees cloud as the property `derived.HumanConfidence`, on the Pro plan, our cloud service, and on the Bespoke plan for your own servers.

**Get a License Key with Human Confidence:** [buy the Pro plan online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp) for the cloud service, or [talk to us](https://51degrees.com/contact-us) about the Bespoke plan to run it on your own servers in a Docker container. [Compare plans](https://51degrees.com/pricing).

To try it, follow the [Quick Start](@ref HumanConfidence_Quickstart).

---

## The values

| Value | Meaning | What websites usually do |
| ----- | ------- | ------------------------ |
| High | A person is reading the page. | Let the request through. |
| Medium | Mixed signals. Could be a person, could be a script. | Serve the page, or challenge with a CAPTCHA or a sign-in first. |
| Low | Almost certainly no person is reading it. | Refuse the request, or serve a version of the page made for machines. |
| Unknown | Not measured, usually because the script didn't run. | Treat it as Medium. |

---

## Two ways to use it

**Measure.** Send Human Confidence to your analytics as a custom dimension and your reports show how much of your traffic is people. Nothing changes for your visitors. The steps for any analytics tool are in @ref HumanConfidence_Analytics, and there's a separate page for Google Analytics 4, @ref HumanConfidence_GoogleAnalytics.

**Act.** Your server gets Human Confidence from the cloud before it sends a page and decides what to send. See @ref Services_Cloud_HumanConfidence for the code.

You can do either on its own, or measure first and act once you know your numbers.

---

## Crawlers that say what they are

Search engines and other crawlers that name themselves don't need Human Confidence. The crawler properties identify them by name and by what they use your content for, and those properties are on every plan, including the free one.

Human Confidence needs the Pro plan, which you can [buy online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp), or the Bespoke plan for your own servers. Ask us about Bespoke through the [contact page](https://51degrees.com/contact-us).

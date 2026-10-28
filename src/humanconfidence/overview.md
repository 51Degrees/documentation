@page HumanConfidence_Overview Human Confidence Overview

# Introduction

Human Confidence is a 51Degrees cloud property, `derived.HumanConfidence`, that says how likely it is that a person is viewing the page. It answers High, Medium, or Low for each visit, or Unknown when it could not be measured.

[Quick Start Guide](@ref HumanConfidence_Quickstart) - Get running in minutes.

**Get a License Key with Human Confidence:** [buy the Pro plan online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp). Human Confidence is in the Pro plan and above. [Compare plans](https://51degrees.com/pricing).

---

## The answers

| Answer | What it means | What a website typically does |
| ------ | ------------- | ----------------------------- |
| High | A person is viewing the page. | Serves the page. |
| Medium | It could be a person or a script. | Serves the page, or asks for a challenge such as a CAPTCHA or a sign-in first. |
| Low | Almost certainly no person is viewing the page. | Turns the visit away, or serves the page without the data it wants to protect. |
| Unknown | Not measured, for example because the 51Degrees script could not run. | Treats it as Medium. |

Human Confidence needs the 51Degrees script to run in the visitor's browser. Your website then reads the answer in the browser, or your server asks the cloud for it.

---

## Two ways to use it

- **Measure.** Send Human Confidence to your analytics as a custom dimension and see how much of your traffic is people. Nothing changes for your visitors. See @ref Services_Cloud_HumanConfidenceAnalytics.
- **Act.** Your server asks the cloud for Human Confidence before it sends a page, and decides what each visit gets. See @ref Services_Cloud_HumanConfidence.

---

## Crawlers that say what they are

Crawlers that identify themselves, such as search engine crawlers, are named by the crawler properties `device.IsCrawler`, `device.CrawlerName`, and `device.CrawlerUsage`, which are on every plan including the free plan. Human Confidence is for the visits that do not say what they are.

---

## Plans

Human Confidence is in the Pro plan and above. A Resource Key made with a free License Key cannot include it.

**Get a License Key with Human Confidence:** [buy the Pro plan online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp). [Compare plans](https://51degrees.com/pricing).

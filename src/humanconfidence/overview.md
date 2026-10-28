@page HumanConfidence_Overview Human Confidence Overview

# Introduction

Human Confidence tells you how likely it is that a person is looking at the page. Every visit gets High, Medium or Low. If the 51Degrees script never ran in the browser, the value is Unknown.

It comes from the 51Degrees cloud as the property `derived.HumanConfidence`, on the Pro plan and above.

**Get a License Key with Human Confidence:** [buy the Pro plan online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp), or [compare plans](https://51degrees.com/pricing).

To try it, follow the [Quick Start](@ref HumanConfidence_Quickstart).

---

## The values

| Value | Meaning | What websites usually do |
| ----- | ------- | ------------------------ |
| High | A person is reading the page. | Let the request through. |
| Medium | Mixed signals. Could be a person, could be a script. | Serve the page, or challenge with a CAPTCHA or a sign-in before anything worth protecting. |
| Low | Almost certainly no person is reading it. | Refuse the request, or serve the page without prices and stock. |
| Unknown | Not measured, usually because the script didn't run. | Treat it as Medium. |

---

## Where to use it

Most sites start in their analytics. Send Human Confidence as a custom dimension and you can see how much of your traffic is people. The steps for any analytics tool are in @ref HumanConfidence_Analytics, and there's a separate page for Google Analytics 4, @ref HumanConfidence_GoogleAnalytics.

When you want to act on it, do it on your server. Your server gets Human Confidence from the cloud before it sends a page and decides what to send. See @ref Services_Cloud_HumanConfidence for the code.

---

## Crawlers that say what they are

Search engines and other crawlers that name themselves don't need Human Confidence. The crawler properties identify them by name and by what they use your content for, and those properties are on every plan, including the free one.

Human Confidence needs the Pro plan or above, which you can [buy online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp).

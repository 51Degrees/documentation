@page HumanConfidence_Overview Human Confidence overview

# Introduction

Human Confidence tells you how likely it is that a person is looking at the page. The value for each visit is High, Medium, or Low.

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
| Unknown | There is insufficient evidence to give a rating. Only the open-source script in your own Pipeline gives it. The cloud doesn't. | Treat it as Medium. |

---

## Passive and Active

`HumanConfidenceSource` says how the value was worked out.

| Source | How it was worked out | What you get |
| ------ | --------------------- | ------------ |
| Passive | From the request alone, before any browser tests ran. | `HumanConfidence` is the value, High, Medium, or Low. |
| Active | The browser also ran the 51Degrees browser tests, and the cloud judged their answers. | `HumanConfidence` is a sealed result. The browser carries it but can't read or change it. Your server sends it back to the cloud with its License Key to get the value. See @ref Services_Cloud_HumanConfidence. |

So read `HumanConfidenceSource` before you read `HumanConfidence`. Never trust a value the browser sends to your server, because a browser can send anything. Trust a value your server got from the cloud.

---

## When the results arrive

Asking for `HumanConfidence` on a page adds the browser tests to the 51Degrees client script. That changes when the script reports complete.

- **On a page.** The first response already holds every property, with a Passive `HumanConfidence`. The client script then runs the browser tests and sends their answers back. It reports complete, firing `fod.complete` and resolving `fod.promise`, only once that second response has arrived. So code you run in `fod.complete` runs later than it would without Human Confidence: after the tests have run and one more request has come back. The tests stop after at most 30 seconds, so the page is never left waiting for ever. `fod.onChange` and the `fod` object have the first response's properties straight away.
- **When the tests answer.** The second response gives an Active source and the sealed result. Where the tests couldn't run, it gives a Passive source and the value.
- **On a server, with no page.** A server that asks the cloud for `HumanConfidence` and doesn't pass the page's JavaScript on gets a Passive value straight away, with no delay.
- **A 51Did.** A request that asks for a 51Did and `HumanConfidence` gets its 51Did on the response that carries the browser test answers, not the first one. Every other property still comes on the first response. See *When the request also asks for Human Confidence* on @ref Identifiers_51Did.

If you only need a property that doesn't depend on Human Confidence, read it in `fod.onChange` or from the `fod` object, rather than waiting for `fod.complete`.

---

## What your page's Content Security Policy must allow

The browser tests run in the visitor's browser. If your page sets a Content Security Policy, it must allow:

- `script-src` with the 51Degrees cloud host, for example `https://cloud.51degrees.com`, and `'unsafe-eval'`
- `connect-src` with the same cloud host, so the client script can send the answers back
- `worker-src blob:`

A page whose policy blocks any of these can't run the tests. It still gets its properties, and a Passive `HumanConfidence`, but never an Active one. A 51Did made for it carries Absent.

---

## Human Confidence in a 51Did

When a request asks for a 51Did and `HumanConfidence`, and the browser tests work out the value, the 51Did carries it. Anyone you pass the 51Did to can then check it was made for a person, with their own License Key valid for Human Confidence. A 51Did made any other way carries Absent, meaning no value was worked out. See *Human Confidence in a 51Did* on @ref Identifiers_51Did.

---

## Two ways to use it

**Measure.** Send Human Confidence to your analytics as a custom dimension and your reports show how much of your traffic is likely to be people. Nothing changes for your visitors. The steps for any analytics tool are in @ref HumanConfidence_Analytics, and there's a separate page for Google Analytics 4, @ref Integrations_GoogleAnalytics.

**Act.** Your server gets Human Confidence from the cloud before it sends a page and decides what to send. See @ref Services_Cloud_HumanConfidence for the code.

You can do either on its own, or measure first and act once you know your numbers.

---

## Crawlers that say what they are

Search engines and other crawlers that name themselves don't need Human Confidence. The crawler properties identify them by name and by what they use your content for, and those properties are on every plan, including the free one.

Human Confidence needs the Pro plan, which you can [buy online](https://51degrees.com/referrer?url=https%3A%2F%2F51degrees-eu.chargifypay.com%2Fsubscribe%2Fsby5q4mtwdrd%2Fpro-monthly&conversion=SignUp), or the Bespoke plan for your own servers. Ask us about Bespoke through the [contact page](https://51degrees.com/contact-us).

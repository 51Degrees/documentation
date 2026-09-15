@page Identifiers_Overview Overview

**51Did** (51Degrees Identifier) and the **PMP** (Preference Management Platform) work together. The platform asks the visitor how they want their data used for marketing, and the identifier is created from that answer along with what the cloud knows about the device and the network.

- **51Did** - signed identifier (a base64 OWID envelope) carrying a probabilistic value, derived from three inputs: the **Device ID** (a `Hardware-Platform-Browser-IsCrawler` tuple produced by Device Detection), the **client IP**, and the **usage purpose** (`non-marketing`, `standard`, or `personalized`) declared per request. See @ref Identifiers_51Did for the identifier-versus-value distinction.
- **PMP** - one script tag that asks the visitor the question in their own language, keeps the answer, and can carry it across a group of sites you name. The three answers are the three `id.usage` values, so nothing is translated on the way to the cloud. See @ref Identifiers_PMP.

## Flow

```
Visitor → PMP → answer → id.usage → 51Did → downstream
```

The identifier is created only after every other value on the page has been resolved and an answer is present, so a page where nobody was asked produces no identifier.

## Use one without the other when

- **PMP alone** - you need to collect a visitor's marketing preference and act on it directly (e.g. gate ad personalization, drive a paywall), without feeding it into 51Did.
- **51Did alone** - `id.usage=non-marketing` for fraud or suspicious activity, where the usage is set by the integrator rather than by the visitor, or a page running a third party consent management platform, where the answer arrives as a consent string instead. See @ref Identifiers_PMP_CmpWiring.

See @ref Identifiers_51Did and @ref Identifiers_PMP. 51Did depends on @ref DeviceDetection_Overview.

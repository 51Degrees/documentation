@page Identifiers_Overview Identifiers overview

This section covers three products. **51Did** (51Degrees Identifier) is a signed identifier downstream systems can compare and verify without seeing the inputs it was made from. **PMP** (Preference Management Platform) is a widget that asks the visitor for the marketing preference a 51Did carries, and **ADI** (Ad Inspector) is a widget that shows the visitor, on an ad, the preference carried by that ad's 51Did.

- **51Did** - signed identifier (a base64 OWID envelope) that records the **usage purpose** (`non-marketing`, `standard`, or `personalized`) declared per request and carries a match key. For the probabilistic type the match key is derived from the **Device ID** (a `Hardware-Platform-Browser-IsCrawler` tuple produced by Device Detection) and the **client IP**. The random and hashed email types, and the difference between the identifier and its match key, are described on @ref Identifiers_51Did.
- **PMP** - embeddable widget that captures a marketing preference (`non-marketing`, `standard` or `personalized`) suitable as `id.usage` input to 51Did.
- **ADI** (Ad Inspector) - embeddable widget that puts an icon on each ad slot the page marks or names, checks the signature of the 51Did that went into the ad auction in the browser, and tells the visitor in one sentence why the ad was served.

## Flow

```
User → PMP → preference → id.usage → 51Did → downstream
```

## Use one without the other when

- **PMP alone** - you need to collect a user marketing preference and act on it directly (e.g. gate ad personalization, drive a paywall), without feeding it into 51Did.
- **51Did alone** - `id.usage=non-marketing` (e.g. fraud or suspicious activity), where the preference is set by the integrator rather than the user.

See @ref Identifiers_51Did, @ref Identifiers_PMP and @ref Identifiers_ADI. 51Did depends on @ref DeviceDetection_Overview.

@page Identifiers_Overview Overview

**51DiD** (51Degrees Identifier) and **PMP** (Privacy Marketing Preference) are derived signals downstream systems can act on without seeing the raw inputs.

- **51DiD** - signed, probabilistic ID derived from three inputs: the **Device ID** (a `Hardware-Platform-Browser-IsCrawler` tuple produced by Device Detection), the **client IP**, and the **usage purpose** (`non-marketing`, `standard`, or `personalized`) declared per request.
- **PMP** - embeddable widget that captures a marketing preference (`standard` / `personalized`) suitable as `id.usage` input to 51DiD.

## Flow

```
User → PMP → preference → id.usage → 51DiD → downstream
```

## Use one without the other when

- **PMP alone** - you need to collect a user marketing preference and act on it directly (e.g. gate ad personalization, drive a paywall), without feeding it into 51DiD.
- **51DiD alone** - `id.usage=non-marketing` (e.g. fraud or suspicious activity); the preference is set by the integrator, not the user.

See @ref Identifiers_51DiD and @ref Identifiers_PMP. 51DiD depends on @ref DeviceDetection_Overview.

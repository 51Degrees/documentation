@page Identifiers_Overview Overview

**51Did** (51Degrees Identifier) and **PMP** (Privacy Marketing Preference) are derived signals downstream systems can act on without seeing the raw inputs.

- **51Did** - signed identifier (a base64 OWID envelope) carrying a probabilistic value, derived from three inputs: the **Device ID** (a `Hardware-Platform-Browser-IsCrawler` tuple produced by Device Detection), the **client IP**, and the **usage purpose** (`non-marketing`, `standard`, or `personalized`) declared per request. See @ref Identifiers_51Did for the identifier-versus-value distinction.
- **PMP** - embeddable widget that captures a marketing preference (`standard` / `personalized`) suitable as `id.usage` input to 51Did.

## Flow

```
User → PMP → preference → id.usage → 51Did → downstream
```

## Use one without the other when

- **PMP alone** - you need to collect a user marketing preference and act on it directly (e.g. gate ad personalization, drive a paywall), without feeding it into 51Did.
- **51Did alone** - `id.usage=non-marketing` (e.g. fraud or suspicious activity); the preference is set by the integrator, not the user.

See @ref Identifiers_51Did and @ref Identifiers_PMP. 51Did depends on @ref DeviceDetection_Overview.

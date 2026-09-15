@page Services_Cloud_Overview Cloud Service Overview

The Cloud Service comes in two forms: the Cloud hosted by 51Degrees, which this page describes, and the [Self-Hosted Docker](@ref Services_Cloud_SelfHostedDocker) image, which serves the same API from your own infrastructure and authenticates with your License Key alone, supplied once when the container starts.

There are a couple methods to integrate the hosted Cloud Service, but regardless of the integration method you will need a credential: a [Resource Key](@ref Services_Cloud_ResourceKeys), or, on the json and js endpoints, a License Key for callers that manage their own property list.

---

# Authentication

Supply a Resource Key in any of these places, checked in order (first match wins): **HTTP header** (`X-51D-Resource-Key`), **route** (`/api/v4/<resource_key>.json`), **query string** (`?resource=`), or **form body**. A License Key is supplied the same way but has no v4 route: **HTTP header** (`X-51D-License-Key`), **query string** (`?license=`), or **form body**. Form fields are only read from a `POST` request.

The json and js endpoints also accept a License Key alone (no Resource Key), in which case the caller must list the properties they want via the `values` parameter (`X-51D-Values` header, `?values=`, or a form field). The OWID public key endpoint (`/owid/api/v3/public-key`) accepts a License Key alone as well, and needs no `values` list because its payload is fixed. Every other v4 endpoint still requires a Resource Key. See [Resource Keys](@ref Services_Cloud_ResourceKeys) for details.

A Licence Key supplied by something that looks like a web browser can be refused with `401` on the v4 and OWID endpoints, to stop a key that identifies and bills your account being published in a page where anyone can read it. A Resource Key is never affected. See [Licence Key used from a web browser](@ref Services_Cloud_ErrorMessages) for what the refusal says and the three ways to resolve it.

# Derived properties

Most properties are read from a data file by the engine that owns them, and
arrive in the response under that engine's own section, such as `device` or
`ip`. A **derived property** is different. It is calculated from other
properties rather than read from a file, so it does not belong to any one
engine and arrives in its own top level `derived` section.

Two things follow that catch people out.

Ask for it by its qualified name. `values=derived.HumanConfidence` works and
`values=HumanConfidence` does not. The service matches each requested name
against its list of `element.property` names and drops a name it cannot
match, so a request that asks for the bare name alone is answered with the
@ref Properties_not_available_with_this_subscription "properties not available with this subscription"
warning, which reads like an entitlement problem and is not one.

Read it from the `derived` section, not from `device` or `ip`.

```json
{
  "derived": {
    "humanconfidence": "Medium"
  }
}
```

Where there is no value, a `humanconfidencenullreason` sibling says why, in
the same way as every other property.

## HumanConfidence

`HumanConfidence` answers how confident 51Degrees is that a request came
from a device being used by a person who is looking at the page. It returns
`High`, `Medium` or `Low`.

It reads several things that describe the request, including whether the
client is a known crawler, whether automation is driving the browser,
whether the browser is running without a screen, how old the browser build
is, what the address itself suggests, and whether the page is actually in
view.

**It has no value until the 51Degrees JavaScript has run.** Two of the
properties it reads, whether the window is in view (`device.IsVisible`) and
whether the browser advertises a web driver (`device.HasWebDriver`), are set
by that JavaScript on the client and cannot be known from an HTTP request,
because the server sees headers rather than a screen. A request answered by
the server alone, which includes the first request of a browser session and
every server to server integration, therefore carries no value, and the
`humanconfidencenullreason` beside it names the two properties that were
missing. The second and later requests of a browser session carry the
value. An empty first answer is the property working rather than a fault,
so include the JavaScript before drawing conclusions from it.

# Caching

Most v4 responses, including the detection endpoints, are cacheable only by the caller's own cache (`Cache-Control: private`). A few endpoints that never return cacheable content, such as `/api/v4/info`, `/api/v4/resource` and `/api/v4/oauth`, return `Cache-Control: no-store`. When a credential or the `values` list is supplied via an `X-51D-*` header rather than in the URL, the response is returned `Cache-Control: no-store` instead, since the header is not part of the URL a shared cache would key on.

---

# RESTful API


In the most raw form Cloud Service is accessible via a RESTful API, documented in the [Cloud REST API reference](https://cloud.51degrees.com/api-docs/index.html).

---

# Libraries


Cloud Service can also be used via a language-specific library wrapping the API calls:

See corresponding examples for one of the services:
- [Device Detection Cloud Console](@ref DeviceDetection_Examples_GettingStarted_Console_Cloud)
- [Device Detection Cloud Web](@ref DeviceDetection_Examples_GettingStarted_Web_Cloud)
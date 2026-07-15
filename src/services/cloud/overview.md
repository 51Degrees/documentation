@page Services_Cloud_Overview Cloud Service Overview

There are a couple methods to integrate the Cloud Service, but regardless of the integration method you will need a credential: a [Resource Key](@ref Services_Cloud_ResourceKeys), or, on the json and js endpoints, a License Key for callers that manage their own property list.

This page describes the hosted Cloud Service. The [Self-Hosted Docker](@ref Services_Cloud_SelfHostedDocker) image serves the same API from your own infrastructure and uses no Resource Keys at all: every request is authorized by the License Key(s) the container is started with.

---

# Authentication

Supply a Resource Key in any of these places, checked in order (first match wins): **HTTP header** (`X-51D-Resource-Key`), **route** (`/api/v4/<resource_key>.json`), **query string** (`?resource=`), or **form body**. A License Key is supplied the same way but has no v4 route: **HTTP header** (`X-51D-License-Key`), **query string** (`?license=`), or **form body**. Form fields are only read from a `POST` request.

The json and js endpoints also accept a License Key alone (no Resource Key), in which case the caller must list the properties they want via the `values` parameter (`X-51D-Values` header, `?values=`, or a form field). Every other v4 endpoint still requires a Resource Key. See [Resource Keys](@ref Services_Cloud_ResourceKeys) for details.

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
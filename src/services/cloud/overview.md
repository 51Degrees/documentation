@page Services_Cloud_Overview Cloud Service Overview

There are a couple methods to integrate the Cloud Service, but regardless of the integration method you will need a credential: a [Resource Key](@ref Services_Cloud_ResourceKeys), or a License Key for callers that manage their own property list.

---

# Authentication

Supply a Resource Key in any of these places, checked in order (first match wins): **HTTP header** (`X-51D-Resource-Key`), **route** (`/api/v4/<resource_key>.json`), **query string** (`?resource=`), or **form body**. A License Key is supplied the same way but has no v4 route: **HTTP header** (`X-51D-License-Key`), **query string** (`?license=`), or **form body**.

A caller can also authenticate with a License Key alone (no Resource Key), in which case they must list the properties they want via the `values` parameter (`X-51D-Values` header, `?values=`, or a form field). The OWID `public-key` and `creator` endpoints accept the same credentials (header, query, or form) and take a bare License Key with no `values` list; each call is metered against the supplied credential. See [Resource Keys](@ref Services_Cloud_ResourceKeys) for details.

---

# RESTful API


In the most raw form Cloud Service is accessible via a RESTful API, documented in the [Cloud REST API reference](https://cloud.51degrees.com/api-docs/index.html).

---

# Libraries


Cloud Service can also be used via a language-specific library wrapping the API calls:

See corresponding examples for one of the services:
- [Device Detection Cloud Console](@ref DeviceDetection_Examples_GettingStarted_Console_Cloud)
- [Device Detection Cloud Web](@ref DeviceDetection_Examples_GettingStarted_Web_Cloud)
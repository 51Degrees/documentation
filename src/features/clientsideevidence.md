@page Features_ClientSideEvidence Client-side Evidence

# Introduction

@Evidence will usually be drawn from one of four places:

* HTTP headers
* Cookies
* Query parameters
* Request metadata such as source IP address

Any device making a request to a web site will include some of this information.
For example, the User-Agent HTTP header is almost always populated as part of a
request.
In some cases though, additional @evidence providing more detail can be obtained
from code running directly on the client device. In some cases, this may even be 
required.
For example, this technique can be used to retrieve the latitude and longitude 
from devices that have this capability.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/features/web-integration.md#client-side-features)
for more technical details.

# Client-side data

When using the client-side evidence integration, the first step is for the @Pipeline
to produce a JSON representation of all the properties that have been populated
by @flowelements.

Each property may also have some meta-data associated with it in the form of 
another property or attribute. The naming convention of meta-data properties 
is the related property name with a suffix. e.g., 

```json
"device": {
	"javascript": "",
	"javascriptdelayexecution": true
}
```

List of suffixes:

| Suffix | Description |
| ------ | ----------- |
| ``nullreason`` | If the result for a property is null this field will be populated with a reason as to why there is no result. |
| ``delayexecution`` | If this value is true the related property is a JavaScript property and will not run immediately when evaluating the JavaScript Resource. |
| ``evidenceproperties`` | A list of JavaScript properties which need to be evaluated first before this property can be populated. |

This JSON data is sent to the client along with some JavaScript that is used to
handle updating that JSON payload with new property values determined from 
client-side evidence as well as provide easy access to the property values 
in client-side JavaScript code.

# JavaScript properties

@Elementproperties include a 'Type' property that indicates the type of the 
data represented by the property's values.

JavaScript properties are simply properties that have their Type set to 'JavaScript'.
The value of such a property should be a snippet of JavaScript code that, when run on
the client device, will obtain some extra values from the device. 

@Elementproperties also include a 'DelayExecution' property which indicates if a 'JavaScript' property
should not be executed on the client straight away and a 'EvidenceProperties' property which
contains a list of JavaScript properties that, when executed, will obtain additional 
@evidence that can help in determining the value of this property.

# How it works

The JSON data management JavaScript will check for any properties of type 'JavaScript'
and execute them on the client or if the 'DelayExecution' property is set to true then 
the 'JavaScript' will only be executed in response to some user action. There are then two 
possible mechanisms to get these extra values back to the server in order for them to 
be included in the evidence used by the @Pipeline.

1. A background callback to the server yields updated JSON data that replaces 
the existing JSON payload.
2. The JavaScript property sets a cookie that is then sent to the server on the
next request.

## Background callback

A request is made to the server in the background that includes the extra values 
as form parameters. The server sends this through the pipeline and the result is 
packaged as JSON and sent in the response to the client, which will update it's 
JSON payload data, making the new values available to all client-side code.

Adding this feature to the page may result in data being written to the client
device using `cookies` or `sessionStorage` for efficiency.
Any keys prefixed with `51D_` are 51Degrees cookies,
and any keys prefixed with `fod_` are sessionStorage items used for efficient
evidence handling and data transfer.

This example shows the process flow between client and server.

@dotfile client-side-evidence-callback.gvdot

## Cookies on next request

When executed, the JavaScript property sets a cookie that is then sent to the 
server on the next request. The @Pipeline will automatically use these cookies
as @evidence so that the results it returns take account of the new information.

This example shows the process flow between client and server.

@dotfile client-side-evidence.gvdot

## Privacy Policy

If you are using this feature, especially when using the server-side capability
to return enriched data, it is your responsibility to consider any updates to
your customer privacy policy.

**This is not legal advice**, and you should consult your legal team for guidance.

If you are using the 51Degrees Cloud service, or would like to see an example
of how to describe this in your service that incorporates client-side evidence,
see our [Client Services Policy](https://51degrees.com/terms/client-services-privacy-policy/20240430).

For efficiency, we store limited data in cookies or session storage.
Anything prefixed `51D_` or `fod_` is related to 51Degrees **client-side evidence**
handling and is used solely for the purpose of enabling this technical feature.

## Storage Mechanism

By default, when using the 51Degrees Cloud service, values returned from client-side
evidence processing are stored using `sessionStorage`. This avoids setting any
cookies unless explicitly required. However, this behaviour can be changed by
adding the `fod-js-enable-cookies=true` query parameter to the resource key URL.
When set, this instructs the client-side script to use `cookies` instead of 
`sessionStorage` for storing data.

For more details on this parameter and related options, see the [Cloud API Documentation](https://cloud.51degrees.com/api-docs/index.html).

# Web integration

The **client-side evidence** feature requires multiple @Pipeline components to operate
together. There are @webintegration solutions for various web frameworks that handle 
most of the complexity for you.

These solutions are generally enabled by default but do require some additional 
configuration in order to function. The implementations vary significantly based 
on the language and framework, but the core steps will involve the following:

- Make a change to request the initial JavaScript with JSON payload. 
For example, by adding a JavaScript include.
- If using the **background callback** mechanism:
  - Create an endpoint that can pass requests to the @Pipeline and serve the 
  required JSON response. *
  - Configure the JavaScriptBuilderElement with the URL for your endpoint. *
  - Add some JavaScript code to update the page content when new JSON data is
  received.

(*) These tasks are handled automatically by the ASP.NET Core, Java MVC 
and Java Servlet integrations

For more detailed, language-specific steps, see the 
[web integration examples](@ref Examples_WebIntegration) or the engine-specific 
examples such as the 
[device detection examples](@ref Examples_DeviceDetection_GettingStarted_Web_Index)
or [reverse geocoding examples](@ref Examples_ReverseGeocoding_WebIntegration_Examples).

# Static and Quasi-Static Script Approaches

## Overview
51Degrees provides multiple ways to integrate device detection using client-side JavaScript evidence collection.
The default approach is a dynamic integration scenario, but semi-static and conceptual static methods can also be used depending on implementation constraints.

### Dynamic Scenario (Default)
In a dynamic integration scenario, the client-side evidence collection script is generated dynamically for each request.
This ensures that the JavaScript snippets used for detection are always specific to the client’s device or browser context.
A typical integration example:
```html
<script src="<51degrees.core.js URL>"></script>
```
The `src` attribute points to a 51Degrees client-side evidence endpoint that dynamically produces the `51degrees.core.js` script.
This script includes JavaScript snippets that perform client-side evidence collection.

## Process Overview

### Dynamic Generation
* The script is generated for every request based on initial evidence (e.g., User-Agent).
* JavaScript snippet properties are retrieved from the data file on the server.
* The final script differs depending on the detected client type.

### Snippet Retrieval and Integration
* Snippet properties are stored within the 51Degrees data file.
* The Device Detection Engine retrieves these as part of the detection results.
* Example:
  * If the User-Agent indicates an iPhone, the `javascripthardwareprofile` property contains iPhone-specific code.
  * If it indicates macOS, the property contains Mac-specific code.
* These snippets are updated daily with the data file.

### Script Assembly
* The JSONBuilderElement and JavaScriptBuilderElement (part of the 51Degrees @Pipeline) inject the snippet properties into a JavaScript template.
* Templates are available at: (https://github.com/51Degrees/javascript-templates).
* The result is the complete `51degrees.core.js` script.

### Client-Side Execution
* The `51degrees.core.js` script executes each snippet sequentially in the client browser.
* Snippets store collected evidence as session storage (or cookies) using `51D_` prefixes, for example:
  * `51D_profileIds`
* This evidence can be sent to the server or accessed in client code through a callback such as:
```js
fod.complete(function() {
    // Handle collected evidence here
});
```

### Profile Matching
* The collected `51D_profileIds` values must be matched against the same data file used to generate the snippets.
* This ensures accurate and consistent device identification.

## Semi-Static Scenario

If your environment already includes a static script (e.g., `<script src="<myscript.js URL>">`) and cannot add another dynamically generated one, a semi-static integration approach is recommended.
This method merges 51Degrees-generated snippets into your existing script, allowing some dynamic behaviour while maintaining a mostly static setup.

### Implementation Options

### Option 1 — Dynamic Merge per Request
* Modify your existing script to be generated dynamically on your server.
* Pass all HTTP header evidence to the 51Degrees @Pipeline during script generation.
* The @Pipeline returns an appropriate version of the snippet (e.g., different for iPhone, iPad, or Mac).
* Your script includes that snippet dynamically before returning it to the client.

### Option 2 — Cached Variants (Semi-Static)
* Pre-generate and cache short-lived variants of the 51Degrees-generated script for device groups (e.g., iPhone, iPad, Mac).
* Your script can decide which cached snippet to load based on basic client-side conditions.
* Cached variants should be refreshed whenever the data file updates.
* Always ensure that `51D_profileIds` are matched against the same data file from which snippets were derived.

## Conceptual Static Approach
In some cases, a fully static integration may be necessary — for example, in restricted hosting environments, strict CDNs, or offline deployments.
This approach trades flexibility for control and simplicity.

### Implementation Considerations
* **Extraction** - Extract relevant JavaScript snippets (for specific device groups such as iPhones) directly from the current 51Degrees data file.
* **Maintenance** - Refresh static scripts daily or as frequently as possible to remain synchronized with data file updates.
* **Customization** - Implementation details depend on your environment.
There is no one-size-fits-all static solution. Stale or outdated static scripts can lead to incorrect device identification.

### Comparison Summary
| Approach Type | Script Generation | Update Frequency | Typical Use Case |
| ------------- | ----------------- | ---------------- | ---------------- |
| Dynamic (Default) | Fully dynamic per request | Real-time | Standard 51Degrees integration for dynamic or modern sites |
| Semi-Static | Cached or merged dynamically | On data file update | When dynamic script loading is restricted |
| Conceptual Static | Fully static (manually updated) | Daily or frequent manual refresh | Static environments or high-security contexts |

### Best Practices

### Synchronization
* Always ensure that the client-side snippets and server-side data file originate from the same data file version. Mismatched versions can cause inaccurate device matching or inconsistent detection results.

### Data File Updates
* Refresh your data file and any cached or static snippets daily (or as frequently as your infrastructure allows).
* Automate the refresh process wherever possible to prevent stale results.

### Caching Strategy
* For semi-static scenarios, limit cache lifetime to no longer than the data file update cycle.
* If using a CDN, configure cache invalidation or revalidation logic based on the 51Degrees data update frequency.

### Version Control
* Keep a record of the data file version or timestamp used to generate each JavaScript snippet.
* This helps debug inconsistencies between collected evidence and device matching.

### Fallback Handling
* Implement fallback logic for cases where no `51D_profileIds` are available (e.g., script blocked, or execution failed).
* Fallback can use baseline server-side detection or cached evidence.

### Testing
* Test across major device types (mobile, tablet, desktop) to ensure snippets behave correctly in different environments.
* Validate that the evidence collection keys (e.g., `51D_profileIds`) are properly populated in storage and transmitted.

### Security
* Avoid exposing sensitive internal URLs or raw data file paths in the browser.
* Serve dynamically generated scripts through your own API gateway or proxy if needed.

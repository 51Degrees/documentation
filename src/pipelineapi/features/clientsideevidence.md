@page PipelineApi_Features_ClientSideEvidence Client-side Evidence

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

Each property may also have some metadata associated with it in the form of 
another property or attribute. The naming convention of metadata properties 
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
see our [Client Services Policy](https://51degrees.com/terms/client-services-privacy-policy).

For efficiency, we store limited data in cookies or session storage.
Anything prefixed `51D_` or `fod_` is related to 51Degrees **client-side evidence**
handling and is used solely for the purpose of enabling this technical feature.

## Storage Mechanism

By default, when using the 51Degrees Cloud service, values returned from client-side
evidence processing are stored using `sessionStorage`. This avoids setting any
cookies unless explicitly required. However, this behaviour can be changed by
adding the `fod-js-enable-cookies=true` query parameter to the Resource Key URL.
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
[web integration examples](@ref PipelineApi_Examples_WebIntegration) or the engine-specific 
examples such as the 
[device detection examples](@ref DeviceDetection_Examples_GettingStarted_Web_Index)
or [reverse geocoding examples](@ref ReverseGeocoding_Examples_WebIntegration_Examples).

# Static and Quasi-Static Script Approaches

## Implementation Details

### Dynamic Scenario (default)
We call the following mechanics a dynamic integration scenario and this is the default scenario used by 51Degrees. The client-side evidence collecting script is usually inserted into the page as a script tag like: <script src="<51degrees.core.js URL>" /> which has `src` attribute pointing at the URL which hosts that 51Degrees Pipeline that dynamically produces this 51degrees.core.js script.
The script consists of the javascript snippet properties that actually do work on the client to collect the client side evidence.  These snippet-properties are retrieved from the data file on the server.  Thus the script is dynamically generated on every request and depends on the type of client (detected from initial evidence).

Here are the details:

1. JavaScript snippet properties that are later executed on the client are stored as part of the data file.  Device Detection Engine on the server retrieves them from the data file as normal properties as part of the detection results.  It is important to note that the values of these properties in the results (like any other properties) depend on the evidence initially provided - f.e. if User-Agent hints that the device is an iPhone, then `javascrpthardwareprofile` property will contain an iPhone-specific client-side code (that will detect the model more precisely upon execution).  If User-Agent signals that the client is a browser running on a macOS - `javascripthardwareprofile` property will contain a Mac-specific code.  There is a finite number of values for this property stored in the data file, but the data file updates daily and may update these JavaScript snippets as well.
2. JSONBuilderElement and JavaScriptBuilderElement that are part of the Pipeline pack and insert these properties into the JavaScript template (https://github.com/51Degrees/javascript-templates) and produce a complete JavaScript that contains these client-side detection snippets.
3. The `51degrees.core.js` JavaScript loads on the page and executes snippets one by one.
4. Upon execution `javascripthardwareprofile` and other snippets store the the collected client-side evidence as `51D_` prefixed sessionStorage (or cookie) keys that can be sent as evidence on subsequent requests to your server or you can collect them otherwise on the client (in your JavaScript) in the callback you pass to `fod.complete`.  Usually you would be interested in the `51D_profileIds` key that allows to match the `profileIds` agains the data file and get detailed information on the device.  Please note that these `profileIds` need to be matched against the same data file that the `javascripthardwareprofile` snippet was retrieved from.

### Semi-static Scenario

Let's imagine you already have some script tag like <script src="<myscript.js URL>" /> integrated into yours or your customer's web page and you can not for some reason integrate another script tag that would fetch dynamic JavaScript as described above.  You would like to have the client-side evidence detection snippets incorporated as part of your already-integrated script.

For this you will need to make your script dynamic to a certain extent and merge the 51Degrees-pipeline-generated script into your script.  You have to do so on every request passing the 51Degrees Pipeline all the HTTP header evidence you get when your script is fetched, because f.e. `javascripthardwareprofile` snippet will differ for iPhone, iPad and Mac.

Alternatively you can pre-generate a short-lived cached variants of the 51Degrees-generated script for iPhone / iPad / Mac devices and then in your script decide which snippet to run.  This may be a semi-static (cached until the next data file update) solution. The most important thing is that the detected `51D_profileIds` are matched against the same data file that `javascripthardwareprofile` snippets were obtained from on the server.

## Conceptual static approach

* Explain how a customer might extract relevant JavaScript for specific iPhone groups from the current data file.
* Recommend refreshing this script daily (or as frequently as possible) to align with 51Degrees’ data updates.
* Emphasise that exact implementation varies by environment and cannot be provided as a one-size-fits-all solution.

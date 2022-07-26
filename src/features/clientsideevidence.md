@page Features_ClientSideEvidence Client-side Evidence

# Introduction

@Evidence will usually be drawn from one of four places:

* HTTP headers
* Cookies
* Query parameters
* Request metadata such as source IP address

Any device making a request to a web site will include some of this information.
For example, the User Agent HTTP header is almost always populated as part of a
request.
In some cases though, additional @evidence providing more detail can be obtained
from code running directly on the client device. In some cases, this may even be 
required.
For example, this technique can be used to retrieve the latitude and longitude 
from devices that have this capability.

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

This example shows the process flow between client and server.

@dotfile client-side-evidence-callback.gvdot

## Cookies on next request

When executed, the JavaScript property sets a cookie that is then sent to the 
server on the next request. The @Pipeline will automatically use these cookies
as @evidence so that the results it returns take account of the new information.

This example shows the process flow between client and server.

@dotfile client-side-evidence.gvdot

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

\\* These tasks are handled automatically by the ASP.NET Core, Java MVC 
and Java Servlet integrations

For more detailed, language-specific steps, see the 
[web integration examples](@ref Examples_WebIntegration) or the engine-specific 
examples such as the 
[device detection examples](@ref Examples_DeviceDetection_GettingStarted_Web_Index)
or [reverse geocoding examples](@ref Examples_ReverseGeocoding_WebIntegration_Examples).
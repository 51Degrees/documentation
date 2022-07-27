@page DeviceDetection_Features_UserAgentClientHints User Agent Client Hints
# Introduction

User Agent Client Hints (UA-CH) are part of a Google proposal to replace the 
existing User Agent HTTP header.

For more details on what User Agent Client Hints are and how they work,
see the Background section below. If you just want to know how to
work with them using the 51Degrees API, then read on.

@anchor UACH_Support
# Support for detection from Client Hints [#](@ref UACH_Support)

The 51Degrees Device Detection API has provided support for detection 
based on one of the Client Hints headers (Sec-CH-UA only) in data files 
from 7 December 2020.

We also support the one-off case of [identifying Windows 11 using User Agent Client Hints](https://51degrees.com/blog/windows-11-detectable-with-uach)
as there is [no other way to do so](https://docs.microsoft.com/en-us/microsoft-edge/web-platform/how-to-detect-win11).

This limited support will be superseded by functionality in version 4.4, which will 
fully support the detection of devices, operating systems, and browsers from UA-CH headers. 

Full UA-CH detection will also require a [new data file](https://51degrees.com/blog/updates-to-user-agent-client-hints-version-4-4). The format of the data file remains the same (what we refer to as Hash v4.1). But the contents will be updated 
to support detection from the full range of UA-CH values.

Note that newer and older API versions and data files will be fully cross-compatible with each 
other. It's just that in order to perform detection using the full range of UA-CH values, you must 
be using BOTH version 4.4 of the API and a newer data file.

# Examples

We have [console](@ref Examples_DeviceDetection_GettingStarted_Console_Index) and 
[web](@ref Examples_DeviceDetection_GettingStarted_Web_Index) examples that include detection 
using User Agent Client Hints for both on-premise and cloud scenarios.

The console examples pass UA-CH values directly to the API, so will work in any situation.
The web examples run as a simple web page, so you will need a browser that supports UA-CH in 
order to try it out.

@anchor UACH_Http_Headers
# HTTP headers [#](@ref UACH_Http_Headers)

Previously, device detection worked primarily by examining the 
value of the User Agent HTTP header. This header is always sent as part 
of the first request to a webserver, meaning device information was 
available immediately on the server-side.

With UA-CH, only a limited subset of information is sent as part of the 
first request.
If the server wishes to know more, then it needs to set an HTTP header in
the response to request the additional detail.

The 51Degrees API will automatically determine the names and values of
any response headers that need to be set based on the initial information.

When using the Pipeline web integration, most languages will automatically set the response 
headers for you as well. If not using a web integration, or your language does not support it, 
you will need to set the response headers manually.

@anchor UACH_Http_Headers_Pseudoheaders
## Pseudo-headers [#](@ref UACH_Http_Headers_Pseudoheaders)

51Degrees groups properties associated with the request by ‘component’. The components 51Degrees recognize are hardware device, platform (operating system), browser, and crawler.

The User Agent header contains information relating to all four of these components. User Agent Client Hints values are different in that they relate to varying numbers of components. For example, the Sec-CH-UA-Model header only relates to the hardware device component.

However, multiple UA-CH values are sometimes needed to fully identify a component. Apple devices running Chrome will not populate the Sec-CH-UA-Model header, so that won't help give us an answer to the hardware component. Instead, we need the Sec-CH-UA-Platform header, which can at least tell us that this is an iOS device.

We concatenate the various UA-CH headers that are needed to identify a component to create ‘pseudo-headers’. These are then used internally to perform the detection. 

The table below shows which pseudo-headers are required in order to detect each component. These are the minimum pseudo-headers we use to detect the component; however, we recommend providing all UA-CH values for the best detection. Additionally, this table is only applicable for Chromium-based browsers; to detect non-Chromium browsers, you will need to continue supplying User Agent information.

Some pseudo-headers are not required to detect the component but can provide more detailed detection results. For example, Sec-CH-UA-Platform-Version is not required to determine the Platform component, but provides additional version information when supplied.

In some cases, there are multiple pseudo-headers for a component. These are processed in order from providing most detail to least. 

### Key
- x = This value is required in order to determine the component.
- x* = This value is not required, but if provided may return more detailed results.
- y and z = One of these values are required. Supplying y may return a more accurate result and removes the need to supply z.

|UA-CH header|Hardware|Platform|Browser/App|
|---|---|---|---|
|Sec-CH-UA|||z|
|Sec-CH-UA-Full-Version-List|||y|
|Sec-CH-UA-Model|x|||
|Sec-CH-UA-Mobile|x||x|
|Sec-CH-UA-Platform|x|x|x|
|Sec-CH-UA-Platform-Version||x*||

@anchor UACH_Cloud
## Cloud [#](@ref UACH_Cloud)

Using UA-CH for device detection with our cloud product is usually simple.
However, there are some scenarios that cause additional complexity.

@anchor UACH_Cloud_Pipeline_ServerSide
### Calling from Pipeline API [#](@ref UACH_Cloud_Pipeline_ServerSide)

If you are calling the cloud from a Pipeline API, then you need 
to ensure that the appropriate response headers are set and that the 
UA-CH headers are included in the request to cloud.

The Pipeline API can handle this for you for the most part. There are 
[console](@ref Examples_DeviceDetection_GettingStarted_Console_Cloud) and 
[web](@ref Examples_DeviceDetection_GettingStarted_Web_Cloud) examples 
available to show what changes you need to make for your language.
As this functionality requires new properties, you will need to create a new Resource Key 
that includes these: 
- SetHeaderHardwareAccept-CH
- SetHeaderPlatformAccept-CH
- SetHeaderBrowserAccept-CH

Alternatively, you can modify your site to set the necessary response headers yourself. The 
UA-CH values will automatically be sent to the cloud in order to perform detection.

@anchor UACH_Cloud_NonPipeline_ServerSide
### Calling from (non-Pipeline API) server-side code [#](@ref UACH_Cloud_NonPipeline_ServerSide)

As above, in order to use UA-CH, you'll just need to ensure that the 
appropriate response headers are set and that the UA-CH headers are 
then included in the request to the cloud.

Exactly what this looks like will vary by language, but there are 
two essential steps;

1. The relevant response headers must be set after a first request. Currently, this is the Accept-CH header for UA-CH. The 'SetHeader*' properties will provide a list of the values that need to be set on response headers in order to request the relevant UA-CH headers. Alternatively, you can just request all the [available](https://wicg.github.io/ua-client-hints/#http-ua-hints) values. 
2. The call to the cloud must be modified to include the UA-CH header values you are interested in. For example: `https://cloud.51degrees.com/api/v4/RESOURCEKEY.json?user-agent=UA&sec-ch-ua=HEADERVALUE&sec-ch-ua-model=HEADERVALUE2`

@anchor UACH_Cloud_ClientSide
### Calling from client-side code [#](@ref UACH_Cloud_ClientSide)	

Calling the cloud from client-side code is simpler in some ways, as you 
don't need to worry about manually including the Sec-CH-UA values in
the calls to the cloud.
However, it does have the additional complication that 
[Client Hints are not sent to third parties by default](https://web.dev/user-agent-client-hints/#hint-scope-and-cross-origin-requests).
To get around this, you will need to include the required values in the 
Permissions-Policy header:

- ch-ua-full-version-list=(self "https://cloud.51degrees.com")  
- ch-ua-platform=(self "https://cloud.51degrees.com")  
- ch-ua-platform-version=(self "https://cloud.51degrees.com")
- ch-ua-model=(self "https://cloud.51degrees.com")  

Note that the browser will only send UA-CH headers to the third party that are also 
requested by the first-party. This means that you'll also need to set your Accept-CH header 
to request the UA-CH headers:

- Sec-CH-UA  
- Sec-CH-UA-Mobile  
- Sec-CH-UA-Full-Version-List 
- Sec-CH-UA-Platform  
- Sec-CH-UA-Platform-Version
- Sec-CH-UA-Model  

@anchor UACH_JavaScriptAPI
# Client Hints JavaScript API [#](@ref UACH_JavaScriptAPI)	

Instead of using HTTP headers, the UA-CH values can be requested using a 
[JavaScript API](https://developer.mozilla.org/en-US/docs/Web/API/User-Agent_Client_Hints_API).
Unfortunately, this API formats the values differently to the values in the HTTP headers.
Currently, 51Degrees only supports detection using the HTTP header values.

If you need to use the JavaScript API to retrieve the values, care must be taken to ensure 
that the string values passed to the 51Degrees API exactly match the format of the values in the
HTTP headers. For example, if the value in the header is surrounded by double quotes, but the 
JavaScript API value does not include the double quotes, then these should be added in order to
give the best results.

@anchor UACH_Background
# Background reading [#](@ref UACH_Background)	

The authors of the proposal have created an [article](https://web.dev/user-agent-client-hints) 
covering how UA-CH works.
51Degrees has [blogged extensively](https://51degrees.com/resources/blogs/tag/Client%20Hints) 
on the subject. We also have an [explainer](https://learnclienthints.com/) and a 
[test page](https://51degrees.com/client-hints) 
that shows how UA-CH headers interact with the Accept-CH and Permissions-Policy response headers.

In May 2021, Google [outlined](https://blog.chromium.org/2021/05/update-on-user-agent-string-reduction.html) 
their plans for the rollout of UA-CH. This also mentioned that the deprecation of the 
existing User Agent string will not happen until at least 2022.
In September 2021, there was [further detail](https://blog.chromium.org/2021/09/user-agent-reduction-origin-trial-and-dates.html) 
about the plan for the phased deprecation of the User Agent.
This will start with Chrome 101 (roughly Q2 2022) and end with Chrome 113 (roughly Q2 2023).

User Agent Client Hints extends the previously existing Client Hints content 
negotiation feature.

There is documentation of the general Client Hints feature on 
[MDN](https://developer.mozilla.org/en-US/docs/Glossary/Client_hints) and
from [Google](https://web.dev/user-agent-client-hints/).

Caniuse.com can be used to check browser support for both 
[Client Hints](https://caniuse.com/client-hints-dpr-width-viewport) and 
[User Agent Client Hints](https://caniuse.com/mdn-api_navigator_useragentdata).







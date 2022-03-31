@page DeviceDetection_Features_UserAgentClientHints User-Agent Client Hints

# Introduction

User-Agent Client Hints (UACH) are part of a Google proposal to replace the 
existing User-Agent HTTP header.

For more details on what User-Agent Client Hints are and how they work,
see the Background section below. If you just want to know how to
work with them using the 51Degrees API then read on.

# Support for detection from Client Hints

The 51Degrees device detection API has provided support for detection 
based on one of the client hints headers (Sec-CH-UA only) in data files 
from 7th December 2020.

We also support the one off case of identifying Windows 11 using User Agent Client Hints as there
is [no other way to do so](https://docs.microsoft.com/en-us/microsoft-edge/web-platform/how-to-detect-win11).

This limited support will be superseded by functionality in a future version (exact version 
number TBC), which will fully support detection of devices, operating systems and browsers from 
UACH headers. 

This will also require a new data file (date of availability TBC). The format of the data file 
remains the same (what we refer to as Hash V4.1). But the contents will be updated to support 
detection from the full range of UACH values.

Note that newer and older API versions and data files will be fully cross-compatible with each 
other. It's just that in order to perform detection using the full range of UACH values, you must be 
using BOTH the future version of the API and a newer data file.

# Examples

We have [console](@ref Examples_DeviceDetection_GettingStarted_Console_Index) and 
[web](@ref Examples_DeviceDetection_GettingStarted_Web_Index) examples that include detection 
using User-Agent Client Hints for both on-premise and cloud scenarios.

The console examples pass UACH values directly to the API, so will work in any situation.
The web examples run as a simple web page, so you will need a browser that supports UACH in 
order to try it out.

# HTTP Headers

Previously, device detection worked primarily by examining the 
value of the User-Agent HTTP header. This header is always sent as part 
of the first request to a webserver, meaning device information was 
available immediately on the server-side.

With UACH, only a limited subset of information is sent as part of the 
first request.
If the server wishes to know more, then it needs to set an HTTP header in
the response to request the additional detail.

The 51Degrees API will automatically determine the names and values of
any response headers that need to be set based on the initial information.

When using the Pipeline web integration, most languages will automatically set the response 
headers for you as well. If not using a web integration, or your language does not support it, 
you will need to set the response headers manually.

## Cloud

Using UACH for device detection with our cloud product is usually simple.
However, there are some scenarios that cause additional complexity.

### Calling from Pipeline API

If you are calling the cloud from a Pipeline API then you need 
to ensure that the appropriate response headers are set and that the 
UACH headers are then included in the request to cloud.

The Pipeline API can handle this for you for the most part. There are 
[console](@ref Examples_DeviceDetection_GettingStarted_Console_Cloud) and 
[web](@ref Examples_DeviceDetection_GettingStarted_Web_Cloud) examples 
available to show what changes you need to make for your language.
As this functionality requires new properties, you will need to create a new resource key 
that includes these: SetHeaderHardwareAccept-CH, SetHeaderPlatformAccept-CH and 
SetHeaderBrowserAccept-CH.

Alternatively, you can modify your site to set the necessary response headers yourself. The 
UACH values will automatically be sent to cloud in order to perform detection.

### Calling from (non-Pipeline API) server-side code.

As above, in order to use UACH, you'll just need to ensure that the 
appropriate response headers are set and that the UACH headers are 
then included in the request to cloud.

Exactly what this looks like will vary by language, but there are 
2 essential steps.

1. The relevant response headers must be set after a first request. Currently, this is the Accept-CH header for UACH. The 'SetHeader*' properties will provide a list of the values that need to be set on response headers in order to request the relevant UACH headers. Alternatively, you can just request all the [available](https://wicg.github.io/ua-client-hints/#http-ua-hints) values. 
2. The call to cloud must be modified to include the UACH header values you are interested in. For example: `https://cloud.51degrees.com/api/v4/RESOURCEKEY.json?user-agent=UA&sec-ch-ua=HEADERVALUE&sec-ch-ua-model=HEADERVALUE2`

### Calling from client-side code. 

Calling the cloud from client-side code is simpler in some ways, as you 
don't need to worry about manually including the sec-ch-ua values in
the calls to cloud.
However, it does have the additional complication that 
[Client Hints are not sent to third parties by default](https://web.dev/user-agent-client-hints/#hint-scope-and-cross-origin-requests).
To get around this, you will need to include the required values in the 
Permissions-Policy header:

- ch-ua-full-version-list=(self "https://cloud.51degrees.com")  
- ch-ua-platform=(self "https://cloud.51degrees.com")  
- ch-ua-platform-version=(self "https://cloud.51degrees.com")
- ch-ua-model=(self "https://cloud.51degrees.com")  

Note that the browser will only send UACH headers to the third party that are also 
requested by the first-party. This means that you'll also need to set your Accept-CH header 
to request the UACH headers:

- sec-ch-ua  
- sec-ch-ua-mobile  
- sec-ch-ua-full-version-list 
- sec-ch-ua-platform  
- sec-ch-ua-platform-version
- sec-ch-ua-model  

# Client Hints JavaScript API

Instead of using HTTP headers, the UACH values can be requested using a 
[JavaScript API](https://developer.mozilla.org/en-US/docs/Web/API/User-Agent_Client_Hints_API).
Unfortunately, this API formats the values quite differently to the values in the HTTP headers.
Currently, 51Degrees only supports detection using the HTTP header values.

If you need to use the JavaScript API to retrieve the values, care must be taken to ensure 
that the string values passed to the 51Degrees API exactly match the format of the values in the
HTTP headers. For example, if the value in the header is surrounded by double quotes, but the 
JavaScript API value does not include the double quotes, then these should be added in order to
give the best results.

# Background Reading

The authors of the proposal have created an [article](https://web.dev/user-agent-client-hints) 
covering how UACH works.
51Degrees has also [blogged](https://51degrees.com/blog/user-agent-client-hints-chrome-89-update) 
[extensively](https://51degrees.com/blog/user-agent-client-hints-update-september-2020) on the subject.
We also have an [explainer](https://learnclienthints.com/) and a [test page](https://51degrees.com/client-hints) 
that shows how UACH headers interact with the Accept-CH and Permissions-Policy response headers.

In May 2021, Google [outlined](https://blog.chromium.org/2021/05/update-on-user-agent-string-reduction.html) 
their plans for the rollout of UACH. This also included mention that the deprecation of the 
existing User-Agent will not happen until at least 2022.
In Sept 2021, there was [further detail](https://blog.chromium.org/2021/09/user-agent-reduction-origin-trial-and-dates.html) 
about the plan for the phased deprecation of the User-Agent.
This will start with Chrome 101 (roughly Q2 2022) and end with Chrome 113 (roughly Q2 2023).

User-Agent Client Hints extends the previously existing Client Hints content 
negotiation feature.

There is documentation of the general Client Hints feature on 
[MDN](https://developer.mozilla.org/en-US/docs/Glossary/Client_hints) and
from [Google](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/client-hints)

Caniuse.com can be used to check browser support for both 
[Client Hints](https://caniuse.com/client-hints-dpr-width-viewport) and 
[User-Agent Client Hints](https://caniuse.com/mdn-api_navigator_useragentdata).







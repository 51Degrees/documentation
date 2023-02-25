@page DeviceDetection_Features_UACH_Overview Overview

# Introduction

User Agent Client Hints (UA-CH) are part of a Google proposal to replace the 
existing User-Agent HTTP header.

This page gives an overview of UA-CH detection in our API and guidance in 
navigating our documentation around UA-CH.

This topic has the following sub pages:

- [Headers](@ref DeviceDetection_Features_UACH_Headers) - How to use UA-CH HTTP headers with our API.
- [JavaScript](@ref DeviceDetection_Features_UACH_Javascript) - How to use the UA-CH JavaScript API with our API.
- [Required Values](@ref DeviceDetection_Features_UACH_RequiredValues) - Which UA-CH values do I need?

In addition, we have examples that demonstrate detection using UA-CH in a variety of scenarios:

- [On-premise console](@ref Examples_DeviceDetection_GettingStarted_Console_Index) 
- [On-premise web page](@ref Examples_DeviceDetection_GettingStarted_Web_Index) 
- [Cloud console](@ref Examples_DeviceDetection_GettingStarted_Console_Cloud) 
- [Cloud web page](@ref Examples_DeviceDetection_GettingStarted_Web_Cloud)
- Our [Configurator](https://configure.51degrees.com/) site includes an example on the 3rd page for how to implement a fully client-side solution that calls our cloud service directly.

The console examples pass UA-CH values directly to the API, so will work in any situation.
The web examples run as a simple web page, so you will need a browser that supports UA-CH in 
order to try it out.

@anchor UACH_Support
[#](@ref UACH_Support)
# Support for detection from Client Hints

The 51Degrees Device Detection API has provided support for detection 
based on one of the Client Hints headers (Sec-CH-UA) in data files 
from 7 December 2020. Full support for the detection of devices, operating systems, and browsers from UA-CH headers was added in Version 4.4 and data files from [June 2022 onwards](https://51degrees.com/blog/updates-to-user-agent-client-hints-version-4-4).

This support also includes [identifying Windows 11 using User Agent Client Hints](https://51degrees.com/blog/windows-11-detectable-with-uach)
as there is [no other way to do so](https://docs.microsoft.com/en-us/microsoft-edge/web-platform/how-to-detect-win11).

Support for getting values using the UA-CH [JavaScript API](https://developer.mozilla.org/en-US/docs/Web/API/User-Agent_Client_Hints_API) was added in API versions from [TODO DATE] and data files from [TODO DATE].

# Guidance

UA-CH has several different mechanisms for accessing these values. The following section 
explains our recommendations for different use-cases.

- On-premise direct to browser:
  - If you are using our web integration, ensure the `SetHeaderBrowserAccept-CH`, `SetHeaderHardwareAccept-CH` and `SetHeaderPlatformAccept-CH` properties are included (all properties are included by default for on-premise). Our software will ensure the `Accept-CH` header is set to request the client hints you need from the browser.
  - If you are not using our web integration, see the 'non-integrated' section on the [UA-CH Headers page](@ref DeviceDetection_Features_UACH_Headers)
- On-premise B2B service supplier:
  - If you are using our web integration, ensure the `JavascriptGetHighEntropyValues` property is included (all properties are included by default for on-premise). This will use the UA-CH JavaScript API to get the values you need.
  - If you are not using our web integration, see the 'non-integrated' section on the [UA-CH JavaScript page](@ref DeviceDetection_Features_UACH_Javascript).
  - For better performance - You'll need ask your clients to set `Delegate-CH` or `Permissions-Policy`. This will allow their user's browser to send UA-CH values to your service.
- Calling our cloud service from client-side code:
  - Simple option - Ensure your resource key includes the `JavascriptGetHighEntropyValues` property. This will gather the values and send them to our cloud service.
  - For better performance - Set `Delegate-CH` or `Permissions-Policy` as described in the 'Cloud' section on the [UA-CH Headers page](@ref DeviceDetection_Features_UACH_Headers)


@anchor UACH_Background
[#](@ref UACH_Background)	
# Background reading 

The authors of the proposal have created an [article](https://web.dev/user-agent-client-hints) 
covering how UA-CH works.
51Degrees has [blogged extensively](https://51degrees.com/resources/blogs/tag/Client%20Hints) 
on the subject. We also have an [explainer](https://learnclienthints.com/) and a 
[test page](https://51degrees.com/client-hints) 
that shows how UA-CH headers interact with the Accept-CH and Permissions-Policy response headers.

In May 2021, Google [outlined](https://blog.chromium.org/2021/05/update-on-user-agent-string-reduction.html) 
their plans for the rollout of UA-CH. This also mentioned that the deprecation of the 
existing User-Agent will not happen until at least 2022.
In September 2021, there was [further detail](https://blog.chromium.org/2021/09/user-agent-reduction-origin-trial-and-dates.html) 
about the plan for the phased deprecation of the User-Agent.
This will start with Chrome 101 (roughly Q2 2022) and end with Chrome 113 (roughly Q2 2023).

User Agent Client Hints extends the previously existing Client Hints content 
negotiation feature.

There is documentation of the general Client Hints feature on 
[MDN](https://developer.mozilla.org/en-US/docs/Glossary/Client_hints) and
from [Google](https://web.dev/user-agent-client-hints/).

Caniuse.com can be used to check browser support for both 
[Client Hints](https://caniuse.com/client-hints-dpr-width-viewport) and 
[User Agent Client Hints](https://caniuse.com/mdn-api_navigator_useragentdata).

Finally, on 28 September 2022, we hosted a webinar discussing User Agent Client Hints and the
future of the User-Agent. [Watch the webinar recording here](https://vimeo.com/755026259).

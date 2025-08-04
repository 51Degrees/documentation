@page DeviceDetection_Features_UACH_Overview UA-CH Overview

# Introduction

User-Agent Client Hints (UA-CH) are part of a Google proposal to replace the existing User-Agent HTTP header.

This page gives an overview of UA-CH detection in our API. It also provides guidance on which mechanism to use based on your use-case.

## Two ways to retrieve UA-CH values


You can retrieve UA-CH values using either of these methods:

- **HTTP headers** - Set headers in your response to ask the browser to send UA-CH values
- **JavaScript API** - Use client-side JavaScript to retrieve UA-CH values directly

See the [Guidance](@ref UACH_Guidance) section below if you're unsure which to use.

This topic has the following subpages:

- [Headers](@ref DeviceDetection_Features_UACH_Headers) - How to use UA-CH HTTP headers with our API.
- [JavaScript](@ref DeviceDetection_Features_UACH_Javascript) - How to use the UA-CH JavaScript API with our API.
- [Required Values](@ref DeviceDetection_Features_UACH_RequiredUachHeaders) - Which UA-CH values do I need?

## Examples


We have examples that demonstrate UA-CH detection in various scenarios:

- [On-premise console](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise) 
- [On-premise web page](@ref DeviceDetection_Examples_GettingStarted_Web_OnPremise) 
- [Cloud console](@ref DeviceDetection_Examples_GettingStarted_Console_Cloud) 
- [Cloud web page](@ref DeviceDetection_Examples_GettingStarted_Web_Cloud)
- Our [Configurator](@ref Services_Configurator) site includes an example for implementing a full client-side solution

**Note:** Console examples work in any situation. Web examples require a browser that supports UA-CH (Chrome, Edge, or other Chromium-based browsers).

---

# Support for detection from Client Hints <a href="#UACH_Support">#</a> @anchor UACH_Support

## Current support


The 51Degrees Device Detection API provides comprehensive UA-CH support:

- **Basic support** - We detect devices using the Sec-CH-UA header (since December 7, 2020)
- **Full support** - We detect devices, operating systems, and browsers from UA-CH headers (Version 4.4 and data files from [June 2022 onwards](https://51degrees.com/blog/updates-to-user-agent-client-hints-version-4-4))
- **Windows 11 detection** - We [identify Windows 11 using User-Agent Client Hints](https://51degrees.com/blog/windows-11-detectable-with-uach) (the [only reliable method](https://docs.microsoft.com/en-us/microsoft-edge/web-platform/how-to-detect-win11))

## JavaScript API support


We added support for the UA-CH [JavaScript API](https://developer.mozilla.org/en-US/docs/Web/API/User-Agent_Client_Hints_API) in:

- .NET API version 4.4.19 
- Data files from March 6, 2023

---

# Guidance <a href="#UACH_Guidance">#</a> @anchor UACH_Guidance

UA-CH offers several mechanisms for accessing values. This section explains our recommendations for different use-cases.

## On-premise API serving end-users directly


**Using our web integration:**
- Ensure these properties are included: `SetHeaderBrowserAccept-CH`, `SetHeaderHardwareAccept-CH`, and `SetHeaderPlatformAccept-CH`
- All properties are included by default for On-Premise
- Our software automatically sets the `Accept-CH` header to request needed client hints

**Not using our web integration:**
- See the 'non-integrated' section on the [UA-CH Headers page](@ref DeviceDetection_Features_UACH_Headers)

## On-premise API not serving end-users directly


**Recommended approach:**
- Ask your clients to set the `Delegate-CH` meta http-equiv tag
- Or have them set `Permissions-Policy` and `Accept-CH` response headers
- This lets user browsers send UA-CH values to your service
- See the 'B2B service supplier' section on the [UA-CH Headers page](@ref DeviceDetection_Features_UACH_Headers)

**Alternative/backup approach:**
- Use the UA-CH JavaScript API to retrieve values
- See the 'non-integrated' section on the [UA-CH JavaScript page](@ref DeviceDetection_Features_UACH_Javascript)

## Calling cloud service from client-side code


**Best performance:**
- Set `Delegate-CH` meta http-equiv tag or `Permissions-Policy` and `Accept-CH` response headers
- See the 'Cloud' section on the [UA-CH Headers page](@ref DeviceDetection_Features_UACH_Headers)

**Alternative approach:**
- Ensure your Resource Key includes the `JavascriptGetHighEntropyValues` property
- This gathers values automatically and sends them to our cloud service

---

# Background reading <a href="#UACH_Background">#</a> @anchor UACH_Background 

## How UA-CH works


The authors of the proposal have created an [article](https://web.dev/user-agent-client-hints) covering how UA-CH works.

51Degrees has [blogged extensively](https://51degrees.com/resources/blogs/tag/Client%20Hints) on the subject. We also have:

- An [explainer site](https://learnclienthints.com/)
- A [test page](https://51degrees.com/client-hints) that shows how UA-CH headers interact with Accept-CH and Permissions-Policy response headers

## Google's rollout timeline


**May 2021:** Google [outlined](https://blog.chromium.org/2021/05/update-on-user-agent-string-reduction.html) their UA-CH rollout plans. They confirmed that User-Agent deprecation wouldn't happen until at least 2022.

**September 2021:** Google provided [further detail](https://blog.chromium.org/2021/09/user-agent-reduction-origin-trial-and-dates.html) about the phased User-Agent deprecation:
- Start: Chrome 101 (roughly Q2 2022)
- End: Chrome 113 (roughly Q2 2023)

## Technical context


User-Agent Client Hints extends the previously existing Client Hints content negotiation feature.

**General documentation:**
- [MDN Client Hints documentation](https://developer.mozilla.org/en-US/docs/Glossary/Client_hints)
- [Google's UA-CH guide](https://web.dev/user-agent-client-hints/)

**Browser support:**
- [Client Hints support](https://caniuse.com/client-hints-dpr-width-viewport)
- [User-Agent Client Hints support](https://caniuse.com/mdn-api_navigator_useragentdata)

## Additional resources


On September 28, 2022, we hosted a webinar discussing User-Agent Client Hints and the future of the User-Agent. [Watch the webinar recording here](https://vimeo.com/755026259).

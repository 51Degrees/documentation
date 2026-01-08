@page DeviceDetection_Features_UACH_Javascript JavaScript

# Introduction

User-Agent Client Hints (UA-CH) values can be obtained using HTTP headers or 
a [JavaScript API](https://developer.mozilla.org/en-US/docs/Web/API/User-Agent_Client_Hints_API).
This page explains how to use the JavaScript approach with our API.

The [UA-CH headers page](@ref DeviceDetection_Features_UACH_Headers) explains the alternative.
The [Overview page](@ref DeviceDetection_Features_UACH_Overview) includes advice if you're unsure which approach to take.

Using the UA-CH JavaScript API is very simple if you are calling our Cloud Service directly. 
See details below.

Otherwise, if you are using one of our web integrations, you can use the 'Integrated' 
approach described below. If not, you'll need to use the 'non-integrated' approach instead.

# Cloud <a href="#UACH_Javscript_Cloud">#</a> @anchor UACH_Javscript_Cloud

Firstly, ensure that the `JavascriptGetHighEntropyValues` property is selected when 
you create your Resource Key. This contains the JavaScript snippet to get the values from 
the UA-CH API on the client device.

If you are calling our Cloud Service directly from the client device, our solution will take care 
of the rest.

If you are calling our Cloud Service via our Pipeline API, hosted on your servers, then you'll
also need to get this snippet to the client device. See the 'On-premise' section below for
the two approaches to doing this.

# On-premise Pipeline API <a href="#UACH_Javscript_OnPrem">#</a> @anchor UACH_Javscript_OnPrem

If you are using our Pipeline API on your server (either cloud or On-premise) then you'll
need a way to get the necessary JavaScript to run on the client and get the values back
to your server.

In either case, you need to ensure the `JavascriptGetHighEntropyValues` property is included 
in the results (all properties are included by default for On-premise).

## Integrated <a href="#UACH_Javascript_Integrated">#</a> @anchor UACH_Javascript_Integrated

If you are using our [web integration](@ref PipelineApi_Features_WebIntegration) with
[client-side evidence](@ref PipelineApi_Features_ClientSideEvidence) enabled, then this will take
care of sending the snippet to the client device, getting the values back to the server and
passing them into our API.

No additional configuration is required for either Cloud or On-premise solutions. The device
detection engine natively processes the `getHighEntropyValues()` result when passed as evidence.

## Non-integrated <a href="#UACH_Javascript_NonIntegrated">#</a> @anchor UACH_Javascript_NonIntegrated

If you don't want to, or can't, use the web integrations as described above, then you'll need to
handle the steps of getting the values from the JavaScript API, transferring those to the server
and adding them to the pipeline evidence values.

This will require a good knowledge of your production environment and how communication works
between your client and server side code.

The following snippet demonstrates how to get the UA-CH values using JavaScript.
The exact mechanism to get this value from the client device to your server will depend on your
infrastructure. Once there, it will need to be added to the @flowdata evidence using either the `query.` or `cookie.` prefix:

```
flowData.AddEvidence("query.51D_GetHighEntropyValues", b64Uach);
// or
flowData.AddEvidence("cookie.51D_GetHighEntropyValues", b64Uach);
```

<div class="c-code__block c-code__block--outline">
<pre>
&lt;script type="text/javascript"&gt;
if (navigator.userAgentData) {
    navigator.userAgentData.getHighEntropyValues(
        ["model",
        "platform",
        "platformVersion",
        "fullVersionList"])
    .then((ua) => {
        // Convert to base64-encoded JSON
        // This string needs to be passed back to the server and added to evidence.
        // Use either query. or cookie. prefix, e.g.:
        // flowData.AddEvidence("query.51D_GetHighEntropyValues", b64Uach);
        var b64Uach = btoa(JSON.stringify(ua));
    });
}
&lt;/script&gt;
</pre>
</div>

No additional configuration is required for either Cloud or On-premise solutions. The device
detection engine natively processes this evidence format, converting it to the equivalent
`Sec-CH-UA-*` HTTP headers internally.

See the [Getting Started Console On-premise](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise)
example for a complete demonstration of this approach.

# Alternative Evidence Formats <a href="#UACH_Javascript_Alternatives">#</a> @anchor UACH_Javascript_Alternatives

In addition to the `getHighEntropyValues()` JavaScript API result, the device detection engine
supports the [Structured User Agent (SUA)](@ref DeviceDetection_Features_UACH_SUA) format
from the OpenRTB 2.6 specification, commonly used in programmatic advertising scenarios.

## Technical Details <a href="#UACH_Javascript_Technical">#</a> @anchor UACH_Javascript_Technical

The `getHighEntropyValues()` evidence is converted internally to the equivalent `Sec-CH-UA-*` HTTP
headers before processing:

- `Sec-CH-UA`
- `Sec-CH-UA-Mobile`
- `Sec-CH-UA-Platform`
- `Sec-CH-UA-Model`
- `Sec-CH-UA-Full-Version-List`
- `Sec-CH-UA-Platform-Version`
- `Sec-CH-UA-Arch`
- `Sec-CH-UA-Bitness`

The conversion happens natively in the device detection engine (in the C layer), making it
efficient and seamless. This eliminates the need for any additional pipeline elements or
pre-processing steps that were required in earlier versions.

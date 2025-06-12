@page DeviceDetection_Features_UACH_Javascript JavaScript

# Introduction

User-Agent Client Hints (UA-CH) values can be obtained using HTTP headers or 
a [JavaScript API](https://developer.mozilla.org/en-US/docs/Web/API/User-Agent_Client_Hints_API).
This page explains how to use the JavaScript approach with our API.

The [UA-CH headers page](@ref DeviceDetection_Features_UACH_Headers) explains the alternative.
The [Overview page](@ref DeviceDetection_Features_UACH_Overview) includes advice if you're unsure which approach to take.

Using the UA-CH JavaScript API is very simple if you are calling our cloud service directly. 
See details below.

Otherwise, if you are using one of our web integrations, you can use the 'Integrated' 
approach described below. If not, you'll need to use the 'non-integrated' approach instead.

@anchor UACH_Javscript_Cloud
[#](@ref UACH_Javscript_Cloud)
# Cloud

Firstly, ensure that the `JavascriptGetHighEntropyValues` property is selected when 
you create your Resource Key. This contains the JavaScript snippet to get the values from 
the UA-CH API on the client device.

If you are calling our cloud service directly from the client device, our solution will take care 
of the rest.

If you are calling our cloud service via our Pipeline API, hosted on your servers, then you'll
also need to get this snippet to the client device. See the 'on-premise' section below for
the two approaches to doing this.

@anchor UACH_Javscript_OnPrem
[#](@ref UACH_Javscript_OnPrem)
# On-Premise Pipeline API

If you are using our Pipeline API on your server (either cloud or on-premise) then you'll
need a way to get the necessary JavaScript to run on the client and get the values back
to your server.

In either case, you need to ensure the `JavascriptGetHighEntropyValues` property is included 
in the results (all properties are included by default for on-premise).

@anchor UACH_Javascript_Integrated
[#](@ref UACH_Javascript_Integrated)
## Integrated

If you are using our [web integration](@ref PipelineApi_Features_WebIntegration) with 
[client-side evidence](@ref PipelineApi_Features_ClientSideEvidence) enabled, then this will take 
care of sending the snippet to the client device, getting the values back to the server and 
passing them into our API.

If you're using our cloud service, no other changes are needed.
However, if you're using our on-premise solution, then you'll also need to modify your configuration 
to include a new engine called `UachJsConversionEngine` to convert the result from the 
JavaScript snippet to evidence values that can be used by the existing device detection engine.

For example:

```
"PipelineOptions": {
    "Elements": [
        {
            "BuilderName": "UachJsConversionEngine"
        },
        {
            "BuilderName": "DeviceDetectionHashEngineBuilder",
            "BuildParameters": {
                ...
            }
        }
    ]
},
```

@anchor UACH_Javascript_NonIntegrated
[#](@ref UACH_Javascript_NonIntegrated)
## Non-integrated

If you don't want to, or can't, use the web integrations as described above, then you'll need to 
handle the steps of getting the values from the JavaScript API, transferring those to the server
and adding them to the pipeline evidence values.

This will require a good knowledge of your production environment and how communication works 
between your client and server side code.

The following snippet demonstrates how to get the UA-CH values using JavaScript.
The exact mechanism to get this value from the client device to your server will depend on your 
infrastructure. Once there, it will need to be added to the @flowdata evidence:

```
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
        // This string needs to be passed back to the server and added to evidence. E.g.
        // flowData.AddEvidence("cookie.51D_GetHighEntropyValues", b64Uach);
        var b64Uach = btoa(JSON.stringify(ua));        
    });
}
&lt;/script&gt;
</pre>
</div>

If you're using our cloud service, no other changes are needed.
However, if you're using on-premise solution, then you'll also need to modify your configuration 
to include a new engine called `UachJsConversionEngine` to convert the base-64 json from the 
JavaScript snippet above to evidence values that can be used by the existing device detection engine.

For example:

```
"PipelineOptions": {
    "Elements": [
        {
            "BuilderName": "UachJsConversionEngine"
        },
        {
            "BuilderName": "DeviceDetectionHashEngineBuilder",
            "BuildParameters": {
                ...
            }
        }
    ]
},
```

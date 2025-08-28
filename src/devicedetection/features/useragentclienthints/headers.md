@page DeviceDetection_Features_UACH_Headers HTTP Headers

# Introduction

User-Agent Client Hints (UA-CH) values can be obtained using HTTP headers or a [JavaScript API](https://developer.mozilla.org/en-US/docs/Web/API/User-Agent_Client_Hints_API).
This page explains how to use the HTTP headers approach with our API.

The [UA-CH JavaScript page](@ref DeviceDetection_Features_UACH_Javascript) explains the alternative.
The [Overview page](@ref DeviceDetection_Features_UACH_Overview) includes advice if you're unsure which approach to take.

# Background

In the past, device detection worked primarily by examining the 
value of the User-Agent HTTP header. This header is always sent as part 
of the first request to a web server, meaning device information was 
available immediately on the server-side.

With UA-CH, only a limited subset of information is sent as part of the 
first request.
If the server wishes to know more, then it needs to set a HTTP header in
the response to request the additional detail.

The 51Degrees API will automatically determine the names and values of
any response headers that need to be set based on the initial information.

When using the Pipeline web integration, most languages will automatically set the response 
headers for you as well. If not using a web integration, or your language does not support it, 
you will need to set the response headers manually.

# Cloud <a href="#UACH_Headers_Cloud">#</a> @anchor UACH_Headers_Cloud

Make sure that one or more of the following properties are included with your 
[Resource Key](@ref Services_Configurator):
- `SetHeaderBrowserAccept-CH`
- `SetHeaderHardwareAccept-CH`
- `SetHeaderPlatformAccept-CH`
(The configurator will automatically add the ones relevant to the properties you have selected)

If you are calling our Cloud Service via our Pipeline API, hosted on your servers, then you'll
also need to ensure the `Accept-CH` HTTP header is set using these values. See the 'On-premise' 
section below for the two approaches to doing this, as well as a note on the `Critical-CH` header.

If you are calling our Cloud Service directly from the client device, then you'll need to let 
the browser know that it's okay to send the client hints to our Cloud Service. There are two 
ways to do this.

## Delegate-CH

This only requires a change to HTML. Simply add the following `meta` element to the `head` of your page.

```
<head>
    <meta http-equiv="Delegate-CH" content="sec-ch-ua-full-version-list https://cloud.51degrees.com; sec-ch-ua-model https://cloud.51degrees.com; sec-ch-ua-platform https://cloud.51degrees.com; sec-ch-ua-platform-version https://cloud.51degrees.com"/>
</head>
```

## Permissions-Policy + Accept-CH

If you would rather use HTTP response headers than HTML, you can use the `Permissions-Policy` 
header to do the same job as `Delegate-CH`. 
Note that, when using `Permissions-Policy`, the browser will only send UA-CH headers to the 
third-party that are also requested by the first-party. This means that you also need to set
`Accept-CH` as well. As an example, you might use the following values:

```
Accept-CH: sec-ch-ua,sec-ch-ua-mobile,sec-ch-ua-full-version-list,sec-ch-ua-platform,sec-ch-ua-platform-version,sec-ch-ua-model 
Permissions-Policy: ch-ua-full-version-list=(self "https://cloud.51degrees.com"), ch-ua-platform=(self "https://cloud.51degrees.com"), ch-ua-platform-version=(self "https://cloud.51degrees.com"), ch-ua-model=(self "https://cloud.51degrees.com") 
```

# On-premise Pipeline API <a href="#UACH_Headers_OnPrem">#</a> @anchor UACH_Headers_OnPrem

If you are using our Pipeline API on your server (either cloud or On-premise) then you'll
need a way to set the `Accept-CH` header in the response to the client.

In either case, you need to ensure the relevant `SetHeaderBrowserAccept-CH`, `SetHeaderHardwareAccept-CH` and 
`SetHeaderPlatformAccept-CH` properties are included in the results (all properties are included 
by default for On-premise).
If you're unsure which ones are relevant for you, see the 
[required values](@ref DeviceDetection_Features_UACH_RequiredUachHeaders) page.

## Integrated <a href="#UACH_Http_Headers_Integrated">#</a> @anchor UACH_Http_Headers_Integrated

If you are using our [web integration](@ref PipelineApi_Features_WebIntegration), then this will take 
care of setting the header automatically.

This uses an internal element called `SetHeadersElement` to set the values of response headers
based on any `SetHeader*` properties that are present. 

## Non-integrated <a href="#UACH_Http_Headers_NonIntegrated">#</a> @anchor UACH_Http_Headers_NonIntegrated

If you don't want to, or can't, use the web integration as described above, then you'll need to 
manually set the `Accept-CH` header.

We don't provide code samples for this, due to the number of different languages and web frameworks.
So, you'll need to know how to set response headers using your particular set of tools.

We recommend using the values of the 'SetHeader*Accept-CH' device detection properties from our API 
to get a list of the UA-CH headers that you need to request. This has a couple of benefits:
1. You won't waste bandwidth sending `Accept-CH` to browsers that don't support UA-CH. 
2. If new UA-CH headers are added, and we use them for device detection, you won't need to 
   change any code in order to request the new headers from the browser.

Alternatively, you can just request all the [required](@ref DeviceDetection_Features_UACH_RequiredUachHeaders) 
headers if you want a more immediate solution.

The `Accept-CH` header should look something like this in the HTML response:

```
Accept-CH: sec-ch-ua,sec-ch-ua-mobile,sec-ch-ua-full-version-list,sec-ch-ua-platform,sec-ch-ua-platform-version,sec-ch-ua-model 
```
## Critical-CH <a href="#UACH_Http_Headers_Critical">#</a> @anchor UACH_Http_Headers_Critical

`Critical-CH` (as described by [MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Critical-CH)) is an experimental Client Hint 
response header used along with the `Accept-CH` header. It specifies that the accepted Client Hints are also critical Client Hints,
such that the web application may not function without them. When the browser supporting Client Hints receives the `Critical-CH` header, 
it checks if the indicated Client Hints were sent in the original request, and if not, immediately makes another request supplying 
the missing Client Hints.   

This has to be used with caution for it may often cause another round trip for the client. We recommend only using `Critical-CH` if you need to do the 
device detection immediately on the very first request from the user. 

In that case, the application or middleware logic must 
consider if the Client Hints necessary for the device detection were missing. If the Client Hints were missing, the application or 
middleware logic will add `Critical-CH` and `Accept-CH` headers and send an immediate response to the client:

```
Critical-CH: sec-ch-ua-arch, sec-ch-ua-full-version, sec-ch-ua-full-version-list, sec-ch-ua-model, sec-ch-ua-platform, sec-ch-ua-platform-version 
```
```
Accept-CH:  sec-ch-ua-arch, sec-ch-ua-full-version, sec-ch-ua-full-version-list, sec-ch-ua-model, sec-ch-ua-platform, sec-ch-ua-platform-version
```

## B2B Service Supplier <a href="#UACH_Http_Headers_BtoB">#</a> @anchor UACH_Http_Headers_BtoB

If your service would be classed as a third-party in the 'browser to web server' communication, 
then you'll also need to arrange for your clients to let their users know that it's okay to
send your server UA-CH values.
This is because the 'high-entropy' UA-CH values are not sent to third-parties by default.

In order to do this, you'll need to ask your customers to use the `Delegate-CH` HTML directive or
the `Permissions-Policy` HTTP header.
This will be similar to the changes described [above](@ref UACH_Headers_Cloud) for calls to 
our Cloud Service. (In that instance, our Cloud Service is the third-party.)
The difference being that you'll need to replace <pre>https://cloud.51degrees.com</pre> with 
the domain for your service.


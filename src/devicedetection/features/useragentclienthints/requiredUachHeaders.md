@page DeviceDetection_Features_UACH_RequiredUachHeaders Required UA-CH Headers

# Overview

This page explains which UA-CH values you need in order to get results for different properties.

If you just want to get all properties, you'll need the following UA-CH values. We generally 
recommend supplying all of these for the best detection results:

- Sec-CH-UA
- Sec-CH-UA-Full-Version-List 
- Sec-CH-UA-Model
- Sec-CH-UA-Mobile
- Sec-CH-UA-Platform
- Sec-CH-UA-Platform-Version

If you want to be more selective for some reason, the rest of the page describes how the data is
used. The table at the end shows which UA-CH values are needed for each 'component'.

# Background

51Degrees groups properties associated with the request by ‘component’. The components 51Degrees recognize are hardware device, platform (operating system), browser, and crawler.

The User-Agent header contains information relating to all four of these components. User Agent Client Hints values are different in that they relate to varying numbers of components. For example, the Sec-CH-UA-Model header only relates to the hardware device component.

However, multiple UA-CH values are sometimes needed to fully identify a component. Apple devices running Chrome will not populate the Sec-CH-UA-Model header, so that won't help give us an answer to the hardware component. Instead, we need the Sec-CH-UA-Platform header, which can at least tell us that this is an iOS device.

We concatenate the various UA-CH headers that are needed to identify a component to create ‘pseudo-headers’. These are then used internally to perform the detection. 


@anchor UACH_Http_Headers_Pseudoheaders
[#](@ref UACH_Http_Headers_Pseudoheaders)
# Pseudo-headers

The table below shows which pseudo-headers are required in order to detect each component. These are the minimum pseudo-headers we use to detect the component; however, we recommend providing all UA-CH values for the best detection. Additionally, this table is only applicable for Chromium-based browsers; to detect non-Chromium browsers, you will need to continue supplying User-Agent information.

Some pseudo-headers are not required to detect the component but can provide more detailed detection results. For example, Sec-CH-UA-Platform-Version is not required to determine the Platform component, but provides additional version information when supplied.

In some cases, there are multiple pseudo-headers for a component. These are processed in order from providing most detail to least. In addition, pseudo-headers will always take precedence over the User-Agent, even in cases where the User-Agent provides more detail. See the @faqs for more discussion on this.

## Key
- x = This value is required in order to determine the component.
- x* = This value is not required, but if provided may return more detailed results.
- y and z = One of these values are required. Supplying y may return a more accurate result and removes the need to supply z.

|UA-CH header|Hardware|Platform|Browser/App|
|---|---|---|---|
|Sec-CH-UA                   |   |    | z |
|Sec-CH-UA-Full-Version-List |   |    | y |
|Sec-CH-UA-Model             | x |    |   |
|Sec-CH-UA-Mobile            | x |    | x |
|Sec-CH-UA-Platform          | x | x  | x |
|Sec-CH-UA-Platform-Version  |   | x* |   |

@page DeviceDetection_Features_UserAgentClientHintsHeaders User Agent Client Hints Headers

# Introduction

51Degrees groups properties associated with the request by ‘component’. The components 51Degrees recognize are hardware device, platform (operating system), browser, and crawler.

The User Agent header contains information relating to all four of these components. [User Agent Client Hints](@ref DeviceDetection_Features_UserAgentClientHints) values are different in that they relate to varying numbers of components. For example, the Sec-CH-UA-Model header only relates to the hardware device component.

However, multiple UA-CH values are sometimes needed to fully identify a component. Apple devices running Chrome will not populate the Sec-CH-UA-Model header, so that won't help give us an answer to the hardware component. Instead, we need the Sec-CH-UA-Platform header, which can at least tell us that this is an iOS device.

# Pseudo-headers

We concatenate the various UA-CH headers that are needed to identify a component to create ‘pseudo-headers’. These are then used internally to perform the detection. The table below shows the pseudo-headers that exist for each component.

In some cases, there are multiple pseudo-headers for a component. These are processed in order from providing most detail to least. 

## Key
0 = This value is required in order to determine the component.
1/2 = One of these values are required. Supplying 1 will enable a more accurate result and removes the need to supply 2.

|UA-CH header|Hardware|Platform|Browser/App|
|---|---|---|---|
|Sec-CH-UA|||2|
|Sec-CH-UA-Version|||| 
|Sec-CH-UA-Full-Version-List|||1|
|Sec-CH-UA-Model|0|||
|Sec-CH-UA-Mobile|0||0|
|Sec-CH-UA-Platform|0|0|0|
|Sec-CH-UA-Platform-Version||0||

Any evidence shared with us is subject to our [usage sharing](@ref Features_UsageSharing) terms. Please refer to our ['Usage sharing: how do we use your data'](https://51degrees.com/blog/usage-sharing-how-we-use-your-data) for more information.

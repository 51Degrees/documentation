@page DeviceDetection_Features_AppleDetection Apple Model Detection

# Introduction

In the early days of the internet, the 
[User Agent header](https://51degrees.com/blog/understanding-user-agent-string) 
was made part of the 
[HTTP/1.0 specification](https://datatracker.ietf.org/doc/html/rfc1945#page-46).

> This is for statistical purposes,
> the tracing of protocol violations, and automated recognition of user
> agents for the sake of tailoring responses to avoid particular user
> agent limitations. Although it is not required, user agents should
> include this field with requests. 

Generally, web browsers will populate the User Agent header with information that allows the 
web server to derive details about the operating system and browser that are being used to make 
the request. 

In the case of mobile devices, the native hardware model name is also included in the User Agent.
This means the web server can additionally determine details about the hardware making the request.

Apple are unique as they have never included the mobile device model name in the User Agent. 
Consequently, it is generally not possible to identify Apple devices from the User Agent alone. 
(This is not always the case. Some apps, such as Facebook, will add the model name to the 
User Agent when they make requests)

Additionally, Apple have certain tools within their system that can change the values within 
the User Agent string. For example, an iPhone browsing the web in Desktop mode would have a User Agent that identifies the device as a Mac, rather than an iPhone. It is impossible to detect an iPhone browsing in Desktop mode.

51Degrees uses client-side code to collect additional information from the device, which is used
to determine the model. This page explains how the feature works.

If you just want to see it working, the 
[getting started - web](@ref Examples_DeviceDetection_GettingStarted_Web_Index) examples
demonstrate this capability.

# Overview

In order to determine the Apple device model, we need additional data, collected from client-side 
code. For languages that support the Pipeline API, gathering this data and sending it back to the
server is handled by the [client-side evidence](@ref Features_ClientSideEvidence) feature.

The JavaScript that runs on the client comes from the [JavascriptHardwareProfile](https://51degrees.com/developers/property-dictionary?item=Device%7CJavascript) property.
In order to explain how this is used, we need to define a little 51Degrees terminology:

- A profile can be thought of as a database record. A profile can represent a hardware device, a specific operating system version or web browser version. The profile will contain values for the properties that are returned by device detection. For example, `model name` or `release date`. 
- A profile id is the unique identifier for a specific profile.
- A device id is a combination of profile ids. For example, `12280-118061-117398` represents an unknown model of iPhone running iOS 15.3 and using Safari 15.3.

The 51Degrees device database contains 3 top-level 'group' profiles for Apple devices:

- iPhone
- iPad
- Mac

The User Agent header can be used to determine which of these groups the device making the request 
falls in to. Each of these profiles has a `JavascriptHardwareProfile` property value that contains 
slightly different JavaScript snippets that need to be executed on the client device.

In each case, the snippet will get several values and then use those values to determine the 
profile id of the hardware profile representing the actual model.

This profile id is then passed back to the server. When detection is performed, the group profile 
that can be determined from the User Agent is swapped for the profile that was passed from the 
client-side code.

# Further Reading

- This [table](@ref DeviceDetection_Features_AppleDeviceTable) contains a break down of exactly which iPhone and iPad models our solution can identify.
- Check the [getting started - web](@ref Examples_DeviceDetection_GettingStarted_Web_Index) examples for a demonstration of how to use this functionality.
- Browse the many [blogs](http://51degrees.com/resources/blogs/tag/Apple) that we've produced relating to Apple.


@page DeviceDetection_Features_AppleDetection Apple Model Detection

# Apple Model Detection

Apple devices are unique in that their User-Agent strings do not include hardware model
identifiers - unlike most Android devices.
This means it's not possible to identify the exact iPhone or iPad model using only the HTTP request headers.

To solve this, 51Degrees uses **client-side JavaScript** to gather additional evidence from the device,
such as screen resolution and GPU model.
This allows us to identify the precise Apple hardware model - including the specific iPhone or iPad generation.
Even when the User-Agent string is generic!

This feature is built into the [client-side evidence](@ref Features_ClientSideEvidence) functionality,
and is automatically enabled when the relevant property is included in your resource key.

To see this feature in action, check out the 
[Getting Started - Web](@ref Examples_DeviceDetection_GettingStarted_Web_Index) example.

## How it works

When a request from an Apple device is received:

1. The server inspects the User-Agent to determine the general device type: iPhone, iPad, or Mac.
2. Based on this, the server sends JavaScript to the client that gathers device-specific information.
3. The JavaScript runs on the client and returns a **hardware profile ID**.
4. This ID is sent back to the server.
5. The server updates the detection result with the exact Apple model.

This works even in edge cases such as:

- iPhones browsing in Desktop mode (which report themselves as Macs)
- User-Agents modified by apps (e.g. Facebook)
- Limited or missing header information

The JavaScript involved comes from the [`JavascriptHardwareProfile`](https://51degrees.com/developers/property-dictionary?item=Device%7CJavascript) property and is tailored per device group.

![](images/51D-detection-example-1.svg)

![](images/51D-detection-example-2.svg)

![](images/51D-detection-example-3.svg)

## Terminology

- **Profile**: A set of property values describing a device, OS, or browser.
  - A profile can be thought of as a database record. It can represent a hardware device, a specific operating system version or web browser version. The profile will contain values for the properties that are returned by device detection. For example, `model name` or `release date`.
- **Profile ID**: The unique identifier for a specific profile.
- **Device ID**: A combination of profile IDs, which represents a specific device + OS + browser version.
  - For example, `12280-118061-117398` represents an unknown model of iPhone running iOS `15.3` and using Safari `15.3`.

When the hardware profile ID is returned from the client,
we swap it into the final device ID on the server - replacing
the generic Apple group profile with a more accurate one.

## More information

- [Web Integration Example](@ref Examples_DeviceDetection_GettingStarted_Web_Index): See how to implement it with code samples
- [Supported Apple Models](@ref DeviceDetection_Features_AppleDeviceTable): A full list of iPhone and iPad models that can be detected by 51Degrees
- [51Degrees Blog - Apple](https://51degrees.com/resources/blogs/tag/Apple): Technical deep dives, case studies, and news we've produced relating to Apple

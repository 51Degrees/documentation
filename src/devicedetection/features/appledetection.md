@page DeviceDetection_Features_AppleDetection Apple Model Detection

# Apple Model Detection

Apple devices are unique in that their User-Agent strings do not include hardware model
identifiers - unlike most Android devices.
This means it's not possible to identify the exact iPhone/iPad model using only the HTTP request headers.

To solve this, 51Degrees uses **client-side JavaScript** to gather additional evidence from the device,
such as screen resolution and GPU model.
This allows us to identify the precise Apple hardware model - including the specific iPhone/iPad generation.
Even when the User-Agent string is generic.

This feature is built into the [client-side evidence](@ref PipelineApi_Features_ClientSideEvidence) functionality,
and is automatically enabled when the relevant property is included in your Resource Key.

To see this feature in action, check out the 
[Getting Started - Web](@ref DeviceDetection_Examples_GettingStarted_Web_Index) example, or jump directly to the [detection results tables](#detection-results) to see which Apple devices can be identified.

## How it works

When a request from an Apple device is received:

1. The server inspects the User-Agent to determine the general device type: iPhone/iPad or Mac.
2. Based on this, the server sends JavaScript to the client that gathers device-specific information.
3. The JavaScript runs on the client and returns a **hardware profile ID**.
4. This ID is sent back to the server.
5. The server updates the detection result with the exact Apple model.

This works even in edge cases such as:

- iPhones browsing in Desktop mode (which report themselves as Macs)
- User-Agents modified by apps (e.g. Facebook)
- Limited or missing header information

The JavaScript involved comes from the [`JavascriptHardwareProfile`](https://51degrees.com/developers/property-dictionary?item=Device%7CJavascript) property and is tailored per device group.

![iPhone Example](images/51D-detection-example-1.svg)

![iPhone in Desktop Mode Example](images/51D-detection-example-2.svg)

![Mac Example](images/51D-detection-example-3.svg)

---

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

- [Web Integration Example](@ref DeviceDetection_Examples_GettingStarted_Web_Index): See how to implement it with code samples
- [51Degrees Blog - Apple](https://51degrees.com/resources/blogs/tag/Apple): Technical deep dives, case studies, and news we've produced relating to Apple

## Detection Results for Apple Devices {#detection-results}
Apple has continually worked to homogenize any information that a website can get about a device, through JavaScript or any other means. For more information, take a look at our [Upgrade Apple Device](https://51degrees.com/blog/upgrade-apple-device-detection) blog. 

Below we cover the detection results that are experienced for each iPhone, starting from the iPhone 3GS, when using Safari.

The 'percentage' column refers to the percentage of the data submissions we have received that would return that detection result for that particular display mode. For example, '100.00%' in Standard mode indicates that 100% of our submissions for that device would receive that result if the data from the submission were passed to our detection script. '1.50%' in indicates that 1.5% of our submissions would receive that detection result.

As we receive more data on Apple devices, this table will change. We will update this table following each update to the JavaScript. The tables currently match the released JavaScript created on 12 June 2026.

For optimized viewing of the table, it is recommended you zoom out within your browser.

### iPhones using browser in Mobile mode and in standard display mode {#iphones_mobile_standard_mode}
|Device|Results|Percentage|
|---|---|---|
|iPhone 17e|iPhone 16e, iPhone 17e|100.00%|
|iPhone Air|iPhone Air|100.00%|
|iPhone 17 Pro Max|iPhone 16 Pro Max, iPhone 17 Pro Max|100.00%|
|iPhone 17 Pro|iPhone 16 Pro, iPhone 17, iPhone 17 Pro|100.00%|
|iPhone 17|iPhone 16 Pro, iPhone 17, iPhone 17 Pro|100.00%|
|iPhone 16e|iPhone 16e, iPhone 17e<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e<br/>iPhone 16e|50.88%<br/>28.07%<br/>21.05%|
|iPhone 16 Pro Max|iPhone 16 Pro Max, iPhone 17 Pro Max<br/>iPhone 16 Pro Max|54.40%<br/>45.60%|
|iPhone 16 Pro|iPhone 16 Pro, iPhone 17, iPhone 17 Pro<br/>iPhone 16 Pro|55.97%<br/>44.03%|
|iPhone 16 Plus|iPhone 15 Pro Max, iPhone 16 Plus<br/>iPhone 16 Plus<br/>iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus|62.93%<br/>22.26%<br/>14.81%|
|iPhone 16|iPhone 15 Pro, iPhone 16<br/>iPhone 16<br/>iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16|62.81%<br/>22.37%<br/>14.81%|
|iPhone 15 Pro Max|iPhone 15 Pro Max, iPhone 16 Plus<br/>iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus<br/>iPhone 15 Pro Max<br/>iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max|51.19%<br/>23.25%<br/>15.11%<br/>10.46%|
|iPhone 15 Pro|iPhone 15 Pro, iPhone 16<br/>iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16<br/>iPhone 15 Pro<br/>iPhone 14 Pro, iPhone 15, iPhone 15 Pro|48.65%<br/>22.03%<br/>15.05%<br/>14.27%|
|iPhone 15 Plus|iPhone 14 Pro Max, iPhone 15 Plus<br/>iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/>iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus|83.86%<br/>8.06%<br/>8.06%|
|iPhone 15|iPhone 14 Pro, iPhone 15<br/>iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16<br/>iPhone 14 Pro, iPhone 15, iPhone 15 Pro|77.76%<br/>11.17%<br/>10.46%|
|iPhone 14 Pro Max|iPhone 14 Pro Max, iPhone 15 Plus<br/>iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus<br/>iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/>iPhone 14 Pro Max|70.71%<br/>14.39%<br/>10.74%<br/>4.16%|
|iPhone 14 Pro|iPhone 14 Pro, iPhone 15<br/>iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16<br/>iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/>iPhone 14 Pro|72.30%<br/>14.77%<br/>8.89%<br/>4.03%|
|iPhone 14 Plus|iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus|99.90%|
|iPhone 14|iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro Max<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e|68.92%<br/>17.13%<br/>13.18%|
|iPhone SE (3rd Gen.)|iPhone SE (3rd Gen.)|100.00%|
|iPhone 13 Pro Max|iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus<br/>iPhone 12 Pro Max, iPhone 13 Pro Max<br/>iPhone 13 Pro Max|91.02%<br/>7.02%<br/>1.96%|
|iPhone 13 Pro|iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro Max<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro<br/>iPhone 13, iPhone 13 Pro, iPhone 14|62.42%<br/>13.00%<br/>11.70%<br/>7.67%<br/>5.20%|
|iPhone 13 mini|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max|68.11%<br/>13.61%<br/>6.80%<br/>5.44%<br/>5.44%|
|iPhone 13|iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro Max<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro|69.38%<br/>14.03%<br/>8.42%<br/>7.58%|
|iPhone 12 Pro Max|iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus<br/>iPhone 12 Pro Max<br/>iPhone 12 Pro Max, iPhone 13 Pro Max|84.09%<br/>11.25%<br/>4.66%|
|iPhone 12 Pro|iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e<br/>iPhone 12, iPhone 12 Pro<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro Max<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro<br/>iPhone 12 Pro|64.34%<br/>12.32%<br/>11.25%<br/>7.29%<br/>3.54%<br/>1.27%|
|iPhone 12 mini|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max|64.59%<br/>12.92%<br/>7.76%<br/>6.00%<br/>5.16%<br/>2.52%|
|iPhone 12|iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14<br/>iPhone 12, iPhone 12 Pro<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro Max<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro|46.41%<br/>35.25%<br/>9.15%<br/>5.49%<br/>3.64%|
|iPhone SE (2nd Gen.)|iPhone SE (2nd Gen.)|100.00%|
|iPhone 11 Pro Max|iPhone 11 Pro Max, iPhone XS Max<br/>iPhone 11 Pro Max|66.68%<br/>33.32%|
|iPhone 11 Pro|iPhone 11 Pro, iPhone 11 Pro Max, iPhone XS, iPhone XS Max<br/>iPhone 11 Pro, iPhone 11 Pro Max<br/>iPhone 11, iPhone 11 Pro, iPhone 11 Pro Max<br/>iPhone 11 Pro, iPhone 11 Pro Max, iPhone 12 mini, iPhone 12 Pro Max, iPhone X, iPhone XS, iPhone XS Max|51.80%<br/>24.94%<br/>15.18%<br/>8.07%|
|iPhone 11|iPhone 11<br/>iPhone 11, iPhone XR|58.94%<br/>41.06%|
|iPhone XS Max|iPhone XS Max<br/>iPhone 11 Pro Max, iPhone XS Max|60.06%<br/>39.94%|
|iPhone XS|iPhone X, iPhone XS, iPhone XS Max<br/>iPhone 11 Pro, iPhone 11 Pro Max, iPhone 12 mini, iPhone 12 Pro Max, iPhone X, iPhone XS, iPhone XS Max<br/>iPhone 11 Pro, iPhone 11 Pro Max, iPhone XS, iPhone XS Max<br/>iPhone XS, iPhone XS Max|43.87%<br/>42.57%<br/>10.75%<br/>2.80%|
|iPhone XR|iPhone 11, iPhone XR<br/>iPhone XR|83.74%<br/>16.26%|
|iPhone X|iPhone X, iPhone XS, iPhone XS Max<br/>iPhone 11 Pro, iPhone 11 Pro Max, iPhone 12 mini, iPhone 12 Pro Max, iPhone X, iPhone XS, iPhone XS Max<br/>iPhone X|53.88%<br/>42.44%<br/>3.68%|
|iPhone 8 Plus|iPhone 8 Plus|100.00%|
|iPhone 8|iPhone 8<br/>iPhone 8, iPhone SE (2nd Gen.)|59.62%<br/>40.38%|
|iPhone 7 Plus|iPhone 7 Plus|100.00%|
|iPhone 7|iPhone 7|100.00%|
|iPhone SE|iPhone 6s, iPhone SE|99.99%|
|iPhone 6s Plus|iPhone 6s Plus|100.00%|
|iPhone 6s|iPhone 6s|100.00%|
|iPhone 6 Plus|iPhone 6 Plus|100.00%|
|iPhone 6|iPhone 6|100.00%|
|iPhone 5S|iPhone 5S|100.00%|
|iPhone 5c|iPhone 5, iPhone 5c|100.00%|
|iPhone 5|iPhone 5, iPhone 5c|100.00%|
|iPhone 4S|iPhone 4S|100.00%|
|iPhone 4|iPhone 4|100.00%|
|iPhone 3GS|iPhone 3GS|100.00%|

### iPhones using browser in Mobile mode and in zoomed display mode {#iphones_mobile_zoom_mode}
This table is for display zoom, an iPhone accessibility feature. It is not the normal zoom operation in browsers. It is enabled in Settings > Display & Brightness > Display Zoom > Zoomed.

|Device|Results|Percentage|
|---|---|---|
|iPhone 17e|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e|100.00%|
|iPhone Air|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone Air|100.00%|
|iPhone 17 Pro Max|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone Air|100.00%|
|iPhone 17 Pro|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e|100.00%|
|iPhone 17|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e|100.00%|
|iPhone 16e|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 16, iPhone 16 Pro, iPhone 16e|49.87%<br/>29.88%<br/>19.72%|
|iPhone 16 Pro Max|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone Air<br/>iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max|54.39%<br/>17.10%<br/>17.08%<br/>11.40%|
|iPhone 16 Pro|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/>iPhone 15 Pro, iPhone 16, iPhone 16 Pro<br/>iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e|55.04%<br/>16.40%<br/>16.40%<br/>12.13%|
|iPhone 16 Plus|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone Air<br/>iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max|42.33%<br/>23.07%<br/>19.15%<br/>15.38%|
|iPhone 16|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/>iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 15 Pro, iPhone 16, iPhone 16 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e|41.49%<br/>22.67%<br/>18.82%<br/>16.97%|
|iPhone 15 Pro Max|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone Air<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 15 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/>iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max|48.19%<br/>24.10%<br/>12.05%<br/>6.02%<br/>4.82%<br/>4.82%|
|iPhone 15 Pro|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/>iPhone 15 Pro<br/>iPhone 15 Pro, iPhone 16, iPhone 16 Pro|48.34%<br/>21.85%<br/>14.28%<br/>10.98%<br/>4.39%|
|iPhone 15 Plus|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max|82.60%<br/>8.70%<br/>4.35%<br/>4.35%|
|iPhone 15|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro|77.99%<br/>12.16%<br/>8.96%|
|iPhone 14 Pro Max|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max|68.66%<br/>14.60%<br/>5.96%<br/>5.95%<br/>4.71%|
|iPhone 14 Pro|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/>iPhone 12 mini, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro|75.13%<br/>14.47%<br/>8.68%<br/>1.55%|
|iPhone 14 Plus|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max|70.48%<br/>13.59%<br/>6.79%<br/>5.46%<br/>3.57%|
|iPhone 14|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12 mini, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro|70.87%<br/>14.22%<br/>12.92%<br/>1.82%|
|iPhone SE (3rd Gen.)|iPhone SE (3rd Gen.)|100.00%|
|iPhone 13 Pro Max|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max|68.97%<br/>14.38%<br/>5.76%<br/>5.03%<br/>4.32%|
|iPhone 13 Pro|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12 mini, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro|63.34%<br/>13.29%<br/>13.25%<br/>5.30%<br/>4.53%|
|iPhone 13 mini|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro|60.27%<br/>15.38%<br/>12.82%<br/>11.52%|
|iPhone 13|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro|69.20%<br/>14.12%<br/>11.30%<br/>4.82%|
|iPhone 12 Pro Max|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max|62.09%<br/>12.93%<br/>7.80%<br/>5.55%<br/>5.14%<br/>3.87%<br/>2.52%|
|iPhone 12 Pro|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro|57.77%<br/>12.72%<br/>11.37%<br/>10.00%<br/>8.04%|
|iPhone 12 mini|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro|65.85%<br/>13.43%<br/>11.43%<br/>5.96%<br/>2.70%|
|iPhone 12|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro|65.86%<br/>13.45%<br/>10.76%<br/>5.90%<br/>3.97%|
|iPhone SE (2nd Gen.)|iPhone SE (2nd Gen.)|100.00%|
|iPhone 11 Pro Max|iPhone 11 Pro, iPhone 11 Pro Max, iPhone XS, iPhone XS Max<br/>iPhone 11, iPhone 11 Pro, iPhone 11 Pro Max<br/>iPhone 11 Pro, iPhone 11 Pro Max, iPhone 12 mini, iPhone 12 Pro Max, iPhone X, iPhone XS, iPhone XS Max<br/>iPhone 11 Pro, iPhone 11 Pro Max|55.18%<br/>18.01%<br/>13.99%<br/>12.81%|
|iPhone 11 Pro|iPhone 11 Pro, iPhone XS<br/>iPhone 11 Pro|56.93%<br/>43.07%|
|iPhone 11|iPhone 11<br/>iPhone 11, iPhone XR|86.55%<br/>13.45%|
|iPhone XS Max|iPhone 11 Pro, iPhone 11 Pro Max, iPhone 12 mini, iPhone 12 Pro Max, iPhone X, iPhone XS, iPhone XS Max<br/>iPhone X, iPhone XS, iPhone XS Max<br/>iPhone 11 Pro, iPhone 11 Pro Max, iPhone XS, iPhone XS Max<br/>iPhone XS, iPhone XS Max|49.06%<br/>30.72%<br/>17.25%<br/>2.96%|
|iPhone XS|iPhone 11 Pro, iPhone XS<br/>iPhone XS|64.44%<br/>35.56%|
|iPhone XR|iPhone 11, iPhone XR<br/>iPhone XR|92.09%<br/>7.91%|
|iPhone X|iPhone X|100.00%|
|iPhone 8 Plus|iPhone 8 Plus|100.00%|
|iPhone 8|iPhone 8|99.95%|
|iPhone 7 Plus|iPhone 7 Plus|100.00%|
|iPhone 7|iPhone 7|100.00%|
|iPhone 6s Plus|iPhone 6s Plus|100.00%|
|iPhone 6s|iPhone 6s, iPhone SE|99.93%|
|iPhone 6 Plus|iPhone 6 Plus|100.00%|
|iPhone 6|iPhone 6|100.00%|

### iPhones using browser in Desktop mode {#iphones_desktop_mode}
|Device|Display Mode|Results|Percentage|
|---|---|---|---|
|iPhone 17e|Standard|iPhone 16e, iPhone 17e|100.00%|
|iPhone 17e|Zoom|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e|100.00%|
|iPhone Air|Standard|iPhone Air|100.00%|
|iPhone Air|Zoom|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone Air|100.00%|
|iPhone 17 Pro Max|Standard|iPhone 16 Pro Max, iPhone 17 Pro Max|100.00%|
|iPhone 17 Pro Max|Zoom|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone Air|100.00%|
|iPhone 17 Pro|Standard|iPhone 16 Pro, iPhone 17, iPhone 17 Pro|100.00%|
|iPhone 17 Pro|Zoom|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e|100.00%|
|iPhone 17|Standard|iPhone 16 Pro, iPhone 17, iPhone 17 Pro|100.00%|
|iPhone 17|Zoom|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e|100.00%|
|iPhone 16e|Standard|iPhone 16e, iPhone 17e<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e<br/>iPhone 16e|50.88%<br/>28.07%<br/>21.05%|
|iPhone 16e|Zoom|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 16, iPhone 16 Pro, iPhone 16e|49.87%<br/>29.88%<br/>19.72%|
|iPhone 16 Pro Max|Standard|iPhone 16 Pro Max, iPhone 17 Pro Max<br/>iPhone 16 Pro Max|54.40%<br/>45.60%|
|iPhone 16 Pro Max|Zoom|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone Air<br/>iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max|54.39%<br/>17.10%<br/>17.08%<br/>11.40%|
|iPhone 16 Pro|Standard|iPhone 16 Pro, iPhone 17, iPhone 17 Pro<br/>iPhone 16 Pro|55.97%<br/>44.03%|
|iPhone 16 Pro|Zoom|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/>iPhone 15 Pro, iPhone 16, iPhone 16 Pro<br/>iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e|55.04%<br/>16.40%<br/>16.40%<br/>12.13%|
|iPhone 16 Plus|Standard|iPhone 15 Pro Max, iPhone 16 Plus<br/>iPhone 16 Plus<br/>iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus|62.93%<br/>22.26%<br/>14.81%|
|iPhone 16 Plus|Zoom|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone Air<br/>iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max|42.33%<br/>23.07%<br/>19.15%<br/>15.38%|
|iPhone 16|Standard|iPhone 15 Pro, iPhone 16<br/>iPhone 16<br/>iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16|62.81%<br/>22.37%<br/>14.81%|
|iPhone 16|Zoom|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/>iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 15 Pro, iPhone 16, iPhone 16 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e|41.49%<br/>22.67%<br/>18.82%<br/>16.97%|
|iPhone 15 Pro Max|Standard|iPhone 15 Pro Max, iPhone 16 Plus<br/>iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus<br/>iPhone 15 Pro Max<br/>iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max|51.19%<br/>23.25%<br/>15.11%<br/>10.46%|
|iPhone 15 Pro Max|Zoom|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone Air<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 15 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/>iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max|48.19%<br/>24.10%<br/>12.05%<br/>6.02%<br/>4.82%<br/>4.82%|
|iPhone 15 Pro|Standard|iPhone 15 Pro, iPhone 16<br/>iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16<br/>iPhone 15 Pro<br/>iPhone 14 Pro, iPhone 15, iPhone 15 Pro|48.65%<br/>22.03%<br/>15.05%<br/>14.27%|
|iPhone 15 Pro|Zoom|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/>iPhone 15 Pro<br/>iPhone 15 Pro, iPhone 16, iPhone 16 Pro|48.34%<br/>21.85%<br/>14.28%<br/>10.98%<br/>4.39%|
|iPhone 15 Plus|Standard|iPhone 14 Pro Max, iPhone 15 Plus<br/>iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/>iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus|83.86%<br/>8.06%<br/>8.06%|
|iPhone 15 Plus|Zoom|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max|82.60%<br/>8.70%<br/>4.35%<br/>4.35%|
|iPhone 15|Standard|iPhone 14 Pro, iPhone 15<br/>iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16<br/>iPhone 14 Pro, iPhone 15, iPhone 15 Pro|77.76%<br/>11.17%<br/>10.46%|
|iPhone 15|Zoom|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro|77.99%<br/>12.16%<br/>8.96%|
|iPhone 14 Pro Max|Standard|iPhone 14 Pro Max, iPhone 15 Plus<br/>iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus<br/>iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/>iPhone 14 Pro Max|70.71%<br/>14.39%<br/>10.74%<br/>4.16%|
|iPhone 14 Pro Max|Zoom|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max|68.66%<br/>14.60%<br/>5.96%<br/>5.95%<br/>4.71%|
|iPhone 14 Pro|Standard|iPhone 14 Pro, iPhone 15<br/>iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16<br/>iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/>iPhone 14 Pro|72.30%<br/>14.77%<br/>8.89%<br/>4.03%|
|iPhone 14 Pro|Zoom|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/>iPhone 12 mini, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro|75.13%<br/>14.47%<br/>8.68%<br/>1.55%|
|iPhone 14 Plus|Standard|iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus|99.90%|
|iPhone 14 Plus|Zoom|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max|70.48%<br/>13.59%<br/>6.79%<br/>5.46%<br/>3.57%|
|iPhone 14|Standard|iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro Max<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e|68.92%<br/>17.13%<br/>13.18%|
|iPhone 14|Zoom|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12 mini, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro|70.87%<br/>14.22%<br/>12.92%<br/>1.82%|
|iPhone SE (3rd Gen.)|Standard|iPhone SE (3rd Gen.)|100.00%|
|iPhone SE (3rd Gen.)|Zoom|iPhone SE (3rd Gen.)|100.00%|
|iPhone 13 Pro Max|Standard|iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus<br/>iPhone 12 Pro Max, iPhone 13 Pro Max<br/>iPhone 13 Pro Max|91.02%<br/>7.02%<br/>1.96%|
|iPhone 13 Pro Max|Zoom|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max|68.97%<br/>14.38%<br/>5.76%<br/>5.03%<br/>4.32%|
|iPhone 13 Pro|Standard|iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro Max<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro<br/>iPhone 13, iPhone 13 Pro, iPhone 14|62.42%<br/>13.00%<br/>11.70%<br/>7.67%<br/>5.20%|
|iPhone 13 Pro|Zoom|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12 mini, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro|63.34%<br/>13.29%<br/>13.25%<br/>5.30%<br/>4.53%|
|iPhone 13 mini|Standard|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max|68.11%<br/>13.61%<br/>6.80%<br/>5.44%<br/>5.44%|
|iPhone 13 mini|Zoom|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro|60.27%<br/>15.38%<br/>12.82%<br/>11.52%|
|iPhone 13|Standard|iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro Max<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro|69.38%<br/>14.03%<br/>8.42%<br/>7.58%|
|iPhone 13|Zoom|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro|69.20%<br/>14.12%<br/>11.30%<br/>4.82%|
|iPhone 12 Pro Max|Standard|iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus<br/>iPhone 12 Pro Max<br/>iPhone 12 Pro Max, iPhone 13 Pro Max|84.09%<br/>11.25%<br/>4.66%|
|iPhone 12 Pro Max|Zoom|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max|62.09%<br/>12.93%<br/>7.80%<br/>5.55%<br/>5.14%<br/>3.87%<br/>2.52%|
|iPhone 12 Pro|Standard|iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e<br/>iPhone 12, iPhone 12 Pro<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro Max<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro<br/>iPhone 12 Pro|64.34%<br/>12.32%<br/>11.25%<br/>7.29%<br/>3.54%<br/>1.27%|
|iPhone 12 Pro|Zoom|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro|57.77%<br/>12.72%<br/>11.37%<br/>10.00%<br/>8.04%|
|iPhone 12 mini|Standard|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/>iPhone 12 mini, iPhone 12 Pro Max|64.59%<br/>12.92%<br/>7.76%<br/>6.00%<br/>5.16%<br/>2.52%|
|iPhone 12 mini|Zoom|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro|65.85%<br/>13.43%<br/>11.43%<br/>5.96%<br/>2.70%|
|iPhone 12|Standard|iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14<br/>iPhone 12, iPhone 12 Pro<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro Max<br/>iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro|46.41%<br/>35.25%<br/>9.15%<br/>5.49%<br/>3.64%|
|iPhone 12|Zoom|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro<br/>iPhone 12, iPhone 12 mini, iPhone 12 Pro|65.86%<br/>13.45%<br/>10.76%<br/>5.90%<br/>3.97%|
|iPhone SE (2nd Gen.)|Standard|iPhone SE (2nd Gen.)|100.00%|
|iPhone SE (2nd Gen.)|Zoom|iPhone SE (2nd Gen.)|100.00%|
|iPhone 11 Pro Max|Standard|iPhone 11 Pro Max, iPhone XS Max<br/>iPhone 11 Pro Max|66.68%<br/>33.32%|
|iPhone 11 Pro Max|Zoom|iPhone 11 Pro, iPhone 11 Pro Max, iPhone XS, iPhone XS Max<br/>iPhone 11, iPhone 11 Pro, iPhone 11 Pro Max<br/>iPhone 11 Pro, iPhone 11 Pro Max, iPhone 12 mini, iPhone 12 Pro Max, iPhone X, iPhone XS, iPhone XS Max<br/>iPhone 11 Pro, iPhone 11 Pro Max|55.18%<br/>18.01%<br/>13.99%<br/>12.81%|
|iPhone 11 Pro|Standard|iPhone 11 Pro, iPhone 11 Pro Max, iPhone XS, iPhone XS Max<br/>iPhone 11 Pro, iPhone 11 Pro Max<br/>iPhone 11, iPhone 11 Pro, iPhone 11 Pro Max<br/>iPhone 11 Pro, iPhone 11 Pro Max, iPhone 12 mini, iPhone 12 Pro Max, iPhone X, iPhone XS, iPhone XS Max|51.80%<br/>24.94%<br/>15.18%<br/>8.07%|
|iPhone 11 Pro|Zoom|iPhone 11 Pro, iPhone XS<br/>iPhone 11 Pro|56.93%<br/>43.07%|
|iPhone 11|Standard|iPhone 11<br/>iPhone 11, iPhone XR|58.94%<br/>41.06%|
|iPhone 11|Zoom|iPhone 11<br/>iPhone 11, iPhone XR|86.55%<br/>13.45%|
|iPhone XS Max|Standard|iPhone XS Max<br/>iPhone 11 Pro Max, iPhone XS Max|60.06%<br/>39.94%|
|iPhone XS Max|Zoom|iPhone 11 Pro, iPhone 11 Pro Max, iPhone 12 mini, iPhone 12 Pro Max, iPhone X, iPhone XS, iPhone XS Max<br/>iPhone X, iPhone XS, iPhone XS Max<br/>iPhone 11 Pro, iPhone 11 Pro Max, iPhone XS, iPhone XS Max<br/>iPhone XS, iPhone XS Max|49.06%<br/>30.72%<br/>17.25%<br/>2.96%|
|iPhone XS|Standard|iPhone X, iPhone XS, iPhone XS Max<br/>iPhone 11 Pro, iPhone 11 Pro Max, iPhone 12 mini, iPhone 12 Pro Max, iPhone X, iPhone XS, iPhone XS Max<br/>iPhone 11 Pro, iPhone 11 Pro Max, iPhone XS, iPhone XS Max<br/>iPhone XS, iPhone XS Max|43.87%<br/>42.57%<br/>10.75%<br/>2.80%|
|iPhone XS|Zoom|iPhone 11 Pro, iPhone XS<br/>iPhone XS|64.44%<br/>35.56%|
|iPhone XR|Standard|iPhone 11, iPhone XR<br/>iPhone XR|83.74%<br/>16.26%|
|iPhone XR|Zoom|iPhone 11, iPhone XR<br/>iPhone XR|92.09%<br/>7.91%|
|iPhone X|Standard|iPhone X, iPhone XS, iPhone XS Max<br/>iPhone 11 Pro, iPhone 11 Pro Max, iPhone 12 mini, iPhone 12 Pro Max, iPhone X, iPhone XS, iPhone XS Max<br/>iPhone X|53.88%<br/>42.44%<br/>3.68%|
|iPhone X|Zoom|iPhone X|100.00%|
|iPhone 8 Plus|Standard|iPhone 8 Plus|100.00%|
|iPhone 8 Plus|Zoom|iPhone 8 Plus|100.00%|
|iPhone 8|Standard|iPhone 8<br/>iPhone 8, iPhone SE (2nd Gen.)|59.62%<br/>40.38%|
|iPhone 8|Zoom|iPhone 8|99.95%|
|iPhone 7 Plus|Standard|iPhone 7 Plus|100.00%|
|iPhone 7 Plus|Zoom|iPhone 7 Plus|100.00%|
|iPhone 7|Standard|iPhone 7|100.00%|
|iPhone 7|Zoom|iPhone 7|100.00%|
|iPhone SE|N/A|iPhone 6s, iPhone SE|99.99%|
|iPhone 6s Plus|Standard|iPhone 6s Plus|100.00%|
|iPhone 6s Plus|Zoom|iPhone 6s Plus|100.00%|
|iPhone 6s|Standard|iPhone 6s|100.00%|
|iPhone 6s|Zoom|iPhone 6s, iPhone SE|99.93%|

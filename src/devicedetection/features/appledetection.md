@page DeviceDetection_Features_AppleDetection Apple model detection

# Apple model detection

Apple devices are unique in that their User-Agent strings do not include hardware model
identifiers - unlike most Android devices.
This means it's not possible to identify the exact iPhone/iPad model using only the HTTP request headers.

To solve this, 51Degrees uses **client-side JavaScript** to gather additional evidence from the device,
such as screen resolution and GPU model.
This evidence can identify a model or narrow the result to a group of models, even when the User-Agent string is generic.

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
5. The server updates the detection result with the detected Apple model or group of models.

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

## Detection results for Apple devices {#detection-results}
Apple has continually worked to homogenize any information that a website can get about a device, through JavaScript or any other means. For more information, take a look at our [Upgrade Apple Device](https://51degrees.com/blog/upgrade-apple-device-detection) blog. 

Below we cover the detection results that are experienced for each iPhone, starting from the iPhone 3GS, when using Safari.

The 'percentage' column shows the share of data submissions that would return each detection result for the given display mode. For example, '100.00%' in Standard mode means all submissions for that device would return that result when passed to our detection script. '1.50%' means 1.5% of submissions would return that result. Results returned for fewer than 1% of submissions are not listed, so the percentages for a device can add up to less than 100%.

As we receive more data on Apple devices, this table will change. We will update this table following each update to the JavaScript. The tables currently match the released JavaScript created on 3 November 2026.

Zoom out in your browser to see more of the table.

### iPhones in mobile browser mode and standard display mode {#iphones_mobile_standard_mode}
|Device|Results|Percentage|
|---|---|---|
|iPhone 18 Pro Max|iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone 18 Pro Max|100.00%|
|iPhone 18 Pro|iPhone 16 Pro, iPhone 17, iPhone 17 Pro, iPhone 18 Pro|100.00%|
|iPhone 17e|iPhone 16e, iPhone 17e|100.00%|
|iPhone Air|iPhone Air|100.00%|
|iPhone 17 Pro Max|iPhone 16 Pro Max, iPhone 17 Pro Max<br/> iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone 18 Pro Max|82.35%<br/> 17.65%|
|iPhone 17 Pro|iPhone 16 Pro, iPhone 17, iPhone 17 Pro<br/> iPhone 16 Pro, iPhone 17, iPhone 17 Pro, iPhone 18 Pro|82.35%<br/> 17.65%|
|iPhone 17|iPhone 16 Pro, iPhone 17, iPhone 17 Pro<br/> iPhone 16 Pro, iPhone 17, iPhone 17 Pro, iPhone 18 Pro|82.35%<br/> 17.65%|
|iPhone 16e|iPhone 16e, iPhone 17e<br/> iPhone 16e<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e|57.65%<br/> 23.53%<br/> 18.82%|
|iPhone 16 Pro Max|iPhone 16 Pro Max, iPhone 17 Pro Max<br/> iPhone 16 Pro Max<br/> iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone 18 Pro Max|55.40%<br/> 37.54%<br/> 7.06%|
|iPhone 16 Pro|iPhone 16 Pro, iPhone 17, iPhone 17 Pro<br/> iPhone 16 Pro<br/> iPhone 16 Pro, iPhone 17, iPhone 17 Pro, iPhone 18 Pro|56.16%<br/> 36.92%<br/> 6.92%|
|iPhone 16 Plus|iPhone 15 Pro Max, iPhone 16 Plus<br/> iPhone 16 Plus<br/> iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus|68.72%<br/> 18.78%<br/> 12.50%|
|iPhone 16|iPhone 15 Pro, iPhone 16<br/> iPhone 16<br/> iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16|68.62%<br/> 18.87%<br/> 12.50%|
|iPhone 15 Pro Max|iPhone 15 Pro Max, iPhone 16 Plus<br/> iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus<br/> iPhone 15 Pro Max<br/> iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max|58.02%<br/> 19.99%<br/> 12.99%<br/> 9.00%|
|iPhone 15 Pro|iPhone 15 Pro, iPhone 16<br/> iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16<br/> iPhone 15 Pro<br/> iPhone 14 Pro, iPhone 15, iPhone 15 Pro|55.55%<br/> 19.07%<br/> 13.03%<br/> 12.36%|
|iPhone 15 Plus|iPhone 14 Pro Max, iPhone 15 Plus<br/> iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/> iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus|85.86%<br/> 7.06%<br/> 7.06%|
|iPhone 15|iPhone 14 Pro, iPhone 15<br/> iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16<br/> iPhone 14 Pro, iPhone 15, iPhone 15 Pro|80.45%<br/> 9.80%<br/> 9.18%|
|iPhone 14 Pro Max|iPhone 14 Pro Max, iPhone 15 Plus<br/> iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus<br/> iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/> iPhone 14 Pro Max|73.72%<br/> 12.90%<br/> 9.64%<br/> 3.73%|
|iPhone 14 Pro|iPhone 14 Pro, iPhone 15<br/> iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16<br/> iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/> iPhone 14 Pro|74.69%<br/> 13.50%<br/> 8.13%<br/> 3.69%|
|iPhone 14 Plus|iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus|99.91%|
|iPhone 14|iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro Max<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e|71.55%<br/> 15.69%<br/> 12.07%|
|iPhone SE (3rd Gen.)|iPhone SE (3rd Gen.)|100.00%|
|iPhone 13 Pro Max|iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus<br/> iPhone 12 Pro Max, iPhone 13 Pro Max<br/> iPhone 13 Pro Max|91.82%<br/> 6.39%<br/> 1.79%|
|iPhone 13 Pro|iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro Max<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro<br/> iPhone 13, iPhone 13 Pro, iPhone 14|65.56%<br/> 11.91%<br/> 10.72%<br/> 7.03%<br/> 4.76%|
|iPhone 13 mini|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max|70.89%<br/> 12.43%<br/> 6.21%<br/> 4.97%<br/> 4.97%|
|iPhone 13|iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro Max<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro|72.12%<br/> 12.78%<br/> 7.67%<br/> 6.90%|
|iPhone 12 Pro Max|iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus<br/> iPhone 12 Pro Max<br/> iPhone 12 Pro Max, iPhone 13 Pro Max|85.29%<br/> 10.40%<br/> 4.31%|
|iPhone 12 Pro|iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e<br/> iPhone 12, iPhone 12 Pro<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro Max<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro<br/> iPhone 12 Pro|67.17%<br/> 11.34%<br/> 10.35%<br/> 6.71%<br/> 3.25%<br/> 1.17%|
|iPhone 12 mini|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max|67.53%<br/> 11.85%<br/> 7.11%<br/> 5.50%<br/> 4.74%<br/> 2.31%|
|iPhone 12|iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14<br/> iPhone 12, iPhone 12 Pro<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro Max<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro|49.64%<br/> 33.13%<br/> 8.60%<br/> 5.16%<br/> 3.42%|
|iPhone SE (2nd Gen.)|iPhone SE (2nd Gen.)|100.00%|
|iPhone 11 Pro Max|iPhone 11 Pro Max, iPhone XS Max<br/> iPhone 11 Pro Max|60.82%<br/> 39.18%|
|iPhone 11 Pro|iPhone 11 Pro, iPhone 11 Pro Max, iPhone XS, iPhone XS Max<br/> iPhone 11 Pro, iPhone 11 Pro Max<br/> iPhone 11, iPhone 11 Pro, iPhone 11 Pro Max<br/> iPhone 11 Pro, iPhone 11 Pro Max, iPhone 12 mini, iPhone 12 Pro Max, iPhone X, iPhone XS, iPhone XS Max|48.15%<br/> 30.24%<br/> 14.11%<br/> 7.50%|
|iPhone 11|iPhone 11<br/> iPhone 11, iPhone XR|61.15%<br/> 38.85%|
|iPhone XS Max|iPhone XS Max<br/> iPhone 11 Pro Max, iPhone XS Max|60.06%<br/> 39.94%|
|iPhone XS|iPhone X, iPhone XS, iPhone XS Max<br/> iPhone 11 Pro, iPhone 11 Pro Max, iPhone 12 mini, iPhone 12 Pro Max, iPhone X, iPhone XS, iPhone XS Max<br/> iPhone 11 Pro, iPhone 11 Pro Max, iPhone XS, iPhone XS Max<br/> iPhone XS, iPhone XS Max|43.87%<br/> 42.57%<br/> 10.75%<br/> 2.80%|
|iPhone XR|iPhone 11, iPhone XR<br/> iPhone XR|83.74%<br/> 16.26%|
|iPhone X|iPhone X, iPhone XS, iPhone XS Max<br/> iPhone 11 Pro, iPhone 11 Pro Max, iPhone 12 mini, iPhone 12 Pro Max, iPhone X, iPhone XS, iPhone XS Max<br/> iPhone X|53.88%<br/> 42.44%<br/> 3.68%|
|iPhone 8 Plus|iPhone 8 Plus|100.00%|
|iPhone 8|iPhone 8<br/> iPhone 8, iPhone SE (2nd Gen.)|59.62%<br/> 40.38%|
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

### iPhones in mobile browser mode and zoomed display mode {#iphones_mobile_zoom_mode}
This table is for display zoom, an iPhone accessibility feature. It is not the normal zoom operation in browsers. It is enabled in Settings > Display & Brightness > Display Zoom > Zoomed.

|Device|Results|Percentage|
|---|---|---|
|iPhone 18 Pro Max|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone 18 Pro Max, iPhone Air|100.00%|
|iPhone 18 Pro|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e, iPhone 18 Pro|100.00%|
|iPhone 17e|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/> iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e, iPhone 18 Pro|72.83%<br/> 27.17%|
|iPhone Air|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone Air<br/> iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone 18 Pro Max, iPhone Air|82.36%<br/> 17.64%|
|iPhone 17 Pro Max|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone Air<br/> iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone 18 Pro Max, iPhone Air|83.44%<br/> 16.56%|
|iPhone 17 Pro|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/> iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e, iPhone 18 Pro|82.88%<br/> 17.12%|
|iPhone 17|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/> iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e, iPhone 18 Pro|82.25%<br/> 17.75%|
|iPhone 16e|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 16e<br/> iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e, iPhone 18 Pro|49.72%<br/> 19.39%<br/> 13.41%<br/> 12.80%<br/> 4.34%|
|iPhone 16 Pro Max|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone Air<br/> iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone 18 Pro Max, iPhone Air|53.63%<br/> 13.91%<br/> 13.89%<br/> 9.27%<br/> 9.27%|
|iPhone 16 Pro|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/> iPhone 15 Pro, iPhone 16, iPhone 16 Pro<br/> iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e, iPhone 18 Pro|55.38%<br/> 13.76%<br/> 13.76%<br/> 10.19%<br/> 6.88%|
|iPhone 16 Plus|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone Air<br/> iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone 18 Pro Max, iPhone Air|42.31%<br/> 19.23%<br/> 15.96%<br/> 12.82%<br/> 9.62%|
|iPhone 16|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/> iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 15 Pro, iPhone 16, iPhone 16 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e, iPhone 18 Pro|41.26%<br/> 19.07%<br/> 15.84%<br/> 14.28%<br/> 9.52%|
|iPhone 15 Pro Max|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone Air<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 15 Pro Max<br/> iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone 18 Pro Max, iPhone Air<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/> iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max|48.96%<br/> 20.83%<br/> 10.42%<br/> 6.25%<br/> 5.21%<br/> 4.17%<br/> 4.17%|
|iPhone 15 Pro|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/> iPhone 15 Pro<br/> iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e, iPhone 18 Pro<br/> iPhone 15 Pro, iPhone 16, iPhone 16 Pro|49.03%<br/> 19.12%<br/> 12.49%<br/> 9.61%<br/> 5.77%<br/> 3.84%|
|iPhone 15 Plus|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max|84.90%<br/> 7.55%<br/> 3.78%<br/> 3.78%|
|iPhone 15|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro|80.72%<br/> 10.65%<br/> 7.85%|
|iPhone 14 Pro Max|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max|71.62%<br/> 13.22%<br/> 5.40%<br/> 5.39%<br/> 4.27%|
|iPhone 14 Pro|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/> iPhone 12 mini, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro|77.42%<br/> 13.14%<br/> 7.88%<br/> 1.41%|
|iPhone 14 Plus|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max|73.21%<br/> 12.33%<br/> 6.16%<br/> 4.95%<br/> 3.24%|
|iPhone 14|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12 mini, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro|73.29%<br/> 13.04%<br/> 11.85%<br/> 1.67%|
|iPhone SE (3rd Gen.)|iPhone SE (3rd Gen.)|100.00%|
|iPhone 13 Pro Max|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max|71.75%<br/> 13.09%<br/> 5.24%<br/> 4.58%<br/> 3.94%|
|iPhone 13 Pro|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12 mini, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro|66.45%<br/> 12.16%<br/> 12.13%<br/> 4.85%<br/> 4.15%|
|iPhone 13 mini|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro|63.56%<br/> 14.11%<br/> 11.76%<br/> 10.57%|
|iPhone 13|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro|71.79%<br/> 12.93%<br/> 10.35%<br/> 4.41%|
|iPhone 12 Pro Max|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max|65.24%<br/> 11.86%<br/> 7.15%<br/> 5.09%<br/> 4.71%<br/> 3.55%<br/> 2.31%|
|iPhone 12 Pro|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro|61.02%<br/> 11.74%<br/> 10.49%<br/> 9.23%<br/> 7.42%|
|iPhone 12 mini|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro|68.79%<br/> 12.28%<br/> 10.45%<br/> 5.45%<br/> 2.47%|
|iPhone 12|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro|68.80%<br/> 12.29%<br/> 9.83%<br/> 5.40%<br/> 3.63%|
|iPhone SE (2nd Gen.)|iPhone SE (2nd Gen.)|100.00%|
|iPhone 11 Pro Max|iPhone 11 Pro, iPhone 11 Pro Max, iPhone XS, iPhone XS Max<br/> iPhone 11 Pro, iPhone 11 Pro Max<br/> iPhone 11, iPhone 11 Pro, iPhone 11 Pro Max<br/> iPhone 11 Pro, iPhone 11 Pro Max, iPhone 12 mini, iPhone 12 Pro Max, iPhone X, iPhone XS, iPhone XS Max|50.90%<br/> 19.58%<br/> 16.61%<br/> 12.90%|
|iPhone 11 Pro|iPhone 11 Pro, iPhone XS<br/> iPhone 11 Pro|52.82%<br/> 47.18%|
|iPhone 11|iPhone 11<br/> iPhone 11, iPhone XR|87.49%<br/> 12.51%|
|iPhone XS Max|iPhone 11 Pro, iPhone 11 Pro Max, iPhone 12 mini, iPhone 12 Pro Max, iPhone X, iPhone XS, iPhone XS Max<br/> iPhone X, iPhone XS, iPhone XS Max<br/> iPhone 11 Pro, iPhone 11 Pro Max, iPhone XS, iPhone XS Max<br/> iPhone XS, iPhone XS Max|49.06%<br/> 30.72%<br/> 17.25%<br/> 2.96%|
|iPhone XS|iPhone 11 Pro, iPhone XS<br/> iPhone XS|64.44%<br/> 35.56%|
|iPhone XR|iPhone 11, iPhone XR<br/> iPhone XR|92.09%<br/> 7.91%|
|iPhone X|iPhone X|100.00%|
|iPhone 8 Plus|iPhone 8 Plus|100.00%|
|iPhone 8|iPhone 8|99.95%|
|iPhone 7 Plus|iPhone 7 Plus|100.00%|
|iPhone 7|iPhone 7|100.00%|
|iPhone 6s Plus|iPhone 6s Plus|100.00%|
|iPhone 6s|iPhone 6s, iPhone SE|99.93%|
|iPhone 6 Plus|iPhone 6 Plus|100.00%|
|iPhone 6|iPhone 6|100.00%|

### iPhones in mobile browser mode and cover display mode {#iphones_mobile_cover_display_mode}
|Device|Results|Percentage|
|---|---|---|
|iPhone Duo|iPhone Duo|100.00%|

### iPhones in desktop browser mode {#iphones_desktop_mode}
|Device|Display Mode|Results|Percentage|
|---|---|---|---|
|iPhone Duo|Cover display|iPhone Duo|100.00%|
|iPhone 18 Pro Max|Standard|iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone 18 Pro Max|100.00%|
|iPhone 18 Pro Max|Zoom|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone 18 Pro Max, iPhone Air|100.00%|
|iPhone 18 Pro|Standard|iPhone 16 Pro, iPhone 17, iPhone 17 Pro, iPhone 18 Pro|100.00%|
|iPhone 18 Pro|Zoom|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e, iPhone 18 Pro|100.00%|
|iPhone 17e|Standard|iPhone 16e, iPhone 17e|100.00%|
|iPhone 17e|Zoom|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/> iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e, iPhone 18 Pro|72.83%<br/> 27.17%|
|iPhone Air|Standard|iPhone Air|100.00%|
|iPhone Air|Zoom|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone Air<br/> iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone 18 Pro Max, iPhone Air|82.36%<br/> 17.64%|
|iPhone 17 Pro Max|Standard|iPhone 16 Pro Max, iPhone 17 Pro Max<br/> iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone 18 Pro Max|82.35%<br/> 17.65%|
|iPhone 17 Pro Max|Zoom|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone Air<br/> iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone 18 Pro Max, iPhone Air|83.44%<br/> 16.56%|
|iPhone 17 Pro|Standard|iPhone 16 Pro, iPhone 17, iPhone 17 Pro<br/> iPhone 16 Pro, iPhone 17, iPhone 17 Pro, iPhone 18 Pro|82.35%<br/> 17.65%|
|iPhone 17 Pro|Zoom|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/> iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e, iPhone 18 Pro|82.88%<br/> 17.12%|
|iPhone 17|Standard|iPhone 16 Pro, iPhone 17, iPhone 17 Pro<br/> iPhone 16 Pro, iPhone 17, iPhone 17 Pro, iPhone 18 Pro|82.35%<br/> 17.65%|
|iPhone 17|Zoom|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/> iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e, iPhone 18 Pro|82.25%<br/> 17.75%|
|iPhone 16e|Standard|iPhone 16e, iPhone 17e<br/> iPhone 16e<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e|57.65%<br/> 23.53%<br/> 18.82%|
|iPhone 16e|Zoom|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 16e<br/> iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e, iPhone 18 Pro|49.72%<br/> 19.39%<br/> 13.41%<br/> 12.80%<br/> 4.34%|
|iPhone 16 Pro Max|Standard|iPhone 16 Pro Max, iPhone 17 Pro Max<br/> iPhone 16 Pro Max<br/> iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone 18 Pro Max|55.40%<br/> 37.54%<br/> 7.06%|
|iPhone 16 Pro Max|Zoom|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone Air<br/> iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone 18 Pro Max, iPhone Air|53.63%<br/> 13.91%<br/> 13.89%<br/> 9.27%<br/> 9.27%|
|iPhone 16 Pro|Standard|iPhone 16 Pro, iPhone 17, iPhone 17 Pro<br/> iPhone 16 Pro<br/> iPhone 16 Pro, iPhone 17, iPhone 17 Pro, iPhone 18 Pro|56.16%<br/> 36.92%<br/> 6.92%|
|iPhone 16 Pro|Zoom|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/> iPhone 15 Pro, iPhone 16, iPhone 16 Pro<br/> iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e, iPhone 18 Pro|55.38%<br/> 13.76%<br/> 13.76%<br/> 10.19%<br/> 6.88%|
|iPhone 16 Plus|Standard|iPhone 15 Pro Max, iPhone 16 Plus<br/> iPhone 16 Plus<br/> iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus|68.72%<br/> 18.78%<br/> 12.50%|
|iPhone 16 Plus|Zoom|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone Air<br/> iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone 18 Pro Max, iPhone Air|42.31%<br/> 19.23%<br/> 15.96%<br/> 12.82%<br/> 9.62%|
|iPhone 16|Standard|iPhone 15 Pro, iPhone 16<br/> iPhone 16<br/> iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16|68.62%<br/> 18.87%<br/> 12.50%|
|iPhone 16|Zoom|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/> iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 15 Pro, iPhone 16, iPhone 16 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e, iPhone 18 Pro|41.26%<br/> 19.07%<br/> 15.84%<br/> 14.28%<br/> 9.52%|
|iPhone 15 Pro Max|Standard|iPhone 15 Pro Max, iPhone 16 Plus<br/> iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus<br/> iPhone 15 Pro Max<br/> iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max|58.02%<br/> 19.99%<br/> 12.99%<br/> 9.00%|
|iPhone 15 Pro Max|Zoom|iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone Air<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 15 Pro Max<br/> iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max, iPhone 17 Pro Max, iPhone 18 Pro Max, iPhone Air<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/> iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max|48.96%<br/> 20.83%<br/> 10.42%<br/> 6.25%<br/> 5.21%<br/> 4.17%<br/> 4.17%|
|iPhone 15 Pro|Standard|iPhone 15 Pro, iPhone 16<br/> iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16<br/> iPhone 15 Pro<br/> iPhone 14 Pro, iPhone 15, iPhone 15 Pro|55.55%<br/> 19.07%<br/> 13.03%<br/> 12.36%|
|iPhone 15 Pro|Zoom|iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/> iPhone 15 Pro<br/> iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e, iPhone 17, iPhone 17 Pro, iPhone 17e, iPhone 18 Pro<br/> iPhone 15 Pro, iPhone 16, iPhone 16 Pro|49.03%<br/> 19.12%<br/> 12.49%<br/> 9.61%<br/> 5.77%<br/> 3.84%|
|iPhone 15 Plus|Standard|iPhone 14 Pro Max, iPhone 15 Plus<br/> iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/> iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus|85.86%<br/> 7.06%<br/> 7.06%|
|iPhone 15 Plus|Zoom|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max|84.90%<br/> 7.55%<br/> 3.78%<br/> 3.78%|
|iPhone 15|Standard|iPhone 14 Pro, iPhone 15<br/> iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16<br/> iPhone 14 Pro, iPhone 15, iPhone 15 Pro|80.45%<br/> 9.80%<br/> 9.18%|
|iPhone 15|Zoom|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro|80.72%<br/> 10.65%<br/> 7.85%|
|iPhone 14 Pro Max|Standard|iPhone 14 Pro Max, iPhone 15 Plus<br/> iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus<br/> iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/> iPhone 14 Pro Max|73.72%<br/> 12.90%<br/> 9.64%<br/> 3.73%|
|iPhone 14 Pro Max|Zoom|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max|71.62%<br/> 13.22%<br/> 5.40%<br/> 5.39%<br/> 4.27%|
|iPhone 14 Pro|Standard|iPhone 14 Pro, iPhone 15<br/> iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16<br/> iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/> iPhone 14 Pro|74.69%<br/> 13.50%<br/> 8.13%<br/> 3.69%|
|iPhone 14 Pro|Zoom|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/> iPhone 12 mini, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro|77.42%<br/> 13.14%<br/> 7.88%<br/> 1.41%|
|iPhone 14 Plus|Standard|iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus|99.91%|
|iPhone 14 Plus|Zoom|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max|73.21%<br/> 12.33%<br/> 6.16%<br/> 4.95%<br/> 3.24%|
|iPhone 14|Standard|iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro Max<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e|71.55%<br/> 15.69%<br/> 12.07%|
|iPhone 14|Zoom|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12 mini, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro|73.29%<br/> 13.04%<br/> 11.85%<br/> 1.67%|
|iPhone SE (3rd Gen.)|Standard|iPhone SE (3rd Gen.)|100.00%|
|iPhone SE (3rd Gen.)|Zoom|iPhone SE (3rd Gen.)|100.00%|
|iPhone 13 Pro Max|Standard|iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus<br/> iPhone 12 Pro Max, iPhone 13 Pro Max<br/> iPhone 13 Pro Max|91.82%<br/> 6.39%<br/> 1.79%|
|iPhone 13 Pro Max|Zoom|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max|71.75%<br/> 13.09%<br/> 5.24%<br/> 4.58%<br/> 3.94%|
|iPhone 13 Pro|Standard|iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro Max<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro<br/> iPhone 13, iPhone 13 Pro, iPhone 14|65.56%<br/> 11.91%<br/> 10.72%<br/> 7.03%<br/> 4.76%|
|iPhone 13 Pro|Zoom|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12 mini, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro|66.45%<br/> 12.16%<br/> 12.13%<br/> 4.85%<br/> 4.15%|
|iPhone 13 mini|Standard|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max|70.89%<br/> 12.43%<br/> 6.21%<br/> 4.97%<br/> 4.97%|
|iPhone 13 mini|Zoom|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro|63.56%<br/> 14.11%<br/> 11.76%<br/> 10.57%|
|iPhone 13|Standard|iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro Max<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro|72.12%<br/> 12.78%<br/> 7.67%<br/> 6.90%|
|iPhone 13|Zoom|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro|71.79%<br/> 12.93%<br/> 10.35%<br/> 4.41%|
|iPhone 12 Pro Max|Standard|iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus<br/> iPhone 12 Pro Max<br/> iPhone 12 Pro Max, iPhone 13 Pro Max|85.29%<br/> 10.40%<br/> 4.31%|
|iPhone 12 Pro Max|Zoom|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max|65.24%<br/> 11.86%<br/> 7.15%<br/> 5.09%<br/> 4.71%<br/> 3.55%<br/> 2.31%|
|iPhone 12 Pro|Standard|iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e<br/> iPhone 12, iPhone 12 Pro<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro Max<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro<br/> iPhone 12 Pro|67.17%<br/> 11.34%<br/> 10.35%<br/> 6.71%<br/> 3.25%<br/> 1.17%|
|iPhone 12 Pro|Zoom|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro|61.02%<br/> 11.74%<br/> 10.49%<br/> 9.23%<br/> 7.42%|
|iPhone 12 mini|Standard|iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone 16 Plus, iPhone 16 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max, iPhone SE (2nd Gen.)<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max, iPhone 13 mini, iPhone 13 Pro Max, iPhone 14 Plus, iPhone 14 Pro Max, iPhone 15 Plus, iPhone 15 Pro Max<br/> iPhone 12 mini, iPhone 12 Pro Max|67.53%<br/> 11.85%<br/> 7.11%<br/> 5.50%<br/> 4.74%<br/> 2.31%|
|iPhone 12 mini|Zoom|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro|68.79%<br/> 12.28%<br/> 10.45%<br/> 5.45%<br/> 2.47%|
|iPhone 12|Standard|iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14<br/> iPhone 12, iPhone 12 Pro<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 16e<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro, iPhone 14, iPhone 14 Pro Max<br/> iPhone 12, iPhone 12 Pro, iPhone 13, iPhone 13 Pro|49.64%<br/> 33.13%<br/> 8.60%<br/> 5.16%<br/> 3.42%|
|iPhone 12|Zoom|iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro, iPhone 16, iPhone 16 Pro, iPhone 16e<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro, iPhone 14, iPhone 14 Pro, iPhone 15, iPhone 15 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro, iPhone 13, iPhone 13 mini, iPhone 13 Pro<br/> iPhone 12, iPhone 12 mini, iPhone 12 Pro|68.80%<br/> 12.29%<br/> 9.83%<br/> 5.40%<br/> 3.63%|
|iPhone SE (2nd Gen.)|Standard|iPhone SE (2nd Gen.)|100.00%|
|iPhone SE (2nd Gen.)|Zoom|iPhone SE (2nd Gen.)|100.00%|
|iPhone 11 Pro Max|Standard|iPhone 11 Pro Max, iPhone XS Max<br/> iPhone 11 Pro Max|60.82%<br/> 39.18%|
|iPhone 11 Pro Max|Zoom|iPhone 11 Pro, iPhone 11 Pro Max, iPhone XS, iPhone XS Max<br/> iPhone 11 Pro, iPhone 11 Pro Max<br/> iPhone 11, iPhone 11 Pro, iPhone 11 Pro Max<br/> iPhone 11 Pro, iPhone 11 Pro Max, iPhone 12 mini, iPhone 12 Pro Max, iPhone X, iPhone XS, iPhone XS Max|50.90%<br/> 19.58%<br/> 16.61%<br/> 12.90%|
|iPhone 11 Pro|Standard|iPhone 11 Pro, iPhone 11 Pro Max, iPhone XS, iPhone XS Max<br/> iPhone 11 Pro, iPhone 11 Pro Max<br/> iPhone 11, iPhone 11 Pro, iPhone 11 Pro Max<br/> iPhone 11 Pro, iPhone 11 Pro Max, iPhone 12 mini, iPhone 12 Pro Max, iPhone X, iPhone XS, iPhone XS Max|48.15%<br/> 30.24%<br/> 14.11%<br/> 7.50%|
|iPhone 11 Pro|Zoom|iPhone 11 Pro, iPhone XS<br/> iPhone 11 Pro|52.82%<br/> 47.18%|
|iPhone 11|Standard|iPhone 11<br/> iPhone 11, iPhone XR|61.15%<br/> 38.85%|
|iPhone 11|Zoom|iPhone 11<br/> iPhone 11, iPhone XR|87.49%<br/> 12.51%|
|iPhone XS Max|Standard|iPhone XS Max<br/> iPhone 11 Pro Max, iPhone XS Max|60.06%<br/> 39.94%|
|iPhone XS Max|Zoom|iPhone 11 Pro, iPhone 11 Pro Max, iPhone 12 mini, iPhone 12 Pro Max, iPhone X, iPhone XS, iPhone XS Max<br/> iPhone X, iPhone XS, iPhone XS Max<br/> iPhone 11 Pro, iPhone 11 Pro Max, iPhone XS, iPhone XS Max<br/> iPhone XS, iPhone XS Max|49.06%<br/> 30.72%<br/> 17.25%<br/> 2.96%|
|iPhone XS|Standard|iPhone X, iPhone XS, iPhone XS Max<br/> iPhone 11 Pro, iPhone 11 Pro Max, iPhone 12 mini, iPhone 12 Pro Max, iPhone X, iPhone XS, iPhone XS Max<br/> iPhone 11 Pro, iPhone 11 Pro Max, iPhone XS, iPhone XS Max<br/> iPhone XS, iPhone XS Max|43.87%<br/> 42.57%<br/> 10.75%<br/> 2.80%|
|iPhone XS|Zoom|iPhone 11 Pro, iPhone XS<br/> iPhone XS|64.44%<br/> 35.56%|
|iPhone XR|Standard|iPhone 11, iPhone XR<br/> iPhone XR|83.74%<br/> 16.26%|
|iPhone XR|Zoom|iPhone 11, iPhone XR<br/> iPhone XR|92.09%<br/> 7.91%|
|iPhone X|Standard|iPhone X, iPhone XS, iPhone XS Max<br/> iPhone 11 Pro, iPhone 11 Pro Max, iPhone 12 mini, iPhone 12 Pro Max, iPhone X, iPhone XS, iPhone XS Max<br/> iPhone X|53.88%<br/> 42.44%<br/> 3.68%|
|iPhone X|Zoom|iPhone X|100.00%|
|iPhone 8 Plus|Standard|iPhone 8 Plus|100.00%|
|iPhone 8 Plus|Zoom|iPhone 8 Plus|100.00%|
|iPhone 8|Standard|iPhone 8<br/> iPhone 8, iPhone SE (2nd Gen.)|59.62%<br/> 40.38%|
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

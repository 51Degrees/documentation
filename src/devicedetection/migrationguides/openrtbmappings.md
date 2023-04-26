@page DeviceDetection_MigrationGuides_OpenRTBMappings OpenRTB Mappings

# Introduction 

The RTB Project is an API specification for companies needing an open protocol for the automated trading of digital media across a broader range of platforms, devices, and advertising solutions. To aid those wishing to enhance the capture of device data, we've compiled a guide to map OpenRTB Object: Device fields to 51Degrees properties and values. The full Open RTB API Specification can be found [here](https://iabtechlab.com/wp-content/uploads/2022/04/OpenRTB-2-6_FINAL.pdf) with the Device Object specification in section 3.2.18 Device (page 28).

# OpenRTB API Mappings

The following table lists the OpenRTB (3.2.18 Object: Device) field names, supported 51Degrees properties that contain equivalent data, alongside notes that may be helpful when mapping OpenRTB and 51Degrees values.

|OpenRTB property|OpenRTB Description|51Degrees property|51Degrees Comments|
|---|---|---|---|
|ua|Browser user agent string.|User-Agent field from HTTP header.|The User-Agent string can be used to identify the device, application, operating system, software vendor or software version of the requesting device.|
|sua|Structured user agent information defined by a UserAgent object (see Section 3.2.29 of the OpenRTB 2.6 spec).|Info obtained from the [User-Agent Client Hints (UA-CH) HTTP headers](@ref DeviceDetection_Features_UACH_Overview) (or equivalent NavigatorUAData JS object) sent by the browsers that support it.|ua may contain a reduced User-Agent string, thus if present, 'sua' should be considered a more accurate and complete device info. [You can also convert UA-CH values into sua information (and vice versa)](https://github.com/51Degrees/sua-uach-conversion) with our [sua and UA-CH converter](https://51degrees.github.io/sua-uach-conversion/).|
|devicetype|The general type of device. Refer to List 5.21.|[DeviceType](https://51degrees.com/resources/property-dictionary#DeviceType)| Indicates the type of the device based on values set in other properties, such as IsMobile, IsTablet, IsSmartphone, IsSmallScreen etc.<br>See [OpenRTB Device Type Mappings](@ref DeviceDetection_MigrationGuides_OpenRTBMappings_DeviceType) table below.|
|make|Device make (e.g., “Apple”)|[HardwareVendor](https://51degrees.com/resources/property-dictionary#HardwareVendor)|Indicates the name of the company that manufactures the device or primarily sells it, e.g. Samsung.<br>[List of Manufactures](https://51degrees.com/developers/documentation/open-rtb-mappings/hardware-vendors).
|model|Device model (e.g., “iPhone”)|[HardwareModel](https://51degrees.com/resources/property-dictionary#HardwareModel)| Indicates the model name or number used primarily by the hardware vendor to identify the device, e.g.SM-T805S. When a model identifier is not available the HardwareName will be used.<br>[List of Models](https://51degrees.com/developers/documentation/open-rtb-mappings/hardware-models).|
|os|Device operating system (e.g., “iOS”)|[PlatformName](https://51degrees.com/resources/property-dictionary#PlatformName)|Indicates the name of the operating system the device is using.<br>[List of Operating Systems](https://51degrees.com/developers/documentation/open-rtb-mappings/platform-names).|
|osv|Device operating system version (e.g., “3.1.2”).|[PlatformVersion](https://51degrees.com/resources/property-dictionary#PlatformVersion)|Indicates the version or subversion of the software platform.|
|hwv|Hardware version of the device (e.g., “5S” for iPhone 5S).||This information is contained within the HardwareModel property (OpenRTB:model).|
|h|Physical height of the screen in pixels|[ScreenPixelsHeight](https://51degrees.com/resources/property-dictionary#ScreenPixelsHeight)|Indicates the height of the device's screen in pixels. This property is not applicable for a device that does not have a screen. For devices such as tablets or TV which are predominantly used in landscape mode, the pixel height will be the smaller value compared to the pixel width.|
|w|Physical width of the screen in pixels|[ScreenPixelsWidth](https://51degrees.com/resources/property-dictionary#ScreenPixelsWidth)|Indicates the width of the device's screen in pixels. This property is not applicable for a device that does not have a screen. For devices such as tablets or TV which are predominantly used in landscape mode, the pixel width will be the larger value compared to the pixel height.|
|ppi|Screen size as pixels per linear inch.|(([ScreenPixelsWidth](https://51degrees.com/resources/property-dictionary#ScreenPixelsWidth) / [ScreenInchesWidth](https://51degrees.com/resources/property-dictionary#ScreenInchesWidth)) + ([ScreenPixelsHeight]( https://51degrees.com/resources/property-dictionary#ScreenPixelsHeight) / [ScreenInchesHeight]( https://51degrees.com/resources/property-dictionary#ScreenInchesHeight))) / 2|Screen size as pixels per linear inch computed from screen dimensions in pixels and inches.|
|js|Support for JavaScript, where 0 = no, 1 = yes.|[Javascript](https://51degrees.com/resources/property-dictionary#Javascript)|Indicates if the browser supports JavaScript.|

# OpenRTB Device Type Mappings @anchor DeviceDetection_MigrationGuides_OpenRTBMappings_DeviceType
This table shows the mappings between OpenRTB Device Types (5.21) and 51Degrees [DeviceType](https://51degrees.com/resources/property-dictionary#DeviceType) Values.

|OpenRTB Value|OpenRTB Description|51Degrees Value|
|---|---|---|
|1|Mobile/Tablet|Mobile|
|2|Personal Computer|Desktop|
|3|Connected TV|Tv|
|4|Phone|SmartPhone, SmallScreen|
|5|Tablet|Tablet|
|6|Connected Device|Console, EReader, SmartWatch|
|7|Set Top Box|MediaHub|

# Unsupported OpenRTB API Mappings
Currently, the following fields are not directly supported by 51Degrees. Unless stated otherwise, this is because the value is unique to an individual device.

|OpenRTB property|OpenRTB Description|Source|51Degrees Comments|
|---|---|---|---|
|geo|Location of the device assumed to be the user’s current location defined by a Geo object (Section 3.2.19).||[Contact Us](https://51degrees.com/contact-us)|
|dnt|Standard “Do Not Track” flag as set in the header by the browser, where 0 = tracking is unrestricted, 1 = do not track||This data is not captured as it is unique to a device.|
|lmt|“Limit Ad Tracking” signal commercially endorsed (e.g., iOS, Android), where 0 = tracking is unrestricted, 1 = tracking must be limited per commercial guidelines.||This data is not captured as it is unique to a device.|
|ip|IPv4 address closest to device.|From HTTP requests.|[Contact Us](https://51degrees.com/contact-us)|
|ipv6|IP address closest to device as IPv6.|From HTTP requests.|This data is not captured as IPv6 adoption is not universal enough to justify.|
|pxratio|The ratio of physical pixels to device independent pixels.||[Contact Us](https://51degrees.com/contact-us)|
|geofetch|Indicates if the geolocation API will be available to JavaScript code running in the banner, where 0 = no, 1 = yes.||This data is not captured as it is unique to a device.|
|flashver|Version of Flash supported by the browser.||Not mapped as legacy property.|
|language|Browser language using ISO-639-1-alpha-2.|Accept-Language field from HTTP header.|This data is not captured as it is unique to a device.|
|carrier|Carrier or ISP (e.g., “VERIZON”) using exchange curated string names which should be published to bidders a priori.||[Contact Us](https://51degrees.com/contact-us)|
|mccmnc|Mobile carrier as the concatenated MCC-MNC code (e.g., “310-005” identifies Verizon Wireless CDMA in the USA).||[Contact Us](https://51degrees.com/contact-us)|
|connectiontype|Network connection type. Refer to List 5.22.||[Contact Us](https://51degrees.com/contact-us)|
|ifa|ID sanctioned for advertiser use in the clear (i.e., not hashed).|||
|didsha1|Hardware device ID (e.g., IMEI); hashed via SHA1.|||	 
|didmd5|Hardware device ID (e.g., IMEI); hashed via MD5.|||
|dpidsha1|Platform device ID (e.g., Android ID); hashed via SHA1.|||
|dpidmd5|Platform device ID (e.g., Android ID); hashed via MD5.|||
|macsha1|MAC address of the device; hashed via SHA1.|||
|macmd5|MAC address of the device; hashed via MD5.|||
|ext|Placeholder for exchange-specific extensions to OpenRTB.|n/a||

# OpenRTB Property Values
Below are several lists of values for use with OpenRTB, they are all open source Creative Commons licensed.

- [Hardware Vendors](https://51degrees.com/developers/documentation/open-rtb-mappings/hardware-vendors) - A list of popular consumer electronic manufactures who sell connected devices. 
- [Hardware Models](https://51degrees.com/developers/documentation/open-rtb-mappings/hardware-models) - A list of popular consumer electronic model codes.
- [Platform Names](https://51degrees.com/developers/documentation/open-rtb-mappings/platform-names) - A  list of popular operating system names.
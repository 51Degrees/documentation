@page DeviceDetection_Features_UACH_SUA Structured User Agent (SUA)

# Introduction

The [OpenRTB 2.6 specification](https://github.com/InteractiveAdvertisingBureau/openrtb2.x/blob/main/2.6.md#3229---object-useragent-) defines a Structured
User Agent (`device.sua`) format for representing User-Agent Client Hints. This is commonly
used in programmatic advertising and real-time bidding scenarios.

# Passing SUA to Device Detection

If you receive UA-CH data in the SUA format, you can pass it directly to the device detection
engine with the `query.` or `cookie.` prefix:

```
flowData.AddEvidence("query.51D_StructuredUserAgent", suaJsonString);
```

# SUA Format

The SUA format looks like this:

```json
{
  "browsers": [
    {"brand": "Chromium", "version": ["130", "0", "6723", "92"]},
    {"brand": "Google Chrome", "version": ["130", "0", "6723", "92"]}
  ],
  "platform": {"brand": "macOS", "version": ["15", "1", "0"]},
  "mobile": 0,
  "model": "",
  "architecture": "arm"
}
```

# Technical Details

The SUA format is converted internally to the equivalent `Sec-CH-UA-*` HTTP
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

# Related Pages

For more details on OpenRTB integration, see the [OpenRTB Mappings](@ref DeviceDetection_OtherIntegrations_OpenRTBMappings) page.

For alternative UA-CH approaches, see:
- [JavaScript API](@ref DeviceDetection_Features_UACH_Javascript) - using `getHighEntropyValues()`
- [HTTP Headers](@ref DeviceDetection_Features_UACH_Headers) - using `Sec-CH-UA-*` headers

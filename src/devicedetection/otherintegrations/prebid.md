@page DeviceDetection_OtherIntegrations_Prebid Prebid

# Prebid Integration

51Degrees provides modules for Prebid that add device detection to programmatic advertising. These modules enrich OpenRTB bid requests with detailed device information before they reach advertisers.

## How It Works

Most bid requests only include basic information like "mobile" or "tablet". This makes it difficult for advertisers to target specific devices or optimize creatives. The 51Degrees modules detect device properties from HTTP headers and add them to the bid request.

The modules provide:

- Device make, model, and operating system details
- Screen dimensions and pixel density  
- Hardware capabilities like video support
- Unique device identifiers for consistent targeting
- Access to 250+ device properties through the device ID

## Implementation Options

You can integrate device detection at different points in your Prebid setup.

### Client-Side: Prebid.js RTD Module

Use this when you want maximum device detection accuracy and control over the enrichment process.

The module runs in the user's browser and can access JavaScript APIs for more precise device identification. This approach works best for detecting specific Apple device models.

**Setup:** [Prebid.js RTD Module Documentation](https://docs.prebid.org/dev-docs/modules/51DegreesRtdProvider.html)

### Server-Side: Prebid Server Modules

Use these when you need faster response times or want to centralize device detection logic.

**Prebid Server (Java)**
- Handles high request volumes efficiently
- Suitable for enterprise deployments
- **Setup:** [PBS Java Module Documentation](https://docs.prebid.org/prebid-server/pbs-modules/51degrees-device-detection.html)

**Prebid Server (Go)**
- Lightweight implementation
- Good for smaller deployments
- **Setup:** [PBS Go Module Documentation](https://docs.prebid.org/prebid-server/pbs-modules/51degrees-device-detection.html)

## Getting Started

### Cloud Setup (Free)

1. Get a Resource Key from the [Cloud Configurator](https://configure.51degrees.com)
2. Install and configure your chosen Prebid module
3. Test with sample bid requests to verify device data appears

### On-Premise Setup

1. Download the [Lite data file](https://github.com/51Degrees/device-detection-data) for testing
2. For production, purchase a license for the full dataset with automatic updates
3. Configure your module to use the local data file

## Bid Request Enrichment

The modules add device information to the OpenRTB `device` object:

```json
{
  "device": {
    "make": "Apple",
    "model": "iPhone 15 Pro", 
    "os": "iOS",
    "osv": "17.1",
    "w": 393,
    "h": 852,
    "pxratio": 3.0,
    "ext": {
      "fiftyonedegrees_deviceId": "17595-131070-140777-18092"
    }
  }
}
```

The `fiftyonedegrees_deviceId` links to additional properties in our [device database](https://51degrees.com/developers/property-dictionary). Use this ID to access hardware specs, browser capabilities, and other targeting criteria.

## Use Cases

📰 **Publishers** can use device data to:
- Create device-specific ad placements
- Analyze traffic by device type
- Set floor prices based on device capabilities

🎯 **Advertisers** can use this data to:
- Target specific device models for app campaigns
- Serve appropriate creative formats (video vs. static)
- Optimize campaigns based on device performance data

⚙️ **Ad Tech Platforms** can:
- Build device-aware bidding algorithms  
- Provide better reporting and analytics
- Create device-based audience segments

## Troubleshooting

If device data doesn't appear in bid requests:

1. Check your Resource Key or data file configuration
2. Verify the module is properly installed and enabled
3. Confirm bid requests include the necessary HTTP headers
4. Check module logs for error messages

For Apple device detection, ensure you're using client-side evidence collection for the most accurate results.

## Support

- Technical questions: [support@51degrees.com](mailto:support@51degrees.com)
- Integration assistance available for custom implementations
- Performance optimization guidance for high-volume scenarios
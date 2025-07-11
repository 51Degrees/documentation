@page DeviceDetection_Overview Device Detection Overview

# Introduction

Device Detection identifies the device, operating system, and browser hitting your website, plus over 250 other details you can use to fine-tune experiences across smartphones, tablets, desktops, TVs, and other connected devices.

[Quick Start Guide](@ref DeviceDetection_Quickstart) - Get running in minutes!

## How It Works

At the core of 51Degrees is our patented [Hash Algorithm](@ref DeviceDetection_Hash). It scans the User-Agent and other HTTP headers to identify devices in record time. Want to jump straight to real-world uses? Scroll down to Common use cases. Or stick around to see how we tackle the tougher challenges modern web traffic throws our way.

- **Apple devices:** We use JavaScript detection to see through Apple's hidden User-Agents and spot specific iPhone/iPad models.
- **Modern browsers:** We support [User-Agent Client Hints](@ref DeviceDetection_Features_UACH_Overview) from Chromium browsers to keep detection accurate, even as Google reduces Android User-Agent details.
- **Transcoding browsers:** We detect devices using alternative headers when the User-Agent gets rewritten or stripped out.
- **Enhanced accuracy:** We can gather client-side evidence for deeper device insights.

Dig deeper in our [technical spec](https://github.com/51Degrees/specifications/blob/main/device-detection-specification/README%2Emd) and [feature overview](@ref DeviceDetection_Features_Index).

## Advanced Capabilities

### Apple Device Detection

Apple makes device detection tricky by hiding User-Agent details. We bypass that with client-side JavaScript to identify specific iPhone/iPad models with precision.

[Learn more about Apple Detection](@ref DeviceDetection_Features_AppleDetection)

### User-Agent Client Hints

Browsers like Chrome are cutting down User-Agent info. Our Client Hints support ensures you stay ahead and maintain accurate detection.

[Learn more about User-Agent Client Hints](@ref DeviceDetection_Features_UACH_Overview)

### TAC Lookup

Need to identify a mobile device from its IMEI number? Our Type Allocation Code (TAC) lookup has you covered.

[Learn more about TAC Lookup](@ref DeviceDetection_Features_TacLookup)

## Flexible Integration Options

Choose what fits your stack:

- **Cloud API:** No infrastructure headaches, always updated, pay-as-you-go.
- **On-Premise:** Maximum control, lightning speed, enterprise security.
- **Hybrid:** The best of both worlds.

[Compare integration options](@ref DeviceDetection_Quickstart) | [See how to migrate from Cloud to On-Premise](@ref DeviceDetection_CloudToOnPremise)

## Technical Foundation

Our patented [Hash Algorithm](@ref DeviceDetection_Hash) is built for performance and scale:

- **Speed:** Processes over one million detections per second, per CPU core
- **Ultra-low latency:** Delivers sub-microsecond detection times with in-process deployment
- **Performance-critical ready:** Perfect for high-load servers, edge environments, and real-time systems
- **Accuracy:** Maintains industry-leading accuracy across [250+ device properties](https://51degrees.com/developers/property-dictionary)
- **Efficiency:** Keeps memory and bandwidth usage minimal
- **Deployment flexibility:** Runs in-process by default, or deploys out-of-process or on a separate server if needed

Read the [full technical specification](https://github.com/51Degrees/specifications/blob/main/device-detection-specification/README%2Emd) for the nitty-gritty details.

## Migrating from older versions or other providers

Already using 51Degrees V3 or another device detection tool? Thinking of making the switch? We've made it easy. Our migration guides show exactly how our properties and features match up with what you're used to - so you can transition smoothly without missing a beat.

- **Upgrading from 51Degrees V3?** Check out our [V4 upgrade guide](@ref DeviceDetection_UpgradingtoV4).
- **Moving from DeviceAtlas or WURFL?** We've got dedicated migration guides. [See all migration guides](@ref DeviceDetection_MigrationGuides_Index)

## Examples and Getting Started

Want to see how it works? Dive into our examples and hit the ground running:

### Quick Start
- [Quick Start Guide](@ref DeviceDetection_Quickstart) - Get started in minutes

### Web Integration Examples
- [Web Examples Index](@ref DeviceDetection_Examples_GettingStarted_Web_Index) - Web integrations, Cloud or On-Premise
- [Cloud Web Integration](@ref DeviceDetection_Examples_GettingStarted_Web_Cloud) - Cloud API examples
- [On-Premise Web Integration](@ref DeviceDetection_Examples_GettingStarted_Web_OnPremise) - On-premise examples

### Console Examples
- [Console Examples Index](@ref DeviceDetection_Examples_GettingStarted_Console_Index) - Command-line examples
- [Cloud Console Examples](@ref DeviceDetection_Examples_GettingStarted_Console_Cloud) - Cloud API on the console
- [On-Premise Console Examples](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise) - On-premise console setups

### All Examples
- [Examples Index](@ref DeviceDetection_Examples_Index) - Browse all our examples in one place

## Common Use Cases

### Responsive Design and User Experience

Detect screen size, device type, and input methods to serve layouts and navigation that feel just right on any device.

### Performance Optimization

Speed things up. Optimize images, trim down content, or tweak features based on device capabilities and network conditions.

### Analytics and Business Intelligence

Get a detailed picture of your audience's devices, browsers, and operating systems. Use the data to understand behavior, improve user journeys, or enhance programmatic ad analytics—especially with [Prebid integrations](@ref DeviceDetection_OtherIntegrations_Prebid).

### Advertising and Monetization

Run device-specific ad formats, fine-tune targeting, and optimize placements to boost revenue. Integrate with [Prebid](@ref DeviceDetection_OtherIntegrations_Prebid) to enrich bid requests and make programmatic smarter.

### Security and Fraud Detection

Spot suspicious traffic and potential threats using device characteristics and behavioral signals.

### Mobile App Development

Identify Progressive Web Apps (PWAs), check feature support, and tailor mobile experiences that feel native.

### Cross-Device User Journeys

Track users across smartphones, tablets, and desktops for seamless omnichannel experiences.

### Content Delivery and Media

Detect codecs, screen resolutions, and bandwidth conditions to deliver streaming media without hiccups.
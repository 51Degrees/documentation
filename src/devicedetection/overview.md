@page DeviceDetection_Overview Device Detection overview

# Introduction

Device Detection identifies the device, operating system, and browser making a request to your website. It also returns over 250 other details about smartphones, tablets, desktops, TVs, and other connected devices.

[Quick Start Guide](@ref DeviceDetection_Quickstart) - Get running in minutes.

---

## How it works


Our patented [Hash algorithm](@ref DeviceDetection_Hash) uses the User-Agent and other HTTP headers to identify devices. The sections below explain its capabilities and common use cases.

- **Apple devices:** We use JavaScript detection to see through Apple's hidden User-Agents and spot specific iPhone/iPad models.
- **Modern browsers:** We support [User-Agent Client Hints](@ref DeviceDetection_Features_UACH_Overview) from Chromium browsers to keep detection accurate, even as Google reduces Android User-Agent details.
- **Transcoding browsers:** We detect devices using alternative headers when the User-Agent gets rewritten or stripped out.
- **Enhanced accuracy:** We can gather client-side evidence for deeper device insights.

Dig deeper in our [technical spec](https://github.com/51Degrees/specifications/blob/main/device-detection-specification/README%2Emd) and [feature overview](@ref DeviceDetection_Features_Index).

---

## Advanced capabilities


### Apple Device Detection

We use client-side JavaScript to identify specific iPhone/iPad models that cannot be distinguished from their User-Agents alone.

[Learn more about Apple Detection](@ref DeviceDetection_Features_AppleDetection)

### User-Agent Client Hints

We support User-Agent Client Hints to identify devices when Chromium browsers reduce the details in their User-Agent headers.

[Learn more about User-Agent Client Hints](@ref DeviceDetection_Features_UACH_Overview)

### TAC lookup

Use the Type Allocation Code (TAC) from an IMEI number to identify a mobile device.

[Learn more about TAC Lookup](@ref DeviceDetection_Features_TacLookup)

---

## Integration options


Choose what fits your stack:

- **Cloud API:** No infrastructure headaches, always updated, with plans sized by monthly requests.
- **On-premise:** Run detection on your own servers.
- **Hybrid:** Combine cloud and on-premise deployment.

[Compare integration options](@ref DeviceDetection_Quickstart) | [See how to migrate from Cloud to On-premise](@ref DeviceDetection_CloudToOnPremise)

---

## Technical foundation


Our patented [Hash Algorithm](@ref DeviceDetection_Hash) is built for performance and scale:

- **Speed:** Over one million detections per second on an eight-core AWS Graviton3 instance, and over 9 million on a 128-core server, when the data file is loaded into memory (see the [hardware benchmarks](@ref ProductSummaries_Benchmarks_Hardware))
- **Fast startup:** Loads the data file into memory and is ready to detect in under 150 milliseconds on the same Graviton3 instance, which matters most where servers start and stop as demand changes
- **Low latency:** Each detection takes microseconds when the data file is in memory, and there is no network call
- **Performance-critical ready:** Perfect for high-load servers, edge environments, and real-time systems
- **Device details:** Returns [250+ device properties](https://51degrees.com/developers/property-dictionary)
- **Efficiency:** Keeps memory and bandwidth usage minimal
- **Deployment flexibility:** Runs in-process by default, or deploys out-of-process or on a separate server if needed

Read the [full technical specification](https://github.com/51Degrees/specifications/blob/main/device-detection-specification/README%2Emd) for implementation details.

---

## Migrating from older versions or other providers


Use our migration guides to compare properties and features when moving from 51Degrees V3 or another device detection tool.

- **Upgrading from 51Degrees V3?** Check out our [V4 upgrade guide](@ref DeviceDetection_UpgradingtoV4).
- **Moving from DeviceAtlas or WURFL?** We've got dedicated migration guides. [See all migration guides](@ref DeviceDetection_MigrationGuides_Index)

---

## Examples and getting started


Choose an example for your application type and deployment:

### 💡 Quick start
- [Quick Start Guide](@ref DeviceDetection_Quickstart) - Get started in minutes

### Web integration examples
- [Web Examples Index](@ref DeviceDetection_Examples_GettingStarted_Web_Index) - Web integrations, Cloud or On-premise
- [Cloud Web Integration](@ref DeviceDetection_Examples_GettingStarted_Web_Cloud) - Cloud API examples
- [On-premise Web Integration](@ref DeviceDetection_Examples_GettingStarted_Web_OnPremise) - On-premise examples

### Console examples
- [Console Examples Index](@ref DeviceDetection_Examples_GettingStarted_Console_Index) - Command-line examples
- [Cloud Console Examples](@ref DeviceDetection_Examples_GettingStarted_Console_Cloud) - Cloud API on the console
- [On-premise Console Examples](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise) - On-premise console setups

### All examples
- [Examples Index](@ref DeviceDetection_Examples_Index) - Browse all our examples in one place

---

## Common use cases


### 📱 Responsive design and user experience

Detect screen size, device type, and input methods to serve layouts and navigation that feel just right on any device.

### ⚡ Performance optimization

Speed things up. Optimize images, trim down content, or tweak features based on device capabilities and network conditions.

### 📊 Analytics and business intelligence

Get a detailed picture of your audience's devices, browsers, and operating systems. Use the data to understand behavior, improve user journeys, or enhance programmatic ad analytics, especially with [Prebid integrations](@ref Integrations_Prebid).

### 💰 Advertising and monetization

Run device-specific ad formats, fine-tune targeting, and optimize placements to boost revenue. Integrate with [Prebid](@ref Integrations_Prebid) to enrich bid requests and make programmatic smarter.

### 🛡️ Security and fraud detection

Spot suspicious traffic and potential threats using device characteristics and behavioral signals.

### 📲 Mobile app development

Identify Progressive Web Apps (PWAs), check feature support, and tailor mobile experiences that feel native.

### 🔄 Cross-device user journeys

Identify whether each visit comes from a smartphone, tablet, or desktop, so each step of a journey works on the device in use.

### 🎬 Content delivery and media

Detect codecs, screen resolutions, and bandwidth conditions to deliver streaming media without hiccups.
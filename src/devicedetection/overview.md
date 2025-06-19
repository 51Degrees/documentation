@page DeviceDetection_Overview Device Detection Overview

# Introduction

**Device detection** identifies the device, operating system, and browser accessing your website, plus [over 250 other device properties](https://51degrees.com/developers/property-dictionary) to optimize user experience across smartphones, tablets, desktops, TVs, and other connected devices.

**→ [Quick Start Guide](@ref DeviceDetection_Quickstart) - Get running in minutes**

## How it works

51Degrees uses a patented [Hash Algorithm](@ref DeviceDetection_Hash) primarily analyzing User-Agent and other HTTP headers. Additional techniques handle modern challenges:

* **Apple devices:** [JavaScript-based detection](@ref DeviceDetection_Features_AppleDetection) overcomes obfuscated User-Agents
* **Modern browsers:** [User-Agent Client Hints](@ref DeviceDetection_Features_UACH_Overview) support for Chromium-based browsers for precise detection and to overcome Google's Android User-Agent reduction  
* **Transcoding browsers:** Detection from alternative headers when User-Agent is modified
* **Enhanced accuracy:** Client-side evidence collection for detailed device identification

See [technical specification](https://github.com/51Degrees/specifications/blob/main/device-detection-specification/README.md) and [features overview](@ref DeviceDetection_Features_Index) for details.

# Common Use Cases

## 🎨 Responsive Design & User Experience
Detect screen size, device type, and input methods to serve optimal layouts and navigation for different device categories.

## ⚡ Performance Optimization  
Optimize images, reduce content, and adapt features based on device capabilities and network conditions to improve loading times.

## 📊 Analytics & Business Intelligence
Detailed device, OS, and browser analytics to understand user behavior patterns and make data-driven decisions. Enhance programmatic advertising analytics with [Prebid integration](@ref DeviceDetection_OtherIntegrations_Prebid).

## 🎯 Advertising & Monetization
Device-specific ad formats, targeting capabilities, and placement optimization to maximize ad revenue. Boost programmatic advertising with [Prebid integration](@ref DeviceDetection_OtherIntegrations_Prebid) for enriched bid requests.

## 🛡️ Security & Fraud Detection
Device fingerprinting and behavioral analysis to identify suspicious traffic, bots, and potential security threats.

## 📱 Mobile App Development
Progressive Web App detection, feature support identification, and mobile-specific optimizations for native-like experiences.

## 🔄 Cross-Device User Journeys
Device identification and user journey mapping across smartphones, tablets, and desktops for omnichannel experiences.

## 🎵 Content Delivery & Media
Codec support detection, screen resolution optimization, and bandwidth-aware delivery for streaming and media platforms.

---

# Advanced Capabilities

## 🍎 Apple Device Detection
Apple devices require special handling due to limited User-Agent information. Our [advanced Apple detection](@ref DeviceDetection_Features_AppleDetection) uses client-side JavaScript to identify specific iPhone and iPad models with high accuracy.

## 🔍 User-Agent Client Hints
Modern browsers are reducing User-Agent information. Stay ahead with our [User-Agent Client Hints support](@ref DeviceDetection_Features_UACH_Overview) for Chromium-based browsers.

## 📱 TAC Lookup
Identify mobile device models from IMEI numbers using Type Allocation Code (TAC) lookup. See our [TAC lookup feature](@ref DeviceDetection_Features_TacLookup) for mobile device identification.

## ⚙️ Flexible Integration Options
- **Cloud API:** Zero maintenance, always up-to-date, pay-as-you-go
- **On-Premise:** Full control, high performance, enterprise security
- **Hybrid:** Combine both for optimal flexibility

[Compare integration options](@ref DeviceDetection_Quickstart)

---

# Technical Foundation

At its core, 51Degrees uses a patented [Hash Algorithm](@ref DeviceDetection_Hash) that delivers:
- **Speed:** Over 1 million detections per second per CPU core
- **Ultra-low latency:** Sub-microsecond detection time with in-process deployment
- **Performance-critical ready:** Ideal for real-time servers, edge/load balancers, and high-load scenarios
- **Accuracy:** Industry-leading detection rates across [250+ device properties](https://51degrees.com/developers/property-dictionary)  
- **Efficiency:** Minimal memory footprint and bandwidth usage
- **Deployment flexibility:** In-process by default, with optional out-of-process or separate server deployment

For complete technical details, see our [specification](https://github.com/51Degrees/specifications/blob/main/device-detection-specification/README.md).

---

# Migration & Upgrading

**Already using device detection?** We make switching easy:

- **51Degrees V3 users:** [Upgrade to V4](@ref DeviceDetection_UpgradingtoV4)
- **DeviceAtlas users:** [Migration Guide](@ref DeviceDetection_MigrationGuides_DeviceAtlas)  
- **WURFL users:** [Migration Guide](@ref DeviceDetection_MigrationGuides_Wurfl)

[View all migration guides](@ref DeviceDetection_MigrationGuides_Index)

# Examples and Getting Started

## Quick Start
- **[Quick Start Guide](@ref DeviceDetection_Quickstart)** - Get up and running in minutes

## Web Integration Examples  
- **[Web Examples Index](@ref DeviceDetection_Examples_GettingStarted_Web_Index)** - Complete web integration examples
- **[Cloud Web Integration](@ref DeviceDetection_Examples_GettingStarted_Web_Cloud)** - Cloud API examples
- **[On-Premise Web Integration](@ref DeviceDetection_Examples_GettingStarted_Web_OnPremise)** - On-premise examples

## Console Examples
- **[Console Examples Index](@ref DeviceDetection_Examples_GettingStarted_Console_Index)** - Command-line examples
- **[Cloud Console Examples](@ref DeviceDetection_Examples_GettingStarted_Console_Cloud)** - Cloud API console examples  
- **[On-Premise Console Examples](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise)** - On-premise console examples

## All Examples
- **[Examples Index](@ref DeviceDetection_Examples_Index)** - Browse all available examples

---

# Migrating from an older version or other providers

If you're already using [51Degrees V3 Device Detection API](@ref DeviceDetection_UpgradingtoV4), or a device detection solution from an alternative provider and are considering switching to 51Degrees, we have a number of [Migration Guides](@ref DeviceDetection_MigrationGuides_Index) showing how our properties and capabilities map to those of others.
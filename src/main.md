@mainpage Introduction

# Welcome to 51Degrees

Device, network, and location data from web requests

Use 51Degrees to detect devices and retrieve location and network data from web requests.

## What we do


Our services include:

- **Device Detection** - Detect 250+ device properties from HTTP headers and other signals to tailor every user experience.
- **IP Intelligence** - Retrieve geolocation, ISP, and network data from IP addresses.
- **Human Confidence** - Rate every visit High, Medium, or Low by how likely it is that a person is viewing the page, and Unknown where the 51Degrees script has not run.
- **Reverse Geocoding** - Transform latitude and longitude into real-world addresses, cities, and regions.
- **Identifiers** - Generate 51Dids, identifiers that name the terms they were created under, and capture user marketing preferences (PMP) to feed downstream systems.
- **In-process deployment** - Run detection in your application process.
- **On-premise deployment** - Run the services on your own servers.

---

## Get started


Mix and match our services to fit your needs:

### Device Detection

Identify devices, browsers, and capabilities to deliver tailored experiences across smartphones, tablets, desktops, TVs, and IoT devices.

- [Overview](@ref DeviceDetection_Overview) - How it works and why it matters
- [Quick Start](@ref DeviceDetection_Quickstart) - Cloud vs. On-premise setup
- [Apple Detection](@ref DeviceDetection_Features_AppleDetection) - Pinpoint specific iPhone/iPad models

### IP Intelligence

Retrieve geolocation, ISP, and network data for fraud prevention, personalization, and geographical restrictions.

- [Overview](@ref IpIntelligence_Overview) - Understand network data and location capabilities
- [Quick Start](@ref IpIntelligence_Quickstart) - Integrate in minutes

### Human Confidence

How likely it is that a person, not a script, is viewing the page, from the 51Degrees cloud. Measure it in your analytics, or act on it from your server.

- [Overview](@ref HumanConfidence_Overview) - What the answers mean and how to use them
- [Quick Start](@ref HumanConfidence_Quickstart) - From License Key to the first answer
- [Deploy with the cloud](@ref Services_Cloud_HumanConfidence) - Decide what each visit gets on your server
- [Analytics](@ref HumanConfidence_Analytics) - Send Human Confidence to your reports, with [Google Analytics 4](@ref Integrations_GoogleAnalytics) step by step

### Reverse Geocoding

Convert GPS coordinates to addresses, cities, and regions.

- [Overview](@ref ReverseGeocoding_Overview) - Map coordinates to addresses, cities, and regions
- [Quick Start](@ref ReverseGeocoding_Quickstart) - Step-by-step implementation guide

### Identifiers

Generate signed, probabilistic device-bound identifiers (51Did). Use the Preference Management Platform (PMP), an embeddable preference widget, to pass `id.usage` to 51Did.

- [Overview](@ref Identifiers_Overview) - How the pieces fit together
- [51Did](@ref Identifiers_51Did) - Properties, `id.usage`, licensing
- [PMP](@ref Identifiers_PMP) - Embeddable preference widget
- [ADI](@ref Identifiers_ADI) - Embeddable ad inspector that tells a visitor why an ad was served

### Client-side only

Run device detection directly in the browser without server-side code.

- [51degrees.com/configure](https://51degrees.com/configure/) - Create a Resource Key and get the JavaScript snippet for it
- [Resource Key guide](@ref Services_Configurator) - Creating a Resource Key step by step
- [Cloud API Reference](https://cloud.51degrees.com/api-docs/index.html) - Complete HTTP API documentation

---

## Language support


Use the following libraries to integrate Device Detection and IP Intelligence:

| Language | Device Detection | IP Intelligence |
|----------|------------------|-----------------|
| .NET (C#) | [device-detection-dotnet](https://github.com/51Degrees/51degrees-dotnet/tree/main/device-detection) | [ip-intelligence-dotnet](https://github.com/51Degrees/51degrees-dotnet/tree/main/ip-intelligence) |
| Java | [device-detection-java](https://github.com/51Degrees/51degrees-java/tree/main/device-detection) | [ip-intelligence-java](https://github.com/51Degrees/51degrees-java/tree/main/ip-intelligence) |
| Go | [device-detection-go](https://github.com/51Degrees/51degrees-go/tree/main/device-detection) | [ip-intelligence-go](https://github.com/51Degrees/51degrees-go/tree/main/ip-intelligence) |
| Node.js | [device-detection-node](https://github.com/51Degrees/51degrees-node/tree/main/device-detection) | [ip-intelligence-node](https://github.com/51Degrees/51degrees-node/tree/main/ip-intelligence) |
| Python | [device-detection-python](https://github.com/51Degrees/51degrees-python/tree/main/device-detection) | [ip-intelligence-python](https://github.com/51Degrees/51degrees-python/tree/main/ip-intelligence) |
| PHP | [device-detection-php](https://github.com/51Degrees/51degrees-php/tree/main/device-detection) | - |

---

## Specialized integrations


Tailor your setup for maximum performance:

- [Nginx Module](https://github.com/51Degrees/51degrees-nginx) - integrate device detection at the edge
- [Google Analytics 4](@ref Integrations_GoogleAnalytics) - send device, location, crawler and Human Confidence properties to your reports
- [Prebid Integration](@ref Integrations_Prebid) - enrich OpenRTB bid requests
- [UA Parser JS](https://github.com/51Degrees/ua-parser-js) - integrate with the cloud API
- [Varnish Module](https://github.com/51Degrees/51degrees-varnish) - cache smarter, deliver faster

Explore all our SDKs on [GitHub](https://github.com/51Degrees/).

---

## Common use cases


Here's how you can combine our services for real-world results:

### 🎯 Enhanced user experience

Device Detection + IP Intelligence = spot-on content delivery.

Detect mobile users in rural areas and serve relevant content tailored to their needs.

### 🛡️ Fraud prevention and security

Combine Device Detection and IP Intelligence to assess device and location patterns.

Spot suspicious device and location patterns, detect bots, and flag logins that need a closer look.

### 📊 Programmatic advertising

Device Detection + IP Intelligence + [Prebid Integration](@ref Integrations_Prebid) = better targeting.

Enrich bid requests with precise device and location data for sharper targeting.

### 📈 Advanced analytics

Combine Device Detection and IP Intelligence to segment audiences by device and location.

See the difference between "iPhone users in London" and "Android tablet users in rural areas" for highly targeted insights.

### 🌍 Location and personalization

Combine IP Intelligence and Reverse Geocoding for location-based experiences.

Apply rules that differ by country or region, such as data protection law and local content licensing, and personalize content by location.

### ⚡ Performance optimization

Device Detection + IP Intelligence = faster, smarter websites.

Serve optimized images, adjust content for connection speeds, and choose the best CDN for each user.

---

## Documentation hub


Everything you need to succeed:

### 💡 Quick starts

- [Device Detection](@ref DeviceDetection_Quickstart) - Cloud vs. On-premise
- [IP Intelligence](@ref IpIntelligence_Quickstart) - Location and network data
- [Human Confidence](@ref HumanConfidence_Quickstart) - People or scripts
- [Reverse Geocoding](@ref ReverseGeocoding_Quickstart) - From coordinates to addresses
- [Identifiers](@ref Identifiers_Overview) - 51Did and PMP

### Detailed guides

- [Device Detection Overview](@ref DeviceDetection_Overview)
- [IP Intelligence Overview](@ref IpIntelligence_Overview)
- [Human Confidence Overview](@ref HumanConfidence_Overview)
- [Reverse Geocoding Overview](@ref ReverseGeocoding_Overview)
- [Identifiers Overview](@ref Identifiers_Overview)

### Advanced topics

- [Pipeline API features](@ref PipelineApi_Features_Index)
- [Architecture concepts](@ref PipelineApi_Concepts_Index)
- [Feature comparisons](@ref ProductSummaries_FeatureMatrix)
- [Performance benchmarks](@ref ProductSummaries_Benchmarks)

---

## 💬 Get support


We're here to help every step of the way:

- Have quick questions? [Raise an issue on GitHub](https://github.com/51Degrees/)
- Need enterprise support? Email us at [support@51degrees.com](mailto:support@51degrees.com)
- Looking for API details? Check the [Cloud API documentation](https://cloud.51degrees.com/api-docs/index.html)
- Want performance tips? Get in touch for optimization advice.
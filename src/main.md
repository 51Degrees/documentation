@mainpage Introduction

# Welcome to 51Degrees

**Real-time user intelligence** that transforms basic web requests into rich, actionable data. Detect devices 📱,
understand locations 🌍, and enhance experiences with **sub-microsecond performance** and industry-leading accuracy.

## 🚀 What We Do

51Degrees enriches every user interaction with precise intelligence:

- **🔍 Device Detection** - Identify [250+ device properties](https://51degrees.com/developers/property-dictionary) from
  HTTP headers and other evidence
- **🌐 IP Intelligence** - Extract geolocation, ISP, and network data from IP
  addresses ([property dictionary](https://51degrees.com/developers/property-dictionary) - see Location and Network
  components)
- **📍 Reverse Geocoding** - Convert coordinates to real-world addresses
- **⚡ Ultra-fast** - Sub-microsecond detection time with in-process deployment
- **🎯 Privacy-first** - On-premise options keep all data in your infrastructure

---

## Get Started Fast

**Mix and match our services for maximum impact:**

### 📱 Device Detection <a href="#device-detection">#</a> @anchor device-detection

**Identify devices, browsers, and capabilities** - Optimize experiences across smartphones, tablets, desktops, TVs, and
IoT devices.

- **[📖 Overview](@ref DeviceDetection_Overview)** - How it works and key benefits
- **[⚡ Quick Start](@ref DeviceDetection_Quickstart)** - Cloud vs on-premise setup guide
- **[🍎 Apple Detection](@ref DeviceDetection_Features_AppleDetection)** - Specific iPhone/iPad model identification

### 🌍 IP Intelligence <a href="#ip-intelligence">#</a> @anchor ip-intelligence

**Geolocation, ISP, and network insights** - Perfect for fraud prevention, content personalization, and compliance.

- **[📖 Overview](@ref IpIntelligence_Overview)** - Network data and location capabilities
- **[⚡ Quick Start](@ref IpIntelligence_Quickstart)** - Integration in minutes

### 📍 Reverse Geocoding <a href="#reverse-geocoding">#</a> @anchor reverse-geocoding

**Convert coordinates to addresses** - Transform lat/lng into postal addresses, cities, and regions.

- **[📖 Overview](@ref ReverseGeocoding_Overview)** - Real-world location from coordinates
- **[⚡ Quick Start](@ref ReverseGeocoding_Quickstart)** - Implementation guide

### 🌐 Client-Side Only <a href="#client-side">#</a> @anchor client-side

**Browser-only implementation** - No server-side code required for simple integrations.

- **[🔧 Cloud Configurator](https://configure.51degrees.com/)** - Generate custom JavaScript snippets
- **[📋 Setup Guide](@ref Services_Configurator)** - Resource Key and implementation
- **[📚 Cloud API Reference](https://cloud.51degrees.com/api-docs/index.html)** - Complete HTTP API documentation

---

## 🎯 Common Use Cases

**Combine our services for powerful solutions:**

### 🎨 **Enhanced User Experience**

Device Detection + IP Intelligence = **Perfect content delivery**  
*Detect mobile devices from rural areas → Serve lightweight, location-relevant content*

### 🛡️ **Fraud Prevention & Security**

Device Detection + IP Intelligence = **Comprehensive risk assessment**  
*Flag suspicious device/location combinations, detect bot traffic, prevent account takeovers*

### 🎯 **Programmatic Advertising**

Device Detection + IP Intelligence + [Prebid Integration](@ref DeviceDetection_OtherIntegrations_Prebid) = **Higher CPMs**
*Enrich bid requests with precise device and location data for better targeting*

### 📊 **Advanced Analytics**

Device Detection + IP Intelligence = **Rich user segmentation**  
*"iPhone users from London" vs "Android tablets from rural areas" - precise audience insights*

### 🌍 **Geo-Compliance & Personalization**

IP Intelligence + Reverse Geocoding = **Location-aware applications**  
*GDPR compliance, content licensing, local regulations, and address completion*

### ⚡ **Performance Optimization**

Device Detection + IP Intelligence = **Smart content adaptation**  
*Optimize images for device capabilities, adjust for connection types, select optimal CDN*

---

## 💻 Language Support

**Choose your preferred language** - all services work consistently across platforms:

### 🚀 **Production-Ready Libraries**

- **[.NET (C#)](https://github.com/51Degrees/device-detection-dotnet)** - Enterprise-grade with full feature
  support ([Device Detection](https://github.com/51Degrees/device-detection-dotnet), [IP Intelligence](https://github.com/51Degrees/ip-intelligence-dotnet))
- **[Java](https://github.com/51Degrees/device-detection-java)** - High-performance server
  applications ([Device Detection](https://github.com/51Degrees/device-detection-java), [IP Intelligence](https://github.com/51Degrees/ip-intelligence-java))
- **[Go](https://github.com/51Degrees/device-detection-go)** - Lightweight, high-performance
  applications ([Device Detection](https://github.com/51Degrees/device-detection-go), [IP Intelligence](https://github.com/51Degrees/ip-intelligence-go))
- **[Node.js](https://github.com/51Degrees/device-detection-node)** - Modern web applications
- **[Python](https://github.com/51Degrees/device-detection-python)** - Data science and web frameworks
- **[PHP](https://github.com/51Degrees/device-detection-php)** - Web development with cloud and on-premise options

### 🛠️ **Specialized Integrations**

- **[Nginx Module](https://github.com/51Degrees/device-detection-nginx)** - Edge/load balancer integration
- **[Prebid Integration](@ref DeviceDetection_OtherIntegrations_Prebid)** - Programmatic advertising
- **[UA Parser JS](https://github.com/51Degrees/ua-parser-js)** - Versatile cloud-API integration wrapper library with
  full device detection capabilities
- **[Varnish Module](https://github.com/51Degrees/device-detection-varnish)** - Cache optimization

**[📦 Browse all SDKs on GitHub](https://github.com/51Degrees/)**

---

## 📚 Documentation Hub

**Everything you need to succeed:**

### 🚀 **Quick Starts**

- **[Device Detection Quickstart](@ref DeviceDetection_Quickstart)** - Cloud vs on-premise setup
- **[IP Intelligence Quickstart](@ref IpIntelligence_Quickstart)** - Location and network data
- **[Reverse Geocoding Quickstart](@ref ReverseGeocoding_Quickstart)** - Coordinates to addresses

### 📖 **Deep Dives**

- **[Device Detection Overview](@ref DeviceDetection_Overview)** - Capabilities and use cases
- **[IP Intelligence Overview](@ref IpIntelligence_Overview)** - Geolocation and network insights
- **[Reverse Geocoding Overview](@ref ReverseGeocoding_Overview)** - Address resolution

### ⚙️ **Advanced Topics**

- **[Pipeline API Features](@ref PipelineApi_Features_Index)** - Built-in capabilities and configuration
- **[Architecture Concepts](@ref PipelineApi_Concepts_Index)** - Pipelines, flow elements, and design patterns
- **[Feature Matrix](@ref ProductSummaries_FeatureMatrix)** - Compare capabilities across languages
- **[Performance Benchmarks](@ref ProductSummaries_Benchmarks)** - Speed comparisons and optimization

---

## 💬 Get Support

**We're here to help you succeed:**

- **🚀 Quick questions?** [GitHub Issues](https://github.com/51Degrees/) - Community support
- **📧 Enterprise support?** [support@51degrees.com](mailto:support@51degrees.com) - Direct technical assistance
- **📝 API Reference?** [Cloud API Documentation](https://cloud.51degrees.com/api-docs/index.html) - Complete HTTP API
  reference
- **📈 Performance guidance?** Contact our team for optimization recommendations

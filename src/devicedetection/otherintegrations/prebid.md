@page DeviceDetection_OtherIntegrations_Prebid Prebid

# Prebid Integration

**Supercharge your programmatic advertising** with 51Degrees Device Detection modules for Prebid. Transform basic OpenRTB requests into rich, device-aware bid opportunities that improve targeting and deliver better user experiences.

## 🚀 Why Prebid + 51Degrees?

Most bid requests contain minimal device information, leaving money on the table. Our Prebid modules enrich auctions with detailed device identification, enabling:

- **📈 Higher bid values** - Detailed device data enables more precise targeting and competitive bidding
- **🎯 Precise targeting** - Advertisers reach users with device-appropriate creatives  
- **📊 Enhanced analytics** - Rich device data provides deeper insights into audience behavior, campaign performance, and audience segmentation
- **⚡ Real-time performance** - Sub-millisecond device detection doesn't slow auctions
- **🍎 Apple device clarity** - Identify specific iPhone/iPad models where others fail

---

## 💰 Publisher Benefits

🎯 **Enhanced Inventory Value**  
Transform generic "mobile" traffic into premium, targetable inventory with specific device models, screen sizes, and capabilities.

📊 **Rich Analytics & Insights**  
Understand your audience better with detailed device breakdowns and performance metrics by device type.

🔒 **Device Model Identification**  
`device.ext.fiftyonedegrees_deviceId` provides consistent device model classification for targeting and analytics, allowing you to associate a device with all of its attributes on the server side. This **unlocks access to [250+ device properties](https://51degrees.com/developers/property-dictionary)** based on the device ID.

## 🎨 Advertiser Benefits

🎪 **Creative Optimization**  
Deliver device-appropriate ad formats - video for capable devices, static for older models, optimal sizes for screens.

🧭 **Precise Audience Targeting**  
Reach "iPhone 15 Pro users" instead of generic "mobile users" for luxury goods, gaming apps, and premium services (specific iPhone/iPad models available with Prebid.js and [client-side evidence](@ref PipelineApi_Features_ClientSideEvidence) via [Apple model detection](@ref DeviceDetection_Features_AppleDetection)).

⚡ **Campaign Performance**  
Reduce wasted spend on incompatible device targeting and improve conversion rates with device-aware strategies.

---

## 🛠️ Implementation Options

### 🌐 Client-Side: Prebid.js RTD Module
**Best for:** Publisher-controlled enrichment, maximum device properties
- Runs in browser for most accurate device detection
- Full access to JavaScript-based Apple device identification
- **[→ Prebid.js RTD Module Documentation](https://docs.prebid.org/dev-docs/modules/51DegreesRtdProvider.html)**

### ⚡ Server-Side: Prebid Server Modules  
**Best for:** Reduced latency, centralized management, privacy compliance

**Prebid Server - Java**
- Enterprise-grade performance and scalability
- **[→ PBS Java Module Documentation](https://docs.prebid.org/prebid-server/pbs-modules/51degrees-device-detection.html)**

**Prebid Server - Go**  
- Lightweight, high-performance alternative
- **[→ PBS Go Module Documentation](https://docs.prebid.org/prebid-server/pbs-modules/51degrees-device-detection.html)**

---

## 🚀 Getting Started

### ⚡ Quick Start (Cloud - Free)
1. **[Get your Resource Key](https://configure.51degrees.com)** - Free cloud integration
2. **Choose your module** - Pick client-side or server-side integration  
3. **Follow the setup guide** - Each Prebid module includes detailed examples
4. **Start earning more** - Watch your CPMs increase with enriched bid requests

### 🏢 Enterprise Setup (On-Premise)
- **[Download Lite data file](https://github.com/51Degrees/device-detection-data)** for testing
- **Purchase enterprise license** for full device coverage and automatic updates
- **Deploy locally** for maximum performance and data privacy

### 📋 What Gets Added to Your Bid Requests

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

---

## 💬 Need Help?

- **Questions?** Email [support@51degrees.com](mailto:support@51degrees.com)
- **Integration support?** Our team helps with custom implementations
- **Performance questions?** We provide optimization guidance for high-volume scenarios

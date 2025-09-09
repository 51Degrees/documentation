@page IpIntelligence_Quickstart IP Intelligence Quick Start

# Getting Started with IP Intelligence

IP Intelligence provides geolocation, ISP, connection type, and network information from IP addresses. It helps enhance user experience, security, and content delivery.

## Choose Your Integration

### Cloud API
**Best for:** Quick deployment, minimal infrastructure, always up-to-date data

**Benefits:**
- **No infrastructure** - No servers or data files to manage
- **Always updated** - Latest IP intelligence data automatically
- **Quick setup** - Get running in minutes with just an API key

**Things to consider:**
- **Internet dependency** - Requires network connectivity
- **Latency** - Network round-trip time for each request
- **Data processing** - Occurs on 51Degrees infrastructure

**Licensing:** Will require a [Resource Key](https://configure.51degrees.com) eventually, but for now [contact us](https://51degrees.com/contact-us) to obtain an enterprise IPI data file for testing

### On-premise Deployment
**Best for:** High-performance, privacy-sensitive, or offline environments

**Benefits:**
- **Ultra-low latency** - Sub-millisecond detection time with in-process deployment
- **Data processing** - Stays within your infrastructure with optional usage sharing available
- **High throughput** - Designed for high-load scenarios
- **Offline capable** - No internet dependency for detection
- **Full control** - Customize update schedules and deployment architecture

**Things to consider:**
- **Setup required** - Initial configuration and data file management
- **Resource usage** - Uses local CPU/RAM (optimized but measurable)
- **Automatic update** - Daily automated updates without restarting the process

**Licensing:** Requires a [License Key](https://51degrees.com/pricing)

### Combined Device Detection + IP Intelligence
**Best for:** Comprehensive user profiling and enhanced accuracy

**Benefits:**
- **Complete user context** - Combine location/network data with device characteristics
- **Enhanced fraud detection** - Cross-reference device properties with IP risk data
- **Optimized content delivery** - Device capabilities + geographic location for perfect targeting
- **Advanced analytics** - Rich user segmentation with both device and location dimensions

**Things to consider:**
- **Multiple engines** - Requires configuration of both Device Detection and IP Intelligence
- **Data file management** - Need both device data files (.hash) and IP data files (.ipi) for On-premise
- **Resource usage** - Combined memory and CPU usage for both engines

**Licensing:** Requires licenses for both Device Detection and IP Intelligence services

## Language-Specific Integration

Select your language below for detailed setup instructions:

@startsnippets
@showsnippet{c,C}
@showsnippet{cxx,C++}
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{go,Go}
@defaultsnippet{Select a language.}
@startsnippet{c}
C does not have a @Pipeline implementation or the ability to use the cloud-based version of 
IP intelligence.
To get started with C IP intelligence On-premise:

1. Clone the GitHub [repository](https://github.com/51degrees/ip-intelligence-cxx).
2. Ensure all submodules are checked out by running `git submodule update --init --recursive` in the repository.
3. Follow the [installation instructions](https://github.com/51Degrees/ip-intelligence-cxx/blob/main/README%2Emd) to get set up with the project. 
4. Follow the linked example here: [Getting Started](@ref IpIntelligence_Examples_GettingStarted_Console_OnPremise).
5. To run the example, [contact us](https://51degrees.com/contact-us) to obtain an enterprise IPI data file.

@endsnippet
@startsnippet{cxx}
C++ does not have a @Pipeline implementation or the ability to use the cloud-based version of 
IP intelligence.
To get started with C++ IP intelligence On-premise:

1. Clone the GitHub [repository](https://github.com/51degrees/ip-intelligence-cxx).
2. Ensure all submodules are checked out by running `git submodule update --init --recursive` in the repository.
3. Follow the [installation instructions](https://github.com/51Degrees/ip-intelligence-cxx/blob/main/README%2Emd) to get set up with the project. <!-- TODO use ref and tagfile so this is not hardcoded -->
4. Follow the linked example here: [Getting Started](@ref IpIntelligence_Examples_GettingStarted_Console_OnPremise).
5. To run the example, [contact us](https://51degrees.com/contact-us) to obtain an enterprise IPI data file.

@endsnippet
@startsnippet{dotnet}
### Console Applications

1. Install the [FiftyOne.IpIntelligence](https://www.nuget.org/packages/FiftyOne.IpIntelligence) package via Nuget.
2. Choose your deployment option:
   * [Cloud Example](@ref IpIntelligence_Examples_GettingStarted_Console_Cloud) - Uses 51Degrees Cloud API for processing
   * [On-premise Example](@ref IpIntelligence_Examples_GettingStarted_Console_OnPremise) - Local processing with data files
   * [Combined Example](@ref IpIntelligence_Combined_Console_OnPremise) - Mix IP Intelligence with Device Detection

### Web Applications (ASP.NET Core)

1. Install the [FiftyOne.IpIntelligence](https://www.nuget.org/packages/FiftyOne.IpIntelligence) and [FiftyOne.Pipeline.Web](https://www.nuget.org/packages/FiftyOne.Pipeline.Web) packages via Nuget.
2. Follow the [web integration guide](@ref PipelineApi_Examples_WebIntegration) to add the @Pipeline middleware.
3. Choose your deployment option:
   * [Cloud Web Example](@ref IpIntelligence_Examples_GettingStarted_Web_Cloud) - Uses 51Degrees Cloud API
   * [On-premise Web Example](@ref IpIntelligence_Examples_GettingStarted_Web_OnPremise) - Local processing
   * [Combined Web Example](@ref IpIntelligence_Combined_Web_OnPremise) - Mix IP Intelligence with Device Detection

@endsnippet
@startsnippet{java}
### Console Applications

1. Add the IP Intelligence dependency to your project:
   ```xml
   <dependency>
       <groupId>com.51degrees</groupId>
       <artifactId>ip-intelligence</artifactId>
   </dependency>
   ```
   Check [Maven Central](https://search.maven.org/artifact/com.51degrees/ip-intelligence) for the latest version.

2. Choose your deployment option:
   * [On-premise Example](@ref IpIntelligence_Examples_GettingStarted_Console_OnPremise) - Local processing with data files

### Web Integration

For web applications, add the web integration dependency:
```xml
<dependency>
    <groupId>com.51degrees</groupId>
    <artifactId>pipeline.web</artifactId>
</dependency>
```

Choose your deployment option:
* [On-premise Web Example](@ref IpIntelligence_Examples_GettingStarted_Web_OnPremise) - Local processing

@endsnippet
@startsnippet{go}
### Console Applications

1. Install the IP Intelligence package:
   ```bash
   go get github.com/51Degrees/ip-intelligence-go/v4
   ```
2. Choose your deployment option:
   * [On-premise Example](@ref IpIntelligence_Examples_GettingStarted_Console_OnPremise) - Local processing with data files

### Web Integration

For web applications, you can integrate IP Intelligence into your HTTP handlers:
* [On-premise Web Example](@ref IpIntelligence_Examples_GettingStarted_Web_OnPremise) - Local processing

@endsnippet
@endsnippets

@page IpIntelligence_Quickstart IP Intelligence Quick Start

# Getting Started with IP Intelligence

IP Intelligence provides geolocation, ISP, connection type, and network information from IP addresses. It helps enhance user experience, security, and content delivery.

## Choose Your Integration

### On-Premise Deployment
**Best for:** High-performance, privacy-sensitive, or offline environments

**Benefits:**
- **Ultra-low latency** - Sub-microsecond detection time with in-process deployment
- **Complete privacy** - All processing stays within your infrastructure
- **High throughput** - Designed for high-load scenarios
- **Offline capable** - No internet dependency for detection
- **Full control** - Customize update schedules and deployment architecture

**Things to consider:**
- **Setup required** - Initial configuration and data file management
- **Resource usage** - Uses local CPU/RAM (optimized but measurable)
- **Update management** - Periodic data file updates needed for latest data

**Licensing:** Requires a [License Key](https://51degrees.com/pricing)

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
To get started with C IP intelligence on-premise:

1. Clone the GitHub [repository](https://github.com/51degrees/ip-intelligence-cxx).
2. Ensure you have [Git LFS](https://git-lfs.github.com/) installed. The device data files are large binary files that can cause problems if stored in a Git repository directly, so Git LFS is used.
3. Ensure all submodules are checked out by running `git submodule update --init --recursive` in the repository.
4. Follow the [installation instructions](https://github.com/51Degrees/ip-intelligence-cxx/blob/main/README%2Emd) to get set up with the project. <!-- TODO use ref and tagfile so this is not hardcoded -->
5. Follow the linked example here: [Getting Started](@ref IpIntelligence_Examples_GettingStarted_Console_OnPremise).
6. (optional) Obtain a License Key by purchasing a subscription and download a data file with access to more devices and properties, see our [pricing page](https://51degrees.com/pricing) for details.

@endsnippet
@startsnippet{cxx}
C++ does not have a @Pipeline implementation or the ability to use the cloud-based version of 
Ip intelligence.
To get started with C++ device detection on-premise:

1. Clone the GitHub [repository](https://github.com/51degrees/ip-intelligence-cxx).
2. Ensure you have [Git LFS](https://git-lfs.github.com/) installed. The device data files are large binary files that can cause problems if stored in a Git repository directly, so Git LFS is used.
3. Ensure all submodules are checked out by running `git submodule update --init --recursive` in the repository.
5. Follow the [installation instructions](https://github.com/51Degrees/ip-intelligence-cxx/blob/main/README%2Emd) to get set up with the project. <!-- TODO use ref and tagfile so this is not hardcoded -->
6. Follow the linked example here: [Getting Started](@ref IpIntelligence_Examples_GettingStarted_Console_OnPremise).
7. (optional) Obtain a License Key by purchasing a subscription and download a data file with access to more devices and properties, see our [pricing page](https://51degrees.com/pricing) for details.

@endsnippet
@startsnippet{dotnet}
### Standalone pipeline / off-line processing

1. Install the [FiftyOne.IpIntelligence](https://www.nuget.org/packages/FiftyOne.IpIntelligence) package via Nuget.
2. Follow the appropriate example from the options below:  
  * [On-Premise Example](@ref IpIntelligence_Examples_GettingStarted_Console_OnPremise) - IP intelligence processing is performed locally using a data file that must be kept updated.

### ASP.NET Core integration.

1. Install the [FiftyOne.IpIntelligence](https://www.nuget.org/packages/FiftyOne.IpIntelligence) and [FiftyOne.Pipeline.Web](https://www.nuget.org/packages/FiftyOne.Pipeline.Web) packages via Nuget.
2. Follow the [web example](@ref PipelineApi_Examples_WebIntegration) to add the @Pipeline middleware.
3. Configure the pipeline using the configuration from the appropriate example from the options below:
 * [On-Premise Example](@ref IpIntelligence_Examples_GettingStarted_Console_OnPremise) - IP intelligence processing is performed locally using a data file that must be kept updated.

@endsnippet
@startsnippet{java}
To get started with Java IP Intelligence:

1. Add the IP Intelligence dependency to your project:
   ```xml
   <dependency>
       <groupId>com.51degrees</groupId>
       <artifactId>ip-intelligence</artifactId>
   </dependency>
   ```
   Check [Maven Central](https://search.maven.org/artifact/com.51degrees/ip-intelligence) for the latest version.
2. Follow the appropriate example from the options below:
   * [On-Premise Example](@ref IpIntelligence_Examples_GettingStarted_Console_OnPremise) - IP intelligence processing is performed locally using a data file that must be kept updated.

### Web Integration

For web applications, add the web integration dependency:
```xml
<dependency>
    <groupId>com.51degrees</groupId>
    <artifactId>pipeline.web</artifactId>
</dependency>
```

Configure the pipeline using the configuration from the on-premise example above.

@endsnippet
@startsnippet{go}
To get started with Go IP Intelligence:

1. Install the IP Intelligence package:
   ```bash
   go get github.com/51Degrees/ip-intelligence-go/v4
   ```
2. Follow the appropriate example from the options below:
   * [On-Premise Example](@ref IpIntelligence_Examples_GettingStarted_Console_OnPremise) - IP intelligence processing is performed locally using a data file that must be kept updated.

### Web Integration

For web applications, you can integrate IP Intelligence into your HTTP handlers. See the on-premise example for implementation details.

@endsnippet
@endsnippets

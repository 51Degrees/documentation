@page IpIntelligence_Quickstart IP Intelligence quick start

# Getting started with IP Intelligence

IP Intelligence provides geolocation, ISP, connection type, and network information from IP addresses. It helps enhance user experience, security, and content delivery.

## Choose your integration

### Cloud API
**Best for:** Quick deployment, minimal infrastructure, always up-to-date data

**Benefits:**
- **No infrastructure** - No servers or data files to manage
- **Always updated** - Latest IP intelligence data automatically
- **Quick setup** - Create a Resource Key to configure your cloud request

**Things to consider:**
- **Internet dependency** - Requires network connectivity
- **Latency** - Network round-trip time for each request
- **Data processing** - Occurs on 51Degrees infrastructure

**Licensing:** Requires a [Resource Key](https://configure.51degrees.com), which is free to create. The free plan includes the country and `LocationConfidence`, and paid plans add more IP Intelligence properties. See [pricing](https://51degrees.com/pricing).

### On-premise deployment
**Best for:** High-performance, data-sensitive, or offline environments

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

### Combine Device Detection and IP Intelligence
**Best for:** Combining device characteristics with network and location data

**Benefits:**
- **Complete user context** - Combine location/network data with device characteristics
- **Enhanced fraud detection** - Cross-reference device properties with IP risk data
- **Content delivery** - Use device capabilities and geographic location to tailor content
- **Advanced analytics** - Rich user segmentation with both device and location dimensions

**Things to consider:**
- **Multiple engines** - Requires configuration of both Device Detection and IP Intelligence
- **Data file management** - Need both device data files (.hash) and IP data files (.ipi) for On-premise
- **Resource usage** - Combined memory and CPU usage for both engines

**Licensing:** Requires licenses for both Device Detection and IP Intelligence services

## Language-specific integration

Select your language below for detailed setup instructions:

@startsnippets
@showsnippet{c,C}
@showsnippet{cxx,C++}
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{go,Go}
@showsnippet{rust,Rust}
@showsnippet{node,Node.js}
@showsnippet{python,Python}
@showsnippet{php,PHP}
@defaultsnippet{Select a language.}
@startsnippet{c}
C does not have a @Pipeline implementation or the ability to use the cloud-based version of 
IP intelligence.
To get started with C IP intelligence On-premise:

1. Clone the GitHub [repository](https://github.com/51Degrees/51degrees-cxx).
2. Ensure all submodules are checked out by running `git submodule update --init --recursive` in the repository.
3. Follow the [installation instructions](https://github.com/51Degrees/51degrees-cxx/blob/main/README%2Emd) to get set up with the project.
4. Follow the linked example here: [Getting Started](@ref IpIntelligence_Examples_GettingStarted_Console_OnPremise).
5. To run the example, [contact us](https://51degrees.com/contact-us) to obtain an enterprise IPI data file.

@endsnippet
@startsnippet{cxx}
C++ does not have a @Pipeline implementation or the ability to use the cloud-based version of 
IP intelligence.
To get started with C++ IP intelligence On-premise:

1. Clone the GitHub [repository](https://github.com/51Degrees/51degrees-cxx).
2. Ensure all submodules are checked out by running `git submodule update --init --recursive` in the repository.
3. Follow the [installation instructions](https://github.com/51Degrees/51degrees-cxx/blob/main/README%2Emd) to get set up with the project. <!-- TODO use ref and tagfile so this is not hardcoded -->
4. Follow the linked example here: [Getting Started](@ref IpIntelligence_Examples_GettingStarted_Console_OnPremise).
5. To run the example, [contact us](https://51degrees.com/contact-us) to obtain an enterprise IPI data file.

@endsnippet
@startsnippet{dotnet}
### Console applications

1. Install the [FiftyOne.IpIntelligence](https://www.nuget.org/packages/FiftyOne.IpIntelligence) package via Nuget.
2. Choose your deployment option:
   * [Cloud Example](@ref IpIntelligence_Examples_GettingStarted_Console_Cloud) - Uses 51Degrees Cloud API for processing
   * [On-premise Example](@ref IpIntelligence_Examples_GettingStarted_Console_OnPremise) - Local processing with data files
   * [Combined Example](@ref IpIntelligence_Combined_Console_OnPremise) - Mix IP Intelligence with Device Detection

### Web applications (ASP.NET Core)

1. Install the [FiftyOne.IpIntelligence](https://www.nuget.org/packages/FiftyOne.IpIntelligence) and [FiftyOne.Pipeline.Web](https://www.nuget.org/packages/FiftyOne.Pipeline.Web) packages via Nuget.
2. Follow the [web integration guide](@ref PipelineApi_Examples_WebIntegration) to add the @Pipeline middleware.
3. Choose your deployment option:
   * [Cloud Web Example](@ref IpIntelligence_Examples_GettingStarted_Web_Cloud) - Uses 51Degrees Cloud API
   * [On-premise Web Example](@ref IpIntelligence_Examples_GettingStarted_Web_OnPremise) - Local processing
   * [Combined Web Example](@ref IpIntelligence_Combined_Web_OnPremise) - Mix IP Intelligence with Device Detection

@endsnippet
@startsnippet{java}
### Console applications

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

### Web integration

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
### Console applications

1. Install the IP Intelligence package:
   ```bash
   go get github.com/51Degrees/51degrees-go/ip-intelligence/v4
   ```
2. Choose your deployment option:
   * [On-premise Example](@ref IpIntelligence_Examples_GettingStarted_Console_OnPremise) - Local processing with data files

### Web integration

For web applications, you can integrate IP Intelligence into your HTTP handlers:
* [On-premise Web Example](@ref IpIntelligence_Examples_GettingStarted_Web_OnPremise) - Local processing

@endsnippet
@startsnippet{rust}
### Console applications

1. Add the [`fiftyone-ip-intelligence`](https://crates.io/crates/fiftyone-ip-intelligence) crate from crates.io (for example with `cargo add fiftyone-ip-intelligence`).
2. Choose your deployment option:
   * [On-premise Example](@ref IpIntelligence_Examples_GettingStarted_Console_OnPremise) - Local processing with a data file.
   * [Cloud Example](@ref IpIntelligence_Examples_GettingStarted_Console_Cloud) - The 51Degrees cloud service, no local data file.

### Web integration

For web applications, integrate IP Intelligence into your axum handlers:
* [On-premise Web Example](@ref IpIntelligence_Examples_GettingStarted_Web_OnPremise) - Local processing.
@endsnippet
@startsnippet{node}
### Console applications

1. Install the [fiftyone.ipintelligence](https://www.npmjs.com/package/fiftyone.ipintelligence) package from npm, for example with `npm install fiftyone.ipintelligence`.
2. Choose your deployment option:
   * [On-premise Example](https://github.com/51Degrees/51degrees-node/blob/main/ip-intelligence/fiftyone.ipintelligence.onpremise/examples/onpremise/gettingstarted-console/gettingStarted.js) - Local processing with a data file.
   * [Cloud Example](https://github.com/51Degrees/51degrees-node/blob/main/ip-intelligence/fiftyone.ipintelligence.cloud/examples/cloud/gettingstarted-console/gettingStarted.js) - The 51Degrees cloud service, no local data file.
   * [Combined Example](https://github.com/51Degrees/51degrees-node/blob/main/ip-intelligence/fiftyone.ipintelligence.onpremise/examples/onpremise/mixed/gettingstarted-console/gettingStarted.js) - Mix IP Intelligence with Device Detection.

### Web integration

For web applications, add the @Pipeline to your HTTP server:
* [On-premise Web Example](https://github.com/51Degrees/51degrees-node/blob/main/ip-intelligence/fiftyone.ipintelligence.onpremise/examples/onpremise/gettingstarted-web/gettingStarted.js) - Local processing.
* [Cloud Web Example](https://github.com/51Degrees/51degrees-node/blob/main/ip-intelligence/fiftyone.ipintelligence.cloud/examples/cloud/gettingstarted-web/gettingStarted.js) - The 51Degrees cloud service.

@endsnippet
@startsnippet{python}
### Console applications

1. Install the [fiftyone_ipintelligence](https://pypi.org/project/fiftyone-ipintelligence/) package from PyPI, for example with `pip install fiftyone_ipintelligence`. Building the on-premise engine's native extension from source needs a C++17 compiler.
2. Choose your deployment option:
   * [On-premise Example](https://github.com/51Degrees/51degrees-python/blob/main/ip-intelligence/fiftyone_ipintelligence_examples/src/fiftyone_ipintelligence_examples/onpremise/gettingstarted_console.py) - Local processing with a data file.
   * [Cloud Example](https://github.com/51Degrees/51degrees-python/blob/main/ip-intelligence/fiftyone_ipintelligence_examples/src/fiftyone_ipintelligence_examples/cloud/gettingstarted_console.py) - The 51Degrees cloud service, no local data file.
   * [Combined Example](https://github.com/51Degrees/51degrees-python/blob/main/ip-intelligence/fiftyone_ipintelligence_examples/src/fiftyone_ipintelligence_examples/onpremise/mixed_console.py) - Mix IP Intelligence with Device Detection.

### Web integration (Flask)

* [On-premise Web Example](https://github.com/51Degrees/51degrees-python/blob/main/ip-intelligence/fiftyone_ipintelligence_examples/src/fiftyone_ipintelligence_examples/onpremise/gettingstarted_web/app.py) - Local processing.
* [Cloud Web Example](https://github.com/51Degrees/51degrees-python/blob/main/ip-intelligence/fiftyone_ipintelligence_examples/src/fiftyone_ipintelligence_examples/cloud/gettingstarted_web/app.py) - The 51Degrees cloud service.

@endsnippet
@startsnippet{php}
### Console applications

The `51degrees/fiftyone.ipintelligence` package is not on Packagist yet, so use it from a clone of the [51degrees-php](https://github.com/51Degrees/51degrees-php) repository through a Composer path repository.

1. Clone the repository with its submodules, using `git clone --recurse-submodules https://github.com/51Degrees/51degrees-php.git`.
2. For on-premise, build the `FiftyOneDegreesIpIntelligenceEngine` extension and enable it, as [OnPremise.md](https://github.com/51Degrees/51degrees-php/blob/main/ip-intelligence/OnPremise.md) describes. The IP Intelligence and Device Detection extensions can be loaded together in one PHP.
3. Choose your deployment option:
   * [On-premise Example](https://github.com/51Degrees/51degrees-php/blob/main/ip-intelligence/examples/onpremise/gettingstarted-console.php) - Local processing with a data file.
   * [Cloud Example](https://github.com/51Degrees/51degrees-php/blob/main/ip-intelligence/examples/cloud/gettingstarted-console.php) - The 51Degrees cloud service, no local data file.
   * [Combined Example](https://github.com/51Degrees/51degrees-php/blob/main/ip-intelligence/examples/onpremise/mixed/gettingstarted-console.php) - Mix IP Intelligence with Device Detection, which needs both extensions.

### Web integration

* [On-premise Web Example](https://github.com/51Degrees/51degrees-php/blob/main/ip-intelligence/examples/onpremise/web/index.php) - Local processing.
* [Cloud Web Example](https://github.com/51Degrees/51degrees-php/blob/main/ip-intelligence/examples/cloud/web/index.php) - The 51Degrees cloud service.

@endsnippet
@endsnippets

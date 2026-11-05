@page DeviceDetection_Quickstart Device Detection Quick Start

# Getting Started with Device Detection

51Degrees Device Detection offers two integration options. Each has different benefits to match your needs:

## Choose Your Integration

### Cloud service {#cloud-integration}

**Best for:** Quick setup, minimal infrastructure, cost-effective scaling

**Benefits:**
- **No setup needed** - No data files or local infrastructure required
- **Always updated** - Latest device data without manual updates
- **Minimal resources** - Very low CPU/RAM usage on your servers
- **Pay-as-you-go** - Cost scales with usage
- **Global availability** - Multiple data centers for low latency

**Things to consider:**
- **Network dependency** - Requires Internet connectivity and adds network latency (typically 10-50ms)
- **External service** - Detection processing occurs on 51Degrees infrastructure

**Authentication:** Requires a [Resource Key](@ref Services_Configurator)

---

### On-premise deployment {#On-premise-integration}

**Best for:** High-performance, data-sensitive, or offline environments

**Benefits:**
- **Low latency** - Microseconds per detection when the data file is held in memory, with no network call
- **Processing on your servers** - All processing stays within your infrastructure
- **High throughput** - Over 1 million detections per second on an eight-core AWS Graviton3 instance, with the data file in memory ([measured results](@ref ProductSummaries_Benchmarks_Hardware))
- **Fast startup** - Loads the data file into memory and is ready to detect in under 150 milliseconds on the same Graviton3 instance, which matters most where servers start and stop as demand changes
- **Offline capable** - No internet dependency for detection
- **Full control** - Customize update schedules and deployment architecture

**Things to consider:**
- **Setup required** - Initial configuration and data file management
- **Resource usage** - Uses local CPU/RAM (optimized but measurable)
- **Update management** - Periodic data file updates needed for latest devices ([automatic updates available](@ref PipelineApi_Features_AutomaticDatafileUpdates))

**Licensing:** Requires a [License Key](https://51degrees.com/pricing)

---

## Which Integration Should I Choose?

| **Use Case** | **Recommended** | **Why** |
|--------------|-----------------|----------|
| **Prototyping & Development** | Cloud | Fastest setup, no infrastructure overhead |
| **Low-volume Production** | Cloud | Cost-effective, automatic updates |
| **High-traffic Web Servers** | On-premise | Maximum performance, cost efficiency at scale |
| **Real-time Applications** | On-premise | Microsecond latency requirements |
| **Edge/CDN Integration** | On-premise | Offline capability, minimal latency |
| **Data-sensitive Applications** | On-premise | Processing stays within your infrastructure |
| **Variable Traffic Patterns** | Cloud | Pay-as-you-go scaling |

---

## Enhanced Accuracy Options

For more accurate results (especially for identifying specific iPhone/iPad models), consider enabling [client-side evidence](@ref PipelineApi_Features_ClientSideEvidence) collection.

---

## Language-Specific Integration

Most programming languages support both integration models. Select your language below for detailed setup instructions:

@startsnippets
@showsnippet{c,C}
@showsnippet{cxx,C++}
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{node,Node.js}
@showsnippet{php,PHP}
@showsnippet{python,Python}
@showsnippet{varnish,Varnish}
@showsnippet{nginx,Nginx}
@showsnippet{go,Go}
@showsnippet{rust,Rust}
@defaultsnippet{Select a language.}
@startsnippet{c}
C does not have a @Pipeline implementation or the ability to use the cloud-based version of 
Device Detection.
To get started with C device detection On-premise:

1. Clone the GitHub [repository](https://github.com/51Degrees/51degrees-cxx) with its submodules by running `git clone --recurse-submodules https://github.com/51Degrees/51degrees-cxx.git`. In a clone you already have, run `git submodule update --init --recursive` instead.
2. Download the free Lite data file by running `sh data/get-data-files.sh 51Degrees-LiteV4.1.hash` from the repository root, or `./data/get-data-files.ps1 51Degrees-LiteV4.1.hash` in PowerShell. The scripts are part of the [data](https://github.com/51Degrees/data) repository, which is the `data` submodule. The examples also download the file themselves when it is missing.
3. Follow the [installation instructions](https://github.com/51Degrees/51degrees-cxx/blob/main/README%2Emd) to get set up with the project. <!-- TODO use ref and tagfile so this is not hardcoded -->
4. Follow the linked example here: [Getting Started](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise).
5. (optional) Obtain a License Key by purchasing a subscription and download a data file with access to more devices and properties, see our [pricing page](https://51degrees.com/pricing) for details.

@endsnippet
@startsnippet{cxx}
C++ does not have a @Pipeline implementation or the ability to use the cloud-based version of 
Device Detection.
To get started with C++ device detection On-premise:

1. Clone the GitHub [repository](https://github.com/51Degrees/51degrees-cxx) with its submodules by running `git clone --recurse-submodules https://github.com/51Degrees/51degrees-cxx.git`. In a clone you already have, run `git submodule update --init --recursive` instead.
2. Download the free Lite data file by running `sh data/get-data-files.sh 51Degrees-LiteV4.1.hash` from the repository root, or `./data/get-data-files.ps1 51Degrees-LiteV4.1.hash` in PowerShell. The scripts are part of the [data](https://github.com/51Degrees/data) repository, which is the `data` submodule. The examples also download the file themselves when it is missing.
3. Follow the [installation instructions](https://github.com/51Degrees/51degrees-cxx/blob/main/README%2Emd) to get set up with the project. <!-- TODO use ref and tagfile so this is not hardcoded -->
4. Follow the linked example here: [Getting Started](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise).
5. (optional) Obtain a License Key by purchasing a subscription and download a data file with access to more devices and properties, see our [pricing page](https://51degrees.com/pricing) for details.

@endsnippet
@startsnippet{dotnet}
### Standalone pipeline / offline processing

1. Install the [FiftyOne.DeviceDetection](https://www.nuget.org/packages/FiftyOne.DeviceDetection) package via Nuget.
2. Follow the appropriate example from the options below:  
  * [Cloud Example](@ref DeviceDetection_Examples_GettingStarted_Console_Cloud) - Negligible processing and memory overhead but slower due to Internet latency. 
  * [On-premise Example](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise) - Device detection processing is performed locally using a data file that must be kept updated.

### ASP.NET Core integration

1. Install the [FiftyOne.DeviceDetection](https://www.nuget.org/packages/FiftyOne.DeviceDetection) and [FiftyOne.Pipeline.Web](https://www.nuget.org/packages/FiftyOne.Pipeline.Web) packages via Nuget.
2. Follow the [web example](@ref PipelineApi_Examples_WebIntegration) to add the @Pipeline middleware.
3. Configure the pipeline using the configuration from the appropriate example from the options below:
 * [Cloud Example](@ref DeviceDetection_Examples_GettingStarted_Console_Cloud) - Negligible processing and memory overhead but slower due to Internet latency.
 * [On-premise Example](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise) - Device detection processing is performed locally using a data file that must be kept updated.
4. (optional) Configure [client-side evidence](@ref PipelineApi_Features_ClientSideEvidence) to get better results. Particularly for iPhone/iPad.
@endsnippet
@startsnippet{java}
### Standalone pipeline / offline processing

1. Install the [com.51degrees.pipeline.device-detection](https://search.maven.org/artifact/com.51degrees/pipeline.device-detection) package via Maven.
2. Follow the appropriate example from the options below:
  * [Cloud Example](@ref DeviceDetection_Examples_GettingStarted_Console_Cloud) - Negligible processing and memory overhead but slower due to Internet latency. 
  * [On-premise Example](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise) - Device detection processing is performed locally using a data file that must be kept updated.    
    
### Web servlet integration

1. Install the [com.51degrees.device-detection](https://search.maven.org/artifact/com.51degrees/device-detection) and [com.51degrees.pipeline.web](https://search.maven.org/artifact/com.51degrees/pipeline.web) packages via Maven.
2. Follow the [servlet example](@ref PipelineApi_Examples_WebIntegration) to add the @Pipeline filter.
3. Configure the pipeline using the configuration from the appropriate example from the options below:
 * [Cloud Example](@ref DeviceDetection_Examples_GettingStarted_Console_Cloud) - Negligible processing and memory overhead but slower due to Internet latency.
 * [On-premise Example](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise) - Device detection processing is performed locally using a data file that must be kept updated.
4. (optional) Configure [client-side evidence](@ref PipelineApi_Features_ClientSideEvidence) to get better results. Particularly for iPhone/iPad.

### Spring MVC integration

1. Install the [com.51degrees.device-detection](https://search.maven.org/artifact/com.51degrees/device-detection) and [com.51degrees.pipeline.web](https://search.maven.org/artifact/com.51degrees/pipeline.web) packages via Maven.
2. Follow the [Spring MVC example](@ref PipelineApi_Examples_WebIntegration) to add the @Pipeline filter.
3. Configure the pipeline using the configuration from the appropriate example from the options below:
 * [Cloud Example](@ref DeviceDetection_Examples_GettingStarted_Console_Cloud) - Negligible processing and memory overhead but slower due to Internet latency.
 * [On-premise Example](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise) - Device detection processing is performed locally using a data file that must be kept updated.
4. (optional) Configure [client-side evidence](@ref PipelineApi_Features_ClientSideEvidence) to get better results. Particularly for iPhone/iPad.
@endsnippet
@startsnippet{node}
1. Install the [fiftyone.devicedetection](https://www.npmjs.com/package/fiftyone.devicedetection) package from NPM.
2. Follow the appropriate example from the options below:  
  * [Cloud Example](@ref DeviceDetection_Examples_GettingStarted_Console_Cloud) - Negligible processing and memory overhead but slower due to Internet latency. 
  * [On-premise Example](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise) - Device detection processing is performed locally using a data file that must be kept updated.
@endsnippet
@startsnippet{php}
### Cloud 

The cloud implementation uses the 51Degrees Cloud Service and requires less memory and CPU than the on-premise implementation. It is slower because each request adds Internet latency. Choose on-premise detection if detection speed is your priority.

1. Install the [51degrees/fiftyone.devicedetection](https://packagist.org/packages/51degrees/fiftyone.devicedetection) package using Composer.
2. Follow the [Cloud Example](@ref DeviceDetection_Examples_GettingStarted_Console_Cloud).

### On-premise

Device detection processing is performed locally using a data file that must be kept updated.
Due to the restrictions imposed by Composer and Packagist, we cannot supply the On-premise Engines through the usual package management ecosystem. Instead, you'll need to clone the [repository](https://github.com/51Degrees/51degrees-php/tree/main/device-detection/onpremise) from GitHub and follow the instructions there in order to build and use the On-premise implementation.

@endsnippet
@startsnippet{python}
1. Install the [fiftyone_devicedetection](https://pypi.org/project/fiftyone-devicedetection/) package from PyPI.
2. Follow the appropriate example from the options below:  
  * [Cloud Example](@ref DeviceDetection_Examples_GettingStarted_Console_Cloud) - Negligible processing and memory overhead but slower due to Internet latency. 
  * [On-premise Example](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise) - Device detection processing is performed locally using a data file that must be kept updated.
@endsnippet
@startsnippet{varnish}
Varnish does not have a @Pipeline implementation or the ability to use the cloud-based version of Device Detection.
To get started with Varnish device detection On-premise:

1. Clone the GitHub [repository](https://github.com/51degrees/51degrees-varnish) with its submodules by running `git clone --recurse-submodules https://github.com/51Degrees/51degrees-varnish.git`. In a clone you already have, run `git submodule update --init --recursive` instead.
2. Download the free Lite data file, and the free Asn data file that the IP Intelligence tests use, by running `sh cxx/data/get-data-files.sh 51Degrees-LiteV4.1.hash 51Degrees-IPIV4AsnIpiV41.ipi` from the repository root. The script is part of the [data](https://github.com/51Degrees/data) repository, which the `cxx` submodule includes at `cxx/data`.
3. Follow the [installation instructions](@ref DeviceDetection_OtherIntegrations_Varnish) to get set up with the project.
4. Follow the linked example here: [Getting Started](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise).
5. (optional) Obtain a License Key by purchasing a subscription and download a data file with access to more devices and properties, see our [pricing page](https://51degrees.com/pricing) for details.

@endsnippet
@startsnippet{nginx}
Nginx does not have a @Pipeline implementation or the ability to use the cloud-based version of Device Detection.
To get started with Nginx device detection On-premise:

1. Clone the GitHub [repository](https://github.com/51degrees/51degrees-nginx) with its submodules by running `git clone --recurse-submodules https://github.com/51Degrees/51degrees-nginx.git`. In a clone you already have, run `git submodule update --init --recursive` instead.
2. Download the free Lite data file by running `sh cxx/data/get-data-files.sh 51Degrees-LiteV4.1.hash` from the repository root. The script is part of the [data](https://github.com/51Degrees/data) repository, which the `cxx` submodule includes at `cxx/data`.
3. Follow the [installation instructions](@ref DeviceDetection_OtherIntegrations_Nginx) to get set up with the project.
4. Follow the linked example here: [Getting Started](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise).
5. (optional) Obtain a License Key by purchasing a subscription and download a data file with access to more devices and properties, see our [pricing page](https://51degrees.com/pricing) for details.

@endsnippet
@startsnippet{go}
For Go setup instructions and examples, see:
[device-detection-go](https://github.com/51Degrees/51degrees-go/tree/main/device-detection#readme), [device-detection-examples-go](https://github.com/51Degrees/51degrees-go/tree/main/examples/device-detection#readme).
To get started with Go device detection On-premise:

1. Clone the GitHub [repository](https://github.com/51Degrees/51degrees-go) with its submodules by running `git clone --recurse-submodules https://github.com/51Degrees/51degrees-go.git`. In a clone you already have, run `git submodule update --init --recursive` instead.
2. Download the free Lite data file by running `sh cxx/data/get-data-files.sh 51Degrees-LiteV4.1.hash` from the repository root, or `./cxx/data/get-data-files.ps1 51Degrees-LiteV4.1.hash` in PowerShell. The scripts are part of the [data](https://github.com/51Degrees/data) repository, which the `cxx` submodule includes at `cxx/data`.
3. Follow the [installation instructions](https://github.com/51Degrees/51degrees-go/tree/main/device-detection#build-and-usage) to get set up with the project.
4. Follow the linked example here: [Getting Started](https://github.com/51Degrees/51degrees-go/blob/main/examples/device-detection/dd/getting_started/getting_started.go).
5. (optional) Obtain a License Key by purchasing a subscription and download a data file with access to more devices and properties, see our [pricing page](https://51degrees.com/pricing) for details.

@endsnippet
@startsnippet{rust}
### Standalone pipeline / offline processing

1. Add the [`fiftyone-device-detection`](https://crates.io/crates/fiftyone-device-detection) crate from crates.io (for example with `cargo add fiftyone-device-detection`).
2. Follow the appropriate example from the options below:
  * [Cloud Example](@ref DeviceDetection_Examples_GettingStarted_Console_Cloud) - Negligible processing and memory overhead but slower due to Internet latency.
  * [On-premise Example](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise) - Device detection processing is performed locally using a data file that must be kept updated.

### Web integration (axum)

1. Add the `fiftyone-device-detection`, `fiftyone-pipeline-web`, and `fiftyone-pipeline-web-axum` crates.
2. Follow the [web example](@ref DeviceDetection_Examples_GettingStarted_Web_OnPremise) to mount the pipeline in an axum application.
@endsnippet

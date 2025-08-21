@page DeviceDetection_Quickstart Device Detection Quick Start

# Getting Started with Device Detection

51Degrees Device Detection offers two integration options. Each has different benefits to match your needs:

## Choose Your Integration

### Cloud Service <a href="#cloud-integration">#</a> @anchor cloud-integration
**Best for:** Quick setup, minimal infrastructure, cost-effective scaling

**Benefits:**
- **No setup needed** - No data files or local infrastructure required
- **Always updated** - Latest device data without manual updates
- **Minimal resources** - Very low CPU/RAM usage on your servers
- **Pay-as-you-go** - Cost scales with usage
- **Global availability** - Multiple data centers for low latency

**Things to consider:**
- **Network dependency** - Requires internet connectivity and handles latency (typically 10-50ms)
- **External service** - Detection processing occurs on 51Degrees infrastructure

**Authentication:** Requires a [Resource Key](@ref Services_Configurator)

---

### On-premise Deployment <a href="#On-premise-integration">#</a> @anchor On-premise-integration
**Best for:** High-performance, privacy-sensitive, or offline environments

**Benefits:**
- **Ultra-low latency** - Sub-microsecond detection time with in-process deployment
- **Complete privacy** - All processing stays within your infrastructure
- **High throughput** - Over 1 million detections per second per CPU core
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
| **Real-time Applications** | On-premise | Sub-microsecond latency requirements |
| **Edge/CDN Integration** | On-premise | Offline capability, minimal latency |
| **Privacy-sensitive Applications** | On-premise | Data never leaves your infrastructure |
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
@defaultsnippet{Select a language.}
@startsnippet{c}
C does not have a @Pipeline implementation or the ability to use the cloud-based version of 
Device Detection.
To get started with C device detection On-premise:

1. Clone the GitHub [repository](https://github.com/51degrees/device-detection-cxx).
2. Ensure you have [Git LFS](https://git-lfs.github.com/) installed. The device data files are large binary files that can cause problems if stored in a Git repository directly, so Git LFS is used.
3. Ensure all submodules are checked out by running `git submodule update --init --recursive` in the repository.
4. Follow the [installation instructions](https://github.com/51Degrees/device-detection-cxx/blob/main/README%2Emd) to get set up with the project. <!-- TODO use ref and tagfile so this is not hardcoded -->
5. Follow the linked example here: [Getting Started](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise).
6. (optional) Obtain a License Key by purchasing a subscription and download a data file with access to more devices and properties, see our [pricing page](https://51degrees.com/pricing) for details.

@endsnippet
@startsnippet{cxx}
C++ does not have a @Pipeline implementation or the ability to use the cloud-based version of 
Device Detection.
To get started with C++ device detection On-premise:

1. Clone the GitHub [repository](https://github.com/51degrees/device-detection-cxx).
2. Ensure you have [Git LFS](https://git-lfs.github.com/) installed. The device data files are large binary files that can cause problems if stored in a Git repository directly, so Git LFS is used.
3. Ensure all submodules are checked out by running `git submodule update --init --recursive` in the repository.
5. Follow the [installation instructions](https://github.com/51Degrees/device-detection-cxx/blob/main/README%2Emd) to get set up with the project. <!-- TODO use ref and tagfile so this is not hardcoded -->
6. Follow the linked example here: [Getting Started](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise).
7. (optional) Obtain a License Key by purchasing a subscription and download a data file with access to more devices and properties, see our [pricing page](https://51degrees.com/pricing) for details.

@endsnippet
@startsnippet{dotnet}
### Standalone pipeline / off-line processing

1. Install the [FiftyOne.DeviceDetection](https://www.nuget.org/packages/FiftyOne.DeviceDetection) package via Nuget.
2. Follow the appropriate example from the options below:  
  * [Cloud Example](@ref DeviceDetection_Examples_GettingStarted_Console_Cloud) - Negligible processing and memory overhead but slower due to Internet latency. 
  * [On-premise Example](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise) - Device detection processing is performed locally using a data file that must be kept updated.

### ASP.NET Core integration.

1. Install the [FiftyOne.DeviceDetection](https://www.nuget.org/packages/FiftyOne.DeviceDetection) and [FiftyOne.Pipeline.Web](https://www.nuget.org/packages/FiftyOne.Pipeline.Web) packages via Nuget.
2. Follow the [web example](@ref PipelineApi_Examples_WebIntegration) to add the @Pipeline middleware.
3. Configure the pipeline using the configuration from the appropriate example from the options below:
 * [Cloud Example](@ref DeviceDetection_Examples_GettingStarted_Console_Cloud) - Negligible processing and memory overhead but slower due to Internet latency.
 * [On-premise Example](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise) - Device detection processing is performed locally using a data file that must be kept updated.
4. (optional) Configure [client-side evidence](@ref PipelineApi_Features_ClientSideEvidence) to get better results. Particularly for iPhone/iPad.
@endsnippet
@startsnippet{java}
### Standalone pipeline / off-line processing

1. Install the [com.51degrees.pipeline.device-detection](https://search.maven.org/artifact/com.51degrees/pipeline.device-detection) package via Maven.
2. Follow the appropriate example from the options below:
  * [Cloud Example](@ref DeviceDetection_Examples_GettingStarted_Console_Cloud) - Negligible processing and memory overhead but slower due to Internet latency. 
  * [On-premise Example](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise) - Device detection processing is performed locally using a data file that must be kept updated.    
    
### Web servlet integration.

1. Install the [com.51degrees.device-detection](https://search.maven.org/artifact/com.51degrees/device-detection) and [com.51degrees.pipeline.web](https://search.maven.org/artifact/com.51degrees/pipeline.web) packages via Maven.
2. Follow the [servlet example](@ref PipelineApi_Examples_WebIntegration) to add the @Pipeline filter.
3. Configure the pipeline using the configuration from the appropriate example from the options below:
 * [Cloud Example](@ref DeviceDetection_Examples_GettingStarted_Console_Cloud) - Negligible processing and memory overhead but slower due to Internet latency.
 * [On-premise Example](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise) - Device detection processing is performed locally using a data file that must be kept updated.
4. (optional) Configure [client-side evidence](@ref PipelineApi_Features_ClientSideEvidence) to get better results. Particularly for iPhone/iPad.

### Spring MVC integration.

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

This implementation of device detection makes use of 51Degrees' cloud service. In PHP, the cloud version is much easier to work with than the On-premise implementation as well as having much lower memory and CPU requirements. However, it is slower due to Internet latency. If you want faster detections, you should consider On-premise. 

1. Install the [51degrees/fiftyone.devicedetection](https://packagist.org/packages/51degrees/fiftyone.devicedetection) package using Composer.
2. Follow the [Cloud Example](@ref DeviceDetection_Examples_GettingStarted_Console_Cloud).

### On-premise

Device detection processing is performed locally using a data file that must be kept updated.
Due to the restrictions imposed by Composer and Packagist, we cannot supply the On-premise engines through the usual package management ecosystem. Instead, you'll need to clone the [repository](https://github.com/51Degrees/device-detection-php-onpremise) from GitHub and follow the instructions there in order to build and use the On-premise implementation.

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

1. Clone the GitHub [repository](https://github.com/51degrees/device-detection-varnish).
2. Ensure you have [Git LFS](https://git-lfs.github.com/) installed. The device data files are large binary files that can cause problems if stored in a Git repository directly, so Git LFS is used.
3. Ensure all submodules are checked out by running `git submodule update --init --recursive` in the repository.
4. Follow the [installation instructions](@ref DeviceDetection_OtherIntegrations_Varnish) to get set up with the project.
5. Follow the linked example here: [Getting Started](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise).
6. (optional) Obtain a License Key by purchasing a subscription and download a data file with access to more devices and properties, see our [pricing page](https://51degrees.com/pricing) for details.

@endsnippet
@startsnippet{nginx}
Nginx does not have a @Pipeline implementation or the ability to use the cloud-based version of Device Detection.
To get started with Nginx device detection On-premise:

1. Clone the GitHub [repository](https://github.com/51degrees/device-detection-nginx).
2. Ensure you have [Git LFS](https://git-lfs.github.com/) installed. The device data files are large binary files that can cause problems if stored in a Git repository directly, so Git LFS is used.
3. Ensure all submodules are checked out by running `git submodule update --init --recursive` in the repository.
4. Follow the [installation instructions](@ref DeviceDetection_OtherIntegrations_Nginx) to get set up with the project.
5. Follow the linked example here: [Getting Started](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise).
6. (optional) Obtain a License Key by purchasing a subscription and download a data file with access to more devices and properties, see our [pricing page](https://51degrees.com/pricing) for details.

@endsnippet
@startsnippet{go}
Currently, we have a light set of device detection features for Go users to try and evaluate the capability of 51Degrees device detection. Documentation for Go can be found via the following GitHub repositories:
[device-detection-go](https://github.com/51Degrees/device-detection-go#readme), [device-detection-examples-go](https://github.com/51Degrees/device-detection-examples-go#readme).
To get started with Go device detection On-premise:

1. Clone the GitHub [repository](https://github.com/51Degrees/device-detection-go).
2. Ensure you have [Git LFS](https://git-lfs.github.com/) installed. The device data files are large binary files that can cause problems if stored in a Git repository directly, so Git LFS is used.
3. Ensure all submodules are checked out by running `git submodule update --init --recursive` in the repository.
4. Follow the [installation instructions](https://github.com/51Degrees/device-detection-go#build-and-usage) to get set up with the project.
5. Follow the linked example here: [Getting Started](https://github.com/51Degrees/device-detection-examples-go/blob/main/dd/getting_started_test.go).
6. (optional) Obtain a License Key by purchasing a subscription and download a data file with access to more devices and properties, see our [pricing page](https://51degrees.com/pricing) for details.

@endsnippet

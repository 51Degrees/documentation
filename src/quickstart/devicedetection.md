@page Quickstart_DeviceDetection Device Detection

@startsnippets
@showsnippet{c,C}
@showsnippet{cxx,C++}
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a language.}
@startsnippet{c}
C does not have a @Pipeline implementation or the ability to use the cloud-based version of 
Device Detection.
To get started with C device detection on-premise:

1. Clone the GitHub [repository](https://github.com/51degrees/device-detection-cxx). (During the beta period, this repository is private. Please [contact us](mailto:support@51degrees.com) to request access.)
2. Ensure you have [Git LFS](https://git-lfs.github.com/) installed. The device data files are large binary files that can cause problems if stored in a Git repository directly so Git LFS is used.
3. Ensure all submodules are checked out by running `git submodule update --init --recursive` in the repository.
4. Decide if you want [Hash or Pattern](@ref DeviceDetection_Overview_PatternVsHash). In summary, @Hash is faster than @Pattern but is less able to cope with User-Agents that have not been seen before.
5. Follow the [installation instructions](../../device-detection-cxx/4.1/md__r_e_a_d_m_e.html) to get set up with the project. <!-- TODO use ref and tagfile so this is not hardcoded -->
6. Follow the linked examples here: [Hash](@ref Examples_DeviceDetection_GettingStarted_OnPremiseHash) or 
[Pattern](@ref Examples_DeviceDetection_GettingStarted_OnPremisePattern). Both examples are included in the project.
7. (optional) Contact us to purchase a license key and [download](https://51degrees.com/resources/downloads/enhanced-device-data) a premium data file with access to more devices and properties.

<!--TODO: Add contact details in step 3.-->
@endsnippet
@startsnippet{cxx}
C++ does not have a @Pipeline implementation or the ability to use the cloud-based version of 
Device Detection.
To get started with C++ device detection on-premise:

1. Clone the GitHub [repository](https://github.com/51degrees/device-detection-cxx). (During the beta period, this repository is private. Please [contact us](mailto:support@51degrees.com) to request access.)
2. Ensure you have [Git LFS](https://git-lfs.github.com/) installed. The device data files are large binary files that can cause problems if stored in a Git repository directly so Git LFS is used.
3. Ensure all submodules are checked out by running `git submodule update --init --recursive` in the repository.
4. Decide if you want [Hash or Pattern](@ref DeviceDetection_Overview_PatternVsHash). In summary, @Hash is faster than @Pattern but is less able to cope with User-Agents that have not been seen before.
5. Follow the [installation instructions](../../device-detection-cxx/4.1/md__r_e_a_d_m_e.html) to get set up with the project. <!-- TODO use ref and tagfile so this is not hardcoded -->
6. Follow the linked examples here: [Hash](@ref Examples_DeviceDetection_GettingStarted_OnPremiseHash) or 
[Pattern](@ref Examples_DeviceDetection_GettingStarted_OnPremisePattern). Both examples are included in the project.
7. (optional) Contact us to purchase a license key and [download](https://51degrees.com/resources/downloads/enhanced-device-data) a premium data file with access to more devices and properties.

<!--TODO: Add contact details in step 3.-->

@endsnippet
@startsnippet{dotnet}
### Standalone pipeline / off-line processing

1. Install the [FiftyOne.DeviceDetection](https://www.nuget.org/packages/FiftyOne.DeviceDetection) package via Nuget.
2. Follow the appropriate example from the options below:  
  * [Cloud Example](@ref Examples_DeviceDetection_GettingStarted_Cloud) - Negligible processing and memory overhead but slower due to Internet latency. 
  * **On-premise** - Device detection processing is performed locally using a data file that must be kept updated.
  Decide if you want [Hash or Pattern](@ref DeviceDetection_Overview_PatternVsHash). In summary, @Hash is faster than @Pattern but is less able to cope with User-Agents that have not been seen before.
    * [On-premise Pattern Example ](@ref Examples_DeviceDetection_GettingStarted_OnPremisePattern)
    * [On-premise Hash Example](@ref Examples_DeviceDetection_GettingStarted_OnPremiseHash)

### ASP.NET Core integration.

1. Install the [FiftyOne.DeviceDetection](https://www.nuget.org/packages/FiftyOne.DeviceDetection) and [FiftyOne.Pipeline.Web](https://www.nuget.org/packages/FiftyOne.Pipeline.Web) packages via Nuget.
2. Follow the [web example](@ref Examples_WebIntegration) to add the @Pipeline middleware.
3. Configure the pipeline using the configuration from the approproate example from the options below:
 * [Cloud Example](@ref Examples_DeviceDetection_ConfigureFromFile_Cloud) - Negligible processing and memory overhead but slower due to Internet latency.
 * **On-premise** - Device detection processing is performed locally using a data file that must be kept updated. Decide if you want [Hash or Pattern](@ref DeviceDetection_Overview_PatternVsHash). In summary, @Hash is faster than @Pattern but is less able to cope with User-Agents that have not been seen before.
   * [On-premise Pattern Example](@ref Examples_DeviceDetection_ConfigureFromFile_OnPremisePattern)
   * [On-premise Hash Example](@ref Examples_DeviceDetection_ConfigureFromFile_OnPremiseHash)
4. (optional) Configure [client-side evidence](@ref Features_ClientSideEvidence) to get better results. Particularly for iPhone and iPad.

### ASP.NET integration.

1. Install the [FiftyOne.DeviceDetection](https://www.nuget.org/packages/FiftyOne.DeviceDetection) and [FiftyOne.Pipeline.Web](https://www.nuget.org/packages/FiftyOne.Pipeline.Web) packages via Nuget.
2. Follow the [web example](@ref Examples_WebIntegration) to add the @Pipeline middleware.
3. Configure the pipeline using the configuration from the approproate example from the options below:
 * [Cloud Example](@ref Examples_DeviceDetection_ConfigureFromFile_Cloud) - Negligible processing and memory overhead but slower due to Internet latency.
 * **On-premise** - Device detection processing is performed locally using a data file that must be kept updated. Decide if you want [Hash or Pattern](@ref DeviceDetection_Overview_PatternVsHash). In summary, @Hash is faster than @Pattern but is less able to cope with User-Agents that have not been seen before.
   * [On-premise Pattern Example](@ref Examples_DeviceDetection_ConfigureFromFile_OnPremisePattern)
   * [On-premise Hash Example](@ref Examples_DeviceDetection_ConfigureFromFile_OnPremiseHash)
4. (optional) Configure [client-side evidence](@ref Features_ClientSideEvidence) to get better results. Particularly for iPhone and iPad.
@endsnippet
@startsnippet{java}
### Standalone pipeline / off-line processing

1. Install the [com.51degrees.pipeline.device-detection](https://search.maven.org/artifact/com.51degrees/pipeline.device-detection) package via Maven.
2. Follow the appropriate example from the options below:
  * [Cloud Example](@ref Examples_DeviceDetection_GettingStarted_Cloud) - Negligible processing and memory overhead but slower due to Internet latency. 
  * **On-premise** - Device detection processing is performed locally using a data file that must be kept updated. Decide if you want [Hash or Pattern](@ref DeviceDetection_Overview_PatternVsHash). In summary, @Hash is faster than @Pattern but is less able to cope with User-Agents that have not been seen before.
    * [On-premise Pattern Example ](@ref Examples_DeviceDetection_GettingStarted_OnPremisePattern)
    * [On-premise Hash Example](@ref Examples_DeviceDetection_GettingStarted_OnPremiseHash)
    
    
### Web servlet integration.

1. Install the [com.51degrees.pipeline.device-detection](https://search.maven.org/artifact/com.51degrees/pipeline.device-detection) and [com.51degrees.pipeline.web](https://search.maven.org/artifact/com.51degrees/pipeline.web) packages via Maven.
2. Follow the [servlet example](@ref Examples_WebIntegration) to add the @Pipeline filter.
3. Configure the pipeline using the configuration from the approproate example from the options below:
 * [Cloud Example](@ref Examples_DeviceDetection_ConfigureFromFile_Cloud) - Negligible processing and memory overhead but slower due to Internet latency.
 * **On-premise** - Device detection processing is performed locally using a data file that must be kept updated. Decide if you want [Hash or Pattern](@ref DeviceDetection_Overview_PatternVsHash). In summary, @Hash is faster than @Pattern but is less able to cope with User-Agents that have not been seen before.
   * [On-premise Pattern Example](@ref Examples_DeviceDetection_ConfigureFromFile_OnPremisePattern)
   * [On-premise Hash Example](@ref Examples_DeviceDetection_ConfigureFromFile_OnPremiseHash)
4. (optional) Configure [client-side evidence](@ref Features_ClientSideEvidence) to get better results. Particularly for iPhone and iPad.

### Spring MVC integration.

1. Install the [com.51degrees.pipeline.device-detection](https://search.maven.org/artifact/com.51degrees/pipeline.device-detection) and [com.51degrees.pipeline.web](https://search.maven.org/artifact/com.51degrees/pipeline.web) packages via Maven.
2. Follow the [Spring MVC example](@ref Examples_WebIntegration) to add the @Pipeline filter.
3. Configure the pipeline using the configuration from the approproate example from the options below:
 * [Cloud Example](@ref Examples_DeviceDetection_ConfigureFromFile_Cloud) - Negligible processing and memory overhead but slower due to Internet latency.
 * **On-premise** - Device detection processing is performed locally using a data file that must be kept updated. Decide if you want [Hash or Pattern](@ref DeviceDetection_Overview_PatternVsHash). In summary, @Hash is faster than @Pattern but is less able to cope with User-Agents that have not been seen before.
   * [On-premise Pattern Example](@ref Examples_DeviceDetection_ConfigureFromFile_OnPremisePattern)
   * [On-premise Hash Example](@ref Examples_DeviceDetection_ConfigureFromFile_OnPremiseHash)
4. (optional) Configure [client-side evidence](@ref Features_ClientSideEvidence) to get better results. Particularly for iPhone and iPad.
@endsnippet
@startsnippet{php}
### Cloud 

This implementation of device detection makes use of 51Degrees' cloud service. In PHP, the cloud version is much easier to work with than the on-premise implementation as well as having much lower memory and CPU requirements. However, it is slower due to Internet latency. If you want faster detections, you should consider on-premise. 

1. Install the [51degrees/fiftyone.devicedetection](https://packagist.org/packages/51degrees/fiftyone.devicedetection) package using Composer.
2. Follow the [Cloud Example](@ref Examples_DeviceDetection_GettingStarted_Cloud).

### On-premise

Device detection processing is performed locally using a data file that must be kept updated.
Due to the restrictions imposed by Composer and Packagist, we cannot supply the on-premise engines through the usual package management ecosystem. Instead, you'll need to clone the [repository](https://github.com/51Degrees/device-detection-php-onpremise) from GitHub and follow the instructions there in order to build and use the on-premise implementation.

One that's done, decide if you want [Hash or Pattern](@ref DeviceDetection_Overview_PatternVsHash). In summary, @Hash is faster than @Pattern but is less able to cope with User-Agents that have not been seen before.
    * [On-premise Pattern Example](@ref Examples_DeviceDetection_GettingStarted_OnPremisePattern)
    * [On-premise Hash Example](@ref Examples_DeviceDetection_GettingStarted_OnPremiseHash)
@endsnippet
@startsnippet{node}
1. Install the [fiftyone.devicedetection](https://www.npmjs.com/package/fiftyone.devicedetection) package from NPM.
2. Follow the appropriate example from the options below:  
  * [Cloud Example](@ref Examples_DeviceDetection_GettingStarted_Cloud) - Negligible processing and memory overhead but slower due to Internet latency. 
  * **On-premise** - Device detection processing is performed locally using a data file that must be kept updated.
  Decide if you want [Hash or Pattern](@ref DeviceDetection_Overview_PatternVsHash). In summary, @Hash is faster than @Pattern but is less able to cope with User-Agents that have not been seen before.
    * [On-premise Pattern Example ](@ref Examples_DeviceDetection_GettingStarted_OnPremisePattern)
    * [On-premise Hash Example](@ref Examples_DeviceDetection_GettingStarted_OnPremiseHash)
@endsnippet
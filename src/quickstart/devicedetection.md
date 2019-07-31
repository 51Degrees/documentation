@page Quickstart_DeviceDetection Device Detection - Quick Start

@startsnippets
@showsnippet{c,C}
@showsnippet{cxx,C++}
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@startsnippet{none,block}
Select a language.
@endsnippet
@startsnippet{c}
C does not have a @Pipeline implementation or the ability to use the cloud-based version of 
Device Detection.
To get started with C device detection on-premise:

1. Clone the GitHub [repository]().
2. Decide if you want [Hash or Pattern](@ref DeviceDetection_Index_PatternVsHash). In summary, @Hash is faster than @Pattern but is less able to cope with User-Agents that have not been seen before.
3. Follow the linked examples here: [Hash](@ref Examples_DeviceDetection_GettingStarted_OnPremiseHash) or 
[Pattern](@ref Examples_DeviceDetection_GettingStarted_OnPremisePattern)
4. (optional) Contact us to purchase a license key and [download]() a premium data file with access to more devices and properties.

TODO: 
- Populate links.
- Add missing steps between 1 and 2.
- Add contact details in step 3.
@endsnippet
@startsnippet{cxx}
C++ does not have a @Pipeline implementation or the ability to use the cloud-based version of 
Device Detection.
To get started with C++ device detection on-premise:

1. Clone the GitHub [repository]().
2. Decide if you want [Hash or Pattern](@ref DeviceDetection_Index_PatternVsHash). In summary, @Hash is faster than @Pattern but is less able to cope with User-Agents that have not been seen before.
3. Follow the linked examples here: [Hash](@ref Examples_DeviceDetection_GettingStarted_OnPremiseHash) or 
[Pattern](@ref Examples_DeviceDetection_GettingStarted_OnPremisePattern)
4. (optional) Contact us to purchase a license key and [download]() a premium data file with access to more devices and properties.


TODO: 
- Populate links.
- Add missing steps between 1 and 2.
- Add contact details in step 3.
@endsnippet
@startsnippet{dotnet}
### Standalone pipeline / off-line processing

1. Install the FiftyOne.DeviceDetection package via Nuget.
2. Follow the appropriate example from the options below:  
  * [Cloud Example](@ref Examples_DeviceDetection_GettingStarted_Cloud) - Negligible processing and memory overhead but slower due to Internet latency. 
  * **On-premise** - Device detection processing is performed locally using a data file that must be kept updated.
  Decide if you want [Hash or Pattern](@ref DeviceDetection_Index_PatternVsHash). In summary, @Hash is faster than @Pattern but is less able to cope with User-Agents that have not been seen before.
    * [On-premise Pattern Example ](@ref Examples_DeviceDetection_GettingStarted_OnPremisePattern)
    * [On-premise Hash Example](@ref Examples_DeviceDetection_GettingStarted_OnPremiseHash)

### ASP.NET Core integration.

1. Install the FiftyOne.DeviceDetection and FiftyOne.Pipeline.Web packages via Nuget.
2. Follow the appropriate example from the options below:  
 * [Cloud Example](@ref Examples_DeviceDetection_GettingStarted_Cloud) - Negligible processing and memory overhead but slower due to Internet latency.
 * **On-premise** - Device detection processing is performed locally using a data file that must be kept updated. Decide if you want [Hash or Pattern](@ref DeviceDetection_Index_PatternVsHash). In summary, @Hash is faster than @Pattern but is less able to cope with User-Agents that have not been seen before.
   * [On-premise Pattern Example ](@ref Examples_DeviceDetection_GettingStarted_OnPremisePattern)
   * [On-premise Hash Example](@ref Examples_DeviceDetection_GettingStarted_OnPremiseHash)
3. (optional) Configure [client-side evidence](@ref) to get better results. Particularly for iPhone and iPad.

### ASP.NET integration.

1. Install the FiftyOne.DeviceDetection and FiftyOne.Pipeline.Web packages via Nuget.
2. Follow the appropriate example from the options below:  
  * [Cloud Example](@ref Examples_DeviceDetection_GettingStarted_Cloud) - Negligible processing and memory overhead but slower due to Internet latency. 
  * **On-premise** - Device detection processing is performed locally using a data file that must be kept updated. Decide if you want [Hash or Pattern](@ref DeviceDetection_Index_PatternVsHash). In summary, @Hash is faster than @Pattern but is less able to cope with User-Agents that have not been seen before.
    * [On-premise Pattern Example ](@ref Examples_DeviceDetection_GettingStarted_OnPremisePattern)
    * [On-premise Hash Example](@ref Examples_DeviceDetection_GettingStarted_OnPremiseHash)
  
3. (optional) Configure [client-side evidence](@ref) to get better results. Particularly for iPhone and iPad.
@endsnippet
@startsnippet{java}
### Standalone pipeline / off-line processing

1. Install the com.51degrees.device-detection package via Maven.
2. Follow the appropriate example from the options below:
  * [Cloud Example](@ref Examples_DeviceDetection_GettingStarted_Cloud) - Negligible processing and memory overhead but slower due to Internet latency. 
  * **On-premise** - Device detection processing is performed locally using a data file that must be kept updated. Decide if you want [Hash or Pattern](@ref DeviceDetection_Index_PatternVsHash). In summary, @Hash is faster than @Pattern but is less able to cope with User-Agents that have not been seen before.
    * [On-premise Pattern Example ](@ref Examples_DeviceDetection_GettingStarted_OnPremisePattern)
    * [On-premise Hash Example](@ref Examples_DeviceDetection_GettingStarted_OnPremiseHash)
    
    
### Web servlet integration.

1. Install the com.51degrees.device-detection and com.51degrees.pipeline.web packages via Maven.
2. Follow the appropriate example from the options below:  
  * [Cloud Example](@ref Examples_DeviceDetection_GettingStarted_Cloud) - Negligible processing and memory overhead but slower due to Internet latency. 
  * **On-premise** - Device detection processing is performed locally using a data file that must be kept updated. Decide if you want [Hash or Pattern](@ref DeviceDetection_Index_PatternVsHash). In summary, @Hash is faster than @Pattern but is less able to cope with User-Agents that have not been seen before.
    * [On-premise Pattern Example ](@ref Examples_DeviceDetection_GettingStarted_OnPremisePattern)
    * [On-premise Hash Example](@ref Examples_DeviceDetection_GettingStarted_OnPremiseHash)
3. (optional) Configure [client-side evidence](@ref) to get better results. Particularly for iPhone and iPad.

### Spring MVC integration.

1. Install the com.51degrees.device-detection and com.51degrees.web.mvc packages via Maven.
2. Follow the appropriate example from the options below:  
  * [Cloud Example](@ref Examples_DeviceDetection_GettingStarted_Cloud) - Negligible processing and memory overhead but slower due to Internet latency. 
  * **On-premise** - Device detection processing is performed locally using a data file that must be kept updated. Decide if you want [Hash or Pattern](@ref DeviceDetection_Index_PatternVsHash). In summary, @Hash is faster than @Pattern but is less able to cope with User-Agents that have not been seen before.
    * [On-premise Pattern Example ](@ref Examples_DeviceDetection_GettingStarted_OnPremisePattern)
    * [On-premise Hash Example](@ref Examples_DeviceDetection_GettingStarted_OnPremiseHash)
3. (optional) Configure [client-side evidence](@ref) to get better results. Particularly for iPhone and iPad.
@endsnippet
@startsnippet{php}
@endsnippet
@startsnippet{node}
@endsnippet
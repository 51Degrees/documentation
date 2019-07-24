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
2. Decide if you want [hash]() or [pattern](). Hash has better performance but is less able to cope with User-Agents that have not been seen before.
3. (optional) Contact us to purchase a license key and [download]() a premium data file with access to more devices and properties.

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
2. Decide if you want [hash](@ref Examples_DeviceDetection_GettingStarted_OnPremiseHash) or 
[pattern](@ref Examples_DeviceDetection_GettingStarted_OnPremisePattern) and follow the linked examples. Hash has better performance but is 
less able to cope with @evidence values that have not been seen before.
3. (optional) Contact us to purchase a license key and [download]() a premium data file with access to more devices and properties.

TODO: 
- Populate links.
- Add missing steps between 1 and 2.
- Add contact details in step 3.
@endsnippet
@startsnippet{dotnet}
### Standalone pipeline / off-line processing

1. Install the FiftyOne.DeviceDetection package via Nuget.
2. Follow the appropriate example from the options below:  
  * [Cloud](@ref Examples_DeviceDetection_GettingStarted_Cloud) - Negligible processing and memory overhead but slower due to Internet latency. 
  * On-premise 
  * [On-premise Pattern](@ref Examples_DeviceDetection_GettingStarted_OnPremisePattern) - Device detection processing is performed locally using 
  a data file that must be kept updated. Pattern is not as fast as Hash but is better able to
  cope with @evidence values that have not been seen before.
  * [On-premise Hash](@ref Examples_DeviceDetection_GettingStarted_OnPremiseHash) - Device detection processing is performed locally using 
  a data file that must be kept updated. Hash is faster than Pattern but is less able to cope 
  with @evidence values that have not been seen before.

### ASP.NET Core integration.

1. Install the FiftyOne.DeviceDetection and FiftyOne.Pipeline.Web packages via Nuget.
2. Follow the appropriate example from the options below:  
  * [Cloud](@ref Examples_DeviceDetection_GettingStarted_Cloud) - Parameters are passed to the 51Degrees cloud service, which performs device 
  detection processing and returns the properties you need.
  * [On-premise Pattern](@ref Examples_DeviceDetection_GettingStarted_OnPremisePattern) - Device detection processing is performed locally using 
  a data file that must be kept updated. Pattern is not as fast as Hash but is better able to
  cope with @evidence values that have not been seen before.
  * [On-premise Hash](@ref Examples_DeviceDetection_GettingStarted_OnPremiseHash) - Device detection processing is performed locally using 
  a data file that must be kept updated. Hash is faster than Pattern but is less able to cope 
  with @evidence values that have not been seen before.
3. (optional) Configure [client-side evidence](@ref) to get better results. Particularly for iPhone and iPad.

### ASP.NET integration.

1. Install the FiftyOne.DeviceDetection and FiftyOne.Pipeline.Web packages via Nuget.
2. Follow the appropriate example from the options below:  
  * [Cloud](@ref Examples_DeviceDetection_GettingStarted_Cloud) - Parameters are passed to the 51Degrees cloud service, which performs device 
  detection processing and returns the properties you need.
  * [On-premise Pattern](@ref Examples_DeviceDetection_GettingStarted_OnPremisePattern) - Device detection processing is performed locally using 
  a data file that must be kept updated. Pattern is not as fast as Hash but is better able to
  cope with @evidence values that have not been seen before.
  * [On-premise Hash](@ref Examples_DeviceDetection_GettingStarted_OnPremiseHash) - Device detection processing is performed locally using 
  a data file that must be kept updated. Hash is faster than Pattern but is less able to cope 
  with @evidence values that have not been seen before.
3. (optional) Configure [client-side evidence](@ref) to get better results. Particularly for iPhone and iPad.
@endsnippet
@startsnippet{java}
@endsnippet
@startsnippet{php}
@endsnippet
@startsnippet{node}
@endsnippet
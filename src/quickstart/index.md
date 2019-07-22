@page Quickstart_Index Quick Start

# Introduction

This guide aims to give you everything you need to get up and running with whatever services 
you need as soon as possible.

# Client-Side JavaScript

TODO: Add link to configurator.

If you intend to use client-side JavaScript only then you can use the 51Degrees cloud 
[Configurator](@ref) 
to select the properties you need and build a custom JavaScript snippet to include in your
web page.

# Server-Side and Off-line Processing

We have getting started examples for each of the languages supported and services provided
by the @Pipeline.
Use the sections below to find the relevant example for you.

## Device Detection

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
2. Decide if you want [hash]() or [pattern]() and follow the linked examples. Hash has better performance but is 
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
  * [Cloud](@ref ) - Parameters are passed to the 51Degrees cloud service, which performs device 
  detection processing and returns the properties you need.
  * [On-premise Pattern](@ref) - Device detection processing is performed locally using 
  a data file that must be kept updated. Pattern is not as fast as Hash but is better able to
  cope with @evidence values that have not been seen before.
  * [On-premise Hash](@ref) - Device detection processing is performed locally using 
  a data file that must be kept updated. Hash is faster than Pattern but is less able to cope 
  with @evidence values that have not been seen before.

### ASP.NET Core integration.

1. Install the FiftyOne.DeviceDetection and FiftyOne.Pipeline.Web packages via Nuget.
2. Follow the appropriate example from the options below:  
  * [Cloud](@ref ) - Parameters are passed to the 51Degrees cloud service, which performs device 
  detection processing and returns the properties you need.
  * [On-premise Pattern](@ref) - Device detection processing is performed locally using 
  a data file that must be kept updated. Pattern is not as fast as Hash but is better able to
  cope with @evidence values that have not been seen before.
  * [On-premise Hash](@ref) - Device detection processing is performed locally using 
  a data file that must be kept updated. Hash is faster than Pattern but is less able to cope 
  with @evidence values that have not been seen before.
3. (optional) Configure [client-side evidence](@ref) to get better results. Particularly for iPhone and iPad.

### ASP.NET integration.

1. Install the FiftyOne.DeviceDetection and FiftyOne.Pipeline.Web packages via Nuget.
2. Follow the appropriate example from the options below:  
  * [Cloud](@ref ) - Parameters are passed to the 51Degrees cloud service, which performs device 
  detection processing and returns the properties you need.
  * [On-premise Pattern](@ref) - Device detection processing is performed locally using 
  a data file that must be kept updated. Pattern is not as fast as Hash but is better able to
  cope with @evidence values that have not been seen before.
  * [On-premise Hash](@ref) - Device detection processing is performed locally using 
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

## Geo-Location

## IP Intelligence

## Fraud Detection
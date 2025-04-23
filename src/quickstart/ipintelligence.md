@page Quickstart_IpIntelligence IP Intelligence Quick Start

@startsnippets
@showsnippet{c,C}
@showsnippet{cxx,C++}
@showsnippet{dotnet,C#}
@defaultsnippet{Select a language.}
@startsnippet{c}
C does not have a @Pipeline implementation or the ability to use the cloud-based version of 
IP intelligence.
To get started with C IP intelligence on-premise:

1. Clone the GitHub [repository](https://github.com/51degrees/ip-intelligence-cxx).
2. Ensure you have [Git LFS](https://git-lfs.github.com/) installed. The device data files are large binary files that can cause problems if stored in a Git repository directly, so Git LFS is used.
3. Ensure all submodules are checked out by running `git submodule update --init --recursive` in the repository.
4. Follow the [installation instructions](https://github.com/51Degrees/ip-intelligence-cxx/blob/main/README%2Emd) to get set up with the project. <!-- TODO use ref and tagfile so this is not hardcoded -->
5. Follow the linked example here: [Getting Started](@ref Examples_IpIntelligence_GettingStarted_Console_OnPremise).
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
6. Follow the linked example here: [Getting Started](@ref Examples_IpIntelligence_GettingStarted_Console_OnPremise).
7. (optional) Obtain a License Key by purchasing a subscription and download a data file with access to more devices and properties, see our [pricing page](https://51degrees.com/pricing) for details.

@endsnippet
@startsnippet{dotnet}
### Standalone pipeline / off-line processing

1. Install the [FiftyOne.IpIntelligence](https://www.nuget.org/packages/FiftyOne.IpIntelligence) package via Nuget.
2. Follow the appropriate example from the options below:  
  * [On-Premise Example](@ref Examples_IpIntelligence_GettingStarted_Console_OnPremise) - IP intelligence processing is performed locally using a data file that must be kept updated.

### ASP.NET Core integration.

1. Install the [FiftyOne.IpIntelligence](https://www.nuget.org/packages/FiftyOne.IpIntelligence) and [FiftyOne.Pipeline.Web](https://www.nuget.org/packages/FiftyOne.Pipeline.Web) packages via Nuget.
2. Follow the [web example](@ref Examples_WebIntegration) to add the @Pipeline middleware.
3. Configure the pipeline using the configuration from the appropriate example from the options below:
 * [On-Premise Example](@ref Examples_IpIntelligence_GettingStarted_Console_OnPremise) - IP intelligence processing is performed locally using a data file that must be kept updated.

@endsnippet

@page DeviceDetection_Index Device Detection

# Introduction

Device detection allows you to discover many facts related to the device that is being used 
to access you content.
This includes details relating to the hardware, operating system and browser being used.

Follow the [quick start guide](@ref Quickstart_DeviceDetection) to get up and running as soon as possible.

# How Device Detection Works

Primarily, 51Degrees device detection solutions focus on the User-Agent HTTP header. However, over time
more complexity has been introduced for multiple reasons:

* Apple purposefully obfuscate the hardware model in the User-Agent. We use 
[various techniques](https://51degrees.com/blog/multi-stage-approach-to-apple-ios-device-detection) to overcome this. 
* Browsers that perform [transcoding](@https://en.wikipedia.org/wiki/Mobile_browser#Mobile_HTML_transcoders) will 
generally replace the content of the User-Agent with something else. The real User-Agent may or may not be sent 
in a separate header.
* Although the User-Agent can tell us a lot about the hardware and software being used, more details can often
be obtained by scripts running on the client device.

51Degrees have two separate algorithms that can be used to perform device detection, 'Pattern' and 'Hash'. 
These have differently formatted data files and use different methods to determine matches between the supplied 
User-Agent and an entry in the lists of possible devices. Each has it's own strengths and weaknesses.

|| Pattern | Hash |
|---|---|---|
|Performance|[Fast](@ref Benchmarks_DeviceDetection)|[Fastest](@ref Benchmarks_DeviceDetection)|
|Approx. data file size (uncompressed)| 150Mb (Lite) - 400Mb (Enterprise)| 200Mb |
|Adaptability (i.e. ability to cope with<br>User-Agents that were not in the<br>source data)|Best|[Configurable](@ref DeviceDetection_Hash_PredictivePower)|

For more detail on exactly how each algorithm works, follow the links below:

- @subpage DeviceDetection_Pattern
- @subpage DeviceDetection_Hash

# Migrating from other Providers

Due to an increasing number of customers migrating from other device detection platforms we 
have introduced a @subpage DeviceDetection_MigrationGuides_Index "migration guide" that helps customers 
switch properties or capabilities used on other platforms to 51Degrees device properties. 


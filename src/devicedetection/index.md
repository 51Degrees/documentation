@page DeviceDetection_Index Device Detection

# Introduction

By providing information on the type and capabilities of the device, operating system and browser being used to access your website, **device detection** enables you to provide your users with the optimal online experience, whether they're using a smartphone, tablet, TV, feature phone or a large screen desktop or laptop computer. 


If you're ready to get going with **device detection**, follow the [quick start guide](@ref Quickstart_DeviceDetection) to get you up and running with just a few clicks - or if you'd like to know more about how our solution works and some of its benefits over others', then carry on reading below.

# How Device Detection Works

Primarily, 51Degrees device detection solutions focus on the User-Agent HTTP header to identify a device. However, over time
we have introduced greater complexity which does not rely solely on the User-Agent string and enables us to return improved results for the following use cases:

* Apple purposefully obfuscate the hardware model in the User-Agent. We use 
[various techniques](https://51degrees.com/blog/multi-stage-approach-to-apple-ios-device-detection) to overcome this. 
* Browsers that perform [transcoding](https://en.wikipedia.org/wiki/Mobile_browser#Mobile_HTML_transcoders) will 
generally replace the content of the User-Agent with something else. The real User-Agent may or may not be sent 
in a separate header.
* Although the User-Agent can tell us a lot about the hardware and software being used, further information can often
be obtained by scripts running on the client device.

## Pattern vs Hash Algorithms @anchor DeviceDetection_Index_PatternVsHash

51Degrees have two separate algorithms which can be used to perform device detection, 'Pattern' and 'Hash'. 

These use differently formatted data files and employ different methods to determine matches between the supplied 
User-Agent and the data file. Each method has its own strengths and weaknesses.

|| Pattern | Hash |
|---|---|---|
|Performance|[Fast](@ref Benchmarks_DeviceDetection)|[Fastest](@ref Benchmarks_DeviceDetection)|
|Approx. data file size (uncompressed)| 150Mb (Lite) - 400Mb (Enterprise)| 200Mb (all file variants) |
|Adaptability (i.e. ability to cope with<br>User-Agents that are not in the<br>source data file)|Best|[Configurable](@ref DeviceDetection_Hash_PredictivePower)|

For more detail on how each algorithm works, follow the links below:

- @subpage DeviceDetection_Pattern
- @subpage DeviceDetection_Hash

# Migrating from an Older Version or Other Providers

If you're already using 51Degrees' v3 device detection API, or a device detection solution from an alternative provider and are considering switching to 51Degrees, we have a number of @subpage DeviceDetection_MigrationGuides_Index showing how our properties and capabilities map to others'.



@page DeviceDetection_Index Device Detection

# Introduction

By providing information on the type and capabilities of the device (plus the operating system and browser being used) being used to access your website, **device detection** enables you to provide your users with the optimal online experience, whether they're using a smartphone, tablet, TV, feature phone or a large screen desktop or laptop computer. 


Follow the [quick start guide](@ref Quickstart_DeviceDetection) to get up and running as soon as possible.

# How Device Detection Works

Primarily, 51Degrees device detection solutions focus on the User-Agent HTTP header to identify a device. However, over time
further complexity has been introduced in order to address the evolving nature of web traffic and improve the results returned.

* Apple purposefully obfuscate the hardware model in the User-Agent. We use 
[various techniques](https://51degrees.com/blog/multi-stage-approach-to-apple-ios-device-detection) to overcome this. 
* Browsers that perform [transcoding](@https://en.wikipedia.org/wiki/Mobile_browser#Mobile_HTML_transcoders) will 
generally replace the content of the User-Agent with something else. The real User-Agent may or may not be sent 
in a separate header.
* Although the User-Agent can tell us a lot about the hardware and software being used, further information can often
be obtained by scripts running on the client device.

51Degrees have two separate algorithms that can be used to perform device detection, 'Pattern' and 'Hash'. 
These use differently formatted data files and employ different methods to determine matches between the supplied 
User-Agent and an entry in the lists of possible devices. Each method has its own strengths and weaknesses.

|| Pattern | Hash |
|---|---|---|
|Performance|[Fast](@ref Benchmarks_DeviceDetection)|[Fastest](@ref Benchmarks_DeviceDetection)|
|Approx. data file size (uncompressed)| 150Mb (Lite) - 400Mb (Enterprise)| 200Mb |
|Adaptability (i.e. ability to cope with<br>User-Agents that are not in the<br>source data file)|Best|[Configurable](@ref DeviceDetection_Hash_PredictivePower)|

For more detail on how each algorithm works, follow the links below:

- @subpage DeviceDetection_Pattern
- @subpage DeviceDetection_Hash

# Migrating from Other Providers

Due to an increasing number of customers migrating from other device detection platforms we 
have introduced a @subpage DeviceDetection_MigrationGuides_Index "migration guide" to help customers 
switch properties or capabilities used by other platforms to 51Degrees device properties. 


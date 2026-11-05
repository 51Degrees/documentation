@page DeviceDetection_Features_PerformanceOptions Performance Options

# Introduction

Device detection has tradeoffs between speed, memory use, and tolerance for unfamiliar evidence.

Use the options below to configure Device Detection for your workload.

These options apply to on-premise detection. The cloud service offers fewer performance controls.

# Performance profile templates

At the low level, the Device Detection API uses various collections of data from the data file in order to perform detections.
These collections may either be fully mapped into memory or accessed via highly optimized [LRU caches](https://en.wikipedia.org/wiki/Cache_replacement_policies#Least_recently_used_(LRU)), with data being loaded from disk on a cache miss.

The mechanism used to access the data, as well as the size of these caches, can be configured specifically. However, we have defined templates which we believe will cover the majority of scenarios.

How you select a template depends on your programming language. See the [performance examples](@ref DeviceDetection_Examples_Performance_OnPremiseHash).

The table below explains the options, from fastest performance and highest memory usage to slowest performance and lowest memory usage.

| Template Name | Behavior | Recommendations |
|---|---|---|
|MaxPerformance|All data from the data file is mapped into main memory at startup. As caches are not needed, data access is lock-free. | Use when memory usage is not a problem and performance is critical. This configuration is also strongly recommended when the API is running in a highly concurrent environment. |
|HighPerformance|Data is accessed through caches large enough to hold the entire data file as it is requested over time.|Generally not recommended. It is slightly slower than MaxPerformance and grows to the same memory use over time. It can be a starting point for a custom configuration.|
|Balanced (Default)|Data is accessed through caches, some smaller than those in HighPerformance. Frequently used items stay in memory, so disk reads are relatively uncommon for a typical web server workload.|Use for general workloads without extreme memory or performance requirements.|
|LowMemory|Data always streamed from disk on-demand. | Recommended when the lowest possible memory usage is more important than performance. |

The precise values associated with each template can be seen in the source code on [GitHub](https://github.com/51Degrees/51degrees-cxx/blob/67503df045efb32e84eb59fe7e320772dd6475db/src/hash/hash.c#L177).

We measured throughput, startup time, and memory for Device Detection on seven machines, with the data file held in memory and with `Balanced`. The results are in the [hardware benchmarks](@ref ProductSummaries_Benchmarks_Hardware).

# Evaluation graphs

In version 4.5 and later, device detection uses a single predictive graph.

# Property Indexing

A configuration option `propertyValueIndex` is available (introduced in version 4.5). 
When enabled (set to `true`), the engine indexes property values at startup.

This improves the speed of property retrieval, which is particularly beneficial for applications that need to access a large number of properties for each detection. It ensures more consistent performance in high-scale environments.

# Restrict properties

When the device detection engine is created, you can specify exactly which properties you want 
to be populated in the result.
By default, all properties are populated. By limiting the properties to only those that you're 
actually going to use, performance may be significantly improved.

Internally, detection is actually performed separately for each **component** (The four components 
associated with device detection are hardware, operating system, browser, and crawler)
This means that if you only want 'IsMobile' and 'HardwareName', which are both hardware properties, 
then the algorithm can skip the detection for operating system, browser, and crawler.

For example, on an eight-core AWS Graviton3 instance with the data file held in memory, requesting
only `IsMobile` gave 1,362,952 detections per second. One property from each of the four components
gave 306,275, and every property gave 166,181. The [hardware benchmarks](@ref ProductSummaries_Benchmarks_Hardware)
have the same comparison for the other machines.

As with all the performance options, we recommend experimenting to see what effect this has in 
your specific scenario. See the [performance examples](@ref DeviceDetection_Examples_Performance_OnPremiseHash)
for a demonstration of how to specify the properties you want in your language of choice.

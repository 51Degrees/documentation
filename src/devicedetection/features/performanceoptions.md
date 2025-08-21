@page DeviceDetection_Features_PerformanceOptions Performance Options

# Introduction

For device detection, as with many computing tasks, there are trade-offs to be made between the performance of the algorithm and memory usage, as well as performance vs adaptability.

Rather than trying to solve this with a one-size-fits-all approach, our Device Detection API allows you to easily configure the solution to suit your requirements.

Be aware that all these options only apply to the On-premise implementation. The cloud solution is
inherently far more limited in the range of options you have to adjust performance.

# Performance profile templates

At the low level, the Device Detection API uses various collections of data from the data file in order to perform detections.
These collections may either be fully mapped into memory or accessed via highly optimized [LRU caches](https://en.wikipedia.org/wiki/Cache_replacement_policies#Least_recently_used_(LRU)), with data being loaded from disk on a cache miss.

The mechanism used to access the data, as well as the size of these caches, can be configured specifically. However, we have defined templates which we believe will cover the majority of scenarios.

The exact method for specifying the template will vary by programing language. See the [performance examples](@ref DeviceDetection_Examples_Performance_OnPremiseHash) for a demonstration.

The table below explains the options, from fastest performance and highest memory usage to slowest performance and lowest memory usage.

| Template Name | Behavior | Recommendations |
|---|---|---|
|MaxPerformance|All data from the data file is mapped into main memory at startup. As caches are not needed, data access is lock-free. | Use when memory usage is not a problem and performance is critical. This configuration is also strongly recommended when the API is running in a highly concurrent environment. |
|HighPerformance|Data accessed via caches; caches are large enough that all data from the data file can be accommodated as it is requested over time. |Generally not recommended. It offers slightly worse performance than MaxPerformance but will grow to the same memory usage over time. Can be useful as a starting point when creating a custom configuration. |
|Balanced (Default)|Data accessed via caches; some caches are smaller than the high performance template. However, there is enough space that the most commonly accessed items are retained in memory. As such, loading from the disk is still relatively uncommon (assuming a typical web server workload). |Fine for generic workloads where there is no extreme memory or performance requirement. |
|LowMemory|Data always streamed from disk on-demand. | Recommended when the lowest possible memory usage is more important than performance. |

The precise values associated with each template can be seen in the source code on [GitHub](https://github.com/51Degrees/device-detection-cxx/blob/67503df045efb32e84eb59fe7e320772dd6475db/src/hash/hash.c#L177).

# Evaluation graphs

The hash data file includes two different 'graphs' that can be used when trying to find a match, [performance](@ref DeviceDetection_Hash_DataSetProduction_Performance) and [predictive](@ref DeviceDetection_Hash_DataSetProduction_Predictive).

The performance graph is significantly faster than predictive, but is less tolerant of differences between the training data and the evaluated User-Agent.

This means that the performance graph is generally recommended when fast matching is the primary concern and the data file is regularly and frequently updated.

In comparison, the predictive graph is recommended when getting an accurate match for every request is the primary concern, particularly when User-Agents are frequently encountered that are not in the training data.

Note that if both graphs are enabled, performance will be used first. Predictive will only then be used if the algorithm fails to find a match with the performance graph.

The default graph options are defined by the performance templates described above. At time of writing, all templates enable predictive and disable performance.
This is done in order to maximize accuracy and ensure consistent device detection results between the profiles.

# Restrict properties

When the device detection engine is created, you can specify exactly which properties you want 
to be populated in the result.
By default, all properties are populated. By limiting the properties to only those that you're 
actually going to use, performance may be significantly improved.

Internally, detection is actually performed separately for each **component** (The four components 
associated with device detection are hardware, operating system, browser, and crawler)
This means that if you only want 'IsMobile' and 'HardwareName', which are both hardware properties, 
then the algorithm can skip the detection for operating system, browser, and crawler.

As with all the performance options, we recommend experimenting to see what effect this has in 
your specific scenario. See the [performance examples](@ref DeviceDetection_Examples_Performance_OnPremiseHash)
for a demonstration of how to specify the properties you want in your language of choice.

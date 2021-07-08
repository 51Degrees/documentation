@page DeviceDetection_Features_PerformanceOptions Performance Options

# Introduction

For device detection, as with many computing tasks, there are tradeoffs to be made between the performance of the algorithm and memory usage, as well as performance vs adaptability.

Rather than trying to solve this with a one-size-fits-all approach, our device detection API allows you to easily configure the solution to suit your requirements.

# Performance Profile Templates

At the low level, the device detection API uses various collections of data from the data file in order to perform detections.
These collections may either be fully mapped into memory or accessed via highly optimized [LRU caches](https://en.wikipedia.org/wiki/Cache_replacement_policies#Least_recently_used_(LRU)), with data being loaded from disk on a cache miss.

The mechanism used to access the data, as well as the size of these caches, can be configured specifically. However, we have defined templates which we believe will cover the majority of scenarios.

The exact method for specifying the template will vary by programing language. See the [performance examples](@ref Examples_DeviceDetection_Performance_OnPremiseHash) for a demonstration.

The table below explains the options, from fastest performance, highest memory usage to slowest performance and lowest memory usage.

| Template Name | Behavior | Recommended when |
|---|---|---|
|MaxPerformance|All data from the data file is mapped into main memory at startup. As caches are not needed, data access is lock-free| Performance is critical and/or the API is running in a highly concurrent environment|
|HighPerformance|Data accessed via caches, caches are large enough that all data from the data file can be accommodated as it is requested over time | tbc|
|Balanced (Default)|Data accessed via caches, some caches are smaller than the high performance template. However, there is enough space that the most commonly accessed items are retained in memory. As such, loading from the disk is still relatively uncommon (assuming a typical web server workload) |There is no extreme memory or performance requirement|
|LowMemory|Data always streamed from disk on-demand. Memory footprint is as low as possible| Having a very low memory overhead is more important than performance |

The precise values associated with each template can be seen in source on [GitHub](https://github.com/51Degrees/device-detection-cxx/blob/67503df045efb32e84eb59fe7e320772dd6475db/src/hash/hash.c#L177).

# Evaluation graphs

The hash data file includes 2 different 'graphs' that can be used when trying to find a match, [performance](@ref DeviceDetection_Hash_DataSetProduction_Performance) and [predictive](@ref DeviceDetection_Hash_DataSetProduction_Predictive).

The performance graph is significantly faster than predictive, but is less tolerant of differences between the training data and the evaluated user-agent.

This means that the performance graph is generally recommended when fast matching is the primary concern and the data file is regularly and frequently updated.

In comparison, the predictive graph is recommended when getting an accurate match for every request is the primary concern, particularly when user-agents are frequently encountered that are not in the training data.

Note that if both graphs are enabled, performance will be used first. Predictive will only be used if the algorithm fails to find a match with the performance graph.


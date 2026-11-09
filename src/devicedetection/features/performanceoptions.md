@page DeviceDetection_Features_PerformanceOptions Performance options

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
|HighPerformance|Every collection is loaded into main memory at startup, each one separately rather than the data file as a single block, so no caches are used. When you name some but not all of the properties, only the values those properties read, and the text those values use, are loaded. The rest of the values and text stays in the data file.|Use when you request a few properties and want lookups at in-memory speed. Name the properties you use. For Device Detection it saves less memory, as [Choosing a profile](#choosing-a-profile) explains.|
|Balanced (Default)|Some collections are loaded into memory at startup and the rest are read through caches of a fixed size. Frequently used items stay in memory, so disk reads are relatively uncommon for a typical web server workload.|Use for general workloads without extreme memory or performance requirements.|
|LowMemory|Data always streamed from disk on-demand. | Recommended when the lowest possible memory usage is more important than performance. |

The default is `Balanced`, except for the engine PHP builds when it starts. That engine is built from the php.ini file and always uses `MaxPerformance`, and any other profile set in the php.ini file is refused. PHP usually serves requests from worker processes copied from the process that built the engine. With a profile that reads from the data file, those workers would share one open data file and its read position, and corrupt each other's reads.

The precise values associated with each template can be seen in the source code on GitHub, for [Device Detection](https://github.com/51Degrees/51degrees-cxx/blob/cf087785f81f1d99fbdecc79eee0b01806b42125/src/dd/hash/hash.c#L307-L401) and for [IP Intelligence](https://github.com/51Degrees/51degrees-cxx/blob/cf087785f81f1d99fbdecc79eee0b01806b42125/src/ipi/ipi.c#L192-L290).

We measured throughput, startup time, and memory for Device Detection on seven machines, with the data file held in memory and with `Balanced`. The results are in the [hardware benchmarks](@ref ProductSummaries_Benchmarks_Hardware).

# Choosing a profile {#choosing-a-profile}

Start with `Balanced`, the default. Change it when your service matches one of these.

- **Memory is plentiful and every lookup must be as fast as possible.** Use `MaxPerformance`. It never waits on a lock, so it suits services that run lookups on many threads at once.
- **You request every property, or most of them.** Use `MaxPerformance`. `Balanced` reads values through its caches, which is slow when every property is read. On an AWS Graviton3 instance (c7g.2xlarge), Device Detection gave 166,181 detections a second in memory with every property, against 3,374 with `Balanced`.
- **You request a few properties and want in-memory speed with less memory.** Use `HighPerformance` and name the properties you use. This makes the biggest difference to IP Intelligence, described below. For Device Detection, every profile and every part of the detection graph is still loaded, so naming properties saves less. With two properties named, the TAC data file took 86 MB rather than 110 MB, and the free Lite data file barely changed at 38 MB ([measurements](https://github.com/51Degrees/51degrees-cxx/pull/135)).
- **The data file sits in a shared network location.** Use `MaxPerformance`, so that lookups never read the file across the network. See [automatic data file updates](@ref PipelineApi_Features_AutomaticDatafileUpdates).
- **Memory is the limit.** Use `LowMemory`, for example in a small container, or for the Enterprise IP Intelligence data file, which takes over 6 GB in memory, on a machine without that much to spare. It's the slowest profile, because every lookup reads the data file.

Profiles that read from the data file share a pool of open file handles between threads. See [concurrent processing](@ref DeviceDetection_Features_ConcurrentProcessing) for how to size it.

# IP Intelligence profiles {#ip-intelligence-profiles}

IP Intelligence uses the same profiles, with two differences in what they hold.

- `HighPerformance` loads only the parts of the data file that the named properties read. Those are the IP address graphs and profiles of the properties' components, the properties' values, and the text those values use. Everything else stays in the data file, and a lookup of the named properties reads nothing from it.
- `Balanced` holds the text, the IP address graphs and the default value of each requested property in memory, and reads values and profiles through caches. Naming properties doesn't change what it holds.

These figures were measured with the Enterprise data file of 4 November 2026, on one thread on Linux, over 400,000 lookups of 20,000 addresses. A microsecond (µs) is a millionth of a second.

| Properties requested | HighPerformance memory | HighPerformance time a lookup | Balanced memory | Balanced time a lookup |
|---|---:|---:|---:|---:|
| Every property | 6,356 MB | 15.89 µs | 2,242 MB | 20.68 µs |
| The 40 properties of the location component | 5,367 MB | 5.60 µs | 2,242 MB | 7.70 µs |
| `Asn` and `AsnName` | 116 MB | 1.42 µs | 2,242 MB | 1.27 µs |

Naming the properties of one component alone takes from 0.6 MB, for `IsTor`, to 11.7 MB, for `IsProxy`, with `HighPerformance`. The full results are in the [measurements](https://github.com/51Degrees/51degrees-cxx/pull/114).

So for IP Intelligence:

- With a few properties, use `HighPerformance` and name them. It takes a small part of the memory `Balanced` takes, at about the same speed.
- With many properties, `HighPerformance` holds most of the data file. Use `Balanced` to keep memory down, or `MaxPerformance` for the fastest lookups.

`Balanced` did well in these runs because its caches held almost every value and profile that 20,000 addresses read. Real traffic has many more addresses, so `Balanced` will read the data file more often than it did here.

# Evaluation graphs

In version 4.5 and later, device detection uses a single predictive graph.

# Property indexing

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

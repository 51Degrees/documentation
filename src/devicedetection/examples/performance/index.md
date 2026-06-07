@page DeviceDetection_Examples_Performance_Index Performance

# Introduction

The Performance examples measure how fast the 51Degrees @devicedetection engine
processes evidence (User-Agents and [User-Agent Client Hints](@ref DeviceDetection_Features_UACH_Overview))
on your own hardware. They run a tight loop over a fixed set of User-Agent
strings, count detections per second, and report mean and p99 latencies, so you
can size capacity, validate tuning changes, and compare deployment models on
the platform you actually run.

The companion @ref DeviceDetection_Features_PerformanceOptions page describes
the configuration knobs that drive throughput and memory: the
**Performance Profile** (`LowMemory`, `Balanced`, `HighPerformance`, `MaxPerformance`),
how the data file is loaded, and the size of the property and value caches.
Pick a profile, run the example, and use the numbers to decide whether to
trade memory for throughput on your target hosts. The example covers the
On-premise Hash engine — Cloud performance is dominated by network round-trip
and is not benchmarked here.

The example ships for C, C# (.NET), Java, Node.js, and Python with matching
shape, so the same workload can be measured across runtimes.

@subpage DeviceDetection_Examples_Performance_OnPremiseHash

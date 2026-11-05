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
on-premise Hash engine. Cloud performance depends on network round-trip time and is not benchmarked here.

The example is available in C, C#, Java, Node.js, Python, and Rust. The C, C#,
and Java versions process 20,000 sets of HTTP headers, some with User-Agent
Client Hints, and the Node.js, Python, and Rust versions process 20,000
User-Agents, so compare runtimes only within each group. For C++, use the C
example. PHP has its own benchmark, built on ApacheBench.

Results we measured on seven machines are in the
[hardware benchmarks](@ref ProductSummaries_Benchmarks_Hardware).

@subpage DeviceDetection_Examples_Performance_OnPremiseHash

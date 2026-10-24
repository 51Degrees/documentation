@page ProductSummaries_Benchmarks Benchmarks

The graphs on this page show the throughput of the console performance example
in each language, from automated runs on GitHub hosted runners. Runners share
hardware with other users, and the hardware can change from one run to the
next. The graphs show trends over time. A change in a graph can come from the
runner hardware as well as from the code, and none of the graphs shows the best
throughput a machine can reach.

For figures measured on known machines, all using the same data files and
evidence, see [Hardware benchmarks](@ref ProductSummaries_HardwareBenchmarks).

If performance is important to you then we highly recommend running
your own profiling on the hardware you plan to use.
<!--
Evidence from the `Evidence Records` file in
[device-detection-data](https://github.com/51Degrees/device-detection-data) is processed by the pipeline
and the time taken measured.
-->
Where the language supports it, the tests use several threads.
For technical details, see the example repositories on [GitHub](https://github.com/51Degrees?q=example).

<!--
# C/C++

- **Number of User-Agents**: 20000
- **Data File**: Enterprise

| Machine                | Settings  | Performance Profile | Time Per Detection (ms) | Detections Per Second |
|------------------------|-----------|---------------------|------------------------:|----------------------:|
| Quad core Xeon 2.4 GHz | 4 Threads | `MaxPerformance`    |                 0.00058 |           ≈ 1,700,000 |
|                        |           | `HighPerformance`   |                 0.00080 |           ≈ 1,250,000 |

# Go

- **Number of User-Agents**: 20000

| Machine                | Settings  | Performance Profile | Time Per Detection (ms) | Detections Per Second |
|------------------------|-----------|---------------------|------------------------:|----------------------:|
| Quad core Xeon 2.4 GHz | 2 Threads | `MaxPerformance`    |                 0.02632 |              ≈ 38,023 |
|                        |           | `HighPerformance`   |                 0.02636 |              ≈ 37,950 |

# .NET

| Machine              | Settings       | Performance Profile | Time Per Detection (ms) | Detections Per Second |
|----------------------|----------------|---------------------|------------------------:|----------------------:|
| Quad core i7 2.2 GHz | Parallel Tasks | `MaxPerformance`    |                 0.00461 |             ≈ 220,000 |
|                      |                | `HighPerformance`   |                 0.00481 |             ≈ 210,000 |
|                      |                | `Balanced`          |                 0.01711 |              ≈ 58,000 |
|                      |                | `LowMemory`         |                 0.06042 |              ≈ 16,000 |

# Node.js

- **Number of User-Agents**: 20000
- **Data File**: Enterprise

| Machine                | Settings           | Performance Profile | Time Per Detection (ms) | Detections Per Second |
|------------------------|--------------------|---------------------|------------------------:|----------------------:|
| Quad core Xeon 2.4 GHz | Asynchronous Tasks | `MaxPerformance`    |                 0.04642 |              ≈ 22,000 |
|                        |                    | `HighPerformance`   |                 0.04929 |              ≈ 20,000 |

# Java

- **Number of User-Agents**: 20000

| Machine              | Settings  | Performance Profile | Time Per Detection (ms) | Detections Per Second |
|----------------------|-----------|---------------------|------------------------:|----------------------:|
| Quad core i7 2.2 GHz | 4 Threads | `MaxPerformance`    |                 0.01900 |              ≈ 52,632 |
|                      |           | `HighPerformance`   |                 0.01957 |              ≈ 51,086 |

# Python

- **Number of User-Agents**: 20000

| Machine                | Settings  | Performance Profile | Time Per Detection (ms) | Detections Per Second |
|------------------------|-----------|---------------------|------------------------:|----------------------:|
| Quad core Xeon 2.4 GHz | 2 Threads | `MaxPerformance`    |                 0.02632 |              ≈ 38,023 |
|                        |           | `HighPerformance`   |                 0.02636 |              ≈ 37,950 |
-->

| API / Product | <center>Device Detection</center>                                                                                                                        | <center>IP Intelligence</center>                                                                                                                        |
|---------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|
| C/C++         | ![dd-cxx](https://raw.githubusercontent.com/51Degrees/device-detection-cxx/gh-images/perf-graph-Ubuntu_x64_Release-DetectionsPerSecond-latest.png)       | ![ip-cxx](https://raw.githubusercontent.com/51Degrees/ip-intelligence-cxx/gh-images/perf-graph-Ubuntu_x64_Release-DetectionsPerSecond-latest.png)       |
| .NET          | ![dd-dotnet](https://raw.githubusercontent.com/51Degrees/device-detection-dotnet/gh-images/perf-graph-Ubuntu_x64_Release-DetectionsPerSecond-latest.png) | ![ip-dotnet](https://raw.githubusercontent.com/51Degrees/ip-intelligence-dotnet/gh-images/perf-graph-Ubuntu_x64_Release-DetectionsPerSecond-latest.png) |
| Java          | ![dd-java](https://raw.githubusercontent.com/51Degrees/device-detection-java/gh-images/perf-graph-Ubuntu_Java_17-DetectionsPerSecond-latest.png)         | ![ip-java](https://raw.githubusercontent.com/51Degrees/ip-intelligence-java/gh-images/perf-graph-Ubuntu_Java_8-DetectionsPerSecond-latest.png)         |
| Go            | ![dd-go](https://raw.githubusercontent.com/51Degrees/device-detection-go/gh-images/perf-graph-ubuntu-DetectionsPerSecond-latest.png)                     | ![ip-go](https://raw.githubusercontent.com/51Degrees/ip-intelligence-go/gh-images/perf-graph-ubuntu-latest-go-1.24-DetectionsPerSecond-latest.png)      |
| Node.js       | ![dd-node](https://raw.githubusercontent.com/51Degrees/device-detection-node/gh-images/perf-graph-Ubuntu_Node_22-DetectionsPerSecond-latest.png)         |                                                                                                                                                         |
| Python        | ![dd-python](https://raw.githubusercontent.com/51Degrees/device-detection-python/gh-images/perf-graph-Ubuntu_Python_3.13-DetectionsPerSecond-latest.png) |                                                                                                                                                         |
| Rust          | ![dd-rust](https://raw.githubusercontent.com/51Degrees/rust/gh-images/perf-graph-DeviceDetection-OnPremise-DetectionsPerSecond-latest.png)               | ![ip-rust](https://raw.githubusercontent.com/51Degrees/rust/gh-images/perf-graph-IpIntelligence-OnPremise-LookupsPerSecond-latest.png)                  |
| NGINX         | ![dd-nginx](https://raw.githubusercontent.com/51Degrees/device-detection-nginx/gh-images/perf-graph-ubuntu-latest-DetectionsPerSecond-latest.png)        | ![ip-nginx](https://raw.githubusercontent.com/51Degrees/device-detection-nginx/gh-images/perf-graph-ubuntu-latest_IPI-DetectionsPerSecond-latest.png)   |

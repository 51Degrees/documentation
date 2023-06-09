@page Benchmarks_DeviceDetection Device Detection Benchmarks

Precise benchmarking is a complex topic. The following results are intended 
more as an illustration of the difference in performance between 
platforms and configurations than an in-depth exploration of performance.

If performance is important to you then we highly recommend running 
your own profiling.

# C/C++

- **Number of User-Agents**: 20000
- **Data File**: Enterprise

| Machine                | Settings           | Performance Profile | Time Per Detection (ms) | Detections Per Second |
| ---------------------- |------------------- | ------------------- | ----------------------: | --------------------: |
| Quad core Xeon 2.4 GHz | 4 Threads          | `MaxPerformance`    | 0.00058                 | ≈ 1,700,000           |
|                        |                    | `HighPerformance`   | 0.00080                 | ≈ 1,250,000           |

We also run performance tests regularly on GitHub actions. The performance of this will
not be as good, as it's running on a GitHub runner, but gives an indication of consistency:

![Ubuntu Results](https://raw.githubusercontent.com/51Degrees/device-detection-cxx/gh-images/perf-graph-Ubuntu_x64_Release-DetectionsPerSecond-latest.png)

# .NET

| Machine              | Settings           | Performance Profile | Time Per Detection (ms) | Detections Per Second |
| ---------------------| ------------------ | ------------------- | ----------------------: | --------------------: |
| Quad core i7 2.2 GHz | Parallel Tasks     | `MaxPerformance`    | 0.00461                 | ≈ 220,000             |
|                      |                    | `HighPerformance`   | 0.00481                 | ≈ 210,000             |
|                      |                    | `Balanced`          | 0.01711                 | ≈ 58,000              |
|                      |                    | `LowMemory`         | 0.06042                 | ≈ 16,000              |

We also run performance tests regularly on GitHub actions. The performance of this will
not be as good, as it's running on a GitHub runner, but gives an indication of consistency:

![Ubuntu Results](https://raw.githubusercontent.com/51Degrees/device-detection-dotnet/gh-images/perf-graph-Ubuntu_x64_Release-DetectionsPerSecond-latest.png)

# Node.js

- **Number of User-Agents**: 20000
- **Data File**: Enterprise

| Machine                | Settings           | Performance Profile | Time Per Detection (ms) | Detections Per Second |
| ---------------------- | ------------------ | ------------------- | ----------------------: | --------------------: |
| Quad core Xeon 2.4 GHz | Asynchronous Tasks | `MaxPerformance`    | 0.04642                 | ≈ 22,000              |
|                        |                    | `HighPerformance`   | 0.04929                 | ≈ 20,000              |

# Java

- **Number of User-Agents**: 20000

| Machine                | Settings           | Performance Profile | Time Per Detection (ms) | Detections Per Second |
| ---------------------- |------------------- | ------------------- | ----------------------: | --------------------: |
| Quad core i7 2.2 GHz   | 4 Threads          | `MaxPerformance`    | 0.01900                 | ≈ 52,632              |
|                        |                    | `HighPerformance`   | 0.01957                 | ≈ 51,086              |

We also run performance tests regularly on GitHub actions. The performance of this will
not be as good, as it's running on a GitHub runner, but gives an indication of consistency:

![Ubuntu Results](https://raw.githubusercontent.com/51Degrees/device-detection-java/gh-images/perf-graph-Ubuntu_Java_17-DetectionsPerSecond-latest.png)

# Python

- **Number of User-Agents**: 20000

| Machine                | Settings           | Performance Profile | Time Per Detection (ms) | Detections Per Second |
| ---------------------- |------------------- | ------------------- | ----------------------: | --------------------: |
| Quad core Xeon 2.4 GHz | 2 Threads          | `MaxPerformance`    | 0.02632                 | ≈ 38,023              |
|                        |                    | `HighPerformance`   | 0.02636                 | ≈ 37,950              |
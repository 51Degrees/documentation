@page Benchmarks_DeviceDetection Device Detection Benchmarks

Precise benchmarking is a complex topic. The following results are intended 
more as an illustration of the difference in performance between 
platforms and configurations than an in-depth exploration of performance.

If performance is important to you then we highly recommend running 
your own profiling.

# C/C++

- **Number of User Agents**: 20000
- **Data File**: Enterprise

| Machine                | Settings           | Performance Profile | Time Per Detection (ms) | Detections Per Second |
| ---------------------- |------------------- | ------------------- | ----------------------: | --------------------: |
| Quad core Xeon 2.4 GHz | 4 Threads          | `MaxPerformance`    | 0.00058                 | ≈ 1,700,000           |
|                        |                    | `HighPerformance`   | 0.00080                 | ≈ 1,250,000           |

# .NET

| Machine              | Settings           | Performance Profile | Time Per Detection (ms) | Detections Per Second |
| ---------------------| ------------------ | ------------------- | ----------------------: | --------------------: |
| Quad core i7 2.2 GHz | Parallel Tasks     | `MaxPerformance`    | 0.00461                 | ≈ 220,000             |
|                      |                    | `HighPerformance`   | 0.00481                 | ≈ 210,000             |
|                      |                    | `Balanced`          | 0.01711                 | ≈ 58,000              |
|                      |                    | `LowMemory`         | 0.06042                 | ≈ 16,000              |

# Node.js

- **Number of User Agents**: 20000
- **Data File**: Enterprise

| Machine                | Settings           | Performance Profile | Time Per Detection (ms) | Detections Per Second |
| ---------------------- | ------------------ | ------------------- | ----------------------: | --------------------: |
| Quad core Xeon 2.4 GHz | Asynchronous Tasks | `MaxPerformance`    | 0.04642                 | ≈ 22,000              |
|                        |                    | `HighPerformance`   | 0.04929                 | ≈ 20,000              |
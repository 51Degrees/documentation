@page Benchmarks_DeviceDetection Device Detection Benchmarks

Precise benchmarking is a complex topic. The following results are intended 
more as an illustration of the difference in performance between 
platforms and configurations than an in-depth exploration of performance.

If performance is important to you then we highly recommend running 
your own profiling.

# .NET

| Machine              | Performance Profile | Time Per Detection (ms) | Detections Per Second |
| ---------------------| ------------------- | ----------------------: | --------------------: |
| Quad core i7 2.2 GHz | `MaxPerformance`    | 0.00461                 | ≈ 220,000             |
|                      | `HighPerformance`   | 0.00481                 | ≈ 210,000             |
|                      | `Balanced`          | 0.01711                 | ≈ 58,000              |
|                      | `LowMemory`         | 0.06042                 | ≈ 16,000              |

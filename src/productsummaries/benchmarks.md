@page ProductSummaries_Benchmarks Benchmarks

Precise benchmarking is a complex topic. The results on these pages are
intended more as an illustration of the difference in performance between
platforms and configurations than an in-depth exploration of performance.

- @subpage ProductSummaries_Benchmarks_Nightly - graphs from the performance
  example in each language, run on GitHub hosted runners as part of the
  nightly builds. They give an indication of consistency over time.
- @subpage ProductSummaries_Benchmarks_Hardware_20260731 - results for
  version 4.5.70 of the Device Detection C library on seven machines, from a
  desktop PC built in 2008 to a 128-core server, and version 4.5.34 of the IP
  Intelligence C library on five of them.

If performance is important to you then we highly recommend running your own
profiling.

# Running your own tests

The performance examples for
[Device Detection](@ref DeviceDetection_Examples_Performance_OnPremiseHash) and
[IP Intelligence](@ref IpIntelligence_Examples_Performance) are a simpler
version of the hardware tests. In C they hold the whole data file in memory and
run two threads over 10,000 records by default, using the Lite data file and
the sample evidence that comes with each library. Their figures won't match the
hardware benchmarks, but running them on each of your own machines shows how
those machines compare with each other.

[Performance Options](@ref DeviceDetection_Features_PerformanceOptions)
describes the settings that affect speed and memory use. If you'd like help
sizing a deployment, [contact us](https://51degrees.com/contact-us).

@page ProductSummaries_Benchmarks_Nightly Nightly Benchmarks

| API / Product | <center>Device Detection</center>                                                                                                                        | <center>IP Intelligence</center>                                                                                                                        |
|---------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|
| C/C++         | ![dd-cxx](https://raw.githubusercontent.com/51Degrees/51degrees-cxx/gh-images/perf-graph-Ubuntu_x64_Release-DetectionsPerSecond-latest.png)       | ![ip-cxx](https://raw.githubusercontent.com/51Degrees/51degrees-cxx/gh-images/perf-graph-Ubuntu_x64_Release-LookupsPerSecond-latest.png)          |
| .NET          | ![dd-dotnet](https://raw.githubusercontent.com/51Degrees/51degrees-dotnet/gh-images/perf-graph-Ubuntu_x64_Release-DetectionsPerSecond-latest.png) | ![ip-dotnet](https://raw.githubusercontent.com/51Degrees/ip-intelligence-dotnet/gh-images/perf-graph-Ubuntu_x64_Release-DetectionsPerSecond-latest.png) |
| Java          | ![dd-java](https://raw.githubusercontent.com/51Degrees/device-detection-java/gh-images/perf-graph-Ubuntu_Java_17-DetectionsPerSecond-latest.png)         | ![ip-java](https://raw.githubusercontent.com/51Degrees/ip-intelligence-java/gh-images/perf-graph-Ubuntu_Java_8-DetectionsPerSecond-latest.png)         |
| Go            | ![dd-go](https://raw.githubusercontent.com/51Degrees/51degrees-go/gh-images/perf-graph-Ubuntu_Go_1.24-DetectionsPerSecond-latest.png)                     | ![ip-go](https://raw.githubusercontent.com/51Degrees/51degrees-go/gh-images/perf-graph-Ubuntu_Go_1.24-LookupsPerSecond-latest.png)      |
| Node.js       | ![dd-node](https://raw.githubusercontent.com/51Degrees/51degrees-node/gh-images/perf-graph-Ubuntu_Node_24-DetectionsPerSecond-latest.png)         |                                                                                                                                                         |
| Python        | ![dd-python](https://raw.githubusercontent.com/51Degrees/51degrees-python/gh-images/perf-graph-Ubuntu_Python_3.13-DetectionsPerSecond-latest.png)        |                                                                                                                                                         |
| Rust          | ![dd-rust](https://raw.githubusercontent.com/51Degrees/51degrees-rust/gh-images/perf-graph-DeviceDetection-OnPremise-DetectionsPerSecond-latest.png)               | ![ip-rust](https://raw.githubusercontent.com/51Degrees/51degrees-rust/gh-images/perf-graph-IpIntelligence-OnPremise-LookupsPerSecond-latest.png)                  |
| NGINX         | ![dd-nginx](https://raw.githubusercontent.com/51Degrees/51degrees-nginx/gh-images/perf-graph-ubuntu-latest-DetectionsPerSecond-latest.png)        | ![ip-nginx](https://raw.githubusercontent.com/51Degrees/51degrees-nginx/gh-images/perf-graph-ubuntu-latest_IPI-DetectionsPerSecond-latest.png)   |
| Varnish       | ![dd-varnish](https://raw.githubusercontent.com/51Degrees/51degrees-varnish/gh-images/perf-graph-ubuntu_DD-DetectionsPerSecond-latest.png)               | ![ip-varnish](https://raw.githubusercontent.com/51Degrees/51degrees-varnish/gh-images/perf-graph-ubuntu_IPI-DetectionsPerSecond-latest.png)             |

# How we test

These tests are run using a console performance example. If language
appropriate, multiple threads are used to run the tests. For technical details,
see the example repositories on [GitHub](https://github.com/51Degrees?q=example).

NGINX and Varnish have no console example, so their figures come from requests
through NGINX or Varnish, each making one detection, with as many concurrent
requests as the machine has processors, timed in the same way. They include the
server's own request handling and the program making the requests, so look at
their trend rather than comparing their values with the other rows.

We run performance tests regularly on GitHub Actions. The performance of this
may not be as good as a dedicated machine, as it's running on a GitHub runner,
but gives an indication of consistency. Results from dedicated machines are in
the [hardware benchmarks](@ref ProductSummaries_Benchmarks_Hardware).

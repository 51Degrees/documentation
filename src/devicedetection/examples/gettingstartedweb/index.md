@page DeviceDetection_Examples_GettingStarted_Web_Index Getting Started - Web

# Introduction

The Getting Started Web examples show how to add 51Degrees @devicedetection to a
web application. The pipeline runs on each incoming HTTP request, reads the
User-Agent and any [User-Agent Client Hints](@ref DeviceDetection_Features_UACH_Overview)
the browser sent, and exposes the detected device, operating system and browser
properties to your handler so you can adapt the response.

Two deployment models are covered:

- **Cloud** — calls 51Degrees' hosted Cloud service over HTTPS. No data file
  to manage, no on-premise binary to update; suitable for traffic that already
  reaches a public endpoint and for teams who want the fastest path to a
  working integration. See @ref DeviceDetection_Examples_GettingStarted_Web_Cloud.

- **On-premise** — runs the Hash engine inside your own process against a
  locally distributed data file. Suitable for workloads that need offline
  operation, predictable latency, or the highest request throughput. See
  @ref DeviceDetection_Examples_GettingStarted_Web_OnPremise.

Both examples follow the same pattern: configure a pipeline, register it with
the framework, and read the detected properties off the request. Each ships
side-by-side snippets for ASP.NET Core, ASP.NET Framework, Java, Node.js, PHP
and Python, so you can pick the language that matches your stack and skip the
rest. If you are evaluating which deployment model fits your use case first,
see @ref DeviceDetection_CloudToOnPremise for a comparison.

@subpage DeviceDetection_Examples_GettingStarted_Web_Cloud

@subpage DeviceDetection_Examples_GettingStarted_Web_OnPremise

@page IpIntelligence_Examples_GettingStarted_Web_Index Getting Started - Web (IP Intelligence)

# Introduction

The Getting Started Web examples show how to add 51Degrees IP Intelligence to
a web application. The pipeline runs on each incoming HTTP request, reads the
client IP from the headers, and exposes geolocation, network classification
and connection-type properties (country, region, city, ASN, registered name,
estimated bandwidth, mobile carrier, and more) to your handler so you can
personalise the response, enforce regional rules, or route traffic.

Two deployment models are covered:

- **Cloud** — calls 51Degrees' hosted Cloud service over HTTPS. No data file
  to manage and no on-premise binary to update; suitable for teams who want
  the fastest path to a working integration. See
  @ref IpIntelligence_Examples_GettingStarted_Web_Cloud.

- **On-premise** — runs the IP Intelligence engine inside your own process
  against a locally distributed data file. Suitable for workloads that need
  offline operation, predictable latency, or the highest request throughput.
  See @ref IpIntelligence_Examples_GettingStarted_Web_OnPremise.

Both examples follow the same shape: configure a pipeline, register it with
the framework, hand it the request and read the detected properties off the
result. Snippets are shown side by side for ASP.NET Core, Java, Node.js, PHP
and Python so you can pick the language that matches your stack. For console
or batch-style integrations, see @ref IpIntelligence_Examples_GettingStarted_Console_Index
instead.

@subpage IpIntelligence_Examples_GettingStarted_Web_Cloud

@subpage IpIntelligence_Examples_GettingStarted_Web_OnPremise

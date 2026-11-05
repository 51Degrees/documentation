@page IpIntelligence_Examples_GettingStarted_Web_Index IP Intelligence web quick start

# Introduction

The Getting Started Web examples show how to add 51Degrees IP Intelligence to
a web application. The pipeline runs on each incoming HTTP request, reads the
client IP from the headers, and exposes geolocation, network classification
and connection-type properties (country, region, city, ASN, registered name,
estimated bandwidth, mobile carrier, and more) to your handler so you can
personalize the response, enforce regional rules, or route traffic.

Two deployment models are covered:

- **Cloud** calls our hosted service over HTTPS. You do not manage a local data file or detection binary. See @ref IpIntelligence_Examples_GettingStarted_Web_Cloud.

- **On-premise** runs the IP Intelligence engine in your process with a local data file. Use it for offline operation or when latency and throughput are priorities. See @ref IpIntelligence_Examples_GettingStarted_Web_OnPremise.

For both examples, configure a pipeline, register it with your framework, pass it the request, and read the result properties. Select a tab for your language and framework. For console
or batch-style integrations, see @ref IpIntelligence_Examples_GettingStarted_Console_Index
instead.

@subpage IpIntelligence_Examples_GettingStarted_Web_Cloud

@subpage IpIntelligence_Examples_GettingStarted_Web_OnPremise

@page IpIntelligence_Examples_GettingStarted_Console_Index IP Intelligence Getting Started Console

# Introduction

The Getting Started Console examples show how to call 51Degrees IP Intelligence
from a standalone command-line program. They are the shortest end-to-end
walkthrough for the engine: build a pipeline, hand it an IP address, and print
the resulting properties such as country, region, city, ASN, registered name,
estimated bandwidth and connection type. Use them as the starting point for
batch enrichment, ad-hoc lookups, automation scripts, or as a sanity check
before wiring the pipeline into a larger application.

Two deployment models are covered:

- **Cloud** — calls 51Degrees' hosted Cloud service over HTTPS. A Resource Key
  configures the pipeline; no data file is needed locally. Best for the fastest
  path to a working integration. See
  @ref IpIntelligence_Examples_GettingStarted_Console_Cloud.

- **On-premise** — runs the IP Intelligence engine inside your own process
  against a locally distributed data file. Best when network access is
  restricted or when you need the lowest per-call latency. See
  @ref IpIntelligence_Examples_GettingStarted_Console_OnPremise.

Both examples are available across every supported language with a matching
pattern, so the same logic can be compared side by side. If you intend to
deploy inside a web framework rather than a console, see
@ref IpIntelligence_Examples_GettingStarted_Web_Index instead.

@subpage IpIntelligence_Examples_GettingStarted_Console_Cloud

@subpage IpIntelligence_Examples_GettingStarted_Console_OnPremise

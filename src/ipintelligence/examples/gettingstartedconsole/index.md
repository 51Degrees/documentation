@page IpIntelligence_Examples_GettingStarted_Console_Index IP Intelligence console quick start

# Introduction

The Getting Started Console examples show how to call 51Degrees IP Intelligence
from a standalone command-line program. They are the shortest end-to-end
walkthrough for the engine: build a pipeline, hand it an IP address, and print
the resulting properties such as country, region, city, ASN, registered name,
estimated bandwidth and connection type. Use them as the starting point for
batch enrichment, ad-hoc lookups, automation scripts, or as a sanity check
before wiring the pipeline into a larger application.

Two deployment models are covered:

- **Cloud** calls our hosted service over HTTPS. Configure the pipeline with a Resource Key. You do not need a local data file. See @ref IpIntelligence_Examples_GettingStarted_Console_Cloud.

- **On-premise** runs the IP Intelligence engine in your process with a local data file. Use it when network access is restricted or latency is a priority. See @ref IpIntelligence_Examples_GettingStarted_Console_OnPremise.

Both examples are available across every supported language with a matching
pattern, so the same logic can be compared side by side. If you intend to
deploy inside a web framework rather than a console, see
@ref IpIntelligence_Examples_GettingStarted_Web_Index instead.

@subpage IpIntelligence_Examples_GettingStarted_Console_Cloud

@subpage IpIntelligence_Examples_GettingStarted_Console_OnPremise

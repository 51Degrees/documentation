@page DeviceDetection_Examples_GettingStarted_Console_Index Getting started with console applications

# Introduction

The Getting Started Console examples show how to call 51Degrees @devicedetection
from a standalone command-line program. They are the shortest possible end-to-end
walkthrough: build a pipeline, hand it a User-Agent (and optionally a set of
[User-Agent Client Hints](@ref DeviceDetection_Features_UACH_Overview)), and print
the resulting properties. Use them as the starting point for batch processing,
ad-hoc lookups, automation scripts, or as a sanity check before wiring the
pipeline into a larger application.

Two deployment models are covered:

- **Cloud** calls our hosted service over HTTPS. Configure the pipeline with a Resource Key. You do not need a local data file. See @ref DeviceDetection_Examples_GettingStarted_Console_Cloud.

- **On-premise** runs the Hash engine in your process with a local data file. Use it when network access is restricted or per-call latency is a priority. See @ref DeviceDetection_Examples_GettingStarted_Console_OnPremise.

The cloud example is available in C#, Java, Node.js, PHP, Python, and Rust, and
the on-premise example in those languages and in C, C++, Nginx, and Varnish.
Each follows the same pattern in every language, so the same logic can be
compared side by side. If you intend to
deploy inside a web framework rather than a console, see
@ref DeviceDetection_Examples_GettingStarted_Web_Index instead.

@subpage DeviceDetection_Examples_GettingStarted_Console_Cloud

@subpage DeviceDetection_Examples_GettingStarted_Console_OnPremise

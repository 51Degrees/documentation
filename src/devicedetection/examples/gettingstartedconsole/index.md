@page DeviceDetection_Examples_GettingStarted_Console_Index Getting Started - Console

# Introduction

The Getting Started Console examples show how to call 51Degrees @devicedetection
from a standalone command-line program. They are the shortest possible end-to-end
walkthrough: build a pipeline, hand it a User-Agent (and optionally a set of
[User-Agent Client Hints](@ref DeviceDetection_Features_UACH_Overview)), and print
the resulting properties. Use them as the starting point for batch processing,
ad-hoc lookups, automation scripts, or as a sanity check before wiring the
pipeline into a larger application.

Two deployment models are covered:

- **Cloud** — calls 51Degrees' hosted Cloud service over HTTPS. The simplest
  path to a working detection: a Resource Key configures the pipeline, no data
  file is needed locally. See @ref DeviceDetection_Examples_GettingStarted_Console_Cloud.

- **On-premise** — runs the Hash engine inside your own process against a
  locally distributed data file. Suitable when network access is restricted or
  when you need the lowest per-call latency. See
  @ref DeviceDetection_Examples_GettingStarted_Console_OnPremise.

Both examples are available in C#, Java, Node.js, PHP and Python with matching
pattern, so you can compare the same logic across languages. If you intend to
deploy inside a web framework rather than a console, see
@ref DeviceDetection_Examples_GettingStarted_Web_Index instead.

@subpage DeviceDetection_Examples_GettingStarted_Console_Cloud

@subpage DeviceDetection_Examples_GettingStarted_Console_OnPremise

@page PipelineApi_Concepts_Data_EvidenceKeyFilter Evidence key filter

# Introduction

An **evidence key filter** lets a caller know if a given key value is included or excluded.

For example, each @flowelement has an **evidence key filter** which will only include key values
that the @flowelement can make use of.

Additionally, the **evidence key filter** can indicate the relative importance or order
of each key value that it includes.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/features/advertize-accepted-evidence.md#)
for more technical details.

# Usage

Use **evidence key filters** with @flowdata to generate @datakeys for @caching.
This allows the @datakey to contain the minimum amount of necessary information to determine
if a given @flowdata will result in the same output from a given @aspectengine as another, regardless
of any other values that may be present in the @evidence.

**Evidence key filters** can also be used by @Pipeline callers to restrict the amount of evidence 
they supply, to only that which is needed.
The @webintegration feature will do this automatically for many languages and web frameworks.

# Implementations

## Whitelist filter

The whitelist filter is a very simple filter that will include any @evidence key names that 
are in a list supplied at construction time.

## Filter aggregator

The filter aggregator includes an evidence key if any child filter includes it. This combines the filters with a logical OR.

## Share usage filter

The share usage filter is a specific implementation for 51Degrees @usagesharing.
It will include anything that meets the following criteria:

1. Any HTTP header.
2. Any cookie with a name that starts with '51D_'.
3. A user session cookie, in .NET and Java. It is used only to tell user sessions apart when session tracking is turned on, and it is never sent to 51Degrees.
4. Any evidence that is not a header, cookie or query string parameter.

Configuration options allow this to be tuned to meet your requirements:

1. A blacklist of HTTP header names to exclude from sharing can be supplied.
2. In .NET and Java, session tracking can be turned on and the name of the session cookie
  can be changed. (The default is the ASP.NET session cookie in .NET and `JSESSIONID` in Java.)
3. A whitelist of query string parameters to share can be supplied.

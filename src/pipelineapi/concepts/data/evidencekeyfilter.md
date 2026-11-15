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

1. Any HTTP header other than `Cookie`.
2. Any cookie with a name that starts with '51D_'.
3. Any session value with a name that starts with '51D_'.
4. Any query string or form parameter.
5. Any evidence that is not a header, cookie, session value or query string parameter.

Some evidence is never shared, whatever the configuration. That includes `id.email`, `id.salt`, `request-query` and `request-path` under any prefix, and every cookie whose name does not start with '51D_'. The @ref PipelineApi_Features_UsageSharing page lists it all.

.NET, Go, Node.js and Rust work this way. In Java and Python, a query string or form parameter is shared only when its name starts with '51D_' or it is on the allow list, unless sharing all query string parameters is turned on, and sharing all evidence also shares every cookie other than the `Cookie` header.

Configuration options allow this to be tuned to meet your requirements:

1. A block list of HTTP header names to exclude from sharing can be supplied.
2. Sharing every query string and form parameter can be turned off. Only those whose names start with '51D_' are then shared, along with any on an allow list that can be supplied.
3. Session tracking can be turned on, so that a repeat of the same evidence from a new user session is shared again. It compares the session cookie, which is not sent to 51Degrees unless its name starts with '51D_'. By default .NET uses the ASP.NET session cookie and Java uses `JSESSIONID`. Node.js, Python, Go and Rust have no default, so give the cookie's name when turning session tracking on.
4. All evidence can be shared, apart from the evidence that is never shared.

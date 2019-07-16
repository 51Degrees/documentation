@page Concepts_Data_EvidenceKeyFilter Evidence Key Filter

# Introduction

An **evidence key filter** lets a caller know if a given key value is included or excluded.

For example, each @flowelement has an **evidence key filter** which will only include key values
that the @flowelement can make use of.

Additionally, the **evidence key filter** can indicate the relative importance or order
of each key value that it includes.

# Usage

**Evidence key filters** are used by @flowdata to generate @datakeys. These @datakeys can then
used in @caching.
This allows the @datakey to contain the minimum amount of necessary information to determine
if a given @flowdata will result in the same output from a given @aspectengine as another, regardless
of any other values that may be present in the @evidence.

**Evidence key filters** can also be used by Pipeline callers to restrict the amount of evidence 
they supply to only that which is needed.
The @webintegration feature will do this automatically for multiple languages and web frameworks.

# Implementations

## Whitelist Filter

The whitelist filter is a very simple filter that will include any @evidence key names that 
are in a list supplied at construction time.

## Filter Aggregator

The filter aggregator combines multiple filters together using a logical OR approach.
I.e. If any one of the child filters would allow the inclusion of an evidence key then this 
aggregator will allow it as well.

## Share Usage Filter

The share usage filter is a specific implementation for 51Degrees @usagesharing.
It will include anything that meets the following criteria:

1. Any HTTP header.
2. Any cookie with a name that starts with '51D_'.
3. A user session cookie.
4. Any evidence that is not a header, cookie or query string parameter.

Configuration options allow this to be tuned to meet your requirements:

1. A blacklist of HTTP header names to exclude from sharing can be supplied.
2. Sharing of user session cookies can be disabled and the name of the cookie
  is customizable. (This will default to the appropriate cookie for the language, 
  for example the ASP.NET session cookie in .NET)
3. A whitelist of query string parameters to share can be supplied.
@page DeviceDetection_Features_RobotsTxt Robots.txt Generator

# Introduction

A `robots.txt` file is a plain text file hosted at the root of a website (for example `https://example.com/robots.txt`) that tells web crawlers which parts of the site they are or are not allowed to access. It follows the [Robots Exclusion Protocol](https://www.rfc-editor.org/rfc/rfc9309.html), where each block declares one or more `User-Agent` lines followed by `Allow:` and/or `Disallow:` directives that the named crawlers should respect.

Maintaining a `robots.txt` file by crawler usage can be difficult. The crawler list changes, operators use multiple product tokens, and one crawler can serve more than one purpose.

The `RobotsTxtEngine` shipped in the [device-detection-dotnet](https://github.com/51Degrees/51degrees-dotnet/tree/main/device-detection/RobotsTxt) package solves this problem by generating a `robots.txt` document on demand from the up-to-date 51Degrees crawler dataset, driven by a small set of allow/disallow choices expressed in terms of [crawler usages](@ref DeviceDetection_Features_Crawlers) rather than individual user-agents.

# Availability

The on-premise `RobotsTxtEngine` is available in .NET only. It ships in
the [device-detection-dotnet](https://github.com/51Degrees/51degrees-dotnet/tree/main/device-detection/RobotsTxt)
package, and there is no equivalent engine in the Java, C, C++, Go,
Rust, PHP, Node or Python SDKs.

Robots.txt generation is available from every language through
51Degrees Cloud, which is an HTTP call and needs no SDK at all. See
[Cloud Usage](#cloud-usage) below. There is also a hosted generator at
[51degrees.com/robots-txt](https://51degrees.com/robots-txt) that
produces a file to host, with no code involved.

| How you use it | Available in |
| --- | --- |
| On-premise engine | .NET only |
| 51Degrees Cloud | Any language, over HTTP |
| Hosted generator | No code required |

# Output Properties

The engine computes two output properties at request time from the crawler data set and supplied evidence. These properties are not stored in a data file.

## robotstxt.plaintext

A complete `robots.txt` document, ready to be served at the root of an arbitrary website. It contains one `User-Agent` / `Disallow: /` block per crawler whose usages are not in the allow set, followed by a wildcard `User-Agent: *` block that catches everything else.

Hosting this string as the body of `https://yoursite.com/robots.txt` is a valid deployment.

## robotstxt.annotatedtext

The same document as `robotstxt.plaintext`, with comments before each crawler block that name the crawler, its declared usages, and a reference URL where available. Use it for review and documentation. It is valid `robots.txt` because lines starting with `#` are comments, but it is not intended to be served verbatim.

# Input crawler usages

The engine consumes evidence keyed by [crawler usage](@ref DeviceDetection_Features_Crawlers) values. For every `CrawlerUsage` value present in the loaded dataset, the engine accepts an evidence key of the form:

```
query.robotstxt.<usage>
```

with a value of either `allow` or `disallow` (case-insensitive; `true`/`false`, `yes`/`no`, `enabled`/`disabled`, and `on`/`off` are also accepted as synonyms).

For each crawler in the data set, the engine checks whether **any** of its usages is allowed. If so, the crawler falls through to the wildcard block. Otherwise, the engine emits a dedicated `Disallow: /` block for each product token the crawler advertises.

If the same usage is supplied as both `allow` and `disallow`, `disallow` wins.

The [Crawlers](@ref DeviceDetection_Features_Crawlers) page describes `Index`, `Train`, `Input`, `Search`, `Monitor`, `Archiving`, `Preview`, `Security`, `Analytics`, `Feed`, and `Discovery`. Query the data set for the currently supported `CrawlerUsage` values, as shown under [Cloud Usage](#cloud-usage).

# Terms Document Locator (TDL)

A Terms Document Locator (TDL) is a stable URL that points at the human-readable terms of use that crawlers in the wildcard `Allow:` block must comply with. When the engine receives the additional evidence key:

```
query.robotstxt.tdl
```

the wildcard catch-all block at the bottom of the generated `robots.txt` is augmented with one `TDL:` line per supplied URI, each preceded by a `# Terms <url>` comment. If no valid TDL URI is supplied the wildcard block is emitted as a plain `Allow: /`.

The `tdl` value can be:

- A single absolute URI, e.g. `https://example.com/terms.txt`.
- Multiple URIs, separated by `,` or `|`, e.g. `https://a.example/terms,https://b.example/terms`.
- A short macro id that the engine resolves to a current URL via an `ITdlSourceResolver`. The default resolver ships with one known macro, **`MOW-SOCW`**, which substitutes the address of the latest version of the Movement for an Open Web [Search Only Contract](https://m4ow.uk/socw/), such as `https://m4ow.uk/socw/3.txt`.

Entries that are neither absolute URIs nor known macro ids are silently dropped, per the IETF-Robots TDL specification. If everything supplied is dropped, the engine falls back to the standard `Allow: /` wildcard block.

# Cloud Usage

Robots.txt is available from 51Degrees Cloud on the free plan. For a step by step guide to fetching the file and keeping it fresh, see @ref Services_Cloud_RobotsTxt. When the properties are enabled on a Resource Key, two additional steps make integration straightforward.

## Discover available CrawlerUsage values

Before deciding which `query.robotstxt.<usage>` parameters to send, fetch the full list of allowed `CrawlerUsage` values from the cloud metadata API:

```
https://cloud.51degrees.com/api/metadata/values?propertyName=CrawlerUsage
```

This returns the usage values available on your Resource Key tier. Use the value names in lowercase as the suffix of each evidence parameter.

## Calling the JSON endpoint

To request a `robots.txt` from Cloud, call the standard JSON endpoint with the appropriate `query.robotstxt.*` parameters. For example:

```
https://cloud.51degrees.com/api/v4/json?resource=<RESOURCE_KEY>&values=robotstxt.plaintext&robotstxt.search=allow&robotstxt.analytics=allow&robotstxt.tdl=https://m4ow.uk/socw/3.txt,https://custom.url/tdl
```

In the example above:

- `robotstxt.search=allow` and `robotstxt.analytics=allow` allow every crawler whose `CrawlerUsage` includes `Search` or `Analytics`. Every other known crawler gets its own `Disallow:` block. Keep `search` in the allow set unless you intend to block search engines, because a request allowing only `analytics` blocks Googlebot.
- `robotstxt.tdl=https://m4ow.uk/socw/3.txt,https://custom.url/tdl` adds two TDL entries to the wildcard `Allow:` block, version 3 of the Movement for an Open Web [Search Only Contract](https://m4ow.uk/socw/) and a custom absolute URL of your own license agreement, in the order supplied.

Send at least one `robotstxt.<usage>` parameter. A request without one returns no `robotstxt` element.

The response is a standard 51Degrees Cloud JSON document, with the generated text in the `plaintext` and `annotatedtext` values of the `robotstxt` element:

```json
{
  "robotstxt": {
    "plaintext":     "User-Agent: ExampleBot\nDisallow: /\n...",
    "annotatedtext": "# N: ExampleBot\n# U: Train\nUser-Agent: ExampleBot\nDisallow: /\n..."
  }
}
```

The Resource Key must include `robotstxt.plaintext`, `robotstxt.annotatedtext`, or both. If you use only a License Key, request the properties in the `values` parameter instead. Use `plaintext` in production and `annotatedtext` for internal review of the generated rules.

Create a Resource Key that includes `robotstxt.plaintext` and `robotstxt.annotatedtext` at [configure.51degrees.com](https://configure.51degrees.com). Leave its domain list empty when your server makes the request, because a key limited to domains refuses requests that come from anywhere else.

# On-premise engine configuration

The engine is built via `RobotsTxtEngineBuilder` and added to a Pipeline that also contains a `DeviceDetectionHashEngine` (the engine reads the crawler list out of the loaded device-detection data file at `AddPipeline` time).

Builder parameters:

| Parameter | Purpose |
|-----------|---------|
| `SetProperties` (inherited) | Restrict the engine output to a subset of `PlainText` / `AnnotatedText`. If unset, both are produced. |
| `SetTdlSourceResolver(resolver)` | Replace the default `GitHubTdlSourceResolver` with a custom `ITdlSourceResolver`, or pass `null` to disable macro resolution entirely (e.g. for air-gapped deployments). |
| `SetUserAgent(userAgent)` / `UseDefaultTdlSourceResolver(userAgent)` | Override the User-Agent that the default GitHub-backed resolver sends when refreshing macro source listings. GitHub rejects requests without a User-Agent. Pipeline configuration files can drive this via `BuildParameters`. |

Properties advertised by the engine carry the data tier of the underlying device-detection data file, so `robotstxt.plaintext` and `robotstxt.annotatedtext` are only available when running against an Enterprise tier file (or higher) that contains the crawler properties.

# See Also

- @ref DeviceDetection_Features_Crawlers for `CrawlerUsage` value definitions.
- [51Degrees Robots.txt generator](https://51degrees.com/robots-txt), a hosted interface for the same engine.
- @ref Services_Cloud_RobotsTxt, a step by step guide to getting a fresh robots.txt from the cloud on a schedule.

@page DeviceDetection_Features_RobotsTxt Robots.txt Generator

# Introduction

A `robots.txt` file is a plain text file hosted at the root of a website (for example `https://example.com/robots.txt`) that tells web crawlers which parts of the site they are or are not allowed to access. It follows the [Robots Exclusion Protocol](https://www.rfc-editor.org/rfc/rfc9309.html), where each block declares one or more `User-Agent` lines followed by `Allow:` and/or `Disallow:` directives that the named crawlers should respect.

With the explosion of AI training crawlers, search bots, analytics agents, archival workers and security scanners, manually maintaining a `robots.txt` that correctly distinguishes between these uses is impractical. The crawler list changes constantly, individual operators ship multiple product tokens, and a single bot can serve more than one purpose.

The `RobotsTxtEngine` shipped in the [device-detection-dotnet](https://github.com/51Degrees/device-detection-dotnet/tree/main/FiftyOne.DeviceDetection.RobotsTxt) package solves this problem by generating a `robots.txt` document on demand from the up-to-date 51Degrees crawler dataset, driven by a small set of allow/disallow choices expressed in terms of [crawler usages](@ref DeviceDetection_Features_Crawlers) rather than individual user-agents.

# Output Properties

The engine produces two synthetic properties — they are not stored in any data file, they are computed at request time from the crawler dataset and the evidence supplied to the engine.

## robotstxt.plaintext

A complete `robots.txt` document, ready to be served at the root of an arbitrary website. It contains one `User-Agent` / `Disallow: /` block per crawler whose usages are not in the allow set, followed by a wildcard `User-Agent: *` block that catches everything else.

Hosting this string as the body of `https://yoursite.com/robots.txt` is a valid deployment.

## robotstxt.annotatedtext

The same document as `robotstxt.plaintext`, but with comments added before each crawler block describing the crawler name, its declared usages and a reference URL where available. Useful for human review and documentation; not intended to be served verbatim, although it remains a valid `robots.txt` (lines starting with `#` are comments).

# Input — Crawler Usages

The engine consumes evidence keyed by [crawler usage](@ref DeviceDetection_Features_Crawlers) values. For every `CrawlerUsage` value present in the loaded dataset, the engine accepts an evidence key of the form:

```
query.robotstxt.<usage>
```

with a value of either `allow` or `disallow` (case-insensitive; `true`/`false`, `yes`/`no`, `enabled`/`disabled`, and `on`/`off` are also accepted as synonyms).

For each crawler in the dataset, the engine checks whether **any** of that crawler's usages appears in the allow set. If so, the crawler is allowed by falling through to the wildcard catch-all block; otherwise the engine emits a dedicated `Disallow: /` block for every product token the crawler advertises.

If the same usage is supplied as both `allow` and `disallow`, `disallow` wins.

The full list of `CrawlerUsage` values — `Index`, `Train`, `Input`, `Search`, `Monitor`, `Archiving`, `Preview`, `Security`, `Analytics`, `Feed`, `Discovery` — is documented under [Crawlers](@ref DeviceDetection_Features_Crawlers). Because the set is data-driven, querying the dataset directly is the way to discover the values currently supported. See [Cloud Usage](#cloud-usage) below for the metadata endpoint.

# Terms Document Locator (TDL)

A Terms Document Locator (TDL) is a stable URL that points at the human-readable terms of use that crawlers in the wildcard `Allow:` block must comply with. When the engine receives the additional evidence key:

```
query.robotstxt.tdl
```

the wildcard catch-all block at the bottom of the generated `robots.txt` is augmented with one `TDL:` line per supplied URI, each preceded by a `# Terms <url>` comment. If no valid TDL URI is supplied the wildcard block is emitted as a plain `Allow: /`.

The `tdl` value can be:

- A single absolute URI, e.g. `https://example.com/terms.txt`.
- Multiple URIs, separated by `,` or `|`, e.g. `https://a.example/terms,https://b.example/terms`.
- A short macro id that the engine resolves to a current URL via a `ITdlSourceResolver`. The default resolver ships with one known macro, **`MOW-SOCW`**, which substitutes the latest version of the [Movement for an Open Web Standard Online Content Wrapper](https://github.com/movementforanopenweb/terms-documents) terms document.

Entries that are neither absolute URIs nor known macro ids are silently dropped, per the IETF-Robots TDL specification. If everything supplied is dropped, the engine falls back to the standard `Allow: /` wildcard block.

# Cloud Usage

Robots.txt support has recently become available as part of 51Degrees Cloud. When enabled on a Resource Key, two additional steps make integration straightforward.

## Discovering the available CrawlerUsage values

Before deciding which `query.robotstxt.<usage>` parameters to send, fetch the full list of allowed `CrawlerUsage` values from the cloud metadata API:

```
https://cloud.51degrees.com/api/metadata/values?propertyName=CrawlerUsage
```

This returns the canonical list of usages available on your Resource Key tier — use the value names verbatim (lower-cased) as the suffix of the evidence parameter.

## Calling the JSON endpoint

To request a `robots.txt` from Cloud, call the standard JSON endpoint with the appropriate `query.robotstxt.*` parameters. For example:

```
https://cloud.51degrees.com/api/v4/json?resource=<RESOURCE_KEY>&values=robotstxt.plaintext&robotstxt.analytics=allow&robotstxt.tdl=MOW-SOCW,https://custom.url/tdl
```

In the example above:

- `robotstxt.analytics=allow` allows every crawler whose `CrawlerUsage` includes `Analytics`. All other crawlers are omitted as explicit `Disallow:` blocks.
- `robotstxt.tdl=MOW-SOCW,https://custom.url/tdl` adds two TDL entries to the wildcard `Allow:` block — the macro `MOW-SOCW` (resolved server-side to the latest published [Movement for an Open Web Standard](https://m4ow.uk/socw/) Online Content Wrapper terms URL) and a custom absolute URL of your own license agreement. Both are added in the order supplied.

The response is a standard 51Degrees Cloud JSON document, with the generated text exposed under the `robotstxt` and `annotatedtext` element:

```json
{
  "robotstxt": {
    "plaintext":     "User-Agent: ExampleBot\nDisallow: /\n...",
    "annotatedtext": "# N: ExampleBot\n# U: Train\nUser-Agent: ExampleBot\nDisallow: /\n..."
  }
}
```

The Resource Key must include the `robotstxt.plaintext` and/or `robotstxt.annotatedtext` properties or the values must be requested using the `values` parameter in the request. The `plaintext` value is intended for production use. The `annotatedtext` value is intended for internal use to understand why certain choices were made and provide context.

Use the @ref Services_Configurator "Configurator" to include `robotstxt` and `annotatedtext` in the resource key response.

# On Premise Engine Configuration

The engine is built via `RobotsTxtEngineBuilder` and added to a Pipeline that also contains a `DeviceDetectionHashEngine` (the engine reads the crawler list out of the loaded device-detection data file at `AddPipeline` time).

Builder parameters:

| Parameter | Purpose |
|-----------|---------|
| `SetProperties` (inherited) | Restrict the engine output to a subset of `PlainText` / `AnnotatedText`. If unset, both are produced. |
| `SetTdlSourceResolver(resolver)` | Replace the default `GitHubTdlSourceResolver` with a custom `ITdlSourceResolver`, or pass `null` to disable macro resolution entirely (e.g. for air-gapped deployments). |
| `SetUserAgent(userAgent)` / `UseDefaultTdlSourceResolver(userAgent)` | Override the User-Agent that the default GitHub-backed resolver sends when refreshing macro source listings. GitHub rejects requests without a User-Agent. Pipeline configuration files can drive this via `BuildParameters`. |

Properties advertised by the engine carry the data tier of the underlying device-detection data file, so `robotstxt.plaintext` and `robotstxt.annotatedtext` are only available when running against an Enterprise tier file (or higher) that contains the crawler properties.

# See Also

- @ref DeviceDetection_Features_Crawlers — `CrawlerUsage` value definitions.
- [51Degrees Robots.txt generator](https://51degrees.com/robots-txt) — hosted UI built on top of the same engine.

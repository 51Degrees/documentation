@page Services_Cloud_SelfHostedDocker Self-Hosted Docker

The Self-Hosted Cloud Docker image runs the
[51Degrees Cloud Service](@ref Services_Cloud_Overview) API entirely on your own
infrastructure. It is **single-tenant**: every request is authorized by the
License Key(s) you start the container with. There are no
[resource keys](@ref Services_Cloud_ResourceKeys), and the container makes
**no outbound calls** to 51Degrees services - no usage sharing and no
entitlement/billing lookups.

For the API itself (endpoints, evidence, response format), see the interactive
documentation served by the running container at `/api-docs`.

# Prerequisites

- A container runtime (Docker, Podman, Kubernetes, etc.).
- The `51degrees/cloud-private` container image. The image is distributed
  privately: [contact us](https://51degrees.com/contact-us) to be granted access
  to it. It already contains the data files it needs (see Data Files below).
- One or more 51Degrees **License Keys** that entitle the products you need.

# Data Files

The data files are baked into the `51degrees/cloud-private` image at
`/app/data/assets`, so you do not need to supply or mount anything:

- `TAC-HashV41.hash` - @DeviceDetection
- `51Degrees-EnterpriseIpiV41.ipi` - @IpIntelligence

51Degrees ships a new image daily, with refreshed data files as needed, and
each image is tagged with its build date. To move to newer data, pull a newer
image (see Updating).

# Environment Variables

| Variable | Required | Description |
| -------- | -------- | ----------- |
| `LICENSE_KEYS` | **yes** | One or more 51Degrees License Keys (comma-separated). Determines the products and properties the container serves. |
| `PROPERTIES_DEVICE_DETECTION` | no | Comma-separated list of @devicedetection properties to expose. Empty (default) = all properties entitled by the license. |
| `PROPERTIES_IP_INTELLIGENCE` | no | Comma-separated list of @ipintelligence properties to expose. Empty (default) = all entitled. |
| `PROPERTIES` | no | Fully-qualified `aspect.property` allow-list (and default) for the per-request `values` selector. Requires the `CloudV5Bespoke` product on the license. |
| `DISABLED_ELEMENTS` | no | Comma-separated list of pipeline elements to remove, e.g. `TacEngine,NativeEngine,RobotsTxtEngineBuilder`. |
| `IPI_CONCURRENCY` | no | Number of concurrent handles in the @ipintelligence engine pool (an unsigned integer). Raise this when peak request rates trigger "Insufficient handles available in the pool" errors. Default = `128`. Invalid or zero values fall back to the default. |
| `REGION_NAME` | no | Free-text region label returned in the `51D-Region` response header and from `/api/info`, and attached as the `region` label on exported telemetry (see Telemetry below). |
| `ASPNETCORE_URLS` | no | Override the in-container listen address/port (the image listens on `8080` by default). |
| `PipelineOptions__Elements__DidOnPremiseEngineBuilder__BuildParameters__IdDomain` | no | The domain embedded and cryptographically signed into every generated [51Did](@ref Identifiers_51Did). Defaults to `51d.es`. Override only if your 51Dids must be attributed to a different domain. |
| `PipelineOptions__Elements__CloudJavaScriptBuilderElement__BuildParameters__Host` | no | The host the generated client-side JavaScript calls back to. Default (unset) = the host the request arrived on (the forwarded `Host` header). Override only to force callbacks to a fixed host. |

> **Note on the 51Did signing domain:** every 51Did the container generates is
> stamped with, and signed under, a fixed domain (`51d.es` by default). This is a
> trust anchor established at startup, **not** the host your end users reach the
> container at - that is taken automatically from the request, so it needs no
> configuration. Override the domain only via the
> `PipelineOptions__Elements__DidOnPremiseEngineBuilder__BuildParameters__IdDomain`
> environment variable above.

> **Note on the JavaScript callback host:** the client-side JavaScript bundle
> refetches data from this container, and by default targets the host the
> original request arrived on (the `Host` header your reverse proxy forwards), so
> no configuration is needed as long as the proxy preserves that header. If you
> need callbacks to go to a fixed host instead, set it via the
> `PipelineOptions__Elements__CloudJavaScriptBuilderElement__BuildParameters__Host`
> environment variable above.

> **Note on restricting properties:** if you set `PROPERTIES_DEVICE_DETECTION`,
> keep the properties that other engines consume as input or the container will
> fail to start: `deviceid`, `TAC`, `NativeModel` (required by the 51Did engine)
> and `CrawlerName`, `CrawlerProductTokens`, `CrawlerUrl`, `CrawlerUsage`
> (required by the robots.txt engine), in addition to whatever you want to expose.

# Running

```{bash}
docker run -d --name 51d-cloud \
  -p 8080:8080 \
  -e LICENSE_KEYS=<your-license-key> \
  51degrees/cloud-private
```

The container listens on port `8080`. Run it behind your own reverse proxy / TLS
terminator, and make sure the proxy preserves the `Host` header - the client-side
JavaScript callback host is derived from it (see the note above).

# Verifying

```{bash}
# Service version
curl http://localhost:8080/api/info/version

# Properties available from your license
curl http://localhost:8080/api/v4/accessibleproperties

# Device detection + IP intelligence
curl "http://localhost:8080/api/v4/json?user-agent=Mozilla/5.0%20(iPhone)&client-ip=2.125.160.216"
```

Interactive API documentation is served at `http://localhost:8080/api-docs`.

# Telemetry

The container can push its own telemetry: metrics, logs and traces, each sent
over OTLP HTTP. This is off by default, and nothing ever goes to 51Degrees:
each signal is exported only when you enable the push and give that signal an
endpoint URL of your own.

- **Metrics** - request metrics from ASP.NET Core, and .NET runtime metrics
  such as CPU, memory, GC and thread pool usage.
- **Logs** - the service's log stream.
- **Traces** - a trace per handled request, with unhandled exceptions recorded
  on the span. A request that reaches pipeline processing also carries a
  `pipeline.process` child span with the resource key and the request evidence
  (headers, query values, client hints) as attributes, plus a client span for
  every outbound HTTP call the service makes. Evidence values that carry an IP
  address, an email address or hashing salt, a license key, or an
  `Authorization`/`Cookie` header are always exported as `[redacted]`,
  whatever the variables below say. Query string values on the server span are
  redacted by default; see the redaction variable below.

Every signal carries `node`, `region` and `provider` resource labels taken from
`INSTANCE_NAME`, `REGION_NAME` (see the table above) and `PROVIDER_NAME`, so
containers in a fleet can be told apart at the backend.

| Variable | Description |
| -------- | ----------- |
| `LogServices__OpenTelemetry__Enabled` | Master switch for the OTLP push. Defaults to `false`. |
| `LogServices__OpenTelemetry__MetricsEndpoint` | OTLP HTTP ingest URL for metrics. Metrics are exported only when this is set. |
| `LogServices__OpenTelemetry__LogsEndpoint` | OTLP HTTP ingest URL for logs. Logs are exported only when this is set. |
| `LogServices__OpenTelemetry__TracesEndpoint` | OTLP HTTP ingest URL for traces. Traces are exported only when this is set. |
| `LogServices__OpenTelemetry__Headers` | Headers sent with every OTLP export, as comma separated `key=value` pairs, e.g. `Authorization=Bearer <token>`. |
| `LogServices__OpenTelemetry__TracesSampleRatio` | Fraction of requests traced, between 0 and 1. Defaults to 1, which traces every request; keep it well below 1 in production, since sampling happens before the outcome of a request is known and the ratio is what bounds the volume of successful-request traces. |
| `LogServices__OpenTelemetry__TracesIncludeEvidence` | Set to `false` to drop the request evidence attributes from `pipeline.process` spans, for installations that must not keep request data in traces. Defaults to `true`. The `[redacted]` values described above stay redacted either way. |
| `OTEL_DOTNET_EXPERIMENTAL_ASPNETCORE_DISABLE_URL_QUERY_REDACTION` | Set to `true` to keep query string values in spans, so a caller's request can be reproduced from its trace. Redacted by default. |
| `INSTANCE_NAME` | `node` label on the exported telemetry, also returned in the `51D-Instance` response header. Defaults to the machine name. |
| `PROVIDER_NAME` | `provider` label on the exported telemetry, e.g. `hetzner`. No label is attached when unset. |

Any backend that accepts OTLP over HTTP works. This example points the three
signals at VictoriaMetrics, VictoriaLogs and VictoriaTraces:

```{bash}
docker run -d --name 51d-cloud \
  -p 8080:8080 \
  -e LICENSE_KEYS=<your-license-key> \
  -e LogServices__OpenTelemetry__Enabled=true \
  -e LogServices__OpenTelemetry__MetricsEndpoint=https://victoriametrics:8428/opentelemetry/v1/metrics \
  -e LogServices__OpenTelemetry__LogsEndpoint=https://victorialogs:9428/insert/opentelemetry/v1/logs \
  -e LogServices__OpenTelemetry__TracesEndpoint=https://victoriatraces:10428/insert/opentelemetry/v1/traces \
  -e "LogServices__OpenTelemetry__Headers=Authorization=Bearer <token>" \
  -e INSTANCE_NAME=node-1 \
  -e REGION_NAME=eu \
  -e PROVIDER_NAME=hetzner \
  51degrees/cloud-private
```

# Updating

Both the software and the data files ship inside the image, so updating either
means moving to a newer image:

- **Data files** - 51Degrees publishes a new `cloud-private` image daily, with
  refreshed data files as needed. Pull the latest (date-tagged) image and
  recreate the container to pick up newer data.
- **Software** - pull a newer `51degrees/cloud-private` image and recreate the container.

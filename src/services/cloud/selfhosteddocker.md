@page Services_Cloud_SelfHostedDocker Self-Hosted Docker

The 51Degrees Private Cloud is a self-hosted Docker container that runs the
51Degrees Cloud API entirely on your own infrastructure. It is **single-tenant**:
every request is authorized by the License Key(s) you start the container with.
There are no resource keys, and the container makes **no outbound calls** to
51Degrees services - no usage sharing and no entitlement/billing lookups.

For the API itself (endpoints, evidence, response format), see the interactive
documentation served by the running container at `/api-docs`.

# Prerequisites

- A container runtime (Docker, Podman, Kubernetes, …).
- The `51degrees/cloud-private` container image, supplied by 51Degrees. The
  image already contains the data files it needs (see Data Files below).
- One or more 51Degrees **License Keys** that entitle the products you need.

# Data Files

The data files are baked into the `51degrees/cloud-private` image at
`/app/data/assets`, so you do not need to supply or mount anything:

- `TAC-HashV41.hash` - Device Detection
- `51Degrees-EnterpriseIpiV41.ipi` - IP Intelligence

51Degrees ships a new image daily, with refreshed data files as needed, and
each image is tagged with its build date. To move to newer data, pull a newer
image (see Updating).

# Environment Variables

| Variable | Required | Description |
| -------- | -------- | ----------- |
| `LICENSE_KEYS` | **yes** | One or more 51Degrees License Keys (comma-separated). Determines the products and properties the container serves. |
| `PROPERTIES_DEVICE_DETECTION` | no | Comma-separated list of Device Detection properties to expose. Empty (default) = all properties entitled by the license. |
| `PROPERTIES_IP_INTELLIGENCE` | no | Comma-separated list of IP Intelligence properties to expose. Empty (default) = all entitled. |
| `PROPERTIES` | no | Fully-qualified `aspect.property` allow-list (and default) for the per-request `values` selector. Requires the `CloudV5Bespoke` product on the license. |
| `DISABLED_ELEMENTS` | no | Comma-separated list of pipeline elements to remove, e.g. `TacEngine,NativeEngine,RobotsTxtEngineBuilder`. |
| `IPI_CONCURRENCY` | no | Number of concurrent handles in the IP Intelligence engine pool (an unsigned integer). Raise this when peak request rates trigger "Insufficient handles available in the pool" errors. Default = `128`. Invalid or zero values fall back to the default. |
| `REGION_NAME` | no | Free-text region label returned in the `51D-Region` response header and from `/api/info`. |
| `ASPNETCORE_URLS` | no | Override the in-container listen address/port (the image listens on `8080` by default). |
| `PipelineOptions__Elements__DidOnPremiseEngineBuilder__BuildParameters__IdDomain` | no | The domain embedded and cryptographically signed into every generated 51Did. Defaults to `51d.es`. Override only if your 51Dids must be attributed to a different domain. |
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

```bash
docker run -d --name 51d-cloud \
  -p 8080:8080 \
  -e LICENSE_KEYS=<your-license-key> \
  51degrees/cloud-private
```

The container listens on port `8080`. Run it behind your own reverse proxy / TLS
terminator, and make sure the proxy preserves the `Host` header - the client-side
JavaScript callback host is derived from it (see the note above).

# Verifying

```bash
# Service version
curl http://localhost:8080/api/info/version

# Properties available from your license
curl http://localhost:8080/api/v4/accessibleproperties

# Device detection + IP intelligence
curl "http://localhost:8080/api/v4/json?user-agent=Mozilla/5.0%20(iPhone)&client-ip=2.125.160.216"
```

Interactive API documentation is served at `http://localhost:8080/api-docs`.

# Updating

Both the software and the data files ship inside the image, so updating either
means moving to a newer image:

- **Data files** - 51Degrees publishes a new `cloud-private` image daily, with
  refreshed data files as needed. Pull the latest (date-tagged) image and
  recreate the container to pick up newer data.
- **Software** - pull a newer `51degrees/cloud-private` image and recreate the container.

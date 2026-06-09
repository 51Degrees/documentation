@page IpIntelligence_Migration_IpInfo From IPInfo

The mapping below is based on the <a href="https://ipinfo.io/developers" rel="nofollow">published IPInfo API documentation</a> across the Lite, Core, Plus and Enterprise tiers, plus the standalone ASN, Privacy Detection, Hosted Domains, Carrier and Company products. Tier availability is IPInfo's, not 51Degrees; every property listed in the right-hand column is available from 51Degrees in a single response when the data file supports it.

Where a mapping is approximate, the **Notes** column calls it out. Where no equivalent exists, the cell is blank.

# Geolocation and network

| IPInfo field | 51Degrees property | Notes |
|--------------|--------------------|-------|
| `ip` | `Ip` / `IpV6` | Use `IpV6` for IPv6 input. |
| `hostname` |  | 51Degrees does not perform reverse DNS lookups. |
| `city` | `Town` | |
| `region` | `Region` | Use `State` for the higher-level administrative area where the two differ. |
| `region_code` | `Iso31662Lvl4SubdivisionOnly` | ISO 3166-2 subdivision code without the country prefix. Use `Iso31662Lvl4` for the full `CC-SUB` form. |
| `country` | `Country` | |
| `country_code` | `CountryCode` | 2-character ISO 3166-1 alpha-2. Use `CountryCode3` for alpha-3. |
| `continent` | `ContinentName` | |
| `continent_code` | `ContinentCode2` | |
| `postal` | `ZipCode` | |
| `loc` | `Latitude`, `Longitude` | IPInfo returns a single `"lat,long"` string; 51Degrees exposes each coordinate as a separate single-value property. See coordinate randomization note below. |
| `timezone` | `TimeZoneIana` | IANA identifier. `TimeZoneOffset` gives the UTC offset separately. |
| `radius` | `AccuracyRadiusMax` | IPInfo returns a location accuracy radius in kilometers. Use `AccuracyRadiusMin` for the inner-bound radius. See the `LocationConfidence` note below for the categorical confidence signal. |
| `org` | `Asn` + `AsnName` | IPInfo combines the ASN and organization name into one string (`"AS15169 Google LLC"`); 51Degrees exposes them separately. |
| `anycast` |  | No direct equivalent. |
| `bogon` |  | No direct equivalent. |

**Coordinate randomization**: 51Degrees randomizes `Latitude` and `Longitude` within around 1 km of the true average location for the IP range. The randomization is applied during data file generation, so the value returned for a given IP address is stable across all lookups against the same data file and only changes when a new data file is published. This guarantees the coordinates cannot be classified as personal data. No other property is affected. See [Randomization](@ref IpIntelligence_Features_Randomization).

**Location confidence**: 51Degrees rolls up location certainty into a single string-valued `LocationConfidence` property covering the town and country. IPInfo's `radius` field expresses accuracy as a numeric kilometer figure; the closest categorical 51Degrees equivalent is `LocationConfidence`, which complements the numeric `AccuracyRadiusMax` and `AccuracyRadiusMin` properties. See the [property dictionary](https://51degrees.com/developers/property-dictionary) for the set of possible values.

# ASN product

| IPInfo field | 51Degrees property | Notes |
|--------------|--------------------|-------|
| `asn` | `Asn` | IPInfo returns the `"AS####"` form; 51Degrees returns the integer. |
| `name` | `AsnName` | |
| `domain` |  | No direct equivalent. |
| `route` | `IpRangeStart` + `IpRangeEnd` | IPInfo returns CIDR notation; 51Degrees returns explicit start and end addresses. |
| `type` | `ConnectionType` | Approximate. IPInfo classifies ASN types (ISP, hosting, business, education); 51Degrees classifies the connection itself. |

# Privacy Detection

| IPInfo field | 51Degrees property | Notes |
|--------------|--------------------|-------|
| `vpn` | `IsVPN` | |
| `proxy` | `IsProxy` | |
| `tor` | `IsTor` | |
| `relay` |  | No direct equivalent. `IsHosted` is the closest signal that traffic does not originate from a residential user. |
| `hosting` | `IsHosted` | |
| `service` |  | No direct equivalent. |

# Mobile carrier

| IPInfo field | 51Degrees property | Notes |
|--------------|--------------------|-------|
| `mobile` (boolean) | `IsCellular` | |
| `carrier.name` |  | 51Degrees does not return the carrier brand name. |
| `carrier.mcc` | `Mcc` | Mobile country code. |
| `carrier.mnc` |  | Mobile network code is not exposed as a separate property. |

# Company, Hosted Domains, Abuse

| IPInfo field | 51Degrees property | Notes |
|--------------|--------------------|-------|
| `company.name` | `RegisteredOwner` | The closest equivalent. This is the registered owner of the network range. |
| `company.domain` |  | No direct equivalent. |
| `company.type` | `ConnectionType` | Approximate. |
| `domains.total`, `domains.domains[]` |  | 51Degrees does not list domains hosted on an IP. |
| `abuse.*` |  | 51Degrees does not return abuse contact details. |

# Properties unique to 51Degrees

The following 51Degrees properties have no IPInfo equivalent. They are the additional context that drives [accuracy weighting](@ref IpIntelligence_Features_Weighting), [country diversity](@ref IpIntelligence_Features_Countries) and bot detection.

- **Weighted country lists**: `CountryCodesGeographical`, `CountryCodesPopulation`, and their `*All` and `*Translated` variants return every candidate country with weightings, not a single best-guess. See [Countries](@ref IpIntelligence_Features_Countries).
- **Diversity scores**: `BrowserDiversity`, `HardwareDiversity`, `PlatformDiversity` quantify how varied the traffic from an IP range is. See [Diversity](@ref IpIntelligence_Features_Diversity).
- **Bot identification**: `IsCrawler`, `IsArtificialIntelligence`, `CrawlerName`, `CrawlerProductTokens`, `CrawlerUrl`, `CrawlerUsage`.
- **Human probability**: `HumanProbability` returns a score from 0 to 10. See [Human](@ref IpIntelligence_Features_Human).
- **Probabilistic identifiers**: `IdProbGlobal`, `IdProbLic`.

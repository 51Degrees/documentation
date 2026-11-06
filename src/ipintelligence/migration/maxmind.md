@page IpIntelligence_Migration_MaxMind From MaxMind

The mapping below uses MaxMind's <a href="https://dev.maxmind.com/geoip/docs/web-services/responses" rel="nofollow">GeoIP2 web service response schema</a> (Country, City, Insights, Enterprise, plus the standalone Anonymous IP, Connection Type, ISP and Domain databases). Nested fields are written in dot notation (`location.latitude`) to match MaxMind's documentation.

Where a mapping is approximate, the **Notes** column calls it out. Where no equivalent exists, the cell is blank.

# Continent, country, registered/represented country

| MaxMind field | 51Degrees property | Notes |
|---------------|--------------------|-------|
| `continent.code` | `ContinentCode2` | |
| `continent.names.{locale}` | `ContinentName` | 51Degrees returns the English name; localized names are not exposed as separate properties. |
| `continent.geoname_id` | `ContinentGeoNameId` |  |
| `country.iso_code` | `CountryCode` | Use `CountryCode3` for ISO 3166-1 alpha-3. |
| `country.names.{locale}` | `Country` | |
| `country.is_in_european_union` | `IsEu` | |
| `country.confidence` | `LocationConfidence` | MaxMind exposes confidence per geographic level (country, city, subdivision, postal); 51Degrees rolls them up into a single string-valued `LocationConfidence`. See the note below the City/postal/location table. |
| `country.geoname_id` | `CountryGeoNameId` |  |
| `registered_country.iso_code` | `RegisteredCountry` | |
| `registered_country.names.{locale}` | `RegisteredCountry` | 51Degrees returns the country only, not localized names. |
| `registered_country.geoname_id` | `RegisteredCountryGeoNameId` | |
| `represented_country.*` |  | 51Degrees does not separately model represented country (US military bases etc.). |

# Subdivision (state / region)

| MaxMind field | 51Degrees property | Notes |
|---------------|--------------------|-------|
| `subdivisions[0].iso_code` | `Iso31662Lvl4SubdivisionOnly` | Use `Iso31662Lvl4` for the `CC-SUB` form. |
| `subdivisions[0].names.{locale}` | `State` or `Region` | `State` for the higher-level subdivision (US states, UK countries); `Region` for the next level down. |
| `subdivisions[0].confidence` | `LocationConfidence` | See the note below the City/postal/location table. |
| `subdivisions[0].geoname_id` | `StateGeoNameId` | Use `StateGeoNameIdsGeographical` for every first-level subdivision that the location's area overlaps, weighted by its share of that area. |
| `subdivisions[1].names.{locale}` | `County` | Approximate. MaxMind lists subdivisions from largest to smallest, and a second one, where MaxMind returns it, is nearest to the second-level administrative area that 51Degrees returns as `County`. |
| `subdivisions[1].geoname_id` | `CountyGeoNameId` | Approximate, as for the name. |

# City, postal, location

| MaxMind field | 51Degrees property | Notes |
|---------------|--------------------|-------|
| `city.names.{locale}` | `Town` | |
| `city.confidence` | `LocationConfidence` | See the note below this table. |
| `city.geoname_id` | `TownGeoNameId` | 51Degrees gives the town or populated place nearest the location. |
| `postal.code` | `ZipCode` | |
| `postal.confidence` | `LocationConfidence` | See the note below this table. |
| `location.latitude` | `Latitude` | 51Degrees returns a single averaged value. See coordinate randomization note below. |
| `location.longitude` | `Longitude` | 51Degrees returns a single averaged value. See coordinate randomization note below. |
| `location.accuracy_radius` | `AccuracyRadiusMax` | Use `AccuracyRadiusMin` for the inner-bound radius. See the `LocationConfidence` note below for the categorical confidence signal that complements these radii. |
| `location.time_zone` | `TimeZoneIana` | `TimeZoneOffset` gives UTC offset separately. |
| `location.metro_code` |  | Deprecated by MaxMind; no 51Degrees equivalent. |
| `location.average_income` |  | No equivalent. |
| `location.population_density` |  | No equivalent. |

**Coordinate randomization**: 51Degrees randomizes `Latitude` and `Longitude` within around 1 km of the true average location for the IP range. The randomization is applied during data file generation, so the value returned for a given IP address is stable across all lookups against the same data file and only changes when a new data file is published. This guarantees the coordinates cannot be classified as personal data. No other property is affected. See [Randomization](@ref IpIntelligence_Features_Randomization).

**Location confidence**: 51Degrees rolls up location certainty into a single string-valued `LocationConfidence` property covering the town and country. Where MaxMind exposes a numeric `*.confidence` score on each geographic level (`country.confidence`, `city.confidence`, `subdivisions[0].confidence`, `postal.confidence`), the categorical 51Degrees equivalent is `LocationConfidence`, complemented by the numeric `AccuracyRadiusMax` and `AccuracyRadiusMin` properties for spatial precision. See the [property dictionary](https://51degrees.com/developers/property-dictionary) for the set of possible values.

# Traits (network and ASN)

| MaxMind field | 51Degrees property | Notes |
|---------------|--------------------|-------|
| `traits.ip_address` | `Ip` / `IpV6` | |
| `traits.network` | `IpRangeStart` + `IpRangeEnd` | MaxMind returns CIDR; 51Degrees returns explicit start and end addresses. |
| `traits.autonomous_system_number` | `Asn` | |
| `traits.autonomous_system_organization` | `AsnName` | |
| `traits.isp` | `AsnName` | 51Degrees does not separate ISP from AS organization. |
| `traits.organization` | `RegisteredOwner` | |
| `traits.domain` |  | No equivalent. |
| `traits.connection_type` | `ConnectionType` | Both classify Cable/DSL, Cellular, Corporate, Satellite, Hosting (51Degrees rolls hosting and anonymous into one category). `IsBroadband`, `IsCellular`, `IsHosted` give the same information as booleans. |
| `traits.mobile_country_code` | `Mcc` | |
| `traits.mobile_network_code` |  | Not exposed as a separate property. |
| `traits.is_anycast` |  | No equivalent. |
| `traits.user_type` |  | Approximate via `ConnectionType` plus `IsCellular` / `IsHosted`; no business / college / school classification. |
| `traits.user_count` |  | No equivalent. |
| `traits.static_ip_score` |  | No equivalent. |
| `traits.ip_risk_snapshot` |  | Differs in semantics. `HumanProbability` is the closest signal. It returns confidence from 0 to 10 that traffic is from a human rather than hosting or automated infrastructure. |

# Anonymizer (privacy / VPN)

| MaxMind field | 51Degrees property | Notes |
|---------------|--------------------|-------|
| `anonymizer.is_anonymous` | `IsVPN` \| `IsProxy` \| `IsTor` | MaxMind's umbrella flag; 51Degrees exposes each anonymizer type separately. |
| `anonymizer.is_anonymous_vpn` | `IsVPN` | |
| `anonymizer.is_hosting_provider` | `IsHosted` | |
| `anonymizer.is_public_proxy` | `IsProxy` | |
| `anonymizer.is_residential_proxy` | `IsProxy` | 51Degrees does not distinguish residential proxies from public proxies. |
| `anonymizer.is_tor_exit_node` | `IsTor` | |
| `anonymizer.confidence` |  | |
| `anonymizer.network_last_seen` |  | |
| `anonymizer.provider_name` |  | |

# Properties unique to 51Degrees

These additional properties describe IP ranges and location [weighting](@ref IpIntelligence_Features_Weighting), or support crawler detection.

- **Diversity scores**: `BrowserDiversity`, `HardwareDiversity`, `PlatformDiversity` quantify how varied the traffic from an IP range is. See [Diversity](@ref IpIntelligence_Features_Diversity).
- **Finer places**: `Suburb`, and `Iso31662Lvl8` and `Iso31662Lvl8SubdivisionOnly`, the ISO 3166-2 code of the OpenStreetMap level 8 area the location is in.
- **Area polygon**: `Areas` returns the area the IP range is likely to be in as a WKT string, trimmed to the land of the location's country so it does not reach into a neighboring country or over the sea.
- **Country information**: `CurrencyCode` (ISO 4217), `DialCode` (the ITU telephone country code) and `LanguageCode` (ISO 639).
- **Network**: `RegisteredName` is the name of the IP range, which is usually its owner, and `IsPublicRouter` says whether the address belongs to a public router.
- **Bot identification**, from Device Detection: `IsCrawler`, `IsArtificialIntelligence`, `CrawlerName`, `CrawlerProductTokens`, `CrawlerUrl`, `CrawlerUsage`.
- **Human probability**: `HumanProbability` returns a score from 0 to 10. See [Human](@ref IpIntelligence_Features_Human).
- **Probabilistic identifiers**, from 51Did: `IdProbGlobal`, `IdProbLic`.

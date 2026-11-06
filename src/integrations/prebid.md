@page Integrations_Prebid Prebid

# Prebid integration

51Degrees enriches OpenRTB bid requests with three streams of data: **Device Detection** properties, the **51Did** probabilistic device identifier, and **IP Intelligence** location signals. Together they let buyers target and value impressions more accurately, and recognise the same device across requests without cookies.

> **Try it.** To experiment with a simple Prebid OpenRTB transaction, use the [Prebid.js developer tool](https://51degrees.com/developers/prebid-js-demo). It runs a Prebid.js auction with the 51Degrees RTD module, for your own browser or a sample device, and shows the OpenRTB bid request before and after 51Degrees enriches it.

## What the integration provides

| Enrichment stream | Prebid.js RTD Module (client-side) | Prebid Server (server-side) |
|---|---|---|
| **Device Detection** - make, model, OS, screen, device ID | ✅ | ✅ |
| **51Did** - probabilistic device identifier | ✅ | - |
| **IP Intelligence** - IP address and geo | ✅ | - |

The client-side RTD module delivers all three streams. The server-side Prebid Server modules currently deliver device detection only.

## Implementation options

You can enrich bid requests in the browser or on your Prebid Server.

### Client-side Prebid.js RTD module

Use this when you want the full enrichment set (device, 51Did, IP Intelligence) and maximum device-detection accuracy. The module runs in the user's browser, can read JavaScript APIs for precise device identification (best for distinguishing Apple models), and calls cloud.51degrees.com to fetch the data.

**Setup:** [Prebid.js RTD Module Documentation](https://docs.prebid.org/dev-docs/modules/51DegreesRtdProvider.html)

**Resource Key properties.** Create the key at [configure.51degrees.com](https://configure.51degrees.com). To populate every field the RTD module writes, include:

- **Device Detection** (`device.*`): `DeviceId`, `DeviceType`, `HardwareVendor`, `HardwareName`, `HardwareNamePrefix`, `HardwareNameVersion`, `HardwareModel`, `PlatformName`, `PlatformVersion`, `ScreenPixelsHeight`, `ScreenPixelsWidth`, `ScreenPixelsPhysicalHeight`, `ScreenPixelsPhysicalWidth`, `ScreenInchesHeight`, `ScreenInchesWidth`, `PixelRatio`, `ThirdPartyCookiesEnabled`.
- **IP Intelligence** (`device.ip`, `device.geo.*`): `Latitude`, `Longitude`, `CountryCode3`, `Iso31662Lvl4`, `ZipCode`, `TimeZoneOffset`, `AccuracyRadiusMin`, `LocationConfidence`.
- **51Did** (`user.eids`): `IdProbLic`, `IdProbGlobal`. Issuing the 51Did for `standard` or `personalized` usage also needs a License Key that carries the 51Did product (see the 51Did section below).

### Server-side Prebid Server (Java and Go)

Use this when you need faster response times or want to centralize detection logic. Prebid Server currently adds **device detection** properties only. Both the Java and Go implementations share a single Prebid.org module documentation page: [Prebid Server 51Degrees Module Documentation](https://docs.prebid.org/prebid-server/pbs-modules/51degrees-device-detection.html)

## Enrichment streams

### Device properties

The modules detect the device from HTTP headers (and, client-side, JavaScript signals) and map the result onto the OpenRTB `device` object: `make`, `model`, `os`, `osv`, `hwv`, `h`, `w`, `pxratio`, `ppi`, and `devicetype`. A 51Degrees device ID is attached in an `ext` field that links to 250+ further properties in the [property dictionary](https://51degrees.com/developers/property-dictionary).

The device-ID field name currently differs by integration:

| Integration | Device-ID field | Extras |
|---|---|---|
| Prebid.js RTD Module | `device.ext.fod.deviceId` | `device.ext.fod.tpc` (whether third-party cookies are enabled in this browser session, 1 or 0) |
| Prebid Server (Java and Go) | `device.ext.fiftyonedegrees_deviceId` | - |

The RTD module additionally reports whether third-party cookies are enabled in the current browser session. The `ThirdPartyCookiesEnabled` property is mapped to `device.ext.fod.tpc` as `1` (third-party cookies are enabled in this browser session) or `0` (disabled), and is omitted when this is unknown. See @ref DeviceDetection_Features_ThirdPartyCookies for how the signal is detected.

For the full field-by-field mapping between OpenRTB and 51Degrees properties, see @ref Integrations_OpenRTBMappings.

### 51Did

The **51Did** is a signed, probabilistic 51Degrees device identifier (a base64 OWID envelope). It lets a buyer reconcile the same device across requests independently of cookies or IDFA, because it is derived from the device, IP, and declared usage purpose rather than from stored state. See @ref Identifiers_51Did for the identifier-versus-value distinction and the licensing model.

The RTD module surfaces the 51Did in the OpenRTB 2.6 `user.eids` array as a single source entry:

```json
{
  "user": {
    "eids": [
      {
        "inserter": "51degrees.com",
        "source": "51d.es",
        "mm": 5,
        "uids": [
          { "id": "AzUxZC5lcwBzGTMAJQAAAAHWTQ...", "atype": 1 },
          { "id": "AzUxZC5lcwCxHzMAJQAAAAHWTQ...", "atype": 1 }
        ],
        "ext": { "tdl": ["https://m4ow.uk/mtm/2.txt"] }
      }
    ]
  }
}
```

- `mm: 5` marks the match method as probabilistic.
- The two `uids` are the license-tier identifier (`idproblic`) and the global-tier identifier (`idprobglobal`), in that order.
- `ext.tdl` names the [Model Terms for Marketing](https://m4ow.uk/mtm/2.txt) on every entry, by the address of version 2, the version in force. When the `tdlUrl` module parameter is set, its address follows the Model Terms in the list.

The 51Did is delivered by the RTD module only. Issuing it for `standard` or `personalized` usage purposes needs a License Key that carries the 51Did product, and the `non-marketing` purpose is available in the free tier. See @ref Identifiers_51Did for licensing and @ref Identifiers_PMP for capturing the user's marketing preference that feeds `id.usage`.

### IP Intelligence

From the request IP the RTD module adds the IP address and, when confident, an approximate location to the `device` object:

- `device.ip` and `device.ipv6` are always set when available.
- `device.geo.*` (`lat`, `lon`, `country` as ISO-3166-1 alpha-3, `region` as ISO-3166-2, `zip`, `utcoffset`, `accuracy`) is set only when location confidence is high or medium. `device.geo.type` is `2` (IP-derived) and `device.geo.ipservice` is `511` (high confidence) or `512` (medium).

The RTD module adds IP and location data to the bid object. It does not add connection type, carrier/ISP, ASN, or MCC-MNC. [Contact us](https://51degrees.com/contact-us) if you need those fields. See @ref Integrations_OpenRTBMappings. See @ref IpIntelligence_Overview for the underlying IP data.

## Enriched bid request examples

### Client-side (RTD module) - full enrichment

```json
{
  "device": {
    "make": "Apple",
    "model": "iPhone 17 Pro Max",
    "os": "iOS",
    "osv": "18.6",
    "w": 1320,
    "h": 2868,
    "pxratio": 3.0,
    "ppi": 460,
    "devicetype": 1,
    "ip": "185.69.144.0",
    "geo": {
      "lat": 51.5,
      "lon": -0.12,
      "country": "GBR",
      "region": "GB-ENG",
      "zip": "EC1A",
      "utcoffset": 0,
      "accuracy": 50000,
      "type": 2,
      "ipservice": 511
    },
    "ext": {
      "fod": {
        "deviceId": "17595-131070-140777-18092",
        "tpc": 1
      }
    }
  },
  "user": {
    "eids": [
      {
        "inserter": "51degrees.com",
        "source": "51d.es",
        "mm": 5,
        "uids": [
          { "id": "AzUxZC5lcwBzGTMAJQAAAAHWTQ...", "atype": 1 },
          { "id": "AzUxZC5lcwCxHzMAJQAAAAHWTQ...", "atype": 1 }
        ],
        "ext": { "tdl": ["https://m4ow.uk/mtm/2.txt"] }
      }
    ]
  }
}
```

### Server-side (Prebid Server) - device detection only

```json
{
  "device": {
    "make": "Apple",
    "model": "iPhone 17 Pro Max",
    "os": "iOS",
    "osv": "18.6",
    "w": 1320,
    "h": 2868,
    "pxratio": 3.0,
    "devicetype": 1,
    "ext": {
      "fiftyonedegrees_deviceId": "17595-131070-140777-18092"
    }
  }
}
```

## Use cases

📰 **Publishers** can:
- Create device-specific ad placements and set floor prices by device capability.
- Analyze traffic by device type and approximate location.

🎯 **Advertisers** can:
- Target specific device models and serve the right creative format (video vs. static).
- Target specific geographic areas.
- Reconcile a device across requests with the 51Did, without cookies or IDFA.

⚙️ **Ad Tech Platforms** can:
- Build device- and geo-aware bidding algorithms.
- Use the 51Did to build cookieless audience segments and improve reporting.

## 💬 Support

- Technical questions: [support@51degrees.com](mailto:support@51degrees.com)
- Integration assistance available for custom implementations.
- Performance optimization guidance for high-volume scenarios.

@page DeviceDetection_WhatsNewV45 What's New in Version 4.5

# What's New in Version 4.5 of Device Detection

## Performance

- Optimized processing of @useragentclienthints, reducing lookup time.

## Graph Selection

- Removed `usePerformanceGraph` and `usePredictiveGraph` configuration options.  
  Detection now uses a single, unified predictive graph.

## Property Retrieval

- Added `propertyValueIndex` configuration option.  
  When `true`, property values are indexed at startup for faster retrieval.  
  See [Property Indexing](@ref DeviceDetection_Features_PerformanceOptions) for more details.

## New Evidence Keys

- Added support for alternative representations of User-Agent Client Hints via the following evidence keys (usable with `query.` and `cookie.` prefixes):
  - `51D_GetHighEntropyValues`: Base64-encoded JSON string from `JSON.stringify()` of the `getHighEntropyValues()` JavaScript call.
  - `51D_StructuredUserAgent`: Plain JSON string using the `device.sua` structure as defined in [OpenRTB 2.6](https://github.com/InteractiveAdvertisingBureau/openrtb2.x/blob/main/2.6.md#3229---object-useragent-).

  These keys are functionally equivalent to passing the following HTTP headers:
  - `Sec-CH-UA`
  - `Sec-CH-UA-Mobile`
  - `Sec-CH-UA-Platform`
  - `Sec-CH-UA-Model`
  - `Sec-CH-UA-Full-Version-List`
  - `Sec-CH-UA-Platform-Version`

  The conversion happens natively in the device detection engine, eliminating the need for
  additional pipeline elements. See the [UA-CH JavaScript page](@ref DeviceDetection_Features_UACH_Javascript)
  for detailed usage information.

## Results Serialization

- Introduced `ResultsHashSerializer` service class.  
  Enables retrieval of all detected property values as a single JSON-serialized string.  
  Previously, properties could only be accessed individually by key.

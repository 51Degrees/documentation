@page DeviceDetection_WhatsNewV45 What's New in Version 4.5 (Pre-release)

# What's New in Version 4.5 (Pre-release) of Device Detection

## Performance

- Optimized processing of @useragentclienthints, reducing lookup time.

## Graph Selection

- Removed `usePerformanceGraph` and `usePredictiveGraph` configuration options.  
  Detection now uses a single, unified predictive graph.

## Property Retrieval

- Added `propertyValueIndex` configuration option.  
  When `true`, property values are indexed at startup for faster retrieval.

## New Evidence Keys

- Added support for alternative representations of User-Agent Client Hints via the following evidence keys (usable with `query.` and `cookie.` prefixes):
  - `51d_gethighentropyvalues`: Base64-encoded JSON string from `JSON.stringify()` of the `getHighEntropyValues()` JavaScript call.
  - `51d_structureduseragent`: Plain JSON string using the `device.sua` structure as defined in [OpenRTB 2.6](https://iabtechlab.com/standards/openrtb/).
  
  These keys are functionally equivalent to passing the following HTTP headers:
  - `Sec-CH-UA`  
  - `Sec-CH-UA-Mobile`  
  - `Sec-CH-UA-Platform`  
  - `Sec-CH-UA-Model`  
  - `Sec-CH-UA-Full-Version-List`  
  - `Sec-CH-UA-Platform-Version`

## Results Serialization

- Introduced `ResultsHashSerializer` service class.  
  Enables retrieval of all detected property values as a single JSON-serialized string.  
  Previously, properties could only be accessed individually by key.

@page IpIntelligence_Features_Confidence Confidence

# Overview

IP location reliability varies. For example, a request routed through a data center proxy may not identify the user's location.

The `LocationConfidence` property should always be consulted before considering how to use results. Four values are provided: `High`, `Medium`, `Low`, and `Unknown`.

See the [IP Tester](https://51degrees.com/developers/ip-tester) to see how the `LocationConfidence` results vary for different IP addresses.

## Values

Always check the value of `LocationConfidence` when determining how to use IP Intelligence results.

- **High** confidence results can be relied upon and considered useful for all practical purposes.

- **Medium** confidence results might be useful where the use case can tolerate a degree of imprecision.

Discard **Low** or **Unknown** confidence results when making consequential decisions. Instead, ask the user to share their location through a device API such as GPS for reverse geocoding, or to enter their postal address.

See the [property dictionary](https://51degrees.com/developers/property-dictionary?item=Location%7CCoordinates%20Accuracy) for more information.

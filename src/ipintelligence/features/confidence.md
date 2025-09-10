@page IpIntelligence_Features_Confidence Confidence

# Overview

Many factors determine the reliability of IP Intelligence results. For example; a request from a data center that acts as a proxy for many countries might be completely useless for location identification.

The `LocationConfidence` property should always be consulted before considering how to use results. Three different values are provided; `High`, `Medium`, and `Low`.

See the [IP Tester](https://51degrees.com/developers/developers/ip-tester) to see how the `LocationConfidence` results vary for different IP addresses.

## Values

Always check the value of `LocationConfidence` when determining how to use IP Intelligence results.

- **High** confidence results can be relied upon and considered useful for all practical purposes.

- **Medium** confidence results might be useful where the use case can tolerate a degree of inaccuracy.

- **Low** or **Unknown** confidence results should be discarded when the results might be used to make consequential decisions. Instead of using the results consider asking the user to share their location via device APIs such as GPS and then using reverse geocoding, or enter their postal address manually. Subsequent processing may also be similar to handling an exception when obtaining the result.

See the [property dictionary](https://51degrees.com/developers/property-dictionary?item=Location%7CCoordinates%20Accuracy) for more information.

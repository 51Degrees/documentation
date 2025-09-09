@page IpIntelligence_Features_Area Area

# Overview

51Degrees understands that the real world isn't divided neatly into circles. That's why we offer irregular polygons that provide a geographic boundary within which the device associated with a given IP address is most likely to currently be located.

We also understand latitude and longitude coordinates and radiuses are the data points many users currently expect from legacy IP solutions.

See the [IP Tester](https://51degrees.com/developers/developers/ip-tester) to compare the two options.

## Circles

For those seeking to replace an existing IP solution, or run 51Degrees in parallel, we offer the legacy latitude and longitude properties together with a minimum (`AccuracyRadiusMin`) and maximum accuracy (`AccuracyRadiusMax`) radius. A circle.

The minimum accuracy radius appears to correspond most closely to other solutions results and is the value that is recommended to use for comparison.

See the [property dictionary](https://51degrees.com/developers/property-dictionary?item=Location%7CCoordinates%20Accuracy) for more information.

## Areas

But what if the geographic location isn't a circle? What if it's a triangle, or the outline of a town? A circle will contain more possible options than an irregular polygon. But an irregular bounding polygon will be much more specific eliminating geographic possibilities that are extremely unlikely.

We recommend upgrading from circles to the (`Areas`) property which returns a [Well Known Text](https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry) format vector geometry object.

Aggregated accurate location and IP address information from real devices is used to form a boundary within which we'd expect devices with a given IP address to be within. This information changes daily, so these boundaries can change all the time along with the most likely latitude and longitude within the bounding area.

See the [property dictionary](https://51degrees.com/developers/property-dictionary?item=Location%7CCoordinates%20Accuracy) for more information.

@page IpIntelligence_Features_Area Area

# Overview

We return irregular polygons that describe the geographic boundary within which a device associated with an IP address is most likely to be located.

We also understand latitude and longitude coordinates and radiuses are the data points many users currently expect from legacy IP solutions.

See the [IP Tester](https://51degrees.com/developers/ip-tester) to compare the two options.

## Circles

To compare with an existing IP solution, use latitude and longitude with a minimum radius (`AccuracyRadiusMin`) and a maximum radius (`AccuracyRadiusMax`).

We recommend using the minimum radius when comparing results with other solutions.

See the [property dictionary](https://51degrees.com/developers/property-dictionary?item=Location%7CCoordinates%20Accuracy) for more information.

## Areas

An irregular polygon can exclude geographic areas that a bounding circle would include.

We recommend upgrading from circles to the (`Areas`) property which returns a [Well Known Text](https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry) format vector geometry object.

We combine location and IP address information from real devices to form a boundary where we expect devices using an IP address to be located. This information changes daily, so both the boundary and the most likely coordinates within it can change.

See the [property dictionary](https://51degrees.com/developers/property-dictionary?item=Location%7CCoordinates%20Accuracy) for more information.

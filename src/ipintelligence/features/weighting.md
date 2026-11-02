@page IpIntelligence_Features_Weighting Weighting

# Overview

In some cases, there cannot be a certain answer when an IP address is used as @evidence. For example, the area associated with an IP address may cover more than one region of a country. In these cases, the IP intelligence engine returns the possible values with a weighting for each, ordered from the highest weighting to the lowest.

What a weighting measures depends on the property, and the property's definition in the [Property Dictionary](https://51degrees.com/developers/property-dictionary) says what it measures. For example, `StateGeoNameIdsGeographical` lists the regions, such as states or provinces, of the country the IP address is located in. The list holds each region that overlaps the area associated with the IP address, as the region's [GeoNames](https://www.geonames.org/) id, weighted by the region's share of that area. Regions covering less than 1% of the area are left out, at most the 20 largest are returned, and the weightings of the regions returned are scaled so they still add up to `1`. A weighting here is a share of the area, not a probability, so a region covering 5% of the area does not mean a 5% chance that the user is in that region.

For more details on how weightings are implemented, see the [specifications](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/features/weighted-values.md#).

# Usage

The weightings of all the values returned for a single property will always add up to `1`. If there is a single value, the weighting will be `1`. But if there are multiple values, they could be weighted in a number of ways. An even weighting of `0.5` and `0.5` means the two values carry an equal share of what the property measures, and a heavier weighting of `0.9` and `0.1` means the first value carries most of it. For `StateGeoNameIdsGeographical`, `0.9` and `0.1` are 90% and 10% of the area, not the chance that the user is in each region.

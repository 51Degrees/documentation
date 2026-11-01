@page IpIntelligence_Features_Weighting Weighting

# Overview

In some cases, there cannot be a certain answer when an IP address is used as @evidence. For example, the range an IP address is registered to may serve more than one town or country. In these cases, the IP intelligence engine returns the possible values with a weighting for each, ordered from the highest weighting to the lowest.

What a weighting measures depends on the property, and the property's definition in the [Property Dictionary](https://51degrees.com/developers/property-dictionary) says what it measures. The country lists are the main example. `CountryCodesGeographical` weights each country by its share of the area associated with the IP address, and `CountryCodesPopulation` by its share of the population living in that area. `StateGeoNameIdsGeographical` weights each first-level subdivision by its share of the area in the same way. These are shares, not probabilities, so a country covering 5% of the area is not a 5% probability that the user is in that country.

For more details on how weightings are implemented, see the [specifications](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/features/weighted-values.md#).

# Usage

The weightings of all the values returned for a single property will always add up to `1`. If there is a single value, the weighting will be `1`. But if there are multiple values, they could be weighted in a number of ways. An even weighting of `0.5` and `0.5` means the two values carry an equal share of what the property measures, and a heavier weighting of `0.9` and `0.1` means the first value carries most of it. For the country lists, `0.9` and `0.1` are 90% and 10% of the area, or of the population, not the chance that the user is in each country.

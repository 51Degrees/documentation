@page IpIntelligence_Features_Weighting Weighting

# Overview

In some cases, there cannot be a certain answer when an IP address is used as @evidence. For example, a range that an IP address is registered may serve more than one town. In these cases, the IP intelligence engine returns the possible values with a weighting, ordered by descending probability.

For more details on how weightings are implemented, see the [specifications](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/features/weighted-values.md#).

# Usage

The weightings of all the values returned for a single property will always add up to `1`. If there is a single value, the weighting will be `1`. But if there are multiple values, they could be weighted in a number of ways. An even weighting of `0.5` and `0.5` would indicate an even probability of both, or a heavier weighting of `0.9` and `0.1` would indicate it the first value is likely the best one to use.

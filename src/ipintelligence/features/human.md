@page IpIntelligence_Features_Human Human

# Overview

We score every usable IP address to indicate how likely it is to relate to a device being used by a human.

We do this using a mixture of data points including the declarations made by the IP registrant and observed traffic patterns associated with the IP address or range.

# Usage

The `HumanProbability` property returns a value between `1` and `10`. The value is our assessment as to the likelihood that the provided IP address relates to a human, or not. `1` means it is very unlikely to be a human, `10` highly likely.

See the [property dictionary](https://localhost:5002/developers/property-dictionary?item=Location%7CHuman%20Detection) for more information.

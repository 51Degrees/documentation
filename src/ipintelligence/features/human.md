@page IpIntelligence_Features_Human Human

# Overview

We score every usable IP address to indicate how likely it is to relate to a device being used by a human.

We do this using a mixture of data points including the declarations made by the IP registrant and observed traffic patterns associated with the IP address or range.

# Usage

The `HumanProbability` property returns a value from `0` to `10`, or `-1` when the probability is unknown. The value is our assessment of how likely it is that the IP address relates to a human. `0` to `3` means low confidence that it is a human, `4` to `6` medium confidence, and `7` to `10` high confidence.

See the [property dictionary](https://51degrees.com/developers/property-dictionary?item=Location%7CHuman%20Detection) for more information.

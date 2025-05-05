@page IpIntelligence_Overview IP Intelligence - Overview

# Introduction

By providing information on the network and location of the device being used to access your website, **IP intelligence** enables you to provide your users with the optimal online experience. 

If you're ready to get going with **IP intelligence**, follow the [quick start guide](@ref Quickstart_IpIntelligence) to get you up and running with just a few clicks. If you'd like to know more about how our solution works and some of its benefits over those of others, then carry on reading below.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/ip-intelligence-specification/README.md#)
for more technical details.

# How IP Intelligence Works

51Degrees IP intelligence solutions uses an IP address associated with a web request to identify the network which is being used, and the location
the device is connecting from.

The engine uses a patent applied for algorithm to produce and consume a data file specifically optimized for fast and small IP detection.

Using an IP address as @evidence, the IP intelligence engine matches the IP ranges which contain the IP, and return the following results:
- **network** - information on the officially registered IP range, e.g. the registered owner,
- **location** - information on the location in which the IP has been observed, e.g. the town.

There are cases where there is more than one possible value. For this reason, the IP intelligence engine gives all the possible
values, with a probability weighting. See [weighting feature](@ref IpIntelligence_Features_Weighting) for more info.

For general privacy, the latitude and longitude values returned by the engine are randomized.
See [randomization feature](@ref IpIntelligence_Features_Randomization) for more info.
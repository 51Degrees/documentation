@page IpIntelligence_Features_Diversity Diversity

# Overview

Diversity properties are used to express how many different @profiles for a specific @component are seen within an IP range. This can be used to make various conclusions about what traffic from a certain range is likely to be. A diversity can relate to any @component, an example is `HardwareDiversity`, which is the number of different hardware profiles. This is different from the number of unique physical devices, as there could be 2 of the same model smartphone.

Properties of this type have values between 0-10, where 0 indicates unknown, 1 is a low diversity, and 10 is high diversity.

If, for an IP range, there is an average of 1 profile per IP, then the diversity score would be 1. However, if there were 10 or more profiles per IP, the score would be 10. This is a slight simplification, but is generally accurate. Details of the full calculation are in the [calculation](#calculation) section.

# Properties

There are 3 diversity properties in the IP Intelligence product:

| Property | Description |
| -------- | ----------- |
| HardwareDiversity | Diversity of hardware models in an IP range e.g. `Samsung Galaxy 10`, `iPhone 16`. |
| BrowserDiversity | Diversity of browser (or app) name and version in an IP range e.g. `Chrome 137`, `Edge 120`. |
| PlatformDiversity | Diversity of OS name and version in an IP range e.g. `Windows 10`, `Android 16`. |

# Values

For a diversity property, the following values can be returned:

| Value | Description |
| ----- | ----------- |
| `0`   | There are no recent web events in this IP range to calculate a score. |
| `1`-`9` | This is the average number of unique profiles per IP in the IP range. |
| `10`  | The average number of unique profiles per IP in the range is `10` or above. |

The values are not the exact average number of unique profiles, as 2 forms of weighting are applied:

### Age Weight
While an event from the current day is counted as 1 event, events from previous days are also included when calculating the score. The older the event, the less it contributes.

This helps fill in data for ranges which see lower daily levels of traffic, while ensuring that profile changes across time do not affect the result.

### Consistency Weight
If we see 1 profile 1000 times for an IP, but another 5 profiles are seen only once each, this will not give a score of 6. This is because profiles where the count is below the average make a smaller contribution.

This helps to keep values for IPs like the example above low, where the majority of the events are for 1 profile. So values are a reflection of the distribution of traffic, not just the count.

# Calculation

The formula used to calculate diversity value for a single IP is:

![diversity-single](images/diversity-single.svg)

where each `p` is a profile (e.g. `Windows 10`), `Cp` is the number of events seen for that profile, and `C̅p` is average value of `Cp` for the IP.

This means that profiles with counts above the average are weighted more highly in the calculation than profiles with small contributions.

The value for an IP range is then the average Dx:

![diversity-sum](images/diversity-sum.svg)

or 

![diversity-range](images/diversity-range.svg)

The actual values of `Cp` are a weighted sample over time. So an event from today contributes `1` to the count, but an event from `n` days ago contributes `(M-n)/M` where `M` is the maximum number of days to include.

So `Cp` can be expressed as:

![count](count.svg)

and
![count-average](images/count-average.svg)

where the new part `Np` is the number of profiles

Meaning that the full equation is:

![diversity-complete](images/diversity-complete.svg)

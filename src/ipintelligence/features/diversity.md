@page IpIntelligence_Features_Diversity Diversity

# Overview

Diversity properties are used to express the uniqueness of devices seen on a network. This can indicate the likelihood of a network being a residential network, or something like a VPN or hosting provider.

Properties of this type have values between 0-10, where 0 indicates unknown, 1 is a low diversity, and 10 is high diversity.

If, for an IP range, there is an average of 1 device per IP, then the diversity score would be 1. However, if there were 10 or more devices per IP, the score would be 10. This is a slight simplification, but is generally accurate. Details of the full calculation are in the [calculation](#calculation) section.

# Properties

There are 3 diversity properties in the IP Intelligence product:

| Property | Description |
| -------- | ----------- |
| HardwareDiversity | Diversity of physical devices in an IP range e.g. `Samsung Galaxy 10`, `iPhone 16`. |
| BrowserDiversity | Diversity of browsers in an IP range e.g. `Chrome 137`, `Edge 120`. |
| PlatformDiversity | Diversity of OS platform in an IP range e.g. `Windows 10`, `Android 16`. |

# Values

For a diversity property, the following values can be returned:

| Value | Description |
| ----- | ----------- |
| `0`   | There are no recent web events in this IP range to give a score. |
| `1`-`9` | This is the average number of unique profiles per IP in the IP range (after weighting events for age and consistency). |
| `10`  | The average number of unique profiles per IP in the range is `10` or above. |

The values are not the exact average number of unique profiles, as 2 forms of weighting are applied:

### Age Weight
While an event from the current day is counted as 1 event, events from previous days are also included when calculating the score. The older the event, the less it contributes.

This helps fill in data for ranges which see lower daily levels of traffic, while ensuring that profile changes across time do not affect the result.

### Consistency Weight
If we see 1 device 1000 times for an IP, but another 5 device are seen only once each, this will not give a score of 6. This is because profiles where the count is below the average make a smaller contribution.

This helps to keep values for IPs like the example above low, where the majority of the events are for 1 profile. So values are a reflection of the distribution of traffic, not just the count.

# Calculation

The formula used to calculate diversity value for a single IP is:

$$
D_{x} = \sum_p{min\left(\frac{C_p}{\bar{C_p}},1\right)}
$$
where each $p$ is a profile (e.g. `Windows 10`), $C_p$ is the number of events seen for that profile, and $\bar{C_p}$ is average value of $C_p$ for the IP.

This means that profiles with counts above the average are weighted more highly in the calculation than profiles with small contributions.

The value for an IP range is then the average $D_x$:

$$
D = \frac{\sum_{x=0}^N{D_x}}{N}
$$
or
$$
D = \frac{\sum_{x=0}^N{\left(\sum_p{min\left(\frac{C_p}{\bar{C_p}},1\right)}\right)}}{N}
$$

The actual values of $C_p$ are a weighted sample over time. So an event from today contributes $1$ to the count, but an event from $n$ days ago contributes $\frac{M-n}{M}$ where $M$ is the maximum number of days to include.

So $C_p$ can be expressed as:

$$
C_p = \sum_i{\frac{M-n_i}{M}}
$$
and
$$
\bar{C_p} = \frac{\sum_{i,p}\frac{M_p - n_{i,p}}{M_p}}
{N_p}
$$

where the new part $N_p$ is the number of profiles

Meaning that the full equation is:

$$
D = \frac
    {\sum_{x=0}^N
        \left( 
            \sum_p min\left(\frac
                {\sum_i\frac{M_p-n_{p,i}}{M_p}}
                {\frac
                    {\sum_{i,p}\frac{M_p-n_{p,i}}{M_p}}
                    {N_p}}
            , 1\right)
        \right)}
    {N}
$$

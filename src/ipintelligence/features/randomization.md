@page IpIntelligence_Features_Randomization Randomization

# Overview

Latitude and longitude values returned by the IP intelligence engine are randomized. The point returned will always be within 1km of the original point.

Randomization occurs in the data generation process. Values returned from a specific data file will always be the same for a given IP address. A different data file will have slightly different values returned for latitude and longitude given the same IP address.

Randomization does not affect other values. For example, Town is the town indicated by the original coordinates.

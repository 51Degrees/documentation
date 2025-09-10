@page IpIntelligence_Features_Randomization Randomization

# Overview

Latitude and longitude values returned by the IP intelligence engine are randomized to ensure that the output data can never be classified as personal data. The point returned will always be within 1km of the original point.

Randomization occurs in the data generation process. Values returned from a specific data file will always be the same for a given IP address. A different data file will have slightly different values returned for latitude and longitude given the same IP address.

No other values are affected by this randomization. i.e. a value for the Town property will always be the town which the original coordinates indicate.

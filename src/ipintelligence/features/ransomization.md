@page IpIntelligence_Features_Randomization Randomization

# Overview

For general privacy, latitude and longitude values returned by the IP intelligence engine are randomized.
The randomization such that the point returned will be no more than 1km from the original point.

Randomization occurs at data file generation. So values returned from a single data file will always be the
same for a single piece of evidence. A new data file will have slightly different values returned for latitude
and longitude.

No other values are affected by this randomization. i.e. a value for the Town property will always be the town
which the original coordinates indicate.

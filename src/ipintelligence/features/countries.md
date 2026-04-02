@page IpIntelligence_Features_Countries Countries

# Overview

If an IP address is associated with an `Area`, this area can be broken down and associated with multiple countries. For example, an IP range may span a border region or serve multiple locations. In these cases, the IP intelligence engine returns possible country codes with weightings, ordered by descending probability.

# Properties

The countries properties can be found under the `Countries Information` catagory on the [property dictionary](https://51degrees.com/developers/property-dictionary?item=Location%7CCountries%20Information). 

## Weighted Properties

The weighted properties (`CountryCodesGeographical`, `CountryCodesPopulation`, etc.) return the most likely countries based on available evidence. The weightings indicate the probability of each country being the correct match.

## 'All' Properties

The 'All' properties (`CountryCodesGeographicalAll`, `CountryCodesPopulationAll`, etc.) return all possible country codes, not just the weighted ones. These are ordered by:

1. First, by their weighting descending (most likely first)
2. Then, any remaining codes alphabetically

This provides convenient access to the complete list of possible countries for an IP address, not just the most likely ones. As an example, this is effective for populating drop down lists on a webpage. 

## Country Names

The country name properties (`CountryNamesGeographical`, etc.) provide the English names corresponding to the country codes. These are useful for display purposes or when you need human-readable output instead of ISO country codes.

# Geographical vs Population Weighting

There are two weighting schemes available:

- **Geographical** - Based on the geographical area coverage of an IP address' likely area. This is useful for location-based targeting where proximity matters.

- **Population** - Based on population coverage. This considers the sum population attributed to different countries. This weighting tends to favour more densely populated areas / countries.

Choose the weighting that best fits your use case. For example, if an IP range were to be associated with two areas, one encompassing the UK and another encompassing Australia, `CountryCodesGeographical` would heavily favour Australia due to the larger land mass and `CountryCodesPopulation` would favour the UK due to a higher population count. 

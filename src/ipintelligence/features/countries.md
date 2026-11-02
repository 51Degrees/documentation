@page IpIntelligence_Features_Countries Countries

# Overview

IP Intelligence gives the country that the location of an IP address is in, and separately the country that the IP address range is registered in. The two can differ, because a range can be used outside the country it is registered in.

# Properties

The country properties can be found under the `Country Information` category on the [property dictionary](https://51degrees.com/developers/property-dictionary?item=Location%7CCountry%20Information).

- `CountryCode` and `CountryCode3` are the ISO 3166-1 alpha-2 and alpha-3 codes of the country the location is in, and `Country` is the country's name.
- `CountryGeoNameId` is the [GeoNames](https://www.geonames.org/) id of that country.
- `IsEu` says whether the country is in the European Union, `CurrencyCode` is the ISO 4217 code of its currency, and `DialCode` is its international dialing code.
- `RegisteredCountry` is the code of the country the IP address range is registered in, and `RegisteredCountryGeoNameId` is that country's GeoNames id.

For the regions within the country, `StateGeoNameIdsGeographical` lists each one with its share of the area, as the [Weighting](@ref IpIntelligence_Features_Weighting) page describes.

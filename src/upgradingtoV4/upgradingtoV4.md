@page UpgradingtoV4 Upgrading to Version 4

# Upgrading to 51Degrees Version 4

This guide details how current Version 3 customers of 51Degrees can upgrade to Version 4.

Version 4 is faster, has a smaller data file, and has an upgraded algorithm that allows better detection of new, different, and rare User-Agents.
Additionally, Version 4 has support for [Google's changes to the User-Agent](https://learnclienthints.com/) and the new 
[User-Agent Client Hints](https://51degrees.com/blog/updates-to-user-agent-client-hints-version-4-4) HTTP request header.

The steps to upgrade will vary depending on whether you are using our cloud or on-premise service.

## V3 Cloud users

Use our [Cloud Configurator](https://configure.51degrees.com/) to generate a new Resource Key. You can follow our 
@configuratorexplanation for a step by step guide. This Resource Key should contain all the properties you wish to collect data for – 
you can find a list of all the available properties on our [property dictionary](https://51degrees.com/developers/property-dictionary). 
Some advanced properties may require the purchase of a License Key. Sign up to one of our [pricing plans](https://51degrees.com/pricing) 
to be granted a 30-day free trial and a License Key.

If you are looking for User-Agent Client Hints support in the cloud, please follow the [User-Agent Client Hints documentation](@ref DeviceDetection_Features_UACH_Overview).

## V3 On-premise users

To access the Version 4 data files, you will need to purchase a License Key. Visit our [pricing](https://51degrees.com/pricing) page and
select the suitable plan for your needs. Alternatively, get in touch with [Sales](https://51degrees.com/contact-us) if you require any help.

Once you have received a License Key, you can use this to download a data file containing all the properties. You can 
[download the file manually](https://51degrees.com/developers/downloads) or set up [automatic data file updates](Features_AutomaticDatafileUpdates).

You can download the latest API packages for your programming language via our [downloads page](https://51degrees.com/developers/downloads)
or [GitHub](https://github.com/51Degrees).

Once you have obtained your new License Key and downloaded the latest API packages and data file, please visit our 
[Migration guide](@ref DeviceDetection_MigrationGuides_51DegreesV3) for the next steps.

If you are looking for User-Agent Client Hints support, please follow the [User-Agent Client Hints documentation](@ref DeviceDetection_Features_UACH_Overview).

## New customers

If you wish to get started with 51Degrees, check out our pricing page for an overview of all our pricing tiers. You can then follow the 
[Configurator guide](@configuratorexplanation) to get started in the cloud or our [on-premise documentation](https://51degrees.com/documentation/index.html).

Alternatively, get in touch with our [Sales](https://51degrees.com/contact-us) team and mention your use case – we will discuss the best solution for you.

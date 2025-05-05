@page UpgradingtoV4 Upgrading to Version 4

# Upgrading to 51Degrees Version 4

This guide details how current Version 3 customers of 51Degrees can upgrade to Version 4.

Version 4 is faster, has a smaller data file, and has an upgraded algorithm that allows better detection of new, different, and rare User-Agents.
Additionally, Version 4 has support for [Google's changes to the User-Agent](https://learnclienthints.com/) and the new 
[User-Agent Client Hints](https://51degrees.com/blog/updates-to-user-agent-client-hints-version-4-4) HTTP request header.

The steps to upgrade will vary depending on whether you are using our cloud or on-premise service.

<BR>

## V3 Cloud users <a href="#V3_Cloud">#</a> @anchor V3_Cloud

Use our [Cloud Configurator](https://configure.51degrees.com/) to generate a new Resource Key. You can follow our 
@configuratorexplanation for a step by step guide. This Resource Key should contain all the properties you wish to collect data for – 
you can find a list of all the available properties on our [property dictionary](https://51degrees.com/developers/property-dictionary). 
Some advanced properties may require the purchase of a License Key. Sign up to one of our [pricing plans](https://51degrees.com/pricing) 
to be granted a License Key.

If you are looking for User-Agent Client Hints support in the cloud, please follow the [User-Agent Client Hints documentation](@ref DeviceDetection_Features_UACH_Overview).

<BR>

## V3 On-premise users <a href="#V3_On_Prem">#</a> @anchor V3_On_Prem

If you wish to continue to use 51Degrees on-premise, you will need to purchase a License Key to access the Version 4 data files. Visit our [pricing](https://51degrees.com/pricing) page and
select the suitable plan for your needs. Alternatively, you may wish to use our [cloud service](@ref V3_Cloud), which can be called from the server via our APIs.

Once you have received a License Key after signing up for a pricing plan, you can use the key to download a data file for on-premise implementations that contains all the properties. You can 
[download the file manually](https://51degrees.com/developers/downloads) or set up [automatic data file updates](@ref Features_AutomaticDatafileUpdates).

You can download the latest API packages for your programming language via our [downloads page](https://51degrees.com/developers/downloads)
or [GitHub](https://github.com/51Degrees).

Once you have obtained your new License Key and downloaded the latest API packages and data file, please visit our 
[Migration guide](@ref DeviceDetection_MigrationGuides_51DegreesV3) for the next steps.

We also recommend enabling @usagesharing in your environment. This allows our machine learning algorithm to grow and therefore detect new and unique User-Agents quicker with 
higher levels of accuracy.

If you are looking for User-Agent Client Hints support, please follow the [User-Agent Client Hints documentation](@ref DeviceDetection_Features_UACH_Overview).

If you require any help upgrading, get in touch with [Sales](https://51degrees.com/contact-us).

<BR>

## New customers <a href="#New_Customers">#</a> @anchor New_Customers

If you wish to get started with 51Degrees, check out our [pricing](https://51degrees.com/pricing) page for an overview of all our pricing tiers. You can then follow the 
@configuratorexplanation to get started in the cloud or use our [on-premise documentation](https://51degrees.com/documentation/index.html).

Alternatively, get in touch with our [Sales](https://51degrees.com/contact-us) team and mention your use case. Please provide as much information as possible such as 
intended deployment method, programming language, and environment configuration as this will help us discuss the best solution for you.

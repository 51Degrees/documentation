@page Services_Configurator Creating a Resource Key

Access to the cloud service is controlled by a Resource Key, which you create for free at [51degrees.com/configure](https://51degrees.com/configure/). Paid properties and higher request limits come from a License Key, which comes with a subscription and is attached to the Resource Key when you create it, so the License Key itself never goes on a page. The difference between the two keys is set out on @ref Services_Cloud_ResourceKeys.

Choose the properties when you create a Resource Key. Its property list cannot be changed later. Create a new key if you need a different list.

For a comprehensive list of all available properties and their descriptions, see the [Property Dictionary](https://51degrees.com/developers/property-dictionary).

\htmlonly
<iframe src="https://player.vimeo.com/video/769426655" width="640" height="360" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe>
\endhtmlonly


## Step 1: Choose properties

Open [51degrees.com/configure](https://51degrees.com/configure/). It shows the complete list of properties, broken down by category and by vendor. Choose whichever properties you need for the query you are planning.

For example, if you intend to look up latitude and longitude data to get a country, using 51Degrees as the vendor, you can find the **Country** property by choosing **Location** on the left, then **location** again, then ticking **Country** with the 51D logo. Clicking on that **Country** key shows a description: "Country By 51Degrees: The name of the country that the supplied location is in." Descriptions are there to help you understand what each property means and whether you want to include it in your queries.

![](images/configurator-location-country.png)

Choose the properties you need before generating the Resource Key. You cannot change its property list later.

## Step 2: Review configuration

Some properties require a subscription to appear in query results, or for queries over a certain quota. The Review Configuration screen will inform you if a subscription License Key is required and allow you to secure your properties to specific domains, register for product updates, attach your new Resource Key to a subscription, and read and agree to the terms and conditions.

## Step 3: Implement

The Implement screen shows code examples with your new Resource Key already inserted. Copy and save the key from the Resource Key section before leaving Step 3. You cannot list the Resource Keys attached to an account or return to this step later.

![](images/configurator-implement-key.png)

Follow these three steps at [51degrees.com/configure](https://51degrees.com/configure/) and take the Resource Key from the Resource Key section in Step 3.

Make a note of that Resource Key and then continue following the @introduction.

# Displaying details for an existing Resource Key

If you have a Resource Key and need to establish which properties it has access to, you can construct a URL https://51degrees.com/configure/YOUR_RESOURCE_KEY. This will show Step 1 with the properties for this specific key already selected.

Continuing to Steps 2 or 3 creates a new Resource Key. It does not edit the existing key, because Resource Keys cannot be changed.

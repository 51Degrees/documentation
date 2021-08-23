@page Concepts_Configurator Configurator

# Obtaining a Resource Key

Access to API queries is controlled by a Resource Key, which is obtained from the Cloud Configurator.

When a Resource Key is created, you choose the properties that it will return from queries, and once these are set they cannot be changed. However, it is possible to create more keys, each tied to whichever properties you choose.

\htmlonly
<iframe src="https://player.vimeo.com/video/559586081" width="640" height="360" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe>
\endhtmlonly


## Step 1: choose properties

To obtain a key, visit the Configurator (link below). This will show the complete list of properties, broken down by category and by vendor. Choose whichever properties you need for the query you are planning.

For example, if you intend to look up latitude and longitude data to get a country, using 51Degrees as the vendor, then in the Configurator you can find the **country** key by choosing **Location** on the left, then **location** again, then ticking **Country** with the 51D logo. Clicking on that **Country** key shows a description: "Country By 51Degrees: The name of the country that the supplied location is in." Descriptions are there to help you understand what each key means and whether you want to include it in your queries.

![](images/configurator-location-country.png)

You should choose as many properties as you need here; once the key is generated, its list of permitted properties cannot be changed.

## Step 2: Review configuration

Some properties require a subscription to appear in query results, or for queries over a certain quota. The Review Configuration screen will inform you if a subscription License Key is required and allow you to secure your keys to specific domains, register for product updates, attach your new Resource Key to a subscription, and read and agree to the terms and conditions.

## Step 3: Implement

Finally your newly created Resource Key is available. The Implement screen shows code examples much like this documentation but with your new key in place, and allows you to copy the key itself from the Resource Key section. It is important that you record the key somewhere at this point; it is not possible to see a list of keys attached to an account, so once you have left Step 3 you cannot return to it.

![](images/configurator-implement-key.png)

Follow these three steps by visiting the configurator at [configure.51degrees.com](https://configure.51degrees.com/) and obtaining a Resource Key from the Resource Key section in step 3. 

Make a note of that key and then continue following the @quickstart.

# Displaying details for an existing resource key

If you have a resource key and need to establish which properties it has access to, you can construct a URL https://configure.51degrees.com/YOUR_RESOURCE_KEY. This will show Step 1 of the Configurator with the properties for this specific key already selected.

Beware: do not continue to steps 2 or 3. Doing this will not edit the properties attached to your resource key, since resource keys are immutable; instead, it wil create a new resource key.


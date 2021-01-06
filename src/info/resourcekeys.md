@page Info_ResourceKeys Resource Keys

A Resource Key grants your code access to the 51Degrees cloud APIs. A specific resource key has access to a particular set of properties which are chosen at key creation time and cannot be changed afterwards. The number of accesses authorised by a particular resource key is limited for free keys, or can be associated with your license key and thus your account.

To obtain a resource key, use the Cloud Configurator; instructions on how to use the Cloud Configurator to create a key while associating it with properties and your license key are part of the @configuratorexplanation, which describes the process in detail.

# Authorization errors

If you attempt to retrieve API values for which your resource key is not authorized, you may see errors similar to these:

`Property "country" not found in data for element "location". This is because your resource key does not include access to any properties under "location".`

`Property "state" not found in data for element "location". This is because your resource key does not include access to this property. Properties that are included for this key under "location" are javascript, town, country.`

As mentioned, all properties that a key is authorized to access must be chosen at key creation time. If you create a key with access to the `javascript`, `town`, and `country` properties under `location`, for example, and then try to access the `state` property of a geolocation retrieved from the cloud APIs, you will see the second error, above. (If the key in question has access to _no_ properties under `location`, you may see the first error instead.)

A key cannot have its list of properties changed, but you can follow the @configuratorexplanation to create a new different Resource Key which does have access to the properties you need.

# Seeing existing key authorized properties

The error message above should list the properties for which the used key is authorized, but you can also see the properties for a key you already have by constructing and visiting the URL https://configure.51degrees.com/YOUR_RESOURCE_KEY. This will show Step 1 of the Configurator with the properties for this specific key already selected.

Beware: do not continue to steps 2 or 3. Doing this will not edit the properties attached to your resource key, since resource keys are immutable; instead, it wil create a new resource key. 

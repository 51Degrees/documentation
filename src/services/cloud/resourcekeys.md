@page Services_Cloud_ResourceKeys Resource Keys

A Resource Key grants your code access to the 51Degrees Cloud APIs. A specific Resource Key has access to a particular set of properties which are chosen at key creation time and cannot be changed afterwards. The number of accesses authorized by a particular Resource Key is limited for free keys, or can be associated with your License Key and thus your account.

To obtain a Resource Key, use the Cloud Configurator; instructions on how to use the Cloud Configurator to create a key while associating it with properties and your License Key are part of the @configuratorexplanation, which describes the process in detail.

# Authorization errors

If you attempt to retrieve API values for which your Resource Key is not authorized, you may see errors similar to these:

`Property "country" not found in data for element "location". This is because your Resource Key does not include access to any properties under "location".`

`Property "state" not found in data for element "location". This is because your Resource Key does not include access to this property. Properties that are included for this key under "location" are javascript, town, country.`

As mentioned, all properties that a key is authorized to access must be chosen at key creation time. If you create a key with access to the `javascript`, `town`, and `country` properties under `location`, for example, and then try to access the `state` property of a geolocation retrieved from the cloud APIs, you will see the second error, above. (If the key in question has access to _no_ properties under `location`, you may see the first error instead.)

A Resource Key cannot have its list of properties changed, but you can follow the @configuratorexplanation to create a new different Resource Key which does have access to the properties you need.

# Failed to load aspect properties

If you attempt to create a cloud pipeline with properties for which your Resource Key is not authorized, you may see errors similar to these:

- Your Resource Key does not include access to any properties under the engine with key hardware that was added to the pipeline. For more details on Resource Keys, see our [explainer](/documentation/4.5/_services__cloud__resource_keys.html). Available engine data keys are: ['device']

- Failed to load aspect properties for element 'hardware'. This is because your Resource Key does not include access to any properties under 'hardware'. For more details on Resource Keys, see our [explainer](/documentation/4.5/_services__cloud__resource_keys.html).

This occurs when creating a Cloud Engine or Element and the Resource Key you provided is not authorized to access any properties associated with the Engine. 

First, check that you have selected properties that are supported by the Engine. The Cloud Service can be queried for all the [available properties](https://cloud.51degrees.com/api/metadata/properties). In the JSON response, the `Id` of each property is prefixed with the Engine or Element data key, the relevant key is shown in the error above. This will show you what property names can be selected. Next, check the @ref Seeing_existing_key_authorized_properties "existing properties in your Resource Key". If you find that the required properties are missing from your configuration then you will need to create a new Resource Key and include them.

A Resource Key cannot have its list of properties changed, but you can follow the @configuratorexplanation to create a new different Resource Key which does have access to the properties you need.

Second, if the above does not solve the issue then make sure that you are authorized to use the properties selected when creating the Resource Key. To do this, browse to Cloud service using 
your Resource Key: `%https://cloud.51degrees.com/api/v4/<resource_key>.json` (delete `<` and `>` when providing your Resource Key). You will see a response containing values for your configure properties like the following:

```json
{
  "device": {
    "ismobile": true,
    "priceband": null,
    "pricebandnullreason": "priceband is a paid feature. You need a licence key to retrieve data. Visit https://51degrees.com/pricing for details",
  },
  "hardware": {
    "profiles": null,
    "profilesnullreason": "profiles is a paid feature. You need a licence key to retrieve data. Visit https://51degrees.com/pricing for details"
  },
  ...
}
```

If you see any null reasons like `priceband is a paid feature. You need a licence key to retrieve data. Visit https://51degrees.com/pricing for details` then you do not have the required subscription to access the property. You can check the 51Degrees [Property Dictionary](https://51degrees.com/developers/property-dictionary) to see what subscription is required.

# Seeing existing key authorized properties {#Seeing_existing_key_authorized_properties}
Some of the error messages above will list the properties for which the used key is authorized, but you can also see the properties for a key you already have by constructing and visiting the URL https://configure.51degrees.com/YOUR_RESOURCE_KEY. This will show Step 1 of the Configurator with the properties for this specific key already selected.

Beware: continuing to steps 2 or 3 will not edit the properties attached to your Resource Key, since Resource Keys are immutable; instead, it will create a new Resource Key. 

# License-key-only callers

Most callers authenticate with a Resource Key, but you can also call the cloud with a License Key and no Resource Key. This suits server-to-server or verifier callers that do not want to create and manage Resource Keys. Only the json and js endpoints accept License-key-only requests; the other endpoints still require a Resource Key.

A Resource Key carries a property list chosen at creation time. A bare License Key does not, so a License-key-only caller must list the properties they want via the `values` parameter, supplied in any of these places (header first, then query, then form):

- Header: `X-51D-Values: device.ismobile,fodid.idprobglobal`
- Query string: `?values=device.ismobile,fodid.idprobglobal`
- Form body: `values=device.ismobile,fodid.idprobglobal`

The License Key itself follows the same order: the `X-51D-License-Key` header, then the `license` query parameter, then a `license` form field.

The `X-51D-*` headers are intended for server-to-server callers: the cloud service does not answer CORS preflight requests for them, so browsers will not send them cross-origin.

A License-key-only request with no `values` returns `400` and explains the requirement. See the [Property Dictionary](https://51degrees.com/developers/property-dictionary) for the properties available on your license.

With a Resource Key, `values` is optional: it narrows the response to a subset of the key's baked-in properties, and omitting it returns them all. A License-key-only caller must supply it, since there is no baked-in list to fall back to.

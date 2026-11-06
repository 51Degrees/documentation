@page Services_Cloud_ResourceKeys Resource Keys

The cloud service has two kinds of key, and they do different jobs.

- **A License Key** comes with a subscription. It proves what you have paid for, it is secret, and it stays on your servers.
- **A Resource Key** is created for free. It names the properties you want, it can have your License Keys attached to it, and it goes in your page or your code. Because the License Key is attached when the key is created, a page uses the Resource Key and never holds the License Key.

A Resource Key has access to a particular set of properties which are chosen at creation time and cannot be changed afterwards. The number of requests a Resource Key may make each month is limited for a free key, and comes from your subscription where a License Key is attached. Which calls count is on @ref Services_Cloud_Metering.

To create a Resource Key, with its properties and your License Key, follow the @configuratorexplanation.

# Authorization errors

If you attempt to retrieve API values for which your Resource Key is not authorized, you may see errors similar to these:

`Property "country" not found in data for element "location". This is because your Resource Key does not include access to any properties under "location".`

`Property "state" not found in data for element "location". This is because your Resource Key does not include access to this property. Properties that are included for this key under "location" are javascript, town, country.`

As mentioned, all properties that a key is authorized to access must be chosen at key creation time. If you create a key with access to the `javascript`, `town`, and `country` properties under `location`, for example, and then try to access the `state` property of a geolocation retrieved from the cloud APIs, you will see the second error, above. (If the key in question has access to _no_ properties under `location`, you may see the first error instead.)

To request different properties, follow the @configuratorexplanation to create a new Resource Key with the properties you need.

# Failed to load aspect properties

If you attempt to create a cloud pipeline with properties for which your Resource Key is not authorized, you may see errors similar to these:

- Your Resource Key does not include access to any properties under the engine with key hardware that was added to the pipeline. For more details on Resource Keys, see our [explainer](/documentation/4.5/_services__cloud__resource_keys.html). Available engine data keys are: ['device']

- Failed to load aspect properties for element 'hardware'. This is because your Resource Key does not include access to any properties under 'hardware'. For more details on Resource Keys, see our [explainer](/documentation/4.5/_services__cloud__resource_keys.html).

This occurs when creating a Cloud Engine or Element and the Resource Key you provided is not authorized to access any properties associated with the Engine. 

First, check that you have selected properties that are supported by the Engine. The Cloud Service can be queried for all the [available properties](https://cloud.51degrees.com/api/metadata/properties). In the JSON response, the `Id` of each property is prefixed with the Engine or Element data key, the relevant key is shown in the error above. This will show you what property names can be selected. Next, check the @ref Seeing_existing_key_authorized_properties "existing properties in your Resource Key". If you find that the required properties are missing from your configuration then you will need to create a new Resource Key and include them.

To request different properties, follow the @configuratorexplanation to create a new Resource Key with the properties you need.

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

# View properties authorized for an existing key {#Seeing_existing_key_authorized_properties}
Some of the error messages above will list the properties for which the used key is authorized, but you can also see the properties for a key you already have by constructing and visiting the URL https://configure.51degrees.com/YOUR_RESOURCE_KEY. This will show Step 1 with the properties for this specific key already selected.

Continuing to steps 2 or 3 creates a new Resource Key. It does not change the existing key's properties.

# Resource Keys and License Keys {#Resource_keys_and_license_keys}

A request can carry a Resource Key, a License Key, or both.

- **A Resource Key** authenticates the request and brings the properties and products set up on it. It is public, because it sits in the script tag of every page that uses it, and it can be restricted to named domains, which [the domains a Resource Key accepts](@ref Resource_key_domains) describes.
- **A License Key** is a server's credential and never goes in a page. It suits server-to-server and verifier callers that do not want to create and manage Resource Keys.
- **A License Key on its own** works on the routes a server calls, being json, js, accessible properties, the 51Did key, verify, verify context, verify full and redeem routes, the attestation route, and the OWID public-key route. On json and js it must name the properties wanted with `values`, because only a Resource Key carries a property list, and a request without `values` returns `400`. The other routes need no `values`, because they return the same fields every time.
- **Both together** are treated as the Resource Key's request, including any domain restriction, and the License Key adds its products on top. A server whose Resource Key is restricted to named domains sends no `Origin`, so it is refused even when it also sends a valid License Key. Such a server should send its License Key alone.

The service looks for each key in these places, in this order, and uses the first one it finds.

1. The `X-51D-Resource-Key` or `X-51D-License-Key` header.
2. The route, for a Resource Key only, as in `/api/v4/<resource_key>.json`.
3. The query string, `?resource=` or `?license=`.
4. The form body of a `POST`, `resource=` or `license=`.

The `values` parameter is read in the same order, from the header, then the query string, then the form body.

- Header: `X-51D-Values: device.ismobile,fodid.idprobglobal`
- Query string: `?values=device.ismobile,fodid.idprobglobal`
- Form body: `values=device.ismobile,fodid.idprobglobal`

With a Resource Key, `values` adds the named properties to the key's own set for that request, without changing the key, and a property the license does not entitle is still withheld. Omit it to get the key's own set. See the [Property Dictionary](https://51degrees.com/developers/property-dictionary) for the properties available on your license.

A page on another domain may send the `X-51D-Resource-Key` and `X-51D-Values` headers, because the service answers the browser's CORS preflight for them. It refuses a preflight for `X-51D-License-Key`, because a License Key is never placed in a page.

The 51Did redeem route needs the account's License Key where the account holds one, sent alone or beside the Resource Key, because the sealed result being redeemed is bound to that account.

# The domains a Resource Key accepts {#Resource_key_domains}

When you create a Resource Key you can name the domains it may be used from, or name none. The list cannot be changed afterwards, so a key for a new domain is a new key.

- **A key that names no domains** is accepted from any page and any server. Anyone who reads the key out of your page can use it, and every request they make counts against your monthly requests, so name the domains on a key that goes in a page, and keep a key that names no domains for a server.
- **A key that names domains** is accepted only from a request that says it came from one of them. The service reads the `Referer` header and, where there is none, the `Origin` header, and refuses any other request with `401` and a message naming the domain it rejected, which is [Resource Key not authorized on domain](@ref Resource_key_not_authorized_on_domain). A page that suppresses the `Referer` header, with `<meta name="referrer" content="no-referrer">` or an equivalent policy, sends neither header, so it is refused. A server sends neither header unless you add one, so a server uses a key that names no domains, sends an `Origin` header naming one of the key's domains, or sends its License Key alone as described above.

The check is the same on every endpoint that takes a Resource Key, except the PMP and ADI loaders, which carry the key in their address without checking it. The bundle request each loader then makes is checked.

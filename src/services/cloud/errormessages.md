@page Services_Cloud_ErrorMessages Error Messages

# Cloud error response messages

This page contains explainers for cloud error messages when using 51Degrees services.

### Continuous processing of unique User-Agents {#Continuous_processing_of_unique_User_Agents}
Continuous processing of unique User-Agents is limited. This is to limit the amount of offline processing that is performed using the 51Degrees Cloud service. You can resume making requests when the number of seconds in the `Retry-After` response header has elapsed. To find out more see the [cloud documentation](https://cloud.51degrees.com/api-docs/index.html)

### Evidence keys could not be determined {#Evidence_keys_could_not_be_determined}
Evidence keys for this Resource Key could not be determined. This could be caused by an invalid Resource Key or due to a lack of subscription. Please see the 51Degrees [Cloud Configurator](https://configure.51degrees.com/) to generate a new Resource Key. If you require a License Key, visit our [pricing page](https://51degrees.com/pricing) to sign up for a 51Degrees Cloud subscription.

### Internal server errors {#Internal_server_error}
There is an issue with the Cloud service. Check the @servicestatuspage for current outages.
If the problem persists then please create a new issue on our [cloud-issues GitHub](https://github.com/51Degrees/cloud-issues/issues) repository.

### Invalid License supplied {#Invalid_license_supplied}
The supplied License Key(s) do not contain any valid products for the 51Degrees Cloud service. The keys you have provided will be displayed in the error message returned from the service. Validate that these are the same keys found in your sign-up email. If the keys match, then please refer to our [pricing page](https://51degrees.com/pricing) to validate you have chosen the correct subscription.

### Invalid product {#Invalid_product}
The product(s) mentioned in the error message is invalid. Cross-reference this with the mapping in the @ref Product_to_subscription_mapping "product to subscription mapping" and check that you have access to the correct subscription by checking your sign-up email. Otherwise, please see our [pricing page](https://51degrees.com/pricing) for details.

### Location lookup error {#Location_lookup_error}
Could not perform reverse geo lookup. If the problem persists then please create a new issue on our [cloud-issues GitHub](https://github.com/51Degrees/cloud-issues/issues) repository.

### Location products missing {#Location_products_missing}
Your subscription does not contain the products required to access location properties. Check that you have access to the correct subscription by checking your sign-up email, otherwise see our [pricing page](https://51degrees.com/pricing) to sign up for a 51Degrees Cloud subscription with access to location.

### No properties associated with these products {#No_properties_associated_with_these_products}
This error means that there are no properties that are offered by the Cloud service which can be accessed by the available products that are defined by your License Keys. The error will list the available products, cross-reference this with the mapping in the @ref Product_to_subscription_mapping "product to subscription mapping" and the [property dictionary](https://51degrees.com/developers/property-dictionary).

### Non-unique properties requested {#Non_unique_property_requested}
A non-unique property has been requested; make sure that each property is only requested once and specify the property name in the format: `<product>.<property>` to avoid ambiguity, e.g., `device.ismobile` or `location.country`. This may occur when using the `values` parameter in requests to the Cloud service. Refer to the [cloud property metadata](https://cloud.51degrees.com/api/metadata/properties) for a list of valid properties IDs.

### Only add-on product provided {#Only_add_on_product_provided}
This product is an add-on to one of the plans outlined on the [pricing page](https://51degrees.com/pricing). The base subscription is licensed in a separate Licence Key. Ensure this Licence Key found in your sign-up email has been included when creating your Resource Key on the 51Degrees [Cloud Configurator](https://configure.51degrees.com/).

### Product to subscription mapping {#Product_to_subscription_mapping}
Some error messages from the 51Degrees Cloud service may list the products that are available in the request or the products that are required to resolve the error. These map to a subscriptions references on the @pricing page and the [property dictionary](https://51degrees.com/developers/property-dictionary).

### Products in subscription not valid {#Products_in_subscription_not_valid}
The products available in your subscription are not valid. Refer to the error message for products available in your subscription and cross reference this with the mapping in the @ref Product_to_subscription_mapping "product to subscription mapping". Check that you have access to the correct subscription by checking your sign-up email, otherwise, please see our [pricing page](https://51degrees.com/pricing) to sign up for a valid 51Degrees Cloud product.

### Products not associated with the Cloud service {#Products_not_associated_with_the_cloud_service}
There were no products available that are associated with the Cloud service. Refer to the error message for products available in your subscription and cross-reference this with the mapping in the @ref Product_to_subscription_mapping "product to subscription mapping". Check that you have access to the correct subscription by checking your sign-up email. If your subscription is not valid then please see our [pricing page](https://51degrees.com/pricing) for details on subscriptions for the Cloud service.

### Properties not available with this subscription {#Properties_not_available_with_this_subscription}
There are no available properties which are associated with the products determined in the request. Refer to the products listed in the original error message and the mapping in the @ref Product_to_subscription_mapping "product to subscription mapping", then visit the 51Degrees [property dictionary](https://51degrees.com/developers/property-dictionary) to see the table of available properties for your subscription.

### Referer or origin header not set {#Referer_or_Origin_header_not_set}
The Referer or Origin header has not been provided in the request. These headers are used to validate that the traffic has originated from a legitimate source. Make sure that the Referer or Origin header is set when making requests to the 51Degrees Cloud service. You can resume making requests when the number of seconds in the `Retry-After` response header has elapsed. If using one of the native pipeline APIs then you can use the `CloudRequestOrigin` setting in the Pipeline or Cloud Request Engine builder to specify the origin. Note that, as with all engine builder methods, this can also be specified in the configuration file.

### Requests have been blocked {#Requests_have_been_blocked}
Your requests to the service have been blocked. This is because the requests to the Cloud service have been found in breach of the terms of service and access to the service has been removed. For details, please review the 51Degrees [terms and policies](https://51degrees.com/terms).

### Request limit reached {#Request_limit_reached}
Your request limit has been reached for the provided Resource Key. To keep using the Cloud service, please see our [pricing page](https://51degrees.com/pricing) to upgrade your subscription and increase your monthly requests limit.

### Resource Key could not be retrieved {#Resource_key_could_not_be_retrieved}
There was an error when getting the details for the Resource Key provided in the request. If the problem persists then please create a new issue on our [cloud-issues GitHub](https://github.com/51Degrees/cloud-issues/issues) repository.

### Resource Key not authorized on domain {#Resource_key_not_authorized_on_domain}
This Resource Key is not authorized for use with the Referer or Origin domain. See the original error message for the disallowed domain. Please visit the 51Degrees [Cloud Configurator](https://configure.51degrees.com/) to update the permitted domains for your Resource Key. If using one of the native pipeline APIs, you can use the `CloudRequestOrigin` setting in the Pipeline or Cloud Request Engine builder to specify the origin. Note that, as with all engine builder methods, this can also be specified in the configuration file.

### Resource Key not recognized {#Resource_key_not_recognized}
The Resource Key provided in the request to the Cloud service was not recognized. Please visit the 51Degrees [Cloud Configurator](https://configure.51degrees.com/) to get a new Resource Key.

### Resource Key not valid {#Resource_key_not_valid}
The Resource Key provided in the request to the Cloud service is not valid. Please visit the 51Degrees [Cloud Configurator](https://configure.51degrees.com/) to create a new Resource Key.

### Resource Key required {#Resource_key_required}
A Resource Key is required to access the 51Degrees Cloud service. This contains your property configuration, preferences and subscriptions. Please visit the 51Degrees [Cloud Configurator](https://configure.51degrees.com/) to create a Resource Key. The key can be supplied as the `X-51D-Resource-Key` header, in the route, as the `resource=` query parameter, or as a `resource` form field. Alternatively, callers can authenticate with a License Key (`X-51D-License-Key`, `?license=`, or a `license` form field) together with a `values` list (see below).

### Sequence value invalid {#Sequence_value_invalid}
The value for the `sequence` parameter could not be parsed to an integer, make sure that the `sequence` value is an integer. If the problem persists then please create a new issue on our [cloud-issues GitHub](https://github.com/51Degrees/cloud-issues/issues) repository.

### Sequence value not found {#Sequence_value_not_found}
The value for the `sequence` parameter could not found. If the `sequence` parameter has been provided in the request, make sure that the value in is an integer. Otherwise, please create a new issue on our [cloud-issues GitHub](https://github.com/51Degrees/cloud-issues/issues) repo.

### Signing key date malformed {#Signing_key_date_malformed}
The `date` parameter on the OWID creator endpoint (`/owid/api/v3/creator?date=`) could not be parsed. It must be an unsigned 32-bit integer giving the number of minutes since `2020-01-01T00:00:00Z` (the OWID envelope's date encoding). Returned as HTTP `400`.

### Signing key date too old {#Signing_key_date_too_old}
The `date` supplied to the OWID creator endpoint predates the oldest signing key, so no key was active at that date. Returned as HTTP `404`. Supply a `date` that matches a 51Did you actually hold.

### Supplied Licenses do not contain any valid products {#Supplied_licenses_do_not_contain_any_valid_products}
The supplied License Key(s) do not contain any valid products for the 51Degrees Cloud service. Check that you have access to the correct subscription by checking your sign-up email. To validate your License Key(s), visit the 51Degrees [Cloud Configurator](https://configure.51degrees.com) and follow the steps to create a new Resource Key, providing your License Keys in the process. If the License Keys are not valid then please see our [pricing page](https://51degrees.com/pricing) for details on subscriptions for the Cloud service.

### There are no valid products {#There_are_no_valid_products}
The supplied License Key(s) do not contain any valid products for the 51Degrees Cloud service. Check that you have access to the correct subscription by checking your sign-up email. Otherwise, please see our [pricing page](https://51degrees.com/pricing) for details.

### Trial period expired {#Trial_period_expired}
Your trial period has expired. To keep using the Cloud service, please upgrade your subscription. See our [pricing page](https://51degrees.com/pricing) for details on subscriptions.

### Values required for license-key call {#Values_required_for_license_key_call}
This request authenticated with a License Key but did not list which properties to return. A bare License Key has no property list, so License-key callers must list the properties they want via `values`: the `X-51D-Values` header, the `?values=` query parameter, or a `values` form field. See the 51Degrees [Property Dictionary](https://51degrees.com/developers/property-dictionary) for the properties available on your license. Returns `400`.

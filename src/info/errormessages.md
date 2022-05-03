@page Info_ErrorMessages Error Messages

# Cloud Error Response Messages

This page contains explainers for cloud error messages when using 51Degrees services.

# Continuous processing of unique user agents @anchor Continuous_processing_of_unique_User_Agents	

Continuous processing of unique User Agents is limited. This is to limit the amount of offline processing that is performed using the 51Degrees Cloud service. You can resume making requests when the number of seconds in the `Retry-After` response header has elapsed. To find out more see the [cloud documentation](https://cloud.51degrees.com/api-docs/index.html)

# Evidence keys could not be determined @anchor Evidence_keys_could_not_be_determined	

Evidence keys for this Resource Key could not be determined. This could be caused by an invalid Resource Key or due to a lack of subscription. Please see the 51Degrees [Cloud Configurator](https://configure.51degrees.com/) to generate a new Resource Key. If you require a License Key, visit our [pricing page](https://51degrees.com/pricing) to sign up for a 51Degrees Cloud subscription.

# Internal server errors @anchor Internal_server_error

There is an issue with the Cloud service. Check the [service status page](http://stats.pingdom.com/qci12uolgufy) for current outages.
If the problem persists then please create a new issue on our [cloud-issues GitHub](https://github.com/51Degrees/cloud-issues/issues) repo.

# Invalid License supplied @anchor Invalid_license_supplied	

The supplied License Key(s) do not contain any valid products for the 51Degrees Cloud service. The keys you have provided will be displayed in the error message returned from the service. Validate that these are the same keys found in your sign-up email. If the keys match, then please refer to our [pricing page](https://51degrees.com/pricing) to validate you have chosen the correct subscription.

# Invalid product @anchor Invalid_product	

The product(s) mentioned in the error message is invalid. Cross reference this with the mapping in the @ref Product_to_subscription_mapping "product to subscription mapping" and check that you have access to the correct subscription by checking your sign-up email. Otherwise, please see our [pricing page](https://51degrees.com/pricing) for details.

# Location lookup error @anchor Location_lookup_error	

Could not perform reverse geo lookup. If the problem persists then please create a new issue on our [cloud-issues GitHub](https://github.com/51Degrees/cloud-issues/issues) repo.

# Location products missing @anchor Location_products_missing	

Your subscription does not contain the products required to access location properties. Check that you have access to the correct subscription by checking your sign-up email, otherwise see our [pricing page](https://51degrees.com/pricing) to sign up for a 51Degrees Cloud subscription with access to location.

# No properties associated with these products @anchor No_properties_associated_with_these_products	

This error means that there are no properties that are offered by the Cloud service which can be accessed by the available products that are defined by your License Keys. The error will list the available products, cross reference this with the mapping in the @ref Product_to_subscription_mapping "product to subscription mapping" and the [property dictionary](https://51degrees.com/developers/property-dictionary).

# Non-unique properties requested @anchor Non_unique_property_requested	

A non-unique property has been requested, make sure that each property is only requested once and specify the property name in the format: `<product>.<property>` to avoid ambiguity, e.g. `device.ismobile` or `location.country`. This may occur when using the `values` parameter in requests to the Cloud service. Refer to the [cloud property metadata](https://cloud.51degrees.com/api/metadata/properties) for a list of valid properties IDs.

# Only add-on product provided @anchor Only_add_on_product_provided	

This product is an add-on to one of the plans outlined on the [pricing page](https://51degrees.com/pricing). The base subscription is licensed in a separate Licence Key. Ensure this Licence Key found in your sign-up email has been included when creating your Resource Key on the 51Degrees [Cloud Configurator](https://configure.51degrees.com/)

# Product to subscription mapping @anchor Product_to_subscription_mapping

Some error messages from the 51Degrees Cloud service may list the products that are available in the request or the products that are required to resolve the error. These map to a subscriptions references on the [pricing page](https://51degrees.com/pricing) and the [property dictionary](https://51degrees.com/developers/property-dictionary). The following is a table which maps the product IDs to the Subscription name. If a Product ID is not listed here then it is not valid for use with the Cloud service.

|Product ID|Subscription(s)|
|-|-|
|CloudV4Free|Free (Cloud)|
|CloudV4Complete|Big, Bigger or Biggest|
|CloudV4TAC|Bespoke|

# Products in subscription not valid @anchor Products_in_subscription_not_valid	

The products available in your subscription are not valid. Refer to the error message for products available in your subscription and cross reference this with the mapping in the @ref Product_to_subscription_mapping "product to subscription mapping". Check that you have access to the correct subscription by checking your sign-up email, otherwise, please see our [pricing page](https://51degrees.com/pricing) to sign up for a valid 51Degrees Cloud product.

# Products not associated with the Cloud service @anchor Products_not_associated_with_the_cloud_service	

There were no products available that are associated with the Cloud service. Refer to the error message for products available in your subscription and cross reference this with the mapping in the @ref Product_to_subscription_mapping "product to subscription mapping". Check that you have access to the correct subscription by checking your sign-up email. If your subscription is not valid then please see our [pricing page](https://51degrees.com/pricing) for details on subscriptions for the Cloud service.

# Properties not available with this subscription @anchor Properties_not_available_with_this_subscription	

There are no available properties which are associated with the products determined in the request. Refer to the products listed in the original error message and the mapping in the @ref Product_to_subscription_mapping "product to subscription mapping", then visit the 51Degrees [property dictionary](https://51degrees.com/developers/property-dictionary) to see the table of available properties for your subscription.

# Referer or origin header not set @anchor Referer_or_Origin_header_not_set	

The Referer or Origin header has not been provided in the request. These headers are used to validate that the traffic has originated from a legitimate source. Make sure that the Referer or Origin header is set when making requests to the 51Degrees Cloud service. You can resume making requests when the number of seconds in the `Retry-After` response header has elapsed. If using one of the native pipeline APIs then you can use the `CloudRequestOrigin` setting in the Pipeline or Cloud Request Engine builder to specify the origin. See the API documentation on how to set the header: [coming soon].

# Requests have been blocked @anchor Requests_have_been_blocked

Your requests to the service have been blocked. This is because the requests to the Cloud service have been found in breach of the terms of service and access to the service has been removed. For details, please review the 51Degrees [terms and policies](https://51degrees.com/terms).

# Request limit reached @anchor Request_limit_reached	

Your request limit has been reached for the provided Resource Key. To keep using the Cloud service, please see our [pricing page](https://51degrees.com/pricing) to upgrade your subscription and increase your monthly requests limit.

# Resource Key could not be retrieved @anchor Resource_key_could_not_be_retrieved	

There was an error when getting the details for the Resource Key provided in the request. If the problem persists then please create a new issue on our [cloud-issues GitHub](https://github.com/51Degrees/cloud-issues/issues) repo.

# Resource Key not authorized on domain @anchor Resource_key_not_authorized_on_domain	

This Resource Key is not authorized for use with the Referer or Origin domain. See the original error message for the disallowed domain. Please visit the 51Degrees [Cloud Configurator](https://configure.51degrees.com/) to update the permitted domains for your Resource Key or leave blank to allow usage on all domains. If using one of the native pipeline APIs then you can use the `CloudRequestOrigin` setting in the Pipeline or Cloud Request Engine builder to specify the origin. See the API documentation on how to set the header: [coming soon].

# Resource Key not recognized @anchor Resource_key_not_recognized	

The Resource Key provided in the request to the Cloud service was not recognized. Please visit the 51Degrees [Cloud Configurator](https://configure.51degrees.com/) to get a new Resource Key.

# Resource Key not valid @anchor Resource_key_not_valid	

The Resource Key provided in the request to the Cloud service is not valid. Please visit the 51Degrees [Cloud Configurator](https://configure.51degrees.com/) to create a new Resource Key.

# Resource Key required @anchor Resource_key_required	

A Resource Key is required to access the 51Degrees Cloud service. This contains your property configuration, preferences and subscriptions. Please visit the 51Degrees [Cloud Configurator](https://configure.51degrees.com/) to create a Resource Key.

# Sequence value invalid @anchor Sequence_value_invalid	

The value for the `sequence` parameter could not be parsed to an integer, make sure that the `sequence` value is an integer. If the problem persists then please create a new issue on our [cloud-issues GitHub](https://github.com/51Degrees/cloud-issues/issues) repo.

# Sequence value not found @anchor Sequence_value_not_found	

The value for the `sequence` parameter could not found. If the `sequence` parameter has been provided in the request, make sure that the value in is an integer. Otherwise, please create a new issue on our [cloud-issues GitHub](https://github.com/51Degrees/cloud-issues/issues) repo.

# Supplied Licenses do not contain any valid products @anchor Supplied_licenses_do_not_contain_any_valid_products	

The supplied License Key(s) do not contain any valid products for the 51Degrees Cloud service. Check that you have access to the correct subscription by checking your sign-up email. To validate your License Key(s), visit the 51Degrees [Cloud Configurator](https://configure.51degrees.com) and follow the steps to create a new Resource Key, providing your License Keys in the process. If the License Keys are not valid then please see our [pricing page](https://51degrees.com/pricing) for details on subscriptions for the Cloud service.

# There are no valid products @anchor There_are_no_valid_products	

The supplied License Key(s) do not contain any valid products for the 51Degrees Cloud service. Check that you have access to the correct subscription by checking your sign-up email. Otherwise, please see our [pricing page](https://51degrees.com/pricing) for details.

# Trial period expired @anchor Trial_period_expired	

Your trial period has expired. To keep using the Cloud service, please upgrade your subscription. See our [pricing page](https://51degrees.com/pricing) for details on subscriptions.
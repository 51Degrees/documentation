@page Info_ErrorMessages Error Messages

This page contains explainers for error messages when using 51Degrees services. 

# Product to Subscription Mapping @anchor Product_to_subscription_mapping

Some error messages from the 51Degrees Cloud Service may list the products that are available in the request or the products that are required to resolve the error. These map to a subscriptions references on the [pricing page](https://51degrees.com/pricing) and the [property dictionary](https://51degrees.com/developers/property-dictionary). The following is a table which maps the product IDs to the Subscription name. If a Product ID is not listed here then it is not valid for use with the Cloud Service.

|Product ID|Subscription(s)|
|-|-|
|CloudV4Free|Free (Cloud)|
|CloudV4Complete|Big, Bigger or Biggest|
|CloudV4TAC|Bespoke|
|CloudV4DigitalElementLocation|Digital Element Add-On|


# Internal Server Errors @anchor Internal_server_error

There is an issue with the Cloud Service. Check the [service status page](http://stats.pingdom.com/qci12uolgufy) for current outages.
If the problem persists then please create a new issue on our [cloud-issues Git Hub](https://github.com/51Degrees/cloud-issues/issues) repo.

# Request Have Been Blocked @anchor Requests_have_been_blocked

Your requests to the service have been blocked. This is because the requests to the cloud service have been found in breach of the terms of service and access to the service has been removed. For details, please review the 51Degrees [terms and policies](https://51degrees.com/terms). 

# Invalid License Supplied @anchor Invalid_license_supplied	

The supplied license key(s) do not contain any valid products for the 51Degrees cloud service. The keys you have provided will be displayed in the error message returned from the service. Validate that these are the same keys found in your sign-up email. If the keys match, then please refer to our [pricing page](https://51degrees.com/pricing) to validate you have chosen the correct subscription. 

# Properties Not Available with this Subscription @anchor Properties_not_available_with_this_subscription	

There are no available properties which are associated with the products determined in the request. Refer to the products listed in the original error message and the mapping in the @ref Product_to_subscription_mapping "product to subscripion mapping", then visit the 51Degrees [property dictionary](https://51degrees.com/developers/property-dictionary) to see the table of available properties for your subscription.

# Non-unique Properties Requested @anchor Non_unique_property_requested	

A non-unique property has been requested, make sure that each property is only requested once and specify the property name in the format: `<product>.<property>` to avoid ambiguity, e.g. `device.ismobile` or `location.country`. This may occur when using the `values` parameter in requests to the cloud service. Refer to the [cloud property metadata](https://cloud.51degrees.com/api/metadata/properties) for a list of valid properties IDs.

# No Properties Associated with these Products @anchor No_properties_associated_with_these_products	

This error means that there are no properties that are offered by the cloud service which can be accessed by the available products that are defined by your license keys. The error will list the available products, cross reference this with the mapping in the @ref Product_to_subscription_mapping "product to subscription mapping" and the [property dictionary](https://51degrees.com/developers/property-dictionary).



# Supplied Licenses Do Not Contain Any Valid Products @anchor Supplied_licenses_do_not_contain_any_valid_products	

The supplied license key(s) do not contain any valid products for the 51Degrees cloud service. Check that you have access to the correct subscription by checking your sign-up email. To validate your license key(s), visit the 51Degrees [Cloud Configurator](https://configure.51degrees.com) and follow the steps to create a new Resource Key, providing your license keys in the process. If the license keys are not valid then please see our [pricing page](https://51degrees.com/pricing) for details on subscriptions for the Cloud Service.

# Request Limit Reached @anchor Request_limit_reached	

Your request limit has been reached for the provided Resource Key. To keep using the cloud service, please see our [pricing page](https://51degrees.com/pricing) to upgrade your subscription and increase your monthly requests limit.

# Trial Period Expired @anchor Trial_period_expired	

Your trial period has expired. To keep using the cloud service, please upgrade your subscription. See our [pricing page](https://51degrees.com/pricing) for details on subscriptions.

# Products Not Associated With the Cloud Service @anchor Products_not_associated_with_the_cloud_service	

There were no products available that are associated with the cloud service. Refer to the error message for products available in your subscription and cross reference this with the mapping in the @ref Product_to_subscription_mapping "product to subscription mapping". Check that you have access to the correct subscription by checking your sign up email. If your subscription is not valid then please see our [pricing page](https://51degrees.com/pricing) for details on subscriptions for the Cloud Service.

# Products in Subscription Not Valid @anchor Products_in_subscription_not_valid	

The products available in your subscription are not valid. Refer to the error message for products available in your subscription and cross reference this with the mapping in the @ref Product_to_subscription_mapping "product to subscription mapping". Check that you have access to the correct subscription by checking your sign-up email, otherwise, please see our [pricing page](https://51degrees.com/pricing) to sign up for a valid 51Degrees Cloud product.

# There Are No Valid Products @anchor There_are_no_valid_products	

The supplied license key(s) do not contain any valid products for the 51Degrees cloud service. Check that you have access to the correct subscription by checking your sign-up email. Otherwise, please see our [pricing page](https://51degrees.com/pricing) for details. 

# Invalid Product @anchor Invalid_product	

The product(s) mentioned in the error message is invalid. Cross reference this with the mapping in the @ref Product_to_subscription_mapping "product to subscription mapping" and check that you have access to the correct subscription by checking your sign-up email. Otherwise, please see our [pricing page](https://51degrees.com/pricing) for details.

# Only Add On Product Provided @anchor Only_add_on_product_provided	

This product is an add-on to one of the plans outlined on the [pricing page](https://51degrees.com/pricing). The base subscription is licensed in a separate licence key. Ensure this licence key found in your sign-up email has been included when creating your resource key on the 51Degrees [Cloud Configurator](https://configure.51degrees.com/)

# Referer or Origin Header Not Set @anchor Referer_or_Origin_header_not_set	

The Referer or Origin header has not been provided in the request. These headers are used to validate that the traffic has originated from a legitimate source. Make sure that the Referer or Origin header is set when making requests to the 51Degrees cloud service. You can resume making requests when the number of seconds in the `Retry-After` response header has elapsed. If using one of the native pipeline APIs then you can use the `CloudRequestOrigin` setting in the Pipeline or Cloud Request Engine builder to specify the origin. See the API documentation on how to set the header: [coming soon].

# Continuous Processing of Unique User-Agents @anchor Continuous_processing_of_unique_User_Agents	

Continuous processing of unique user agents is limited. This is to limit the amount of offline processing that is performed using the 51Degrees cloud service. You can resume making requests when the number of seconds in the `Retry-After` response header has elapsed. To find out more see the [cloud documentation](https://cloud.51degrees.com/api-docs/index.html)

# Resource Key Not Valid @anchor Resource_key_not_valid	

The Resource Key provided in the request to the Cloud Service is not valid. Please visit the 51Degrees [Cloud Configurator](https://configure.51degrees.com/) to create a new Resource Key.

# Resource Key Not Recognized @anchor Resource_key_not_recognized	

The Resource Key provided in the request to the Cloud Service was not recognized. Please visit the 51Degrees [Cloud Configurator](https://configure.51degrees.com/) to get a new Resource Key.

# Resource Key Could Not Be Retrieved @anchor Resource_key_could_not_be_retrieved	

There was an error when getting the details for the Resource Key provided in the request. If the problem persists then please create a new issue on our [cloud-issues Git Hub](https://github.com/51Degrees/cloud-issues/issues) repo.
# Resource Key Not Authorized On Domain @anchor Resource_key_not_authorized_on_domain	

This resource key is not authorized for use with the Referer or Origin domain. See the original error message for the disallowed domain. Please visit the 51Degrees [Cloud Configurator](https://configure.51degrees.com/) to update the permitted domains for your resource key or leave blank to allow usage on all domains. If using one of the native pipeline APIs then you can use the `CloudRequestOrigin` setting in the Pipeline or Cloud Request Engine builder to specify the origin. See the API documentation on how to set the header: [coming soon].

# Location Products Missing @anchor Location_products_missing	

Your subscription does not contain the products required to access location properties. Check that you have access to the correct subscription by checking your sign-up email, otherwise see our [pricing page](https://51degrees.com/pricing) to sign up for a 51Degrees Cloud subscription with access to location.

# Location Lookup Error @anchor Location_lookup_error	

Could not perform reverse geo lookup. If the problem persists then please create a new issue on our [cloud-issues Git Hub](https://github.com/51Degrees/cloud-issues/issues) repo.

# Resource Key Required @anchor Resource_key_required	

A Resource Key is required to access the 51Degrees Cloud Service. This contains your property configuration, preferences and subscriptions. Please visit the 51Degrees [Cloud Configurator](https://configure.51degrees.com/) to create a Resource Key.

# Evidence Keys Could Not Be Determined @anchor Evidence_keys_could_not_be_determined	

Evidence keys for this resource key could not be determined. This could be caused by an invalid Resource Key or due to a lack of subscription. Please see the 51Degrees [Cloud Configurator](https://configure.51degrees.com/) to generate a new resource key. If you require a license key, visit our [pricing page](https://51degrees.com/pricing) to sign up for a 51Degrees cloud subscription.

# Sequence Value Invalid @anchor Sequence_value_invalid	

The value for the `sequence` parameter could not be parsed to an integer, make sure that the `sequence` value is an integer. If the problem persists then please create a new issue on our [cloud-issues Git Hub](https://github.com/51Degrees/cloud-issues/issues) repo.

# Sequence Value Not Found @anchor Sequence_value_not_found	

The value for the `sequence` parameter could not found. If the `sequence` parameter has been provided in the request, make sure that the value in is an integer. Otherwise, please create a new issue on our [cloud-issues Git Hub](https://github.com/51Degrees/cloud-issues/issues) repo.

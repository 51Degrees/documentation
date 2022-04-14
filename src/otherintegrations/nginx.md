@page OtherIntegrations_Nginx Nginx

# Introduction

We have also integrated our Device Detection to Nginx. This page describes in detail how you can install and use our module in your Nginx environment.
# Prerequisites

## Dependencies:
* gcc
* make
* zlib1g-dev
* libpcre3
* libpcre3-dev

## Tested versions:
* Nginx 1.21.3, 1.20.0, 1.19.0, 1.19.5, 1.19.10
* C11 or above

## Tested platforms:
* Ubuntu 18.04
* Ubuntu 20.04

## Tested architectures:
* 64-bit

# Installing
If you haven’t already, you can obtain a copy of the latest version of the API [here](https://github.com/51Degrees/device-detection-nginx).

To build the module only, run the following command. This will output to `ngx_http_51D_module.so` in the `build/modules` directory.
```
make module
```
<br>

To build the module and Nginx, run the following command.
```
make install
```
By default, this will use the latest version of Nginx specified in the Makefile. To use a specific version of Nginx, run the above command with the `FIFTYONEDEGREES_NGINX_VERSION` variable. e.g.
```
make install FIFTYONEDEGREES_NGINX_VERSION=[Version]
```
<br>

To build and link the module statically with Nginx, use the `STATIC_BUILD` variable. e.g.
```
make install STATIC_BUILD=1
```
<br>

Finally, run the 51Degrees tests with the default 51Degrees Lite data file included in the `device-detection-cxx\device-detection-data` directory. Make sure to build the module with `make install` command as the tests do not work on a static build.
```
make test
```

To run the 51Degrees together with the Nginx test suite, run the following command:
```
make test-full
```

These do not run all the required tests as some tests require properties that are not supported with the Lite version of the data file. To run all tests, obtain a data file that provides properties: JavascriptHardwareProfile, ScreenPixelsWidthJavascript and ScreenPixelsWidth. Then, use the `FIFTYONEDEGREES_DATAFILE` variable to specify the file name to run the tests with. The new data file should be placed in the `device-detection-cxx\device-detection-data` folder and should have a different name to `51Degrees-LiteV4.1.hash`. If tests still fail, obtain a data file with any other properties used in the tests. Below is an example of running tests with a different data file named `51Degrees-EnterpriseV4.1.hash`:
```
make [test|test-full] FIFTYONEDEGREES_DATAFILE=51Degrees-EnterpriseV4.1.hash
```

# Configuring the Nginx API

Before you start performing any detections, you may wish to configure the detection.

## Init Settings
Detection configuration directives.

|Directives|
|---------|
|Syntax: `51D_file_path` *filename*;<br>Default: ---<br>Context: main<br>Specify the data file to used for 51Degrees Device Detection V4 engine|
|Syntax: `51D_drift` *drift*;<br>Default: 51D_drift 0;<br>Context: main<br>Specify the `drift` value that a detection can allow. Details about how setting `drift` value effects the results can be found at [False Positive](@ref DeviceDetection_Features_FalsePositiveControl).|
|Syntax: `51D_difference` *difference*;<br>Default: 51D_difference 0;<br>Context: main<br>Specify the `difference` value that a detection can allow. Details about how setting `difference` value effects the results can be found at [False Positive](@ref DeviceDetection_Features_FalsePositiveControl).|
|Syntax: `51D_allow_unmatched` *on \| off*;<br>Default: 51D_allow_unmatched off;<br>Context: main<br>Specify if `AllowUnmatched` should be allowed. Details about how setting `AllowUnmatched` value effects the results can be found at [False Positive](@ref DeviceDetection_Features_FalsePositiveControl).|
|Syntax: `51D_use_performance_graph` *on \| off*;<br>Default: 51D_use_performance_graph off;<br>Context: main<br>Specify if performance graph should be used in detection. More details about `performance graph` can be found at [Hash](@ref DeviceDetection_Hash).|
|Syntax: `51D_use_predictive_graph` *on \| off*;<br>Default: 51D_use_predictive_graph on;<br>Context: main<br>Specify if predictive graph should be used in detection. More details about `predictive graph` can be found at [Hash](@ref DeviceDetection_Hash).|
|Syntax: `51D_value_separator` *separator*;<br>Default: 51D_value_separator ',';<br>Context: main<br>Specify the separator to be used in the value string returned from a detection. Each value in the returned result string corresponds to a requested property.|
## Match settings
Match directives.

|Directives|
|---------|
|Syntax: `51D_match_single` *header* *properties* \[*argument*\];<br>Default: ---<br>Context: main, server, `location` (**NOTE**: This directive can be used in main, server and location blocks. Specified properties are aggregated and eventually queried in the location. *header* value is set after the query is performed and is only available within `location` block)<br>Perform a detection using a single request header `User-Agent`. *header* specifies which request header the returned *properties* values should be stored at. *properties* is a comma separated list string. *argument* specifies if `User-Agent` is supplied as a query argument. This will override the value in the `User-Agent` header. The *argument* is optional.<br>If a property is not available for any reason, the value being returned for that property will be `NA`|
|Syntax: `51D_match_all` *header* *properties*;<br>Default: ---<br>Context: main, server, `location` (**NOTE**: This directive can be used in main, server and location blocks. Specified properties are aggregated and eventually queried in the location. *header* value is set after the query is performed and is only available within `location` block)<br>Perform a detection using all headers, query argument and cookie from a http request. *header* specifies which request header the returned *properties* values should be stored at. *properties* is a comma separated list string.<br>If a property is not available for any reason, the value being returned for that property will be `NA`|
|Syntax: `51D_get_javascript_single` *javascript_property* \[*argument*\];<br>Default: ---<br>Context: location<br>Perform a detection using a single request header `User-Agent`. The returned value of *javascript_property* is set in the response body. This works in a similar way as CDN to serve static content. *argument* specifies if `User-Agent` is supplied as a query argument. This will override the value in the `User-Agent` header. The *argument* is optional.<br>If the Javascript property is not available for any reason, a Javascript block comment will be returned so that it will not cause syntax error when the client s it.<br>The whole response body is used for the returned content so only one of these directives can be used in a single location block. Also, since the static content does not actually exist as a static file, the nginx http core module will log an error, so it is recommended to use this directive with [log_not_found](http://nginx.org/en/docs/http/ngx_http_core_module.html#log_not_found) set to off.|
|Syntax: `51D_get_javascript_all` *javascript_property*;<br>Default: ---<br>Context: location<br>Perform a detection using all headers, cookie and query arguments from a http request. The returned value of *javascript_property* is set in the response body. This works in a similar way as CDN to serve static content.<br>If the Javascript property is not available for any reason, a Javascript block comment will be returned so that it will not cause syntax error when the client executes it.<br>The whole response body is used for the returned content so only one of these directives can be used in a single location block. Also, since the static content does not actually exist as a static file, the nginx http core module will log an error, so it is recommended to use this directive with [log_not_found](http://nginx.org/en/docs/http/ngx_http_core_module.html#log_not_found) set to off.|
|Syntax: `51D_set_resp_headers` *on \| off*;<br>Default: 51D_set_resp_headers  off<br>Context: main, server, location<br>Allow Client Hints to be set in response headers where it is applicable to the user agent (e.g. Chrome 89 or above) so that more evidence can be returned in subsequent requests, allowing more accurate detection. Value set in a block overwrites values set in precedent blocks (e.g. value set in `location` block will overwrite value set in `server` and `main` blocks). This will only be available from the 4.3.0 version onwards.|

# New features
Following set of new features has been introduced in Nginx Device Detection V4 module:
- Detection match metrics
- Javascript and property overrides
- False Positive controls
- User Agent Client Hint supports

## Detection match metrics
This V3 functionality is extended with more options available in V4. These metrics can be used in the same way as the properties.
```
51D_match_all x-metrics IsMobile,Iterations,Drift,Difference,Method,UserAgents,MatchedNodes,DeviceId;
```

## Javascript and property overrides

Some certain properties might require further steps to obtain. For example, to determine ScreenPixelsWidth, users might need to execute the Javascript returned from ScreenPixelsWidthJavascript property in client User-Agents. In V4, we allow users to request the Javascript as static content via using `51D_get_javascript_single` and `51D_get_javascript_all` directives.

Once the value has been obtained by executing the Javascript in client user agent, it can be added as evidence in the next request's cookie or query argument. 51Degrees module will override the returned value with what it found in the request.

## False Positive Controls

Nginx Device Detection V4 module supports `False Positives` features as described at [False Positives](@ref DeviceDetection_Features_FalsePositiveControl) via settings of directives `51D_drift`, `51D_difference` and `51D_allow_unmatched`. When `AllowUnmatched` is set to `off`, if `HasValue` is `false`, a `NoMatch` will be returned. Else, if `AllowUnmatched` is set to `on`, when a match can not be found, default profile will be returned such as `Unknown`, `N/A` or similar.

## User Agent Client Hint supports

User Agent Client Hint was introduced by Google in Chrome, preventing traditional detection using User-Agent from performing accurate matches. In Nginx Device Detection V4 module, `51D_set_resp_headers` was implemented to allow Client Hint request headers to be set in responses so that more evidence is provided in subsequent requests, allowing better matches.

# Other resources
More details can be found at:
- [README](https://51degrees.com/device-detection-nginx/md__home_vsts_work_1_s_apis_device-detection-nginx__r_e_a_d_m_e.html).
- [Examples](https://51degrees.com/device-detection-nginx/examples.html)
- [Migrations](@ref DeviceDetection_MigrationGuides_51DegreesV3)

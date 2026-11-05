@page DeviceDetection_OtherIntegrations_Varnish Varnish

# Introduction
Use our Varnish module to run Device Detection in Varnish. This page explains installation and configuration.

# Prerequisites

See our @testedversions page for tested versions and platforms.

# Installing
If you haven’t already, you can obtain the latest version of the API from the [51degrees-varnish repository](https://github.com/51Degrees/51degrees-varnish).
To install on a Linux system, run the following commands from the project's root directory.

```
$ ./autogen.sh
$ ./configure --with-config=release|test
$ make
$ sudo make install
```

Where `--with-config [optional]` sets the version of the module that you want to build. Defaults to release. To run all the tests, you will need to use the `test` option.

If your Varnish source is not installed at the standard location (i.e., `/usr/local/include/varnish`), you can adjust this by setting the environment variable `VARNISHSRC [optional]` to point to the correct location. For example, if you have installed Varnish source via package manager, it will be located at `/usr/include/varnish`. Then, you will need to set `VARNISHSRC` to `/usr/include/varnish` for the installation to succeed. If you want to install the module to a location of your choice, you can also set it via `VMOD_DIR [optional]`.

Finally run the included tests. You will need to make sure that the module is built with `test` option.

```
$ make check
```

# Configuring the Varnish API

Before you start matching User-Agents, you may wish to configure the solution to use a different data set for example, or to use a certain performance profile.

## Init settings
These settings are used in the vcl_init and should only be set once.

|Setting|Default|Description|
|---|---|---|
|fiftyonedegrees.start                    |N/A           |Starts the 51Degrees module using the dataset path provided. All other 51Degrees init options must be set before calling this.|
|fiftyonedegrees.set_performance_profile  |DEFAULTS      |Set the performance profile that controls memory allocation and data access. Set it before other configuration fields, because it sets their defaults. Later field settings override these defaults.|
|fiftyonedegrees.set_drift                |0             |Set the drift value to allow sub strings to be matched in a wider range of character positions.|
|fiftyonedegrees.set_difference           |0             |Set the difference value to allow User-Agents which are slightly different to what is expected.|
|fiftyonedegrees.set_allow_unmatched      |NO            |Set whether the unmatched node should be used. `NO` means if there are no matched results, an empty string will be returned for the required property. A default string will be returned if `YES` is set.|
|fiftyonedegrees.set_use_performance_graph|NO            |Set whether performance optimized graph should be used. Deprecated since version 4.5. The performance graph is now an alias of the predictive graph, so this setting does not change the results.|
|fiftyonedegrees.set_use_predictive_graph |YES           |Set whether predictive optimized graph should be used|
|fiftyonedegrees.set_max_concurrency      |0             |Set the expected concurrent requests that will be handled|
|fiftyonedegrees.set_delimiter            |“,”           |Set the delimiter to separate values with|
|fiftyonedegrees.set_properties           |All properties|Set the properties to initialize|

## Match settings
These settings are valid in client-side subroutines, such as vcl_recv and vcl_deliver, and any number can be set.

|Setting|Description|
|---|---|
|fiftyonedegrees.match_single|Gets device properties using a User-Agent. Takes a User-Agent and a comma separated list of properties to return.|
|fiftyonedegrees.match_all	 |Gets device properties using multiple HTTP headers. Takes comma separated list of properties to return.|

For full documentation, use
```
$ man vmod_fiftyonedegrees
```

## User-Agent Client Hints

To enable client-hint matching, add the set_resp_headers to the vcl_deliver block. This adds the Accept-CH header to the response if it is supported by the browser. The client-hint headers sent by the browser are then automatically used by the match_all method.
```
sub vcl_deliver {
    # Enable client-hints
    fiftyonedegrees.set_resp_headers();
    # Use the match_all as above.
    set resp.http.X-IsMobile = fiftyonedegrees.match_all("IsMobile");
}
```

# New features
Use match metadata to assess detection results. See the [false positive controls page](@ref DeviceDetection_Features_FalsePositiveControl) for details.

Use this metadata in the same way as device properties:
```
set req.http.X-IsMobileX = fiftyonedegrees.match_all("IsMobile,Iterations,Drift,Difference,Method,UserAgents,MatchedNodes,DeviceId");
```

`HasValue` is also supported in Varnish. Whether a property has values or not is indicated by a return of an empty string in the returned list. A message, detailing the reason will also be printed out.


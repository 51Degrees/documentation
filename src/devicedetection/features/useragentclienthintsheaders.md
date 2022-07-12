@page DeviceDetection_Features_UserAgentClientHintsHeaders User Agent Client Hints Headers

# Introduction

To return device information via [User Agent Client Hints](@ref DeviceDetection_Features_UserAgentClientHints), there are two methods you can follow.

One is using the [51Degrees ClientHints properties](https://51degrees.com/developers/property-dictionary?item=WebBrowserandApps%7CClientHints) which contain the Accept-CH HTTP header values to add to the HTTP response.

Alternatively, you can bypass the [51Degrees ClientHints properties](https://51degrees.com/developers/property-dictionary?item=WebBrowserandApps%7CClientHints) by providing @evidence via the User Agent Client hints headers. 

# Supplying the User Agent Client Hints headers as evidence

There are multiple UA-CH headers available, but not all of them require @evidence; some are optional.

The below table details which of UA-CH headers require @evidence values in order to return device component information. 

0 = This value is required in order to determine the component 
1/2 = One of these values are required. Supplying 1 will enable a more accurate result and removes the need to supply 2.

|UA-CH header|Hardware|Platform|Browser/App|
|---|---|---|---|
|Sec-CH-UA|||2|
|Sec-CH-UA-Version|||| 
|Sec-CH-UA-Full-Version-List|||1|
|Sec-CH-UA-Model|0|||
|Sec-CH-UA-Mobile|0||0|
|Sec-CH-UA-Platform|0|0|0|
|Sec-CH-UA-Platform-Version||0||

Any evidence shared with us is subject to our [usage sharing](@ref Features_UsageSharing) terms. Please refer to our [usage sharing and GDPR blog](link) for more information on what we do with your data.

# Pseudo-headers







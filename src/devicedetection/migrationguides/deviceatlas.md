@page DeviceDetection_MigrationGuides_DeviceAtlas Device Atlas

# Introduction

Here you'll find a list of DeviceAtlas Properties and their 51Degrees equivalent. 
Details of all available [DeviceAtlas Properties](https://deviceatlas.com/device-data/properties) can be found on their website, whilst the [51Degrees Property Dictionary](https://51degrees.com/resources/property-dictionary) contains details of all our properties and their possible values.


# Obsolete DeviceAtlas Capabilities

DeviceAtlas was launched in 2008 when the web and mobile was very different to now. As such many of the properties DeviceAtlas list have not proven relevant to businesses who've migrated to 51Degrees. 
Examples of these include properties related to J2ME which has been surpassed by platforms like Android, iOS and Windows Phone, legacy data delivery mechanisms that are no longer in use or markup specifications that are no longer popular.

Such capabilities are considered obsolete and for reference are listed at the bottom of this page.

Skip to the list of [obsolete capabilities](@ref DeviceDetection_MigrationGuides_DeviceAtlas_Obsolete).

# Mapped DeviceAtlas API Names

The following table lists the DeviceAtlas API Name and 51Degrees properties and values that contain the equivalent data.

|DeviceAtlas API Name|51Degrees Equivalent Property(s)|51Degrees Value|Comments|
|---|---|---|---|
|id|||The DeviceId related methods from the 51Degrees API.|
|3gp.aac.lc|[CcppAccept](https://51degrees.com/resources/property-dictionary#CcppAccept)|video/AAC||	 
|3gp.amr.nb|[CcppAccept](https://51degrees.com/resources/property-dictionary#CcppAccept)|video/amr, video/amr-nb||

TODO: Migrate the rest of this table from https://51degrees.com/deviceatlas

# Obsolete DeviceAtlas Capabilities @anchor DeviceDetection_MigrationGuides_DeviceAtlas_Obsolete

The following DeviceAtlas API Names are considered  to be obsolete and are not currently present in our published data set. Should you require these capabilities in order to migrate to 51Degrees, please ask us for advice.

|DeviceAtlas API Name|Comments|
|---|---|
|developerPlatform||	 
|developerPlatformVersion||
|drmOmaCombinedDelivery||
|drmOmaDownload||
|drmOmaForwardLock||
|drmOmaSeparateDelivery||

TODO: Migrate the rest of this table from https://51degrees.com/deviceatlas
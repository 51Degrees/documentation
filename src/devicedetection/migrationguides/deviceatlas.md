@page DeviceDetection_MigrationGuides_DeviceAtlas Device Atlas

# Introduction

List of DeviceAtlas Properties and their 51Degrees Property equivalent for all API variants. For WURFL see this guide.
Details of all DeviceAtlas properties are available on DeviceAtlas's web site.

# Obsolete DeviceAtlas Capabilities

DeviceAtlas was launched in 2008 when the web and mobile was very different. As such the many of the properties DeviceAtlas contains have not proven relevant to businesses who've migrated to 51Degrees. Such capabilities are considered obsolete for this reason and are listed at the bottom of this page. Examples relate to J2ME which has been surpassed by platforms like Android, iOS and Windows Phone, legacy data delivery mechanisims that are nolonger in use or markup specifications that are no longer popular.

Skip to the list of [obsolete capabilities](@ref DeviceDetection_MigrationGuides_DeviceAtlas_Obsolete).

# Mapped DeviceAtlas API Names

The following table lists the DeviceAtlas API Name, 51Degrees properties and values that contain equivalent data, alongside comments helpful to mapping DeviceAtlas and 51Degrees values.

|DeviceAtlas API Name|51Degrees Equivalent Property(s)|51Degrees Value|Comments|
|---|---|---|---|
|id|||The DeviceId related methods from the 51Degrees API.|
|3gp.aac.lc|[CcppAccept](@ref https://51degrees.com/resources/property-dictionary#CcppAccept)|video/AAC||	 
|3gp.amr.nb|[CcppAccept](@ref https://51degrees.com/resources/property-dictionary#CcppAccept)|video/amr, video/amr-nb||

TODO: Migrate the rest of this table from https://51degrees.com/deviceatlas

# Obsolete DeviceAtlas Capabilities @anchor DeviceDetection_MigrationGuides_DeviceAtlas_Obsolete

These DeviceAtlas API Names have not been considered relevant by those migrating from DeviceAtlas to 51Degrees. Should you require these capabilities mapped to 51Degrees please ask us for advice.

|DeviceAtlas API Name|Comments|
|---|---|
|developerPlatform||	 
|developerPlatformVersion||
|drmOmaCombinedDelivery||
|drmOmaDownload||
|drmOmaForwardLock||
|drmOmaSeparateDelivery||

TODO: Migrate the rest of this table from https://51degrees.com/deviceatlas
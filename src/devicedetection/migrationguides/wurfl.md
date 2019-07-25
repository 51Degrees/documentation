@page DeviceDetection_MigrationGuides_Wurfl WURFL

# Introduction

To aid those migrating from [ScientiaMobile's](@ref https://www.scientiamobile.com/) [WURFL](@ref http://wurfl.sourceforge.net/) to 51Degrees we've compiled a guide to map WURFL capabilities to 51Degrees properties and values.

Details of all [WURFL Capabilities](@ref https://www.scientiamobile.com/wurflCapability) are available on [ScientiaMobile's web site](@ref https://www.scientiamobile.com/wurflCapability).

# Obsolete WURFL Capabilities

[WURFL](@ref https://en.wikipedia.org/wiki/WURFL) was designed in 2001 when the web and mobile were very different. As such, the majority of the capabilities WURFL contains have not proven relevant to businesses who've migrated to 51Degrees. Such capabilities are considered obsolete for this reason and are listed at the bottom of this page. Examples include:

Capabilities related to iMode which have been replaced by modern smartphones.
Manufacturer specific capabilities that are no longer significant (Siemens, Sagem, Nokia, etc)
Media formats that are no longer used.
Specific J2ME platform information which has been surpassed by platforms like Android, iOS and Windows Phone.
Markup specifications that are no longer considered relevant such as WML, XHTML and CHTML.

Skip to the list of [obsolete capabilities](@ref DeviceDetection_MigrationGuides_Wurfl_Obsolete).

# Mapped WURFL Capabilities

The following table lists the WURFL capability name, 51Degrees [properties and values](@ref https://51degrees.com/resources/property-dictionary) that contain equivalent data, alongside comments helpful to mapping WURFL and 51Degrees values.

|WURFL Capability|51Degrees Equivalent Property|51Degrees Value|Comments|
|---|---|---|---|
|release_date|[ReleaseMonth](@ref https://51degrees.com/resources/property-dictionary#ReleaseMonth), [ReleaseYear](@ref https://51degrees.com/resources/property-dictionary#ReleaseYear)|||
|pointing_method|[HasClickWheel](@ref https://51degrees.com/resources/property-dictionary#HasClickWheel), [HasTrackPad](@ref https://51degrees.com/resources/property-dictionary#HasTrackPad), [HasTouchScreen](@ref https://51degrees.com/resources/property-dictionary#HasTouchScreen)|||

TODO: Finish migrating the full table from here: https://51degrees.com/scientiamobile
 
# Obsolete WURFL Capabilities @anchor DeviceDetection_MigrationGuides_Wurfl_Obsolete
These WURFL capabilities have not been considered relevant by those migrating from WURFL to 51Degrees. Should you require these capabilities mapped to 51Degrees please ask us for advice.

|WURFL Capability|Comments|
|---|---|
|ununiqueness_handler||
|unique||
|uaprof3||
|uaprof2||
|uaprof||
|nokia_series||
|nokia_feature_pack||
|nokia_edition||
|is_google_glass|Google glass is currently under review.|

TODO: Finish migrating the full table from here: https://51degrees.com/scientiamobile

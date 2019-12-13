@page DeviceDetection_MigrationGuides_Wurfl WURFL

# Introduction

Here you'll find a list of [ScientiaMobile's WURFL](http://wurfl.sourceforge.net) properties and values and the 51Degrees equivalents that they map to.

Details of all available WURFL Capabilities can be found on [ScientiaMobile](https://www.scientiamobile.com/wurflCapability)'s web site, whilst the [51Degrees Property Dictionary](https://51degrees.com/resources/property-dictionary) contains details of all our properties and their possible values.

# Obsolete WURFL Capabilities

WURFL was designed in 2001 when the web and mobile were very different to now. As such, the majority of the capabilities WURFL contains have not proven relevant to businesses who've migrated to 51Degrees. 

Examples of these include:
* Capabilities related to iMode which have been replaced by modern smartphones.
* Manufacturer specific capabilities that are no longer significant (Siemens, Sagem, Nokia, etc)
* Media formats that are no longer used.
* Specific J2ME platform information which has been surpassed by platforms like Android, iOS and Windows Phone.
* Markup specifications that are no longer considered relevant such as WML, XHTML and CHTML.

Such capabilities are considered obsolete and for reference are listed at the bottom of this page.

Skip to the list of [obsolete capabilities](@ref DeviceDetection_MigrationGuides_Wurfl_Obsolete).

# Mapped WURFL Capabilities

The following table lists the WURFL capability name and 51Degrees properties and values that contain the equivalent data.


|WURFL Capability|51Degrees Equivalent Property|51Degrees Value|Comments|
|---|---|---|---|
|release_date|[ReleaseMonth](https://51degrees.com/resources/property-dictionary#ReleaseMonth), [ReleaseYear](https://51degrees.com/resources/property-dictionary#ReleaseYear)|||
|pointing_method|[HasClickWheel](https://51degrees.com/resources/property-dictionary#HasClickWheel), [HasTrackPad](https://51degrees.com/resources/property-dictionary#HasTrackPad), [HasTouchScreen](https://51degrees.com/resources/property-dictionary#HasTouchScreen)|||

TODO: Finish migrating the full table from here: https://51degrees.com/scientiamobile
 
# Obsolete WURFL Capabilities @anchor DeviceDetection_MigrationGuides_Wurfl_Obsolete
The following WURFL capabilities are considered to be obsolete and are not currently present in our published data set. Should you require these capabilities in order to migrate to 51Degrees, please ask us for advice.

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

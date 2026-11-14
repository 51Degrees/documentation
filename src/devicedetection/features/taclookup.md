@page DeviceDetection_Features_TacLookup TAC lookup

# Introduction

A TAC or [Type Allocation Code](https://en.wikipedia.org/wiki/Type_Allocation_Code) is an 8-digit numeric code that is used to identify mobile device models.
It is part of the [IMEI](https://en.wikipedia.org/wiki/International_Mobile_Equipment_Identity) 
number and is generally only available to code running with sufficient privileges on the 
user's device.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/device-detection-specification/pipeline-elements/hardware-profile-lookup-cloud.md#)
for more technical details.

TAC lookup is currently available in three forms:
1. Requests to the 51Degrees Cloud Service, fully integrated into the Pipeline API.
2. Using the 'TAC CSV' data file to create a local lookup solution based on SQL or some 
other data query mechanism.
3. The on-premise Hash engine with the TAC Hash data file.

# Cloud Service

Include a 'TAC' query parameter in your Cloud Service request. Your [Resource Key](@term{ResourceKey}) must include 'profiles' and one or more hardware device properties. The service returns details of devices that match the supplied TAC.

NOTE: You **MUST** select the 'profiles' property for TAC lookup to work.

For language specific details, see these [examples](@ref DeviceDetection_Examples_TacLookup_Cloud). 

# Local lookup

Currently, the recommended solution for a local lookup is to use the TAC CSV file.
This is a data file that is available from the 51Degrees [Distributor](@term{Distributor}) service (assuming you 
have a valid License Key that includes access to this product). 

This data file includes all values for all properties and can be used to populate a database or 
similar. The database can then be used to perform indexed lookups on given property values, 
such as TAC.

# On-premise lookup

The on-premise Hash engine can also give the profiles holding a TAC, using the TAC Hash data 
file. Name the TAC property with the engine's indexed properties option, for example 
`SetIndexedProperties` on the .NET Hash engine builder, and the lookup uses the engine's index 
rather than reading every profile. A TAC matches only when it is given exactly as the data file 
holds it.

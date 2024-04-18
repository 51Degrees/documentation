@page DeviceDetection_Features_NativeKeyLookup Native Key Lookup Feature

# Introduction

A native key is a short string that identifies a mobile device model and is stored internally 
by such devices.
This string is generally only available to code running with sufficient privileges on the 
user's device and is available for both [Android](https://developer.android.com/reference/android/os/Build#MODEL) 
and [iOS](https://gist.github.com/soapyigu/c99e1f45553070726f14c1bb0a54053b#file-machinename-swift) devices.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/device-detection-specification/pipeline-elements/hardware-profile-lookup-cloud.md#)
for more technical details.

Native key lookup is currently available in two forms:
1. Requests to the 51Degrees cloud service, fully integrated into the Pipeline API.
2. Using the 'TAC CSV' data file to create a local lookup solution based on SQL or some 
other data query mechanism.

# Cloud service

Requests to the cloud service can include a 'NativeModel' query parameter. As long as the [Resouce Key](@term{ResourceKey}) 
includes one or more 'hardware device' properties and the 'profiles' property, the cloud service will return a result set with 
the details of any devices that match the supplied native model key.

NOTE: The 'profiles' and property ***MUST** be selected for native lookup to function.

For language specific details, see these [examples](@ref Examples_DeviceDetection_NativeKeyLookup_Cloud). 

# Local lookup

Currently, the recommended solution for a local lookup is to use the TAC CSV file.
This is a data file that is available from the 51Degrees [Distributor](@term{Distributor}) service (assuming you 
have a valid License Key that includes access to this product). 

This data file includes all values for all properties and can be used to populate a database or 
similar. The database can then be used to perform indexed lookups on given property values, 
such as native model.

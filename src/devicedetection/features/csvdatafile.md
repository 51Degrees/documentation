@page DeviceDetection_Features_CsvDataFile CSV Data File

# Overview

As well as providing device detection, we also offer access to a CSV version of our data.
This includes all property values for all profiles (hardware, platform, browser, and crawler). It does not include any information to help determine device details from User-Agent or UA-CH values.

# Use Cases

This data may be used to lookup details using some other key such as TAC or the model name returned by native apps running on the device. 

It can also be used to obtain sets of possible values for each value (this can also be accessed using the API with the standard data file – see the [metadata examples](@ref DeviceDetection_Examples_Metadata_Index))

You may load the data into a database or similar indexing system if you wish. The unique keys (profile id) for each profile are included in the CSV. These values are also returned by the device detection API. One use for this would be to store the profile ids along with other details related to the request. Later, some offline process could then use the profile ids to lookup the corresponding device values in the database, rather than needing to do device detection on the original evidence again.

# How do I get it?

The CSV file is supplied via our @Distributor service, just like the other data files. 

As such, you will need a License Key that allows access to this particular file. This may or may not be included in your current license. See our [pricing page](https://51degrees.com/pricing) for details of which packages include access to the CSV file.

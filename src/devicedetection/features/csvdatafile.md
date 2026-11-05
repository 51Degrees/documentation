@page DeviceDetection_Features_CsvDataFile CSV Data File

# Overview

As well as providing device detection, we also offer access to a CSV version of our data.
This includes all property values for all profiles (hardware, platform, browser, and crawler). It does not include any information to help determine device details from User-Agent or UA-CH values.

# Use Cases

Use this data to look up device details by a key such as a TAC or a model name returned by a native app.

Use it to obtain the possible values for each property. You can also access these values through the API with the standard data file, as shown in the [metadata examples](@ref DeviceDetection_Examples_Metadata_Index).

You can load the CSV into a database or another indexing system. The CSV includes unique profile IDs, which the device detection API also returns. Store these IDs with request details so that an offline process can look up device values later without repeating detection on the original evidence.

# How do I get it?

The CSV file is supplied via our @Distributor service, just like the other data files. 

As such, you will need a License Key that allows access to this particular file. This may or may not be included in your current license. See our [pricing page](https://51degrees.com/pricing) for details of which packages include access to the CSV file.

@mainpage Home

# 51Degrees API Documentation

Using the 51Degrees API to integrate real-time data insights into your own services involves a few steps:

1. Create a Resource Key to authenticate your requests.
2. Obtain the programming library for your choice of language.
3. Choose your service: Reverse Geocoding, Device Detection, or others.
4. Query the APIs for the data you need.

Each of these steps are described in more detail in this documentation and below.

## Authentication with a Resource Key

To create a Resource Key, use the [Configurator](https://configure.51degrees.com/) to select the data you need returned. Read @configuratorexplanation for more detail on how to create a Resource Key and errors that may occur.

## Choose a programming library

There are programming libraries available in C#, Java, Node.js, client-side JavaScript, PHP, and Python for each of the services. 

## Choosing your service

* @DeviceDetection – Detailed insight into the devices being used to access your content.
* @ReverseGeocoding – Obtain accurate real-world data such as postal address from the users' location as reported by their smartphone or similar device.
* Antifraud – Identify and exclude fraudulent requests. (Coming soon)
* IpIntelligence – Determine key information from the network path taken by the request such as mobile carrier or location. (Coming soon)

## Query the APIs

Querying 51Degrees APIs is done by constructing a Pipeline and adding Evidence to it and then telling it to process to get the best data for that evidence; for example, a location request might involve creating a Pipeline and adding an IP address to it, and then processing to receive a latitude and longitude associated with that IP address. 

To get started, see real examples of how to obtain Resource Keys and query the APIs in detail in the @quickstart.

For further detail, once the @quickstart is completed, please refer to the documentation in the menu. Pipelines are described in more detail in the @pipelinebasics, which explains how pipelines are constructed from flow elements and consume flow data. Reference documentation for the HTTP API is provided in the [cloud API documentation](https://cloud.51degrees.com/api-docs/index.html).

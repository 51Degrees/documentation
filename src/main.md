@mainpage Home

# 51Degrees Pipeline Documentation

The Pipeline API has been created by 51Degrees to remove friction from the process of working with real-time data micro-services.
It is the mechanism for delivering 51Degrees' data services such as device detection but it is more than that.

The Pipeline aggregates multiple different services from multiple vendors into a single, simple request.
The plug-in based architecture makes it easy for new services to be added by third parties. You can also add your own custom elements, taking advantage of the features built into the Pipeline and allowing you to focus on your business logic.

## Fundamentals

Each @Pipeline is defined by the @flowelements that are added to it.
Each @flowelement performs some data processing task.

When a @Pipeline is created, the desired @flowelements are added to it and can be configured to run in sequence or in parallel as required. (If the language supports @parallelexecution).

Once created, a @Pipeline can then be used to create @flowdata. This is a one-time-use construct that is used both to pass data to the @Pipeline for processing and to access the results.

After the input data (@evidence) has been added to the @flowdata, it is processed by the component @flowelements that make up the @Pipeline. Each @flowelement can add new values to the @flowdata, which can be retrieved once processing is complete.

For a deeper understanding of the Pipeline concept, start with the @Pipeline page. 

## Key features

- Seamless switching between on-premise data and cloud backed data services.
- Automatic updating of on-premise data files from a configurable central service, including in place updates to avoid the need to interrupt running processes.
- For web environments, JavaScript bundling to improve client side performance and network efficiency.
- Support for high performance native data processing libraries via SWIG.
- All components designed for scalable, multi-threaded applications.
- Modern software design including fluent builders, dependency injection, unit testing and continuous integration. DevOps friendly.
- Support for .NET, Java, PHP and Node with more being added over time.
- Plug-in architecture supporting custom third party data services.

## New to the Pipeline?

* If you're migrating from the older 51Degrees device detection API then start with the @v3migrationguide.
* New users should check the @quickstart guide for help getting up and running as soon as possible.

## 51Degrees Data Services

* @DeviceDetection - Detailed insight into the devices being used to access your content.
* @GeoLocation - Obtain accurate data regarding the users' location.
* @Antifraud - Identify and exclude fraudulent requests.
* @IpIntelligence - Determine key information from the network path taken by the request such as mobile carrier. (Coming in 2020)

## Technical Detail

* Explore detailed technical documentation for each language supported by the Pipeline.
* Build a @customengine to match your requirements.
* [Compare features](@ref Info_FeatureMatrix) of Pipeline and data service implementations in each language.


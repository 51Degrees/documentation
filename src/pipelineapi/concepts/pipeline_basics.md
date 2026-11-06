@page PipelineApi_Concepts_PipelineBasics Pipeline basics

# 51Degrees Pipeline documentation

Use the 51Degrees Pipeline API to combine real-time data services, including device detection, in one configurable pipeline.

The Pipeline aggregates multiple different services from multiple vendors into a single, simple request.
The plug-in architecture supports third-party services and your own custom elements. Use the built-in Pipeline features to handle common processing tasks while you implement your business logic.

## Fundamentals

Each @Pipeline is defined by the @flowelements that are added to it.
Each @flowelement performs some data processing task.

When a @Pipeline is created, the desired @flowelements are added to it and can be configured to run in sequence or in parallel as required (if the language supports @parallelexecution).

Once created, a @Pipeline can then be used to create @flowdata. This is a one-time-use construct that is used both to pass data to the @Pipeline for processing and to access the results.

After the input data (@evidence) has been added to the @flowdata, it is processed by the component @flowelements that make up the @Pipeline. Each @flowelement can add new values to the @flowdata, which can be retrieved once processing is complete.

For a deeper understanding of the Pipeline concept, start with the @Pipeline page. 

## Key features

- Switch between on-premise data and cloud-backed data services.
- Automatic updating of On-premise data files from a configurable central service, including in place updates to avoid the need to interrupt running processes.
- For web environments, JavaScript bundling to improve client side performance and network efficiency.
- Support for high performance native data processing libraries via SWIG.
- All components designed for scalable, multithreaded applications.
- Modern software design including fluent builders, dependency injection, unit testing, and continuous integration. DevOps friendly.
- Support for .NET, Java, PHP, Node.js, Python, and Rust.
- Plug-in architecture supporting custom third party data services.

## New to the Pipeline?

* If you're migrating from the older 51Degrees Device Detection API then start with the @v3migrationguide.
* New users should check the @introduction guide for help getting up and running as soon as possible.

## 51Degrees data services

* @DeviceDetection - Detailed insight into the devices being used to access your content.
* @ReverseGeocoding - Obtain accurate real-world data such as postal address from the user's location as reported by their smartphone or similar device.
* @IpIntelligence - Determine key information from the network path taken by the request such as mobile carrier or location.

## Technical detail

* Explore detailed technical documentation for each language supported by the Pipeline.
* Build a @customengine to match your requirements.
* [Compare features](@ref ProductSummaries_FeatureMatrix) of Pipeline and data service implementations in each language.

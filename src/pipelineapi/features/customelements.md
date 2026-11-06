@page PipelineApi_Features_CustomElements Custom flow elements

# Introduction

Create custom @flowelements to add your business logic to the @Pipeline. You can use features such as @buildfromconfiguration, @automaticdatafileupdates, @resultcaching, and @webintegration.

# Choosing the right classes to extend

At the most basic level, all that is required to create a **custom flow element** is a class 
implementing the @flowelement interface.

However, there are various levels of base classes that build up functionality which a 
developer may wish to take advantage of.
The diagram below shows this hierarchy and the features introduced at each level. Note that
the precise details of class names, etc., will vary between languages.

@dotfile customflowelement-hierarchy.gvdot


Each level has associated classes as described by the following table:

| Element | Data | Metadata | Builder |
|---|---|---|---| 
|@Flowelement|@Elementdata|@Elementpropertymetadata|N/A|
|@Aspectengine|@Aspectdata|@Aspectpropertymetadata|Aspect Engine builder|
|@Onpremiseengine|@Aspectdata|@Aspectpropertymetadata|On-premise aspect engine builder|
|@Cloudengine|@Aspectdata|@Aspectpropertymetadata|Cloud engine builder|


# Examples

[Examples](@ref PipelineApi_Examples_CustomElement_Index) are provided which cover the creation of a 
**custom flow element** in a variety of scenarios.



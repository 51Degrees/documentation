@page Features_CustomElements Custom Flow Elements

# Introduction

The @Pipeline has been designed as an extensible hierarchy of functionality and is fully
publicly accessible. This allows 3rd party developers to create custom @flowelements which
focus on their core business logic, whilst also benefiting from the features of the @Pipeline - such as
@buildfromconfiguration, @automaticdatafileupdates, @resultcaching, @webintegration, etc.

# Choosing the Right Classes to Extend

At the most basic level, all that is required to create a **custom flow element** is a class 
implementing the @flowelement interface.

However, there are various levels of base classes that build up functionality that a 
developer may wish to take advantage of.
The diagram below shows this hierarchy and the features introduced at each level. Note that
the precise details of class names, etc will vary between languages.

@dotfile customflowelement-hierarchy.gvdot


Each level has associated classes as described by the following table:

| Element | Data | Metadata | Builder |
|---|---|---|---| 
|@Flowelement|@Elementdata|@Elementpropertymetadata|N/A|
|@Aspectengine|@Aspectdata|@Aspectpropertymetadata|Aspect engine builder|
|@Onpremiseengine|@Aspectdata|@Aspectpropertymetadata|On-premise aspect engine builder|
|@Cloudengine|@Aspectdata|@Aspectpropertymetadata|Cloud engine builder|


# Examples

Examples are provided [examples](@ref Examples_CustomElement_Index) which cover the creation of a 
**custom flow element** in a variety of scenarios.



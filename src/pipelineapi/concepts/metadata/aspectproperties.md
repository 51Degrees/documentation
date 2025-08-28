@page PipelineApi_Concepts_MetaData_AspectProperties Aspect Properties

# Introduction

**Aspect properties** extend @elementproperties to add metadata relevant to @aspectengines.

As @aspectengines consume external data from either a @datafile or [Cloud Service](@term{CloudService}), extra metadata
is included to indicate where the **property** is available.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/features/properties.md#aspect-property-metadata)
for more technical details.

# Data tier

The data tier of a **property** describes which product tiers the **property** is available in. For example,
an @aspectengine could consume both a free and enterprise @datafile. Please be aware that certain 
**properties** may not be available in the free data file..


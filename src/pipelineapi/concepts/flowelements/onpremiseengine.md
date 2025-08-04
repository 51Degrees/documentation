@page PipelineApi_Concepts_FlowElements_OnPremiseEngine On-Premise Engine

# Introduction

**On-premise engines** are a specialization of @aspectengine where additional data exists locally to
the **engine**, either in memory or a data file. This is in contrast to a @cloudengine where data
exists in a cloud service which is called by the **engine**. Having data that does not reside in the
**engine** itself means that the same **engine** can be used with multiple data sets.

An **On-Premise engine** builds on the @aspectengine concept to introduce the ability to:
* load data either from memory or one or more data files
* keep data files up to date

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/conceptual-overview.md#On-Premise-engines)
for more technical details.

# Use cases

An **On-Premise engine** typically does not need to call external components when processing a request.
This makes it best suited to cases where performance is critical, and the supporting hardware implementation
reflects this. To provide optimal performance, some **On-Premise engines** can be configured to run 
with any data files held entirely in memory, reducing latency further.

There are also situations where the security demands of a service make sending sensitive data to an
external [cloud service](@term{CloudService}) problematic. Using an **On-Premise engine** will address this issue.

# Data files <a href="#PipelineApi_Concepts_Configuration_DataFiles">#</a> @anchor PipelineApi_Concepts_Configuration_DataFiles

An @aspectengine can make use of one or more data files to carry out its processing. This is typically the 
case when an **engine** relies on data being updated, so the data is not stored statically in the **engine** itself.

## Updates

To facilitate keeping the data up to date, an **engine** may be registered with the @dataupdateservice, to provide 'automatic updates'. Enabling this feature
in an **engine** means that when it is added to a @pipeline, it will be registered for updates, and the @dataupdateservice
will refresh the data file automatically.

An **engine's** data can also be refreshed manually by giving the **engine** either a new data file or memory location and requesting that
it use that new data file or memory location. Depending on the **engine** implementation, refreshing the data in an **engine** may or may not require the engine to
briefly stop serving requests. 
All 51Degrees **engines** have been designed so that processing will be uninterrupted by data updates.

## Temporary data files

An **engine** can optionally create a temporary copy of the data file to use. This is good practice when making use of the
[update functionality](@ref PipelineApi_Features_AutomaticDatafileUpdates), as an **engine** can be configured so that it streams data from the data file. When a temporary data file
is used, the original data file cannot be updated because the **engine** will have a lock on the file.

## Metadata

Each data file in an **engine** can contain metadata, some of which is used by the @dataupdateservice. This metadata can provide
the @dataupdateservice with the age of the data file, the time at which a new one will be available, and the URL of where the new data file can be obtained.

## Multiple files

An **On-Premise engine** can require more than one data file. Files can be individually registered with the @dataupdateservice, 
which will handle each file according to its own metadata. This allows different data files to have distinct update configurations.

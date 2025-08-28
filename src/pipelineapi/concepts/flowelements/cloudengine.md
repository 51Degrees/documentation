@page PipelineApi_Concepts_FlowElements_CloudEngine Cloud Engine

# Introduction

**Cloud Engines** are a specialization of @aspectengine where the processing is handed off to a
[Cloud Service](@term{CloudService}). This is in contrast to an @onpremiseengine where processing 
occurs locally to the **engine**. Having data that does not reside
in the **engine** itself means that the same **engine** can be used with multiple data sets.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/conceptual-overview.md#cloud-aspect-engine)
for more technical details.

# Use cases

A **Cloud Engine** is very lightweight compared to an @onpremiseengine both in terms of memory and CPU usage.
This is because all the complex processing and any data that is required for that processing to occur are handled
by the associated [Cloud Service](@term{CloudService}). The trade-off is that a **Cloud Engine**
cannot provide the same performance as an @onpremiseengine.

In many cases, a **Cloud Engine's** performance is sufficient and is ideal for small environments where
memory is in short supply. On small services such as a cloud Lambda function where there are low limits to the size of
the services, **Cloud Engines** are a perfect fit.

As **Cloud Engines** typically offload the actual processing onto a [Cloud Service](@term{CloudService}), this
also makes them a good choice for environments that lack processing power. By letting a
[Cloud Service](@term{CloudService}) do all the work, CPU cycles are freed up on the low power device for other
tasks.

# Internals

All the data for a **Cloud Engine** is accessed through a [Cloud Service](@term{CloudService}), any data
or processing needed by the **engine** is serviced through HTTP requests. This means the **engine** itself
has limited knowledge of its capabilities, for example, the properties available in a **Cloud Engine** may be
populated from a request to the [Cloud Service](@term{CloudService}).

Typically, a **Cloud Engine** does not carry out processing itself. Instead, its processing consists of sending
a call to a [Cloud Service](@term{CloudService}) and interpreting the result.

# 51Degrees Cloud Engines

The functionality of all @aspectengines that make use of the 51Degrees cloud is split into two 
separate @aspectengines.
The 'cloud request engine' marshals the evidence and makes a request to the Cloud Service. The resulting
raw JSON string is stored in the request engine's associated @elementdata.

There are then individual **Cloud Engines** that can be added to the @Pipeline for each [aspect](@term{Aspect}). These will take
the part of the raw JSON string which is relevant to them and transform it into something with the same interface
as the associated @onpremiseengine.

This splitting allows a single request to be made even if the details of multiple [aspects](@term{Aspect}) need to be 
populated while also allowing the ability to easily swap between a **Cloud Engine** and the @onpremiseengine 
concerned with the same [aspect](@term{Aspect}).

@page Concepts_FlowElements_CloudEngine Cloud Engine

# Introduction

**Cloud engines** are a specialization of @aspectengine where the processing is handed off to a
[cloud service](@term{CloudService}). This is in contrast to an @onpremiseengine where processing 
occurs locally to the **engine**. Having data which does not reside
in the **engine** itself means that the same **engine** can be used with multiple data sets.

# Use Cases

A **cloud engine** is very lightweight compared to an @onpremiseengine both in terms of memory and CPU usage.
This is because all the complex processing and any data that is required for that processing to occur are handled
by the associated [cloud service](@term{CloudService}). The trade-off is that a **cloud engine**
cannot provide the same performance as an @onpremiseengine.

For many cases, a **cloud engine**'s performance is sufficient, and is ideal for small environments where
memory is in short supply. On small services such as a cloud Lambda function where there are low limits to the size of
the services, **cloud engines** are a perfect fit.

As **cloud engines** typically offload the actual processing onto a [cloud service](@term{CloudService}), this
also makes them a good choice for environments which lack processing power. By letting a
[cloud service](@term{CloudService}) do all the work, CPU cycles are freed up on the low power device for other
tasks.

# Internals

All the data for a **cloud engine** is accessed through a [cloud service](@term{CloudService}), any data
or processing needed by the **engine** is serviced through HTTP requests. This means the **engine** itself
has limited knowledge of its capabilities, for example, the properties available in a **cloud engine** may be
populated from a request to the [cloud service](@term{CloudService}).

Typically a **cloud engine** does not carry out processing itself. Instead, its processing consists of sending
a call to a [cloud service](@term{CloudService}) and interpreting the result.

# 51Degrees Cloud Engines

The functionality of all @aspectengines that make use of the 51Degrees cloud is actually split into two 
separate @aspectengines.
The 'cloud request engine' marshals the evidence and makes a request to the cloud service. The resulting
raw JSON string is stored in the request engine's associated @elementdata.

There are then individual **cloud engines** that can be added to the @Pipeline for each @term{Aspect}. These will take
the part of the raw JSON string which is relevant to them and transform it into something with the same interface
as the associated @onpremiseengine.

This splitting thus allows a single request to be made even if the details of multiple [aspects](@ref Concepts_Terminology_Aspect) need to be 
populated while also allowing the ability to easily swap between a **cloud engine** and the @onpremiseengine 
concerned with the same @term{Aspect}.

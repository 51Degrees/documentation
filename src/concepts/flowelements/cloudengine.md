@page Concepts_FlowElements_CloudEngine Cloud Engine

# Introduction

**Cloud engines** are a specialization of @aspectengine where additional data exists on a
[cloud service](@term{CloudService}) and is accessed by the **engine**. This is in contrast to an
@onpremiseengine where data exists locally to the **engine**. Having data which does not reside
in the **engine** itself means that the same **engine** can be used with multiple data sets.

# Use Cases

A **cloud engine** is very lightweight compared to an @onpremiseengine. This is achieved by all
the data being stored elsewhere on a [cloud service](@term{CloudService}). However a **cloud engine**
does not provide the same performance as an @onpremiseengine.

For many cases, a **cloud engine**'s performance is sufficient, and is ideal for small environments where
memory is commodity. On small services such as a cloud Lambda function where there are low limits to the size of
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
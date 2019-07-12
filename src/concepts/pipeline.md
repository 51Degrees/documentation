@page Concepts_Pipeline Pipeline

@htmlonly <script type="text/javascript" src="examplegrabber.js"></script> @endhtmlonly


# Introduction

A **Pipeline** is a customizable data processing system. At the most basic level, input data is 
supplied in the form of @evidence. 
One or more [flow elements](@ref Concepts_FlowElements_Index) in the **Pipeline** then perform processing 
based on that [evidence](@ref Concepts_Data_Evidence) and optionally, populate data values that 
are required by the user.

The incoming [evidence](@ref Concepts_Data_Evidence) is usually related to a 
[web request](@term{WebRequest}), for example 
the HTTP headers, cookies, source IP address or values from the query string.
The [evidence](@ref Concepts_Data_Evidence) is carried through the **Pipeline** to the 
[elements](@ref Concepts_FlowElements_Index) by a @flowdata instance. 
The [flow data](@ref Conepts_Data_FlowData) structure encapsulates all input and output data associated 
with a single **Pipeline** process request.


# Creation

A **Pipeline** is built using a [pipeline builder](@ref Concepts_Configuration_Builders_PipelineBuilder)
utilizing the fluent builder pattern. By adding [flow elements](@ref Concepts_FlowElements_FlowElement)
to the **Pipeline**, the nature of the processing it will carry out is defined.

Once created, a **Pipeline** is immutable, i.e. the [flow elements](@ref Concepts_FlowElements_FlowElement)
it contains and the order in which they execute cannot be changed. Individual 
[flow elements](@ref Concepts_FlowElements_FlowElement) may be immutable, or not, based upon their
individual implementations.

As an alternative to configuring a **Pipeline** using a builder, configuration can be supplied from a file. 
Depending on the language features and conventions, this could be formatted as either JSON or XML.
This allows the **Pipeline** to be configurable at runtime without recompiling the code. This is the 
default operation for [Web integrations](@ref Concepts_Web_Index), but can be used for any other use-case
as well. 
For more on this, see the [build from file](@ref Concepts_Configuration_Builder_BuildFromFile) section, 
and the [configure from file](@ref Examples_Configure_From_File) example.


# Processing

The flow of a **Pipeline's** operation starts with the creation of a [flow data](@ref Concepts_Data_FlowData).
This is created from the **Pipeline**, and is specific to it. Each [flow data](@ref Concepts_Data_FlowData) instance
can only be processed using the **Pipeline** that created it.

Next, [evidence](@ref Concepts_Data_Evidence) is added to the [flow data](@ref Concepts_Data_FlowData) ready 
to be processed.

Finally, the [flow data](@ref Concepts_Data_FlowData) is processed. 
Doing this sends the data (along with all the [evidence](@ref Concepts_Data_Evidence) it
now contains) through the **Pipeline**. Each [flow element](@ref Concepts_FlowElements_FlowElement) will 
receive the [flow data](@ref Concepts_Data_FlowData) and do its processing before optionally updating the 
[flow data](@ref Concepts_Data_FlowData) with new values.

Note that the order of execution of [flow elements](@ref Concepts_FlowElements_FlowElement) is decided when the
**Pipeline** is created.
By default, [flow elements](@ref Concepts_FlowElements_FlowElement) are executed sequentially in the order
they are added. However, if the [language supports](@ref Info_FeatureMatrix) it, 
two or more [flow elements](@ref Concepts_FlowElements_FlowElement)
can also be executed in @parallel within the overall sequential structure.

Additionally, the **Pipeline** may offer @asynchronous execution or a @lazyloading capability for individual 
[flow elements](@ref Concepts_FlowElements_FlowElement). These features are also [language dependent](@ref Info_FeatureMatrix).

Regardless of the method of execution and configuration, after processing the 
[flow data](@ref Concepts_Data_FlowData) will contain the results, which can then be accessed by the caller.


@dotfile basic-pipeline-flow.dot

# Public Access

Other than the creation of a new [flow data](@ref Concepts_Data_FlowData), there are very few other 
publicly accessible parts of the **Pipeline**.

[flow elements](@ref Concepts_FlowElements_FlowElement) inside the **Pipeline** are accessible as 
a read-only collection, and can also be retrieved individually if needed.

All @elementproperties that the **Pipeline's** 
[flow elements](@ref Concepts_FlowElements_FlowElement) can populate are also exposed in one place.
This enables easy iteration over all @elementproperties.

=========

@htmlonly

<button class="b-btn b-btn--secondary iterPropertiesBtn" onclick="grabSnippet(this, 'pipeline-dotnet', '_snippets.html', 'iter-properties', 'iterPropertiesBtn', 'iter-properties-eg')">C#</button>
<button class="b-btn b-btn--secondary iterPropertiesBtn" onclick="grabSnippet(this, 'pipeline-java', '_snippets.html', 'iter-properties', 'iterPropertiesBtn', 'iter-properties-eg')">Java</button>
<div id="iter-properties-eg"></div>

@endhtmlonly

=========

An [evidence key filter](@ref Concepts_Data_Keys_EvidenceKeyFilter) is also exposed. 
This aggregates all the [evidence](@ref Concepts_Data_Evidence) keys accepted by all the 
[flow elements](@ref Concepts_FlowElements_FlowElement) within the **Pipeline**. 
This can be used by the caller to check which items of [evidence](@ref Concepts_Data_Evidence) 
could affect the result of processing.


# Internals

The structure of the [flow elements](@ref Concepts_FlowElements_FlowElement) within the 
**Pipeline**, and the [flow data](@ref Concepts_Data_FlowData) which it creates, is determined
by how it is created.

Consider an example where [flow elements](@ref Concepts_FlowElements_FlowElement) **E1** 
and **E2** are added to the **Pipeline** individually in that order.

@dotfile pipeline-process.dot

**E1** will carry out its processing on the [flow data](@ref Concepts_Data_FlowData), then 
once it is finished, **E2** will do the same. In this scenario, the **Pipeline** 'knows' 
that the [flow data](@ref Concepts_Data_FlowData) will not be written to by multiple threads.
As such, the [flow data](@ref Concepts_Data_FlowData) created by the **Pipeline** will not be
thread-safe but will have slightly improved performance.

Now consider an example where both **E1** and **E2** are added in parallel.

@dotfile pipeline-parallel-process.dot

In this case, both will carry out their processing at the same time. This time, the 
[flow data](@ref Concepts_Data_FlowData)
which the **Pipeline** creates will be thread-safe for writing as it is possible that both 
**E1** and **E2** will attempt to write their results to the FlowData at the same time.

TODO: The above example is language-specific.

=========

@htmlonly

<button class="b-btn b-btn--secondary configBtn" onclick="grabSnippet(this, 'pipeline-dotnet', '_snippets.html', 'build-pipeline-cs', 'configBtn', 'config-eg')">C#</button>
<button class="b-btn b-btn--secondary configBtn" onclick="grabSnippet(this, 'pipeline-java', '_snippets.html', 'build-pipeline-java', 'configBtn', 'config-eg')">Java</button>
<div id="config-eg"></div>

@endhtmlonly

=========


# Lifecycle

A **Pipeline** is the second thing to be created, after the 
[flow elements](@ref Concepts_FlowElements_FlowElement) which it contains. It then exists for
as long as processing is required. When a **Pipeline** is disposed of, it can optionally dispose
of the [flow elements](@ref Concepts_FlowElements_FlowElement) within too. 
This makes managing the lifetime of the [flow elements](@ref Concepts_FlowElements_FlowElement)
easy, however this should not be done if the same 
[flow element](@ref Concepts_FlowElements_FlowElement) instances have also been added to 
another **Pipeline**.

If an attempt is made to process a [flow data](@ref Concepts_Data_FlowData) from a **Pipeline**
which has since been disposed, an error
will occur. The **Pipeline** which creates a [flow data](@ref Concepts_Data_FlowData) **MUST** 
exist for as long as the [flow data](@ref Concepts_Data_FlowData). This
is also true of post processing usage like retrieving results from the 
[flow data](@ref Concepts_Data_FlowData). 
Imagine a case where a certain result has been [lazily loaded](@ref Concepts_Feature_LazyLoading) - 
a call to get that result will require the [flow element](@ref Concepts_FlowElements_FlowElement)
which created it to do the loading, so if the **Pipeline** has disposed of the 
[flow element](@ref Concepts_FlowElements_FlowElement), there will be an error.

While not a necessity, it is good practice to dispose of each 
[flow data](@ref Concepts_Data_FlowData) produced by the **Pipeline** once
it is finished with.


(TODO description on why memory management matters for languages that usually don't have to worry about it)

@page Concepts_Pipeline_Pipeline Pipeline

@htmlonly <script type="text/javascript" src="examplegrabber.js"></script> @endhtmlonly


## Introduction

The Pipeline is the glue that holds together all the [Elements](@ref Concepts_FlowElements_Index).
It orchestrates the way [FlowData](@ref Conepts_Data_FlowData) is passed through each
[Element](@ref Concepts_FlowElements_Index) in order to turn [Evidence](@ref Concepts_Data_Evidence)
into useful results in the form of [ElementData](@ref Concepts_Data_ElementData).


## Creation

A Pipeline is built using a [PipelineBuilder](@ref Concepts_Configuration_Builders_PipelineBuilder)
using the fluent builder pattern. By adding [FlowElements](@ref Concepts_FlowElements_FlowElements)
to the Pipeline, the nature of the processing it will carry out is defined.

Once created, a Pipeline is immutable. So once it is built, its configuration will not change, nor
will the way in which it processes Evidence.

In addition to configuring a Pipeline through a builder, a configuration can be used to make setup
simpler and more configurable. This is the default operation for [Web integrations](@ref Concepts_Web_Index),
but can be used for any other use-case. For more on this, see the
[build from file](@ref Concepts_Configuration_Builder_BuildFromFile) section, and the
[configure from file](@ref Examples_Configure_From_File) example.


## Processing

The flow of a Pipeline's operation starts with the creation of a [FlowData](@ref Concepts_Data_FlowData)
which is handled by the Pipeline, and handed out to the user. This is specific to the Pipeline
that handed it out, and cannot be processed with another Pipeline.

Next, [Evidence](@ref Concepts_Data_Evidence) is added to the FlowData ready to be processed.

Finally, the FlowData is processed. Doing this sends the data (along with all the Evidence it
now contains) through the Pipeline. After each Element in the pipeline has finished its processing in
whichever order has been configured when the Pipeline was built, the FlowData is returned with and
results from the processing contained within.


@dotfile basic-pipeline-flow.dot

## Public Access

Other than the creation of a new FlowData, there are very few other publicly accessible parts
of the Pipeline.

FlowElements inside the Pipeline are accessible as a read-only collection, and can also be retrieved
individually if the type of the required FlowElement is known.

All [Properties](@ref Concepts_MetaData_Properties) available in the Pipeline's FlowElements are also
exposed in one place. This enabled easy iteration over all properties.

=========

@htmlonly

<button class="b-btn b-btn--secondary iterPropertiesBtn" onclick="grabSnippet(this, 'pipeline-dotnet', '_snippets.html', 'iter-properties', 'iterPropertiesBtn', 'iter-properties-eg')">C#</button>
<button class="b-btn b-btn--secondary iterPropertiesBtn" onclick="grabSnippet(this, 'pipeline-java', '_snippets.html', 'iter-properties', 'iterPropertiesBtn', 'iter-properties-eg')">Java</button>
<div id="iter-properties-eg"></div>

@endhtmlonly

=========

An [EvidenceKeyFilter](@ref Concepts_Data_Keys_EvidenceKeyFilter) is also exposed which aggregates
all the keys accepted by the FlowElements within the Pipeline. This tells the caller which items
of [Evidence](@ref Concepts_Data_Evidence) should be added to the FlowData before processing.


## Internals

The structure of the Elements within the Pipeline, and the FlowData which it creates, is defined
by how it is created.

Consider an example where Elements **E1** and **E2** are added to the Pipeline individually in that
order.

@dotfile pipeline-process.dot

**E1** will carry out its processing on the FlowData, then once it is finished, **E2** will
do the same. A consequence of this scenario is that the FlowData created by the Pipeline will not be
thread-safe for the purposes of processing. This improves performance, and is safe as it is known
that **E1** and **E2** will never be writing at the same time.

Now consider an example where both **E1** and **E2** are added in parallel.

@dotfile pipeline-parallel-process.dot

In this case, both will carry out their processing at the same time. This time, the FlowData
which the Pipeline creates will be thread-safe for writing as it is likely that both **E1** and
**E2** will attempt to write their results to the FlowData at the same time.

=========

@htmlonly

<button class="b-btn b-btn--secondary configBtn" onclick="grabSnippet(this, 'pipeline-dotnet', '_snippets.html', 'build-pipeline-cs', 'configBtn', 'config-eg')">C#</button>
<button class="b-btn b-btn--secondary configBtn" onclick="grabSnippet(this, 'pipeline-java', '_snippets.html', 'build-pipeline-java', 'configBtn', 'config-eg')">Java</button>
<div id="config-eg"></div>

@endhtmlonly

=========


## Lifecycle

A Pipeline is the second thing to be created, after the Elements which it contains. It then exists for
as long as processing is required. When a Pipeline is disposed of, it can optionally dispose
of the Elements within too. This makes managing the lifetime of the Elements easy, however this
should not be done if the Elements are also present in another Pipeline.

If an attempt is made to process a FlowData from a Pipeline which has since been disposed, an error
will occur. The Pipeline which creates a FlowData **MUST** exist for as long as the FlowData. This
is also true of post processing usage like retrieving results from the FlowData. Imagine a case
where a certain result has been lazily loaded - a call to get that result will require the FlowElement
which created it to do the loading, so if a Pipeline has disposed of the FlowElement there will be an error.

While not a necessity, it is good practice to dispose of each FlowData produced by the Pipeline once
it is finished with.

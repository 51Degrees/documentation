@page Concepts_Data_FlowData FlowData

## Introduction

**Flow data** is a container that encapsulates all the data related to a single @Pipeline process request.

**Flow data** has several sub-containers that are used to segment the data that it contains:
* @Evidence
* @Elementdata
* Errors

## Evidence

Before the @flowdata is passed into the @Pipeline, input data is supplied. We refer to this data as
'@evidence'.
The @evidence can be set manually or automatically by using a 
[web integration](@ref Concepts_Web_Index) package where available for your web framework of choice.

## Element data

The responses from each @flowelement are stored in key/value pair structure within **flow data**.
In each case, the key is the string key of the @flowelement and the value is an @elementdata instance.
The @Elementdata structure is visible to each @flowelement so one @element can use the result
from another @element in it's processing.

An example where this is required is the 51Degrees @cloudengines. First, an @element makes the
HTTP request to the cloud and stores the JSON response in the **flow data**. Later, another 
@element takes that JSON response and parses it to populate a strongly typed object with values
for the specific @aspect it is concerned with.

## Life cycle


### Creation

**Flow data** is only ever created by a @Pipeline, when the ```CreateFlowData``` method is called.

### Disposal/Cleanup

**Flow data** should be disposed of correctly when no longer in use. This ensures that any 
resources being held by the instance are correctly freed.
(TODO: Add examples for each language)

## Concurrency

Concurrency is a complex topic that has subtle nuances within different languages. As such,
we will describe the data structures used in each langauge separately.

In .NET, by default, the non-thread-safe Dictionary class is used for @elementdata.
@Evidence is build on top of @data and also uses the Dictionary class by default.
In both cases, this can be overriden to use another IDictionary implementation such as the 
thread-safe ConcurrentDictionary.

The errors collection uses the List class. This is not thread-safe. As performance is less 
of an issue with this collection, a simple lock is used to synchronise items being 
added to the list.

TODO: Discuss best way to do this with Ben.

=========

@htmlonly

<button class="b-btn b-btn--secondary iterPropertiesBtn" onclick="grabSnippet(this, 'pipeline-dotnet', '_snippets.html', 'iter-properties', 'iterPropertiesBtn', 'iter-properties-eg')">C#</button>
<button class="b-btn b-btn--secondary iterPropertiesBtn" onclick="grabSnippet(this, 'pipeline-java', '_snippets.html', 'iter-properties', 'iterPropertiesBtn', 'iter-properties-eg')">Java</button>
<div id="iter-properties-eg"></div>

@endhtmlonly

=========

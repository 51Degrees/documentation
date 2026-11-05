@page PipelineApi_Concepts_Data_FlowData Flow data

# Introduction

**Flow data** holds the inputs, outputs, metadata, and errors for one @Pipeline processing request.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/conceptual-overview.md#flow-data)
for more technical details.

# Data structure

**Flow data** has several sub-containers that are used to segment the data that it contains:
* [Evidence](@ref PipelineApi_Concepts_Data_FlowData_Evidence)
* [Element data](@ref PipelineApi_Concepts_Data_FlowData_ElementData)
* [Errors](@ref PipelineApi_Concepts_Data_FlowData_Errors)

## Evidence {#PipelineApi_Concepts_Data_FlowData_Evidence}
Before the @flowdata is passed into the @Pipeline, input data is supplied. We refer to this data as
'@evidence'.
The @evidence can be set manually or automatically by using a 
[web integration](@ref PipelineApi_Features_WebIntegration) package (where available) for your web framework of choice.

Visit the @evidence page for more details.

## Element data {#PipelineApi_Concepts_Data_FlowData_ElementData}
The responses from each @flowelement are stored in a key/value pair structure within **flow data**.
In each case, [the key](@ref PipelineApi_Concepts_Data_ElementDataKey) is the string key of the @flowelement and the value is an @elementdata instance.
The @elementdata structure is visible to each @flowelement so one @element can use the result
from another @element in its processing.

An example where this is required is the 51Degrees @cloudengines. First, an @element makes an
HTTP request to the cloud and stores the JSON response in the **flow data**. Later, another 
@element takes that JSON response and parses it to populate a strongly typed object with values
for the specific [aspect](@term{Aspect}) it is concerned with.

Visit the @elementdata page for more details.

## Errors {#PipelineApi_Concepts_Data_FlowData_Errors}
The errors collection stores the details of any errors that occur during processing.
The language's default exception handling mechanism will be used to catch
and record any exceptions that occur when a @flowelement is processing. However, the processing of 
later @flowelements will continue as normal.

By default, once all @flowelements have been processed, an exception will be thrown with details 
of any errors that have occurred.

The @pipelinebuilder has an option to modify this behavior so that exceptions are totally suppressed.
In this situation, the caller is responsible for handling any exceptions by checking the errors
collection after processing.


# Lifecycle

## Creation

**Flow data** is only ever created by a @Pipeline, when the ```CreateFlowData``` method is called.
This allows the @Pipeline to create the **flow data** internal data structures using implementations
that are most appropriate for the configuration of the @flowelements in the @Pipeline.

For example, thread-safe but slower data collections only need to be used if the @Pipeline
is configured to execute @elements in @parallel.

## Disposal and cleanup

Dispose of **flow data** as soon as it is no longer needed. **Flow data** can hold native resources, such as the results of an on-premise engine, and under high load the garbage collector may not free them fast enough, which can cause an out-of-memory error.

In C# use a `using` block and in Java a try-with-resources block, as shown below. In Python use a `with` statement, and in PHP call `close()`. Node.js has no disposal method, so leave **flow data** to the garbage collector.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@defaultsnippet{Select a language.}
@startsnippet{dotnet}
In .NET, use a using block to dispose of flow data:
```
// Create the FlowData instance.
using (var data = pipeline.CreateFlowData())
{
   ...
}
```
@endsnippet
@startsnippet{java}
In Java, use a try-with-resources block:

```            
// A try-with-resource block MUST be used for 
// the FlowData instance. This ensures that native resources created
// by the device detection engine are freed.
try (FlowData data = pipeline.createFlowData()) {
    ...
}
```
@endsnippet
@endsnippets

# Thread-safety {#PipelineApi_Concepts_Data_FlowData_ThreadSafety}
@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a language.}
@startsnippet{dotnet}
In .NET, by default, the non-thread-safe `Dictionary` class is used for both @elementdata and @evidence.

In both cases, this can be overridden to use another `IDictionary` implementation such as the thread-safe `ConcurrentDictionary`.

The errors collection uses the List class. This is not thread-safe. As performance is less of an issue with this collection, a simple lock is used to synchronize items being added to the list.
@endsnippet
@startsnippet{java}
In Java, by default, the non-thread-safe `TreeMap` class is used for @elementdata and the thread-safe `ConcurrentSkipListMap` class for @evidence.

In both cases, this can be overridden to use another `Map` implementation such as the thread-safe `ConcurrentHashMap`. However, it should be noted that not all `Map` implementations support case insensitivity.
@endsnippet
@startsnippet{php}
PHP runs in a single thread. Consequently, elements cannot run in parallel and 
concurrency issues are not a concern.
@endsnippet
@startsnippet{node}
Node runs in a single thread with asynchronous execution, except where worker threads are used. It is strongly recommended to not share an element data object with a worker thread.
@endsnippet
@endsnippets

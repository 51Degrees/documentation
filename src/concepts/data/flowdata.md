@page Concepts_Data_FlowData Flow Data

# Introduction

**Flow data** is a container that encapsulates all the data related to a single @Pipeline process request.
This includes input and output data as well as metadata related to the processing such as 
the details of any errors that occurred.

# Data structure

**Flow data** has several sub-containers that are used to segment the data that it contains:
* [Evidence](@ref Concepts_Data_FlowData_Evidence)
* [Element data](@ref Concepts_Data_FlowData_ElementData)
* [Errors](@ref Concepts_Data_FlowData_Errors)

## Evidence @anchor Concepts_Data_FlowData_Evidence

Before the @flowdata is passed into the @Pipeline, input data is supplied. We refer to this data as
'@evidence'.
The @evidence can be set manually or automatically by using a 
[web integration](@ref Features_WebIntegration) package (where available) for your web framework of choice.

Visit the @evidence page for more details.

## Element data @anchor Concepts_Data_FlowData_ElementData

The responses from each @flowelement are stored in a key/value pair structure within **flow data**.
In each case, [the key](@ref Concepts_Data_ElementDataKey) is the string key of the @flowelement and the value is an @elementdata instance.
The @elementdata structure is visible to each @flowelement so one @element can use the result
from another @element in its processing.

An example where this is required is the 51Degrees @cloudengines. First, an @element makes an
HTTP request to the cloud and stores the JSON response in the **flow data**. Later, another 
@element takes that JSON response and parses it to populate a strongly typed object with values
for the specific [aspect](@term{Aspect}) it is concerned with.

Visit the @elementdata page for more details.

## Errors @anchor Concepts_Data_FlowData_Errors

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

## Disposal / Cleanup

**Flow data** disposal should be left up to the garbage collector. This ensures that any resource which may still be needed (e.g., if it has been cached) is freed at the correct point.

There are exceptions where **Flow data** must be disposed immediately after it is no longer needed. This is because the garbage collector does not free the resource fast enough under high load and causes an out of memory exception. Two languages where this is required are Java and C#.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@defaultsnippet{Select a language.}
@startsnippet{dotnet}
In .NET, try-with-resource pattern is done as below.
```
// Create the FlowData instance.
using (var data = pipeline.CreateFlowData())
{
   ...
}
```
@endsnippet
@startsnippet{java}
In Java, try-with-resource pattern is done as below.

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

# Thread-safety @anchor Concepts_Data_FlowData_ThreadSafety

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

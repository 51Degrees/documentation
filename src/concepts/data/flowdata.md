@page Concepts_Data_FlowData Flow Data

# Introduction

**Flow data** is a container that encapsulates all the data related to a single @Pipeline process request.
This includes input and output data as well as metadata related to the processing such as 
the details of any errors that occurred.

# Data Structure

**Flow data** has several sub-containers that are used to segment the data that it contains:
* @Evidence
* @Elementdata
* Errors

### Evidence

Before the @flowdata is passed into the @Pipeline, input data is supplied. We refer to this data as
'@evidence'.
The @evidence can be set manually or automatically by using a 
[web integration](@ref Features_WebIntegration) package (where available) for your web framework of choice.

### Element Data

The responses from each @flowelement are stored in key/value pair structure within **flow data**.
In each case, the key is the string key of the @flowelement and the value is an @elementdata instance.
The @elementdata structure is visible to each @flowelement so one @element can use the result
from another @element in its processing.

An example where this is required is the 51Degrees @cloudengines. First, an @element makes an
HTTP request to the cloud and stores the JSON response in the **flow data**. Later, another 
@element takes that JSON response and parses it to populate a strongly typed object with values
for the specific [aspect](@term{Aspect}) it is concerned with.

### Errors @anchor Concepts_Data_FlowData_Errors

The errors collection stores the details of any errors that occur during processing.
The language's default exception handling mechanism will be used to catch
and record any exceptions that occur when a @flowelement is processing. However, processing of 
later @flowelements will continue as normal.

By default, once all @flowelements have been processed, an exception will be thrown with details 
of any errors that have occurred.

The @pipelinebuilder has an option to modify this behavior so that exceptions are totally suppressed.
In this situation, the caller is responsible for handling any exceptions by checking the errors
collection after processing.


# Life Cycle

### Creation

**Flow data** is only ever created by a @Pipeline, when the ```CreateFlowData``` method is called.
This allows the @Pipeline to create the **flow data** internal data structures using implementations
that are most appropriate for the configuration of the @flowelements in the @Pipeline.

For example, thread-safe but slower data collections only need to be used if the @Pipeline
is configured to execute @elements in @parallel.

### Disposal / Cleanup

**Flow data** should be disposed of correctly when no longer in use. This ensures that any 
resources being held by the instance are correctly freed.

TODO: Add the snippets for this example.

=========

@htmlonly

<button class="b-btn b-btn--secondary disposalBtn" onclick="grabSnippet(this, 'pipeline-dotnet', '_snippets.html', 'dispose-flowdata-cs', 'disposalBtn', 'disposal-eg')">C#</button>
<button class="b-btn b-btn--secondary disposalBtn" onclick="grabSnippet(this, 'pipeline-java', '_snippets.html', 'dispose-flowdata-java', 'disposalBtn', 'disposal-eg')">Java</button>
<button class="b-btn b-btn--secondary disposalBtn" onclick="grabSnippet(this, 'pipeline-php', '_snippets.html', 'dispose-flowdata-php', 'disposalBtn', 'disposal-eg')">PHP</button>
<button class="b-btn b-btn--secondary disposalBtn" onclick="grabSnippet(this, 'pipeline-node', '_snippets.html', 'dispose-flowdata-node', 'disposalBtn', 'disposal-eg')">Node.js</button>
<div id="disposal-eg"></div>

@endhtmlonly

=========

# Thread Safety @anchor Concepts_Data_FlowData_ThreadSafety


=========

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@startsnippet{dotnet}
In .NET, by default, the non-thread-safe Dictionary class is used for both @elementdata and @evidence.

In both cases, this can be overridden to use another IDictionary implementation such as the thread-safe ConcurrentDictionary.

The errors collection uses the List class. This is not thread-safe. As performance is less of an issue with this collection, a simple lock is used to synchronize items being added to the list.
@endsnippet
@startsnippet{java}
**todo**
@endsnippet
@startsnippet{php}
PHP runs in a single thread. Consequently, elements cannot run in parallel and 
concurrency issues are not a concern.
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets

=========

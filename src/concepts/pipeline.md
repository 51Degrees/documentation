@page Concepts_Pipeline Pipeline

# Introduction

A **Pipeline** is a customizable data processing system. At the most basic level, input data is 
supplied in the form of @evidence. 
One or more @flowelements in the **Pipeline** then perform processing 
based on that @evidence and optionally, populate data values that 
are required by the user.

The incoming @evidence is usually related to a 
[web request](@term{Concepts_Terminology_WebRequest}), for example 
the HTTP headers, cookies, source IP address or values from the query string.
The @evidence is carried through the **Pipeline** to the 
@elements by a @flowdata instance. 
The @flowdata structure encapsulates all input and output data associated 
with a single **Pipeline** process request.


# Creation

A **Pipeline** is built using a @pipelinebuilder
utilizing the fluent builder pattern. By adding @flowelements
to the **Pipeline**, the nature of the processing it will carry out is defined.

Once created, a **Pipeline** is immutable, i.e. the @flowelements
it contains and the order in which they execute cannot be changed. Individual 
@flowelements may be immutable, or not, based upon their
individual implementations.

As an alternative to configuring a **Pipeline** using a builder, configuration can be supplied from a file. 
Depending on the language features and conventions, this could be formatted as either JSON or XML.
This allows the **Pipeline** to be configurable at runtime without recompiling the code. This is the 
default operation for @webintegrations, but can be used for any other use-case
as well. 
For more on this, see the @buildfromfile section, 
and the [configure from file](@ref Examples_Configure_From_File) example.


# Processing

The flow of a **Pipeline's** operation starts with the creation of a @flowdata.
This is created from the **Pipeline**, and is specific to it. Each @flowdata instance
can only be processed using the **Pipeline** that created it.

Next, @evidence is added to the @flowdata ready 
to be processed.

Finally, the @flowdata is processed. 
Doing this sends the data (along with all the @evidence it
now contains) through the **Pipeline**. Each @flowelement will 
receive the @flowdata and do its processing before optionally updating the 
@flowdata with new values.

Note that the order of execution of @flowelements is decided when the
**Pipeline** is created.
By default, @flowelements are executed sequentially in the order
they are added. However, if the [language supports](@ref Info_FeatureMatrix) it, 
two or more @flowelements
can also be executed in @parallel within the overall sequential structure.

Additionally, the **Pipeline** may offer @asynchronous execution or a @lazyloading capability for individual 
@flowelements. These features are also [language dependent](@ref Info_FeatureMatrix).

Regardless of the method of execution and configuration, after processing the 
@flowdata will contain the results, which can then be accessed by the caller.


@dotfile basic-pipeline-flow.dot

# Public Access

Other than the creation of a new @flowdata, there are very few other 
publicly accessible parts of the **Pipeline**.

@Flowelements inside the **Pipeline** are accessible as 
a read-only collection, and can also be retrieved individually if needed.

All @elementproperties that the **Pipeline's** 
@flowelements can populate are also exposed in one place.
This enables easy iteration over all @elementproperties.

=========

@grabsnippet{iter-properties,pipeline-dotnet,_snippets.html,iter-properties,C#}
@grabsnippet{iter-properties,pipeline-java,_snippets.html,iter-properties,Java}

@grabbedexample{iter-properties}

=========

An @evidencekeyfilter is also exposed. 
This aggregates all the evidence keys accepted by all the 
@flowelements within the **Pipeline**. 
This can be used by the caller to check which items of @evidence 
could affect the result of processing.


# Internals

The structure of the @flowelements within the 
**Pipeline**, and the @flowdata which it creates, is determined
by how it is created.

Consider an example where @flowelements **E1** 
and **E2** are added to the **Pipeline** individually in that order.

@dotfile pipeline-process.dot

**E1** will carry out its processing on the @flowdata, then 
once it is finished, **E2** will do the same. In this scenario, the **Pipeline** 'knows' 
that the @flowdata will not be written to by multiple threads.
As such, the @flowdata created by the **Pipeline** will not be
thread-safe but will have slightly improved performance.

Now consider an example where both **E1** and **E2** are added in parallel.

@dotfile pipeline-parallel-process.dot

In this case, both will carry out their processing at the same time. This time, the 
@flowdata
which the **Pipeline** creates will be thread-safe for writing as it is possible that both 
**E1** and **E2** will attempt to write their results to the FlowData at the same time.

TODO: The above example is language-specific.

=========

@grabsnippet{config,pipeline-dotnet,_snippets.html,build-pipeline-cs,C#}
@grabsnippet{config,pipeline-java,_snippets.html,build-pipeline-java,Java}

@grabbedsnippet{config}

=========


# Lifecycle

A **Pipeline** is the second thing to be created, after the 
@flowelements which it contains. It then exists for
as long as processing is required. When a **Pipeline** is disposed of, it can optionally dispose
of the @flowelements within too. 
This makes managing the lifetime of the @flowelements
easy, however this should not be done if the same 
@flowelement instances have also been added to 
another **Pipeline**.

If an attempt is made to process a @flowdata from a **Pipeline**
which has since been disposed, an error
will occur. The **Pipeline** which creates a @flowdata **MUST** 
exist for as long as the @flowdata. This
is also true of post processing usage like retrieving results from the 
@flowdata. 
Imagine a case where a certain result has been [lazily loaded] (@ref Concepts_Feature_LazyLoading) -- 
a call to get that result will require the @flowelement
which created it to do the loading, so if the **Pipeline** has disposed of the 
@flowelement, there will be an error.

While not a necessity, it is good practice to dispose of each 
@flowdata produced by the **Pipeline** once
it is finished with.


(TODO description on why memory management matters for languages that usually don't have to worry about it)

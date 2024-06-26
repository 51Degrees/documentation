@page Concepts_FlowElements_FlowElement Flow Element

# Introduction

A **flow element** is an atomic processing component of a @Pipeline. 
It takes an input in the form of @evidence, and outputs results in the form of @elementdata. 
A **flow element** can be seen as a black
box where the internal method of processing, and the way in which it is used externally, are decoupled, such
that any **element** can be used in the same manner, regardless of its input, output, or method of processing.
These are the building blocks of a @pipeline, and do all the processing as instructed by
the @pipeline they reside in.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/conceptual-overview.md#flow-element)
for more technical details.

# Creation

**Flow elements** are built using a corresponding @elementbuilder, which
follows the fluent builder pattern. All configuration of an **element** occurs in the
@elementbuilder.
By convention, the configuration of an **element** is immutable once it has been built. 
However, this is not enforced, and is dependent on the implementation of each specific **element**.

# Processing

The primary function of a **flow element** is to process data. Both the input (@evidence) and output
(@elementdata) of the processing are contained in a single place called a @flowdata.

The **flow element** typically uses the @evidence contained within the supplied @flowdata to
determine the values it will populate in the resulting @elementdata, which is then added to the @flowdata
as an output.

However, **flow elements** may also use existing @elementdata from the @flowdata as input, and 
are not required to populate any output data.


@dotfile flowelement-process.gvdot

<!--(TODO: I'm not sure the diagram above is very clear. Possibly need to whiteboard some ideas)-->


For example, a 'user age' **element** might look for a date of birth in the @evidence, and set
the age of the user in an @elementdata instance before adding the @elementdata into the same 
@flowdata which the @evidence came from.

@dotfile ageelement-process.gvdot

# Hierarchy

While an implementation can implement just **flow element**, useful functionality is built up in layers as shown below.
Any of these layers can be added to by an implementation, depending on its requirements.

In languages which support inheritance, this is a structural hierarchy. In other languages, this may be more of a conceptual
hierarchy, and not reflected directly in the code.

@dotfile flowelement-hierarchy.gvdot


# Properties

The @elementdata produced by an **element** contains values of @properties based on the
@evidence provided. Each **element** has a set of @properties it can populate values for.

The @properties populated by an **element** can be queried directly to retrieve metadata relating 
to each property. The data available will vary by implementation but will typically include
information such as the property name and data type. 

# Evidence keys

Each **element** can only make use of certain items of @evidence during processing. In the **age element**
example above, it expects a date of birth to be present in the @evidence.

The items of @evidence which an **element** can make use of are exposed via an @evidencekeyfilter. This is 
also available in an aggregated form from the parent @Pipeline. 
(This would be equivalent to combining the @evidencekeyfilter from each **element** of the @pipeline individually).

Using an @evidencekeyfilter means that instead of asking an **element** "which items of @evidence do you want?", 
one would ask "do you want this item of @evidence?". This gives an 
**element** a greater degree of flexibility with how it specifies the @evidence that it accepts. 
For example, it allows an **element** to easily indicate that it can make use of any HTTP headers, regardless of 
the header name.

@dotfile flowelement-evidencekeys.gvdot


# Data keys

Results of an **element's** processing are stored in the @flowdata, keyed on the **element's** @elementdatakey. 
While not required, it is convention that each **element** has a unique key name. 
For example, our 'user age' example would likely have the key name 'user age'.

In addition to the name, an @elementdatakey also contains the type of @elementdata that the element populates.
Please note that this is only the case in languages which support this.


# Creating data

When an **element** adds @elementdata to a @flowdata, it cannot be assumed that an @elementdata does not
already exist for the **element**. For this reason, an **element** contains an 'element data factory', which
it gives to the @flowdata when it asks for a new or existing @elementdata. A method is called on the @flowdata,
giving the factory as an argument, and the @flowdata returns either the @elementdata previously created with
the same key, or a new @elementdata from the factory which it has added to its internal structure.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@defaultsnippet{Select a language to view an example of the 'get or add' method.}
@startsnippet{dotnet}
In .NET, the 'factory' is an anonymous function given to the **element** at construction,
taking a @flowdata and returning an @elementdata.
```{cs}
var elementData = flowData.GetOrAdd(ElementDataKeyTyped, CreateElementData);
```
@endsnippet
@startsnippet{java}
In Java, the 'factory' is an instance of a factory class given to the **element** at construction,
taking a @flowdata and returning an @elementdata.
```{java}
final TData aspectData = flowData.getOrAdd(getTypedDataKey(), getDataFactory());
```
@endsnippet
@endsnippets
# Scope

By convention, an **element's** configuration is immutable once created. Although this is not enforced.

An **element** can be added to any number of @pipelines. A @pipeline is merely an organizational layer which instructs **elements** to
carry out processing on a @flowdata, so the **element** acts in isolation without the need to reference to the @pipeline.

It is also possible for an **element** to be added more than once to the same @pipeline. For example, an **element** which opens a
persistent connection to a database, then closes it at another point in the @pipeline, would exist more than once in the same @pipeline.
In this case, it is the responsibility of the **element** to ensure access to a @flowdata isn't assumed as a fresh instance, and is
accessed in a safe manner.


# Thread-safety

**Flow elements** are required to be thread-safe in languages that support multi-threaded operations. As multiple @pipelines may be
calling on an **element** to carry out processing simultaneously, they must be able to handle this.

**Flow elements** also expose whether or not they will carry out concurrent operations, as the @pipeline needs to know this.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a language to view language specific info on thread-safety.}
@startsnippet{dotnet}
**Flow elements** in C# are generally immutable, so do not need thread safety built in directly, however they often alter a @flowdata which
must be done in a thread-safe way. Accessing the internal data structure is usually left up to the @flowdata itself by exposing a thread safe
`set` method to the **element**.
@endsnippet
@startsnippet{java}
**Flow elements** in Java are generally immutable, so do not need thread safety built in directly, however they often alter a @flowdata which
must be done in a thread-safe way. Accessing the internal data structure is usually left up to the @flowdata itself by exposing a thread safe
`set` method to the **element**.
@endsnippet
@startsnippet{php}
PHP runs in a single thread. Consequently, elements cannot run in parallel and 
concurrency issues are not a concern.
@endsnippet
@startsnippet{node}
Node runs in a single thread with asynchronous execution, except where worker threads are used. It is strongly recommended to not share a flow element object with a worker thread.
@endsnippet
@endsnippets

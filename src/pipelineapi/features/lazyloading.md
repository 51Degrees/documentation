@page PipelineApi_Features_LazyLoading Lazy Loading

# Introduction

Lazy loading is a concept whereby an object is not loaded until it is actually needed. This can mean that it
does not start loading until it is required, or it is loaded in the background so that there is no delay in the 
execution of other logic. The latter is usually preferable, as loading in the background often results in no
waiting at all (i.e., by the time the object is needed, it has already been loaded).

In the context of a @pipeline, lazy loading refers to the way values are populated in an @aspectdata. Usually
the default is to not lazily load them, so an @aspectengine's processing does not finish until all values
have been populated. When lazy loading is configured in an @aspectengine, values begin to load in another
thread, and other processing can continue.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/advanced-features/lazy-loading.md#)
for more technical details.

# Caveats

Getting an @aspectproperty's value from an @aspectdata which has been lazily loaded has the added
complexity of the value not yet being known. Consequently, an exception that would otherwise have
occurred during the @pipeline's processing stage has now been deferred until the point at which a value
is fetched. When lazy loading is enabled, this extra possibility of an error should be taken into
consideration.

# Configuration

Lazy loading has two main configuration options.

## Property timeout

As it is not known at the point of fetching an @aspectproperty's value whether or not it has been
populated, a timeout option is available. This is the time to wait for the value before throwing an
exception.


## Cancellation

In languages where it is possible, a 'cancellation token' can be provided. This is a means of
canceling all processing which is still being carried out internally to the @aspectdata.


# Implementation

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@showsnippet{python,Python}
@defaultsnippet{Select a tab to view language specific implementation details.}
@startsnippet{dotnet}
Lazy loading functionality in .NET is fulfilled by `Tasks`. An @aspectengine's processing will be
added to its @aspectdata as a new `Task` using its `AddProcessTask` method . Then when a value is
requested from the @aspectdata, the `Task` is waited on by internal methods.

The cancellation token in C# is the `CancellationToken` class from System.

In the case where fetching a property times out, a `TimeoutException` is thrown, or if the token has
been used to cancel processing, a `OperationCanceledException` is thrown.
@endsnippet
@startsnippet{java}
Lazy loading functionality in Java is fulfilled by the `Callable` class which returns a `Future`. An
@aspectengine's processing will be added to its @aspectdata as a new `Callable` using its `addProcessCallable`
method. Then when a value is requested from the @aspectdata, the `Future` is waited on by internal methods.

Java does not support cancellation tokens. However, an aggregate `Future` is exposed by an @aspectdata which
can be canceled in the same manner as an individual `Future`, canceling all futures associated with the
@aspectdata.

In the case where fetching a property times out, a `LazyLoadTimeoutException` is thrown. Or, if the aggregate
future has been canceled, a `CancellationException` is thrown.
@endsnippet
@startsnippet{php}
PHP does not support lazy loading
@endsnippet
@startsnippet{node}
As Node.js is inherently asynchronous, it will always function in a similar way to a lazy loading 
implementation without the need for specific functionality.
@endsnippet
@startsnippet{python}
Python does not support lazy loading
@endsnippet
@endsnippets

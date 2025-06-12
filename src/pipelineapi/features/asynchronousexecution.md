@page PipelineApi_Features_AsynchronousExecution Asynchronous Execution

# Introduction

In the context of the @Pipeline, **asynchronous execution** refers to the use of 
non-blocking processing. 
@Lazyloading is closely related to this as it is effectively non-blocking processing 
for an individual @aspectengine.
In contrast, **asynchronous execution** refers to non-blocking execution of the 
@Pipeline as a whole.

# Language support

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a language to view details of **asynchronous execution** support for that language.}
@startsnippet{dotnet}
.NET supports asynchronous code using the [Task asynchronous programming model](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/async/).
However, for .NET we have decided to implement a @lazyloading feature instead of a fully
asynchronous approach as we believe this gives better control to the developer.
@endsnippet
@startsnippet{java}
Java supports asynchronous code using the [CompletableFuture](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/CompletableFuture.html) class.
For Java we have decided to implement a @lazyloading feature instead of a fully
asynchronous approach as we believe this gives better control to the developer.
@endsnippet
@startsnippet{php}
PHP is single-threaded and does not support non-blocking execution out of the box.
The @Pipeline has no support for **asynchronous execution** nor @lazyloading in PHP.  
@endsnippet
@startsnippet{node}
Node.js, being based on JavaScript is a fundamentally asynchronous language. As such,
the @Pipeline will work in a non-blocking way by default through the use of promises.

See the node documentation for more details about 
[blocking vs non-blocking calls](https://nodejs.org/de/docs/guides/blocking-vs-non-blocking/). 
@endsnippet

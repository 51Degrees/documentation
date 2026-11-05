@page PipelineApi_Features_AsynchronousExecution Asynchronous Execution

# Introduction

**Asynchronous execution** runs the @Pipeline without blocking the caller. @Lazyloading provides non-blocking processing for an individual @aspectengine.

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
In Node.js, the @Pipeline uses JavaScript promises to process requests without blocking by default.

See the node documentation for more details about 
[blocking vs non-blocking calls](https://nodejs.org/de/docs/guides/blocking-vs-non-blocking/). 
@endsnippet

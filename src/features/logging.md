@page Features_Logging Logging

# Introduction

**Logging** is available in all parts of the @pipeline, including @flowdata and @flowelements.
The way **logging** is set up and used is very dependent on the language, as each language
will have its own idiomatic way of carrying it out. Any **logging** method which matches the
language's logging interface can be used. Where possible, dependency injection
is used to introduce a **logger** / **logger factory** to the @pipeline.


# Configuration

Idiomatic set up of logging differs a lot between languages, but the basic principals apply
to all. A logger factory is provided to all @builders so everything has access to logging
functionality by creating a logger for its instance. Standard log levels are adhered to,
so the information logged can be limited to 'warn' etc.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific information on configuring **logging**}
@startsnippet{dotnet}
In C#, the ILogger interface is used for logging. This means that @pipelinebuilders and @elementbuilders
should be supplied with an implementation of ILoggerFactory which will create **logger** instances for each
@pipeline and @flowelement they create. **Loggers** will also be created for all @flowdata and @elementdata
that are created.

The simplest way is to create the default Microsoft implementation available in Microsoft.Logging.Extensions:
```
ILoggerFactory loggerFactory = new LoggerFactory();
```

In an ASP.NET Core environment, a **logger** can be introduced via dependency injection. **todo...**
@endsnippet
@startsnippet{java}
**todo**
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets
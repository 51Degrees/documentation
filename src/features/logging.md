@page Features_Logging Logging

# Introduction

**Logging** is available in all parts of the @pipeline, including @flowdata and @flowelements.
How **logging** is implemented will differ depending on language, with each having
its own idiomatic way of performing the function. Any **logging** method which matches the
language's logging interface can be used. Where possible, dependency injection
is used to introduce a **logger** / **logger factory** to the @pipeline.


# Configuration

Idiomatic set up of logging varies greatly between languages, but the basic principals apply
to all. A logger factory is provided to all @builders so everything has access to logging
functionality by creating a logger for its instance. Standard log levels are adhered to,
so the information logged can be limited to 'warn' for example.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific information on configuring **logging**}
@startsnippet{dotnet}
In C#, the `ILogger` interface from Microsoft.Extensions.Logging.Abstractions is used for **logging**.
This means that @pipelinebuilders and @elementbuilders should be supplied with an implementation 
of `ILoggerFactory` which will create **logger** instances for each @pipeline and @flowelement
they create. **Loggers** will also be created for all @flowdata and @elementdata that are created.

The simplest way is to create the default Microsoft implementation available in Microsoft.Extensions.Logging:
```{cs}
ILoggerFactory loggerFactory = new LoggerFactory();
```

In an ASP.NET Core environment, a **logger** can be introduced via dependency injection when starting up the
service. This will then be injected into the @pipelinebuilder.
@endsnippet
@startsnippet{java}
In Java, the `Logger` interface from org.slf4j.slf4j-api is used for **logging**. This means that
@pipelinebuilders and @elementbuilders should be supplied with an implementation of `ILoggerFactory` which
will create **logger** instances for each @pipeline and @flowelement that are created.

The simplest way is to include a dependency on an implementation of slf4j-api such as org.slf4j.slf4j\c \-simple:
```{xml}
<project>
  ...
  <dependencies>
    <dependency>
      <groupId>org.slf4j</groupId>
      <artifactId>slf4j-simple</artifactId>
      <version>${slf4j-simple.version}</version>
    </dependency>
    ...
  </dependencies>
  ...
</project>

```

This will then be injected automatically when creating @builders using their default constructors.

Alternatively, an implementation can be passed explicitly in a @builder's constructor:
```{java}
PipelineBuilder builder = new PipelineBuilder(new MyLoggerFactory());
```
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets
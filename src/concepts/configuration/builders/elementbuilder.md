@page Concepts_Configuration_Builders_ElementBuilder Element Builder

# Introduction

@Flowelements are constructed using a **builder** which follows the
[fluent builder pattern](https://en.wikipedia.org/wiki/Fluent_interface).
This gives a consistent structure when building any @flowelement and allows
automatic building via configuration files.

Typically the @flowelement built by an **element builder** is added to a @pipeline
via a @pipelinebuilder.

By convention, the configuration of a @flowelement is immutable once it has been
constructed, so all configuration should be done in the **builder**.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/features/pipeline-configuration.md)
for more technical details.

# Configuration

Following the convention of fluent builder, configuration methods are prefixed with 'set'. For example,
the method to set a configuration option with the name 'cachesize' would have a 'SetCacheSize' method which
takes the value of the option as an argument and returns the **builder**.

The precise constraints around these methods vary by language.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@defaultsnippet{Select a language.}
@startsnippet{dotnet}
In .NET, the user is free to define methods on the builder as they wish.
However, if they want to take advantage of the @buildfromconfiguration method on the @Pipeline then they must 
follow certain rules:

1. A configuration method on an **element builder** must have one and only one parameter.
2. The builder must have at least one method named 'Build' which returns an instance that implements `IFlowElement`.
3. The types of any parameters on configuration methods and build methods must be string or have a static 
'TryParse' method. This can be an extension method if needed. It is used to parse the string value from the 
configuration file.
@endsnippet
@startsnippet{java}
In Java, the user is free to define methods on the builder as they wish.
However, if they want to take advantage of the @buildfromconfiguration method on the @Pipeline then they must 
follow certain rules:

1. A configuration method on an **element builder** must have one and only one parameter.
2. The builder must have at least one method named 'Build' which returns an instance that implements `FlowElement`.
3. The types of any parameters on configuration methods and build methods must be string or have a static `parse` method. This can be in the boxed class in the case of primative type e.g. `Integer.parseInt` is used for `int`. It is used to parse the string value from the configuration file.
@endsnippet
@endsnippets

# Building

Once all options are set in the **builder**, a 'build' method is used to build and return a @flowelement
with the configuration provided. 
A build method can take additional arguments and a **builder** may have multiple build methods.
When an argument appears on all build methods for that **builder** it becomes compulsory.

For example, a 'Resource Key' is compulsory for 51Degrees' @cloudengines. Consequently, it appears as 
an argument in all build methods for the associated **builders**.

Combinations of compulsory arguments can also be arranged. For example, 51Degrees' @onpremiseengines 
require either a filename or a data structure containing the file data in memory.
Therefore they have two build methods, one taking a filename and the other taking the memory-based
data structure.

# Usage

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@defaultsnippet{Select a language.}
@startsnippet{dotnet}
```{cs}
IFlowElement element = new ElementBuilder(loggerFactory)
    .SetOption(value)
    .SetAnotherOption(anotherValue)
    .Build(compulsoryOption);
```
@endsnippet
@startsnippet{java}
```{java}
FlowElement element = new ElementBuilder(loggerFactory)
    .setOption(value)
    .setAnotherOption(anotherValue)
    .build(compulsoryOption);
```
@endsnippet
@endsnippets

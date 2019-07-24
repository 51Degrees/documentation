@page Concepts_Configuration_Builders_PipelineBuilder Pipeline Builder

# Introduction

A @pipeline is created using a **builder** which follows the
[fluent builder pattern](https://en.wikipedia.org/wiki/Fluent_interface).
@Flowelements are added to a @pipeline via the **builder**, along with
other configuration options for the @pipeline. In languages that support it, a @pipeline can also be
built from a configuration.

A @pipeline's configuration is immutable once it has been constructed, so
all its configuration must be done in the **builder**.


# Options

## Auto Dispose Elements

By default, when a @pipeline is disposed of, the @flowelements which it
contained will still exist and will need to be disposed of at some point.

An option is available in the **Pipeline builder** to automatically dispose
of all the @pipeline's @flowelements during its own disposal. 
This option should not be used when a @pipeline contains @flowelements which
are also present in another @pipeline, as they may still be required elsewhere. This should not usually be the case, but must be 
considered if building multiple @pipelines.


## Suppress Process Exceptions @anchor Concepts_Configuration_Builders_PipelineBuilder_SuppressProcessExceptions

By default, exceptions that occur during the processing of a @flowdata will be thrown. 
However, it is sometimes preferable to suppress and analyze
these at runtime, rather than breaking the execution.

By enabling this option, any exceptions that occur during the processing of a
@flowdata are added to an [errors](@ref Concepts_Data_FlowData_Errors) collection
in the @flowdata and are not thrown.

# Configuration

Following the convention of fluent builder, configuration methods are prefixed with 'set'. For example,
to set the 'auto dispose elements' option, the **builder** has a 'SetAutoDisposeElements' method which
takes a boolean as an argument and returns the **builder**.


# Building

Once all options are set in the **builder**, a 'build' method is used to build and return a @pipeline
with the configuration provided.

# Building From a Configuration

Rather than setting all build options and @flowelements explicitly in code form, it is often
preferable to make the @pipeline configurable without recompiling. For more on this, see
[Building from Configuration](@ref Concepts_Configuration_Builders_BuildFromConfiguration).

# Usage

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@startsnippet{none,block}
Select a language to view language specific usage example.
@endsnippet
@startsnippet{dotnet}
```{cs}
IPipeline pipeline = new PipelineBuilder(loggerFactory)
    .SetAutoDisposeElements(true)
    .SetSuppressProcessException(true)
    .AddFlowElement(element)
    .Build();
```
@endsnippet
@startsnippet{java}
```{java}
Pipeline pipeline = new PipelineBuilder(loggerFactory)
    .setAutoDisposeElements(true)
    .setSuppressProcessException(true)
    .addFlowElement(element)
    .build();
```
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet

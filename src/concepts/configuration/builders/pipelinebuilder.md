@page Concepts_Configuration_Builders_PipelineBuilder Pipeline Builder

# Introduction

A @pipeline is created using a **builder** which follows the
[fluent builder pattern](https://en.wikipedia.org/wiki/Fluent_interface).
@Flowelements are added to a @pipeline via the **builder**, along with
other configuration options for the @pipeline. A @pipeline can also be
built from a configuration by using dependency injection to find and build
the @flowelements it needs in languages where this is supported.

A @pipeline's configuration is immutable once it has been constructed, so
all of its configuration must be done in the **builder**.


# Options

## Auto Dispose Elements

By default, when a @pipeline is disposed of, the @flowelements which it
contained will still exist and will need to be disposed of at some point.

An option is available in the **Pipeline builder** to automatically dispose
of all the @pipeline's @flowelements during its own disposal.

This option should not be used when a @pipeline contains @flowelements which
are also present in another @pipeline, as the other @pipeline will then not
function as intended. This will not usually be the case, but should be a
consideration when building multiple @pipelines.


## Suppress Process Exceptions

When exceptions occur during the processing of a @flowdata, these will be thrown
by default. However, it is sometimes preferable to suppress these and analyze
them at runtime rather than letting them break execution.

By enabling this option, any exceptions that occur during the processing of a
@flowdata are added to an [errors](@ref Concepts_Data_FlowData_Errors) collection
in the @flowdata instead of being thrown.

# Configuration

Following the convention of fluent builder, configuration options are set using 'set' naming. For example,
to set a the 'auto dispose elements' option, the **builder** has a 'SetAutoDisposeElements' method which
takes a boolean as an argument and returns the **builder**.


# Building

Once all configuration are set in a **builder**, a 'build' method is used to build a @pipeline
using the configuration options provided.

# Usage

@startsnippets{usage}
@showsnippet{usage,dotnet,C#}
@showsnippet{usage,java,Java}
@showsnippet{usage,php,PHP}
@showsnippet{usage,node,Node.js}
@startsnippet{none,block}
Select a language to view language specific usage example.
@endsnippet
@startsnippet{dotnet}
@snippet snippets.cs Using a pipeline builder
@endsnippet
@startsnippet{java}
@snippet snippets.java Using a pipeline builder
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet

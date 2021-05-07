@page Examples_CustomElement_Cloud Custom Cloud Engine

# Introduction

This example takes the very simple @flowelement described in the
[simple flow element example](@ref Examples_CustomElement_FlowElement),
and delegates all the logic to a cloud service.

Instead of the data being stored locally and processing being carried out by the @flowelement
directly, as demonstrated in the [simple flow element example](@ref Examples_CustomElement_FlowElement),
this example will call a cloud service to perform the required functionality.

# Download Example

The source code used in this example is available here:
- [C# Visual Studio project](https://github.com/51degrees/pipeline-dotnet)
- [Java project](https://github.com/51degrees/pipeline-java)
- [PHP project](https://github.com/51degrees/pipeline-php)
- [Node.js project](https://github.com/51degrees/pipeline-node)

# Dependencies

The @aspectengine will need a dependency on the @pipeline engines package, and cloud request engine package

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific dependencies.}
@startsnippet{dotnet}
The dependencies needed for .NET are the `FiftyOne.Pipeline.Engines` and
`FiftyOne.Pipeline.CloudRequestEngine` NuGet packages.
@endsnippet
@startsnippet{java}
The only dependency needed for Java is the `pipeline.core` Maven package from `com.51degrees`.
To include this, add the following to the `<dependencies>` section of the project's `pom.xml`:
```{xml}
<dependency>
    <groupId>com.51degrees</groupId>
    <artifactId>pipeline.cloudrequestengine</artifactId>
    <version>4.2.0</version>
</dependency>
<dependency>
    <groupId>com.51degrees</groupId>
    <artifactId>pipeline.engines</artifactId>
    <version>4.2.0</version>
</dependency>
```
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets



# Data

The @elementdata implemented in the previous example can now be upgraded to implement an
@aspectdata.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific @aspectdata implementation.}
@startsnippet{dotnet}
Instead of implementing `IElementData`, the `IStarSignData` will now implement `IAspectData`
which extends `IElementData`.

@snippet SimpleCloudEngine/Data/IStarSignData.cs class

Now the internal implementation of it will implement a 'getter' and add a 'setter' for `StarSign` in the
same way as the [previous example](@ref Examples_CustomElement_FlowElement).

@snippet SimpleCloudEngine/Data/StarSignData.cs class

@endsnippet
@startsnippet{java}
Instead of implementing `ElementData`, the `StarSignData` will now implement `AspectData`
which extends `ElementData`.

@snippet developerexamples/cloudengine/data/StarSignData.java class

Now the internal implementation of it will implement a 'getter' and add a 'setter' for `StarSign` in the
same way as the [previous example](@ref Examples_CustomElement_FlowElement).

@snippet developerexamples/cloudengine/flowelements/StarSignDataInternal.java class

Note that this concrete implementation of `StarSignData` sits in the same package as the @aspectengine,
not the `StarSignData` interface, as it only needs to be accessible by the @aspectengine.
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets


# Aspect Engine

Now the actual @aspectengine needs to be implemented. For this, the class from the
[previous example](@ref Examples_CustomElement_FlowElement) will now implement the
[cloud aspect engine's](@ref Concepts_FlowElements_CloudEngine) base class.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific @aspectengine implementation.}
@startsnippet{dotnet}
First let's change the class to extend `CloudAspectEngineBase`. This has the type arguments of
`IStarSignData` - the interface extending @aspectdata which will be added to the @flowdata, and 
`IAspectPropertyMetaData` - instead of `IElementPropertyMetaData`.

The existing constructor needs to change to match the `CloudAspectEngineBase` class.

The constructor will also take a `CloudRequestEngine` instance to get the available properties
from.

@snippet SimpleCloudEngine/FlowElements/SimpleCloudEngine.cs constructor

The `LoadAspectProperties` method in this example will get the @aspectproperties from the `CloudRequestEngine`
and store them. In this case we know the only property will be 'star sign', but more complex @cloudengines can have many
properties.

@snippet SimpleCloudEngine/FlowElements/SimpleCloudEngine.cs loadaspectproperties

Now the abstract methods can be implemented to create a functional @aspectengine.

@snippet SimpleCloudEngine/FlowElements/SimpleCloudEngine.cs class

@endsnippet
@startsnippet{java}
First let's change the class to extend `CloudAspectEngineBase`. This has the type arguments of
`StarSignData` - the interface extending @aspectdata which will be added to the @flowdata, and 
`AspectPropertyMetaData` - instead of `ElementPropertyMetaData`.

The existing constructor needs to change to match the `CloudAspectEngineBase` class.

The constructor will also take a `CloudRequestEngine` instance to get the available properties
from.

@snippet developerexamples/cloudengine/flowelements/SimpleCloudEngine.java constructor

The `loadAspectProperties` method in this example will get the @aspectproperties from the `CloudRequestEngine`
and store them. In this case we know the only property will be 'star sign', but more complex @cloudengines can have many
properties.

@snippet developerexamples/cloudengine/flowelements/SimpleCloudEngine.java loadaspectproperties

Now the abstract methods can be implemented to create a functional @aspectengine.

@snippet developerexamples/cloudengine/flowelements/SimpleCloudEngine.java class

@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets


# Builder

Now the @aspectengine needs one final thing, an @elementbuilder to construct it.
This needs to provide the @aspectengine with a logger and an @aspectdata factory as in
the previous example. However, it also now needs a cloud request @aspectengine.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific @elementbuilder implementation.}
@startsnippet{dotnet}
As this @aspectengine is using a @datafile, the builder can make use of the logic in the
`CloudAspectEngineBuilderBase`.

@snippet SimpleCloudEngine/FlowElements/SimpleCloudEngineBuilder.cs class

@endsnippet
@startsnippet{java}
As this @aspectengine is using a @datafile, the builder can make use of the logic in the
`CloudAspectEngineBuilderBase`.

@snippet developerexamples/cloudengine/flowelements/SimpleCloudEngineBuilder.java class

@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets


# Usage

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific usage.}
@startsnippet{dotnet}
This new @aspectengine can now be added to a @pipeline along with a `CloudRequestEngine`,
and used like:

@snippet SimpleCloudEngine/Program.cs usage

to give an output of:
```{bash}
With a date of birth of 18/12/1992, your star sign is Sagittarius.
```
@endsnippet
@startsnippet{java}
This new @aspectengine can now be added to a @pipeline along with a `CloudRequestEngine`,
and used like:

@snippet developerexamples/cloudengine/Main.java usage

to give an output of:
```{bash}
With a date of birth of 18/12/1992, your star sign is Sagittarius.
```
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets

# Next Steps

The [Custom On-premise Engine](@ref Examples_CustomElement_OnPremise) example shows you how to build an on premise engine to perform the functionality that was executed by the **cloud engine** here.
@page Examples_CustomElement_FlowElement Simple Custom Flow Element

# Introduction

This example shows a very simple @flowelement which takes a date of birth
and returns an star sign. Although a basic (and not all that useful) @flowelement, the
example demonstrates how you can start to implement your own @flowelements.

# Download example

The source code used in this example is available here:
- [C# Visual Studio project](https://github.com/51degrees/pipeline-dotnet)
- [Java project](https://github.com/51degrees/pipeline-java)
- [PHP project](https://github.com/51Degrees/pipeline-php-core)
- [Node.js project](https://github.com/51degrees/pipeline-node)

# Dependencies

The @flowelement will need a reference to the @pipeline core package

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific dependencies.}
@startsnippet{dotnet}
Create a new console project (.NET Core or Framework) and add a reference to
the `FiftyOne.Pipeline.Core` NuGet package.
@endsnippet
@startsnippet{java}
The only dependency needed for Java is the `pipeline.core` Maven package from `com.51degrees`.
To include this, add the following to the `<dependencies>` section of the project's `pom.xml`:
```{xml}
<dependency>
    <groupId>com.51degrees</groupId>
    <artifactId>pipeline.core</artifactId>
    <version>4.2.0</version>
</dependency>
```
@endsnippet
@startsnippet{php}
Add a dependency to the `fiftyone.pipeline.core` composer package to the composer.json, and required it in the source with `include("../vendor/autoload.php");`
@endsnippet
@startsnippet{node}
Add a dependency to the `fiftyone.pipeline.core` NPM package to the package.json, and required it
in the source with `require("fiftyone.pipeline.core")`.
@endsnippet
@endsnippets


# Data

The @elementdata being added to the @flowdata by this @flowelement is a star sign. So this should
have its own 'getter' in its @elementdata.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific @elementdata implementation.}
@startsnippet{dotnet}
.NET supports interfaces, so the @elementdata should have a public interface and an internal
concrete implementation with easy 'setters'.

In this example, only one value is populated. So an interface `IStarSign` will extend `IElementData`
to add a 'getter' for it.

@snippet "CustomFlowElement/1. Simple Flow Element/Data/IStarSignData.cs" class

Now the internal implementation of it will implement this 'getter' and add a 'setter' for the @flowelement
to use.

@snippet "CustomFlowElement/1. Simple Flow Element/Data/StarSignData.cs" class

@endsnippet
@startsnippet{java}

Java supports interfaces, so the @elementdata should have a public interface and a package private
concrete implementation with easy 'setters'.

In this example, only one value is populated. So an interface `StarSignData` will extend `ElementData`
to add a 'getter' for it.

@snippet "pipeline.developer-examples.flowelement/src/main/java/pipeline/developerexamples/flowelement/data/StarSignData.java" class

Now the internal implementation of it will implement this 'getter' and add a 'setter' for the @flowelement
to use.

@snippet "pipeline.developer-examples.flowelement/src/main/java/pipeline/developerexamples/flowelement/flowelements/StarSignDataInternal.java" class

Note that this concrete implementation of `StarSignData` sits in the same package as the @flowelement,
not the `StarSignData` interface, as it only needs to be accessible by the @flowelement.
@endsnippet
@startsnippet{php}
PHP's implementation of @elementdata does not require concrete getters for IDE autocompletion, so `elementDataDictionary` can be used.
@endsnippet
@startsnippet{node}
Node's implementation of @elementdata does not require concrete getters for IDE autocompletion, so `elementDataDictionary` can be used.
@endsnippet
@endsnippets

# Flow element

Now the actual @flowelement needs to be implemented. For this, the @flowelement's base class
can be used which deals with most of the logic. The @elementproperties,
@evidencekeys and the processing are all that need implementing.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific @flowelement implementation.}
@startsnippet{dotnet}
First let's define a class which extends `FlowElementBase` (and partially implements `IFlowElement`).
This has the type arguments of `IStarSignData` - the interface extending @elementdata which will be 
added to the @flowdata, and  `IElementPropertyMetaData` - as we only need the standard metadata for
@elementproperties.

This needs a constructor matching the `FlowElementBase` class. So it takes a logger, and an
@elementdata factory which will be used to construct an `IStarSignData`:

@snippet "CustomFlowElement/1. Simple Flow Element/FlowElements/SimpleFlowElement.cs" constructor

The `Init` method in this example will simply initialize a list of star signs with the start and end dates of
each star sign and add each to a list of a new class named `StarSign` which has the following simple implementation:

@snippet "CustomFlowElement/1. Simple Flow Element/Data/StarSign.cs" class

Note that the year of the start and end date are both set to 1, as the year should be ignored, but
the year 0 cannot be used in a `DateTime`.

The new `Init` method looks like this:

@snippet "CustomFlowElement/1. Simple Flow Element/FlowElements/SimpleFlowElement.cs" init

Now the abstract methods can be implemented to create a functional @flowelement.

@snippet "CustomFlowElement/1. Simple Flow Element/FlowElements/SimpleFlowElement.cs" class

@endsnippet
@startsnippet{java}

First let's define a class which extends `FlowElementBase` (which partially implements `FlowElement`).
This has the type arguments of `StarSignData` - the interface extending @elementdata which will be 
added to the @flowdata, and  `ElementPropertyMetaData` - as we only need the standard metadata for
@elementproperties.

This needs a constructor matching the `FlowElementBase` class. So it takes a logger, and an
@elementdata factory which will be used to construct a `StarSignData`:

@snippet "pipeline.developer-examples.flowelement/src/main/java/pipeline/developerexamples/flowelement/flowelements/SimpleFlowElement.java" constructor

The `init` method in this example will simply initialize a list of star signs with the start and end dates of
each star sign and add each to a list of a new class named `StarSign` which has the following simple implementation:

@snippet "pipeline.developer-examples.flowelement/src/main/java/pipeline/developerexamples/flowelement/data/StarSign.java" class

Note that the year of the start and end date are both set to 0, as the year should be ignored.

The new `init` method looks like this:

@snippet "pipeline.developer-examples.flowelement/src/main/java/pipeline/developerexamples/flowelement/flowelements/SimpleFlowElement.java" init

Now the abstract methods can be implemented to create a functional @flowelement.

@snippet "pipeline.developer-examples.flowelement/src/main/java/pipeline/developerexamples/flowelement/flowelements/SimpleFlowElement.java" class
@endsnippet
@startsnippet{php}
First let's define a class which extends `flowElement`:

@snippet customFlowElement.php declaration

Now the abstract methods can be implemented to create a functional @flowelement.

@snippet customFlowElement.php class
@endsnippet
@startsnippet{node}
First let's define a class which extends `flowElement`.

This needs a constructor matching the `flowElement` class which initializes the element:

@snippet simpleEvidenceFlowElement.js constructor

Now the abstract methods can be implemented to create a functional @flowelement.

@snippet simpleEvidenceFlowElement.js class
@endsnippet
@endsnippets


# Builder

Now the @flowelement needs one final thing, an @elementbuilder to construct it.
This only needs to provide the @flowelement with a logger and an @elementdata factory -
as this example has no extra configuration options.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific @elementbuilder implementation.}
@startsnippet{dotnet}
The @elementbuilder has one important method, and that is `Build`. This returns a new @flowelement
which the @elementbuilder provides with a logger and an @elementdata factory.

The @elementdata factory is implemented in the @elementbuilder class to make use of the same
logger factory.

@snippet "CustomFlowElement/1. Simple Flow Element/FlowElements/SimpleFlowElementBuilder.cs" class

@endsnippet
@startsnippet{java}
The @elementbuilder has one important method, and that is `build`. This returns a new @flowelement
which the @elementbuilder provides with a logger and an @elementdata factory.

The @elementdata factory is implemented in the @elementbuilder class to make use of the same
logger factory.

@snippet "pipeline.developer-examples.flowelement/src/main/java/pipeline/developerexamples/flowelement/flowelements/SimpleFlowElementBuilder.java" class
@endsnippet
@startsnippet{php}
The PHP implementation does not use separate builder classes. Instead the options are provided by optional constructor parameters.
@endsnippet
@startsnippet{node}
The Node implementation does not use separate builder classes. Instead the options are provided by optional constructor parameters.
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
This new @flowelement can now be added to a @pipeline and used like:

@snippet "CustomFlowElement/1. Simple Flow Element/Program.cs" usage

to give an output of:
```{bash}
With a date of birth of 18/12/1992, your star sign is Sagittarius.
```
@endsnippet
@startsnippet{java}
This new @flowelement can now be added to a @pipeline and used like:

@snippet "pipeline.developer-examples.flowelement/src/main/java/pipeline/developerexamples/flowelement/Main.java" usage

to give an output of:
```{bash}
With a date of birth of 18/12/1992, your star sign is Sagittarius.
```
@endsnippet
@startsnippet{php}
This new @flowelement can now be added to a @pipeline and used like:

@snippet customFlowElement.php usage

To print the star sign of the user.
@endsnippet
@startsnippet{node}
This new @flowelement can now be added to a @pipeline and used like:

@snippet "simpleEvidenceFlowElement.js" usage

To print the star sign of the user.
@endsnippet
@startsnippet{java}
This new @flowelement can now be added to a @pipeline and used like:

@snippet "pipeline.developer-examples.flowelement/src/main/java/pipeline/developerexamples/flowelement/Main.java" usage

to give an output of:
```{bash}
With a date of birth of 18/12/1992, your star sign is Sagittarius.
```
@endsnippet
@endsnippets

# Next steps

The example for [Custom On-premise Engine](@ref Examples_CustomElement_OnPremise) shows how you can extend the functionality of this **flow element** to use a @datafile.

The **flow element** can also be upgraded to use evidence supplied by the client, as shown in the [Custom Client-Side Evidence](@ref Examples_CustomElement_ClientSideEvidence) example.

To delegate the processing and logic to a cloud service, refer to the [Custom Cloud Engine](@ref Examples_CustomElement_Cloud) example.
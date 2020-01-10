@page Examples_CustomElement_OnPremise Custom On-Premise Engine

# Introduction

This example takes the very simple @flowelement described in the
[simple flow element example](@ref Examples_CustomElement_FlowElement), and adds
a @datafile, upgrading the @flowelement to an @aspectengine. 

Instead of storing data statically, as the [simple flow element example](@ref Examples_CustomElement_FlowElement)
did, this example will store it in a @datafile which will be loaded and can also be updated.

# Download Example

The source code used in this example is available here:
- [C# Visual Studio project](https://github.com/51degrees/pipeline-dotnet)
- [Java project](https://github.com/51degrees/pipeline-java)
- PHP project <!-- TODO: add link -->
- Node.js project <!-- TODO: add link -->

# Dependencies

The @aspectengine will need a dependency on the @pipeline engines package now as
it is implementing an @aspectengine rather than a @flowelement.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific dependencies.}
@startsnippet{dotnet}
The only dependency needed for .NET is the `FiftyOne.Pipeline.Engines` NuGet package.
@endsnippet
@startsnippet{java}
The only dependency needed for Java is the `pipeline.engines` Maven package from `com.51degrees`.
To include this, add the following to the `<dependencies>` section of the project's `pom.xml`:
```{xml}
<dependency>
    <groupId>com.51degrees</groupId>
    <artifactId>pipeline.engines</artifactId>
    <version>4.1.0</version>
</dependency>
```
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
Add a dependency to the `fiftyone.pipeline.engines` NPM package to the package.json, and required it
in the source with `require("fiftyone.pipeline.engines")`.
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

@snippet SimpleOnPremiseEngine/Data/IStarSignData.cs class

Now the internal implementation of it will implement a 'getter' and add a 'setter' for `StarSign` in the
same way as the [previous example](@ref Examples_CustomElement_FlowElement).

@snippet SimpleOnPremiseEngine/Data/StarSignData.cs class

@endsnippet
@startsnippet{java}
Instead of implementing `ElementData`, the `StarSignData` will now implement `AspectData`
which extends `ElementData`.

@snippet developerexamples/onpremiseengine/data/StarSignData.java class

Now the internal implementation of it will implement a 'getter' and add a 'setter' for `StarSign` in the
same way as the [previous example](@ref Examples_CustomElement_FlowElement).

@snippet developerexamples/onpremiseengine/flowelements/StarSignDataInternal.java class

Note that this concrete implementation of `StarSignData` sits in the same package as the @aspectengine,
not the `StarSignData` interface, as it only needs to be accessible by the @aspectengine.
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
Node's implementation of @elementdata does not require concrete getters for IDE autocompletion, so `aspectDataDictionary` can be used.
@endsnippet
@endsnippets


# Aspect Engine

Now the actual @aspectengine needs to be implemented. For this, the class from the
[previous example](@ref Examples_CustomElement_FlowElement) will now implement the
@onpremiseengine's base class.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific @aspectengine implementation.}
@startsnippet{dotnet}
First let's change the class to extend `OnPremiseAspectEngineBase` (which partially implements
`IOnPremiseAspectEngine`). This has the type arguments of
`IStarSignData` - the interface extending @aspectdata which will be added to the @flowdata, and 
`IAspectPropertyMetaData` - instead of `IElementPropertyMetaData`.

The existing constructor needs to change to match the `OnPremiseAspectEngineBase` class. So it takes
the additional arguments of a @datafile path, and a temporary @datafile path. This is the location of the @datafile
that the @aspectengine will use, and where to make a temporary copy if required.

The constructor will also read the @datafile containing the star signs into memory. This is done in another
method so that it can also be used by the `RefreshData` method when a new @datafile is downloaded (this is not
applicable for this example as star sign data will not change).

@snippet SimpleOnPremiseEngine/FlowElements/SimpleOnPremiseEngine.cs constructor

The `Init` method in this example will simply read a CSV file with the start and end dates of each
star sign, which looks like:
```{csv}
Aries,21/03,19/04
Taurus,20/04,20/05
Gemini,21/05,20/06
Cancer,21/06,22/07
...
```

and add each to a list of a new class named `StarSign` which has the following simple implementation:

@snippet SimpleOnPremiseEngine/Data/StarSign.cs class

Note that the year of the start and end date are both set to 1, as the year should be ignored, but
the year 0 cannot be used in a `DateTime`.

The new `Init` method looks like this:

@snippet SimpleOnPremiseEngine/FlowElements/SimpleOnPremiseEngine.cs init

Now the abstract methods can be implemented to create a functional @aspectengine.

@snippet SimpleOnPremiseEngine/FlowElements/SimpleOnPremiseEngine.cs class

@endsnippet
@startsnippet{java}
First let's change the class to extend `OnPremiseAspectEngineBase` (which partially implements
`OnPremiseAspectEngine`). This has the type arguments of
`StarSignData` - the interface extending @aspectdata which will be added to the @flowdata, and 
`AspectPropertyMetaData` - instead of `ElementPropertyMetaData`.

The existing constructor needs to change to match the `OnPremiseAspectEngineBase` class. So it takes
the additional arguments of a @datafile path, and a temporary @datafile path. This is  the location of the @datafile
that the @aspectengine will use, and where to make a temporary copy if required.

The constructor will also read the @datafile containing the star signs into memory. This is done in another
method so that it can also be used by the `refreshData` method when a new @datafile is downloaded (this is not
applicable for this example as star sign data is static).

@snippet developerexamples/onpremiseengine/flowelements/SimpleOnPremiseEngine.java constructor

The `init` method in this example will simply read a CSV file with the start and end dates of each
star sign, which looks like:
```{csv}
Aries,21/03,19/04
Taurus,20/04,20/05
Gemini,21/05,20/06
Cancer,21/06,22/07
...
```

and add each to a list of a new class named `StarSign` which has the following simple implementation:

@snippet developerexamples/onpremiseengine/data/StarSign.java class

Note that the year of the start and end date are both set to 0, as the year should be ignored.

The new `init` method looks like this:

@snippet developerexamples/onpremiseengine/flowelements/SimpleOnPremiseEngine.java init

Now the abstract methods can be implemented to create a functional @aspectengine.

@snippet developerexamples/onpremiseengine/flowelements/SimpleOnPremiseEngine.java class

@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}

First let's change the class to extend `engine`.

The existing constructor needs to change to match the `engine` class. So it takes
the additional argument of a @datafile path. This is  the location of the @datafile
that the @aspectengine will use.

The constructor will also read the @datafile containing the star signs into memory. This is done in another
method so that it can also be used when a new @datafile is downloaded (this is not
applicable for this example as star sign data is static).

@snippet onPremiseFlowElement.js constructor

The `refresh` method in this example will simply read a JSON file with the start and end dates of each
star sign, which looks like:
```{json}
[
    [
        "Aries",
        "21/03",
        "19/04"
    ],
    [
        "Taurus",
        "20/04",
        "20/05"
    ],
    ...
```

and parse into objects.

The new `refresh` method looks like this:

@snippet onPremiseFlowElement.js refresh

Now the abstract methods can be implemented to create a functional @aspectengine.

@snippet onPremiseFlowElement.js class
@endsnippet
@endsnippets


# Builder

Now the @aspectengine needs one final thing, an @elementbuilder to construct it.
This needs to provide the @aspectengine with a logger and an @aspectdata factory as in
the previous example. However, it also now needs a data file.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific @elementbuilder implementation.}
@startsnippet{dotnet}
As this @aspectengine is using a @datafile, the builder can make use of the logic in the
`SingleFileAspectEngineBuilderBase`.

@snippet SimpleOnPremiseEngine/FlowElements/SimpleOnPremiseEngineBuilder.cs class

@endsnippet
@startsnippet{java}
As this @aspectengine is using a @datafile, the builder can make use of the logic in the
`SingleFileAspectEngineBuilderBase`.

@snippet developerexamples/onpremiseengine/flowelements/SimpleOnPremiseEngineBuilder.java class

@endsnippet
@startsnippet{php}
**todo**
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
This new @aspectengine can now be added to a @pipeline and used like:

@snippet SimpleOnPremiseEngine/Program.cs usage


to give an output of:
```{bash}
With a date of birth of 18/12/1992, your star sign is Sagittarius.
```
@endsnippet
@startsnippet{java}
This new @aspectengine can now be added to a @pipeline and used like:

@snippet developerexamples/onpremiseengine/Main.java usage

to give an output of:
```{bash}
With a date of birth of 18/12/1992, your tar sign is Sagittarius.
```
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
This new @aspectengine can now be added to a @pipeline and used like:

@snippet onPremiseFlowElement.js usage

To print the star sign of the user.
@endsnippet
@endsnippets

# Next Steps
The [Custom Client-Side Evidence](@ref Examples_CustomElement_ClientSideEvidence) example shows how you can build a custom engine that can take evidence supplied by the client.
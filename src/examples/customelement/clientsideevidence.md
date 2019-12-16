@page Examples_CustomElement_ClientSideEvidence Custom Engine Using Client-Side Evidence

# Introduction

This example takes the very simple @flowelement described in the
[simple flow element example](@ref Examples_CustomElement_FlowElement), and adds
a JavaScript @property to use @clientsideevidence. 

Instead of using @evidence which is already available, as the [simple flow element example](@ref Examples_CustomElement_FlowElement)
did, this example will send JavaScript to the a client to get the @evidence.

# Download Example

The source code used in this example is available here:
- [C# Visual Studio project](https://github.com/51degrees/pipeline-dotnet)
- [Java project](https://github.com/51degrees/pipeline-java)
- [PHP project](https://github.com/51degrees/pipeline-php)
- [Node.js project](https://github.com/51degrees/pipeline-node)

# Dependencies

The @flowelement will need a dependency on the @pipeline core package

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific dependencies.}
@startsnippet{dotnet}
The only dependency needed for .NET is the `FiftyOne.Pipeline.Core` NuGet package.
@endsnippet
@startsnippet{java}
The only dependency needed for Java is the `pipeline.core` Maven package from `com.51degrees`.
To include this, add the following to the `<dependencies>` section of the project's `pom.xml`:
```{xml}
<dependency>
    <groupId>com.51degrees</groupId>
    <artifactId>pipeline.core</artifactId>
    <version>4.1.0</version>
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

The @elementdata being added to the @flowdata by this @flowelement is a star sign. So this should
have its own 'getter' in its @elementdata. The additional @property containing the JavaScript to
get the date of birth is also added using the appropriate type.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific @elementdata implementation.}
@startsnippet{dotnet}
.NET supports interfaces, so the @elementdata should have a public interface and an internal
concrete implementation with easy 'setters'.

In this example, values for star sign and JavaScript are populated. So an interface `IStarSign`
will extend `IElementData` to add a 'getter' for it.

@snippet SimpleClientSideElement/Data/IStarSignData.cs class

Now the internal implementation of it will implement this 'getter' and add a 'setter' for the @flowelement
to use.

@snippet SimpleClientSideElement/Data/StarSignData.cs class

@endsnippet
@startsnippet{java}
Java supports interfaces, so the @elementdata should have a public interface and a package private
concrete implementation with easy 'setters'.

In this example, values for star sign and JavaScript are populated. So an interface `StarSignData`
will extend `ElementData` to add a 'getter' for it.

@snippet developerexamples/clientsideelement/data/StarSignData.java class

Now the internal implementation of it will implement this 'getter' and add a 'setter' for the @flowelement
to use.

@snippet developerexamples/clientsideelement/flowelements/StarSignDataInternal.java class


Note that this concrete implementation of `StarSignData` sits in the same package as the @flowelement,
not the `StarSignData` interface, as it only needs to be accessible by the @flowelement.
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets

# JavaScript

The client-side JavaScript for this example will be fairly simple. It will create a popup asking the user
to enter their date of birth. It will then store the date of birth in a cookie named 'date-of-birth' and
reload the page with the new cookie present. 

The JavaScript to do this looks like:
```{js}
// Ask the user for their data of birth.
var dob = window.prompt('Enter your date of birth.','dd/mm/yyyy');
if (dob != null) {
    // Store it in a cookie.
    document.cookie='date-of-birth='+dob;
    // Reload the page with the new cookie.
    location.reload();
}
```

# Flow Element

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

@snippet SimpleClientSideElement/FlowElements/SimpleClientSideElement.cs constructor

The `Init` method in this example will simply initialize a list of star signs with the start and end dates of
each star sign and add each to a list of a new class named `StarSign` which has the following simple implementation:

@snippet SimpleClientSideElement/Data/StarSign.cs class

Note that the year of the start and end date are both set to 1, as the year should be ignored, but
the year 0 cannot be used in a `DateTime`.

The new `Init` method looks like this:

@snippet SimpleClientSideElement/FlowElements/SimpleClientSideElement.cs init

Now the abstract methods can be implemented to create a functional @flowelement.

@snippet SimpleClientSideElement/FlowElements/SimpleClientSideElement.cs class

@endsnippet
@startsnippet{java}

First let's define a class which extends `FlowElementBase` (which partially implements `FlowElement`).
This has the type arguments of `StarSignData` - the interface extending @elementdata which will be 
added to the @flowdata, and  `ElementPropertyMetaData` - as we only need the standard metadata for
@elementproperties.

This needs a constructor matching the `FlowElementBase` class. So it takes a logger, and an
@elementdata factory which will be used to construct a `StarSignData`:

@snippet developerexamples/clientsideelement/flowelements/SimpleClientSideElement.java constructor

The `init` method in this example will simply initialize a list of star signs with the start and end dates of
each star sign and add each to a list of a new class named `StarSign` which has the following simple implementation:

@snippet developerexamples/clientsideelement/data/StarSign.java class

Note that the year of the start and end date are both set to 0, as the year should be ignored.

The new `init` method looks like this:

@snippet developerexamples/clientsideelement/flowelements/SimpleClientSideElement.java init

Now the abstract methods can be implemented to create a functional @flowelement.

@snippet developerexamples/clientsideelement/flowelements/SimpleClientSideElement.java class

@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
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

@snippet SimpleClientSideElement/FlowElements/SimpleClientSideElementBuilder.cs class

@endsnippet
@startsnippet{java}
The @elementbuilder has one important method, and that is `build`. This returns a new @flowelement
which the @elementbuilder provides with a logger and an @elementdata factory.

The @elementdata factory is implemented in the @elementbuilder class to make use of the same
logger factory.

@snippet developerexamples/clientsideelement/flowelements/SimpleClientSideElementBuilder.java class

@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets

# Usage

As this example gathers its @evidence using client-side JavaScript, it will need to be run in
a web environment. Using a @webintegration will mean that the @flowelement can be added, and the
client-side JavaScript automatically run.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific usage.}
@startsnippet{dotnet}
Using a ASP.NET Core project (full example included in the source), a [pipeline configuration](@ref Concepts_Configuration_Builders_BuildFromConfiguration) file can be
added to the 'appsettings.json' to load the new @flowelement and a 'JavaScriptBundlerElement' to
include the client-side JavaScript:
```{json}
{
  ...
  "PipelineOptions": {
    "Elements": [
      {
        "BuilderName": "SimpleClientSideElement"
      },
      {
        "BuilderName": "JavaScriptBundlerElement"
      }
    ]
  }
}
```

Then a simple view can be added which includes '51Degrees.core.js' to run the JavaScript, and displays
the message which is passed from the controller:
```{html}
@{
    ViewData["Title"] = "Home Page";
}

<script type="application/javascript"  src="~/51Degrees.core.js"></script>

<div class="row">
    @ViewData["message"]
</div>
```

The message is constructed in the controller in the same way as in the [previous example](@ref Examples_CustomElement_FlowElement):

@snippet SimpleClientSideElementMVC/Controllers/HomeController.cs usage

@endsnippet
@startsnippet{java}
Using a Spring MVC project (full example included in the source), a [pipeline configuration](@ref Concepts_Configuration_Builders_BuildFromConfiguration) file
can be added to load the new @flowelement and a 'JavaScriptBundlerElement' to include the client-side
JavaScript:
```{xml}
<PipelineOptions>
    <Elements>
        <Element>
            <BuilderName>SimpleClientSideElement</BuilderName>
        </Element>
        <Element>
            <BuilderName>JavaScriptBundlerElement</BuilderName>
        </Element>
    </Elements>
</PipelineOptions>
```

Then a simple view can be added which includes '51Degrees.core.js' to run the JavaScript, and displays
the star sign which is passed from the controller:
```{html}
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Example page</title>
<script src="/simple-clientside-element-mvc/51Degrees.core.js"></script>
</head>
<body>
    <p>${message}</p>
</body>
</html>
```
The message is constructed in the controller in the same way as in the [previous example](@ref Examples_CustomElement_FlowElement):

@snippet controller/ExampleController.java class

@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets

# Next Steps
The example for [Custom On-premise Engine](@ref Examples_CustomElement_OnPremise) shows how you can extend the functionality of this **flow element** to use a @datafile rather than hard coded values.
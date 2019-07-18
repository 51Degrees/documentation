@page Concepts_Configuration_Builders_BuildFromConfiguration Building From Configuration

# Introduction

Rather than setting all build options and @flowelements explicitly in code form, it is often
preferable to make the @pipeline configurable without recompiling. A @pipelinebuilder allows
this via its 'BuildFromConfiguration' method. A @pipeline's configuration can be built up within
code, however the most flexible method is to store the configuration in a file.

# Usage

A configuration can either be parsed manually from XML or JSON and given to a @pipelinebuilder.
Alternatively, in @webintegrations, a configuration file is loaded automatically.

Parsing XML or JSON is very language dependent, and in some languages one format is preferable.

## Parsing XML

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@startsnippet{none,block}
Select a language for an example of parsing XML.
@endsnippet
@startsnippet{dotnet}
@snippet snippets.cs Build from xml
@endsnippet
@startsnippet{java}
@snippet snippets.java Build from xml
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets

## Parsing JSON

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@startsnippet{none,block}
Select a language for an example of parsing JSON.
@endsnippet
@startsnippet{dotnet}
@snippet snippets.cs Build from json
@endsnippet
@startsnippet{java}
**todo**
@snippet snippets.java Build from json
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets


# Example Configuration

@startsnippets
@showsnippet{XML}
@showsnippet{JSON}
@emptysnippet
@startsnippet{XML}
Configure a @pipeline with a @flowelement named 'MyElement' with a build parameter, and
set the @pipeline to suppress process exceptions.
@snippet snippets.xml Pipeline configuration
@endsnippet
@startsnippet{JSON}
Configure a @pipeline with a @flowelement named 'MyElement' with a build parameter, and
set the @pipeline to suppress process exceptions.
@snippet snippets.json Pipeline configuration
@endsnippet
@endsnippets


# Internals

Internally, the @pipelinebuilder relies on reflection to find the correct builder to build
the @flowelements required by the configuration. For this reason, it is necessary for the
libraries containing the @elementbuilders for these @flowelement to be loaded. This can be done
in a number of ways:
* loading the library by calling a method in code;
* adding a library to a config file to be loaded;
* using dependency injection to find a suitable implementation and add it to a service collection.

The best method to use depends heavily on the language and use case. For example, a .NET Core
web app would use dependency injection to add builder implementations to its service collection.

Build parameters for the @flowelements in the configuration are set through the @elementbuilder
using methods with the naming convention of 'set' + option name, or the build method itself for
options which are compulsory.


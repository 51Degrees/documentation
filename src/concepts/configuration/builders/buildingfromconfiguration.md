@page Concepts_Configuration_Builders_BuildFromConfiguration Building from Configuration

# Introduction

Rather than setting all build options and @flowelements explicitly in code form, it is often
preferable to make the @pipeline configurable without recompiling. A @pipelinebuilder allows
this via its 'BuildFromConfiguration' method. A @pipeline's configuration can be built up within
code, however the most flexible method is to store the configuration in a file.

# Usage

A configuration can be parsed manually from XML or JSON and given to a @pipelinebuilder, alternatively, in @webintegrations, a configuration file is loaded automatically.

Note, the parsing of XML or JSON is varies greatly between languages, with some languages having a preference for which format is used.

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
```{cs}
var config = new ConfigurationBuilder()
    .AddXmlFile("configuration.xml")
    .Build();
PipelineOptions options = new PipelineOptions();
config.Bind("PipelineOptions", options);

IPipeline pipeline = new PipelineBuilder(loggerFactory)
    .BuildFromConfiguration(options);
```
@endsnippet
@startsnippet{java}
```{java}
File file = new File("configuration.xml");
Unmarshaller unmarshaller = JAXBContext
    .newInstance(PipelineOptions.class)
    .createUnmarshaller();
PipelineOptions options = (PipelineOptions) unmarshaller.unmarshal(file);

Pipeline pipeline = new PipelineBuilder(loggerFactory)
    .buildFromConfiguration(options);
```
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
```{cs}
var config = new ConfigurationBuilder()
    .AddJsonFile("configuration.json")
    .Build();
PipelineOptions options = new PipelineOptions();
config.Bind("PipelineOptions", options);

IPipeline pipeline = new PipelineBuilder(loggerFactory)
    .BuildFromConfiguration(options);
```
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


# Example Configuration

@startsnippets
@showsnippet{XML}
@showsnippet{JSON}
@defaultsnippet{Select a file format to view an example configuration.}
@startsnippet{XML}
Configure a @pipeline with a @flowelement named 'MyElement' with a build parameter, and
set the @pipeline to [suppress process exceptions](@ref Concepts_Configuration_Builders_PipelineBuilder_SuppressProcessExceptions).
```{xml}
<PipelineOptions>
    <Elements>
        <Element>
            <BuilderName>MyElementBuilder</BuilderName>
            <BuildParameters>
                <MyBuildParameter>a value for the element</MyBuildParameter>
            </BuildParameters>
        </Element>
    </Elements>
    <BuildParameters>
        <SuppressProcessExceptions>true</SuppressProcessExceptions>
    </BuildParameters>
</PipelineOptions>
```
@endsnippet
@startsnippet{JSON}
Configure a @pipeline with a @flowelement named 'MyElement' with a build parameter, and
set the @pipeline to [suppress process exceptions](@ref Concepts_Configuration_Builders_PipelineBuilder_SuppressProcessExceptions).
```{js}
{
  "PipelineOptions": {
    "Elements": [
      {
        "BuilderName": "MyElementBuilder",
        "BuildParameters": {
          "MyBuildParameter": "a value for the element"
        }
      }
    ],
    "BuildParameters": {
      "SuppressProcessExceptions": true
    }
  }
}
```
@endsnippet
@endsnippets


# Internals

Internally, the @pipelinebuilder relies on reflection to find the correct builder to build
the @flowelements required by the configuration. For this reason, it is necessary for the
libraries that contain the @elementbuilders for those @flowelement to be loaded. This can be done
in a number of ways:
* loading the library by calling a method in code;
* adding a library to a config file to be loaded;
* using dependency injection to find a suitable implementation and add it to a service collection.

The best method to use depends heavily on the language and use case. For example, a .NET Core
web app would use dependency injection to add builder implementations to its service collection.

Build parameters for the @flowelements in the configuration are set through the @elementbuilder,
using methods with the naming convention of 'set' + option name, or the build method itself for
options which are compulsory.


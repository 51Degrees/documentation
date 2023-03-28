@page Concepts_Configuration_Builders_BuildFromConfiguration Building from Configuration

# Introduction

Rather than setting all build options and @flowelements explicitly in code form, it is often
preferable to make the @pipeline configurable without recompiling. A @pipelinebuilder allows
this via its 'BuildFromConfiguration' method.

# Usage

A configuration can be parsed manually from XML, JSON, or any other source and given to a @pipelinebuilder. 
Alternatively, in @webintegrations, a configuration file is loaded automatically.

Note, the possible format of the configuration file varies greatly between languages, with some languages 
having many options and others only having one.
Where possible, we recommend using JSON as the simplest and most transferable configuration format; JSON is
also supported by the PHP and Node.js bindings, where XML is not. In contrast, it should be noted that Java 
only supports XML configuration files.

## Parsing XML

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@defaultsnippet{Select a language for an example of parsing XML.}
@startsnippet{dotnet}
```{cs}
var config = new ConfigurationBuilder()
    .AddXmlFile("configuration.xml")
    .Build();
PipelineOptions options = new PipelineOptions();
var section = config.GetRequiredSection("PipelineOptions");
// Use the 'ErrorOnUnknownConfiguration' option to warn us if we've got any
// misnamed configuration keys.
section.Bind(options, (o) => { o.ErrorOnUnknownConfiguration = true; });

IPipeline pipeline = new PipelineBuilder(loggerFactory)
    .BuildFromConfiguration(options);
```
@endsnippet
@startsnippet{java}
```{java}

PipelineOptions options = PipelineOptionsFactory.getOptionsFromFile("configuration.xml");

Pipeline pipeline = new PipelineBuilder(loggerFactory)
    .buildFromConfiguration(options);
```
@endsnippet
@endsnippets

## Parsing JSON

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a language for an example of parsing JSON.}
@startsnippet{dotnet}
```{cs}
var config = new ConfigurationBuilder()
    .AddJsonFile("configuration.json")
    .Build();
PipelineOptions options = new PipelineOptions();
var section = config.GetRequiredSection("PipelineOptions");
// Use the 'ErrorOnUnknownConfiguration' option to warn us if we've got any
// misnamed configuration keys.
section.Bind(options, (o) => { o.ErrorOnUnknownConfiguration = true; });

IPipeline pipeline = new PipelineBuilder(loggerFactory)
    .BuildFromConfiguration(options);
```
@endsnippet
@startsnippet{php}
\verbatim
use fiftyone\pipeline\core\PipelineBuilder;
$builder = new PipelineBuilder();
$pipeline = $builder->buildFromConfig($configFile)->build();
\endverbatim
@endsnippet
@startsnippet{node}
```js
const pipeline = new FiftyOneDegreesGeoLocation.GeoLocationPipelineBuilder({resourceKey:localResourceKey});
pipeline.buildFromConfigurationFile(configFilePath);
```
@endsnippet
@endsnippets


# Example configuration

@startsnippets
@showsnippet{XML}
@showsnippet{JSON}
@defaultsnippet{Select a file format to view an example configuration.}
@startsnippet{XML}
There is a sample file demonstrating all configuration options for Java on [GitHub](@ref https://github.com/51Degrees/device-detection-java/blob/master/device-detection.examples/web/getting-started.onprem/src/main/webapp/WEB-INF/51Degrees-OnPrem.xml).

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

Note that for use in node.js, `BuilderName` and `BuilderParameters` should be replaced by `elementName` and `elementParameters`.

There is a sample file demonstrating all configuration options for .NET on [GitHub](@ref https://github.com/51Degrees/device-detection-dotnet/blob/master/Examples/sample-configuration.json).

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

# Rules for building from a configuration file

The core **build from configuration** logic ultimately calls the same configuration
methods, on the same builders as the developer does if they configure the @Pipeline in code.

There are several rules that govern how a value in a configuration file is mapped to a 
builder or configuration method:

## Element builder names

The element builder name is used to determine the @elementbuilder that we want to use.
Each of the following is tried in turn to find a builder that matches the supplied name:

1. Case insensitive match on type name (e.g. 'MyElementBuilder' matches a type with that name).
2. Case insensitive match on type name suffixed with 'builder' (e.g. 'MyElement' matches a type called 'MyElementBuilder').
3. Where the language allows it, match on some 
[alternative name](@ref Concepts_Configuration_Builders_BuildFromConfiguration_AlternativeName) for the builder.

## Element build parameters

The key value of each entry in the 'build parameters' list associated with each @element is used to determine 
the method to call on the @elementbuilder.
Each of the following is tried in turn to find a method that matches the supplied name:

1. Case insensitive match on method name (e.g. 'SetCacheSize' matches a method with that name).
2. Case insensitive match on method name prefixed with 'set' (e.g. 'CacheSize' matches a method called 'SetCacheSize').
3. Where the language allows it, match on some 
[alternative name](@ref Concepts_Configuration_Builders_BuildFromConfiguration_AlternativeName) for the method.

The value part of each entry in the 'build parameters' list is then passed to the matching method as a parameter.
For strongly-types languages, this may also involve parsing a string value from the configuration into the required type.

If there are any build parameters for which a method cannot be found, they will be used to set parameters on the
'Build' method once configuration is complete.
In this case, a simple case-insensitive match is performed to determine the parameter value to set.


## Pipeline build parameters

@Pipeline build parameters work in the same way as element build parameters but they are used to call configuration
methods on the @pipelinebuilder instead of the @elementbuilder.

See above for all the rules governing this.

## Alternative naming details @anchor Concepts_Configuration_Builders_BuildFromConfiguration_AlternativeName

Some languages have a mechanism for specifying alternative names for builders and methods.
These can be used to match against supplied configuration options.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@defaultsnippet{Select a language for information of specifying an alternative name for element builders and configuration methods.}
@startsnippet{dotnet}
The AlternateNameAttribute can be used to decorate @elementbuilder classes as well as configuration methods
on an @elementbuilder.
This can be used to specify one or more other names to match on when building from configuration.
@endsnippet
@startsnippet{java}
The `ElementBuilder(alternateName)` attribute can be used to decorate @elementbuilder classes.
This can be used to specify one or more other names to match when buiding from configuration.
@endsnippet
@endsnippets


# Internals

The exact internal mechanics of the **builder** will depend on the language being used.
Wherever possible, the rules for mapping are consistent between languages but this
cannot always be achieved.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a language for more details of the internals of **build from configuration**.}
@startsnippet{dotnet}
In .NET, @pipelinebuilder relies on reflection to find the correct builder to build
the @flowelements required by the configuration. For this reason, it is necessary for the
libraries that contain the @elementbuilders for each @flowelement to be loaded. This can be done
in a number of ways:
* loading the library by calling a method in code;
* adding a library to a config file to be loaded;

For example:
```{cs}
Assembly.Load("FiftyOne.DeviceDetection.Hash.Engine.OnPremise");
```

Additionally, the @pipelinebuilder will need to know how to supply any dependencies required 
by the @elementbuilders it creates.

By default, the @pipelinebuilder will call a constructor on @elementbuilder that takes an 
ILoggerFactory if one is available. 
If not, it will call the default constructor - if one is available.

If neither are available then the @pipelinebuilder will be unable to create the @elementbuilder.

This can be resolved by passing an IServiceProvider to the @pipelinebuilder on
construction that is populated with instances of the services that @elementbuilders will require.
@endsnippet
@startsnippet{php}
PHP will load elements named in `BuilderName` as if they were specified in a `use` statement, so for example:

\verbatim
"BuilderName": "fiftyone\\pipeline\\cloudrequestengine\\CloudRequestEngine"
\endverbatim

@endsnippet
@startsnippet{node}
Node will load elements named in `ElementName` as if they were specified in a `require` statement, so for example:

"ElementName": "fiftyone.pipeline.cloudrequestengine"
@endsnippet
@endsnippets



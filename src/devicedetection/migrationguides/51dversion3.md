@page DeviceDetection_MigrationGuides_51DegreesV3 51Degrees Device Detection API Version 3.x

# Introduction

This page describes the steps for migrating from 51Degrees' previous device detection API to either version 4 of that API or to the @Pipeline API where it is available.
In either case, there are breaking changes so this guide should be followed carefully to ensure no problems arise.

# Overview

The language that you are using is the most important factor in determining what work is required to migrate to the new API.
For some languages and frameworks, such as C or Nginx, there is no @Pipeline API so you will be migrating directly to version 4 of the device detection API.
For other languages such as Java or .NET, you will be migrating from a pure device detection installation to the @Pipeline API with a device detection plugin.

# Detail

Regardless of which API you are migrating to, there are breaking changes and new features to be aware of. See the following section for detail on the changes needed for your language of choice.

@startsnippets
@showsnippet{c,C}
@showsnippet{cpp,C++}
@showsnippet{dotnet,C#}
@showsnippet{aspdotnet,ASP.NET}
@showsnippet{aspdotnetcore,ASP.NET Core}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@showsnippet{nginx,Nginx}
@defaultsnippet{Select a language to view a language specific migration guide.}
@startsnippet{c}
<!-- ===================================================================================
     |                                        C                                        |
     =================================================================================== -->

First, add the device detection libraries from the
[GitHub repo](https://github.com/51degrees/device-detection-cxx). These can be included
using the Visual Studio projects, the CMake projects, or just the files themselves.

The old (V3) device detection API used a single method to initialize a `fiftyoneDegreesProvider`.
This took all available options as parameters, and was similar for both the 'Pattern' and 'Hash' algorithms.

```{c}
fiftyoneDegreesDataSetInitStatus status =
    fiftyoneDegreesInitProviderWithPropertyString(
    fileName, &provider, properties, 4, 1000);
```

An equivalent service can be set up using the V4 device detection API. However, the Hash data files have been significantly improved for V4, 
and are now equivalent or superior to Pattern in every way. As such, Hash is now the only option. It takes the following parameters:

1. A resource manager. This is similar to the V3 provider, but provides a generic way of managing resources in a thread-safe manner.
2. A configuration structure. This defines the way the data set is used. For example, whether the data set is loaded into memory, or streamed from file.
3. A required properties structure. This is a structure which can contain a string or array indicating the properties which should be loaded.
4. Data file path. This is the path to the data file which should be loaded.
5. An exception structure. This provides a way for internal methods to report exceptions instead of allowing the process to crash.

After setting any configuration options required in the config structure, the data set is
initialized using the `fiftyoneDegreesHashInitManagerFromFile`, or `fiftyoneDegreesHashInitManagerFromMemory`
method.

```{c}
fiftyoneDegreesStatusCode status =
    fiftyoneDegreesHashInitManagerFromFile(
        &manager,
        &config,
        &properties,
        dataFilePath,
        exception);
```

To process a User-Agent with the old API, the `fiftyoneDegreesMatch` is called with a workset
which has been fetched from the provider. Instead new set of results should be created, then
the `fiftyoneDegreesResultsHashFromUserAgent` is used in a similar way to `fiftyoneDegreesMatch`.

```{c}
fiftyoneDegreesResultsHash *result =
    fiftyoneDegreesResultsHashCreate(&manager, 1, 0);

fiftyoneDegreesResultsHashFromUserAgent(
    results,
    userAgent,
    strlen(userAgent),
    exception);
```

To get a value of a property in the old API, the `fiftyoneDegreesSetValues` and
`fiftyoneDegreesGetString` methods were used. Using the new results structure,
values of a property can be retrieved using the `fiftyoneDegreesResultsHashGetValueString`
method.

```{c}
fiftyoneDegreesResultsPatternGetValuesString(
    results,
    propertyName,
    valueBuffer,
    sizeof(valueBuffer),
    ",",
    exception);
```

Multiple HTTP header matching can follows a similar pattern to single User-Agent matching.
Instead of a single string, a `fiftyoneDegreesEvidenceKeyValuePairArray` structure is used.
Each header is added to the evidence before calling the `fiftyoneDegreesResultsHashFromEvidence`
method.

```{c}
fiftyoneDegreesEvidenceKeyValuePairArray *evidence =
    fiftyoneDegreesEvidenceCreate(1);
fiftyoneDegreesEvidenceAddString(
    evidence,
    FIFTYONE_DEGREES_EVIDENCE_HTTP_HEADER_STRING,
    "User-Agent",
    userAgent);

fiftyoneDegreesResultsHashFromEvidence(
    results,
    evidence,
    exception);
```

Once finished, the results are released using the `fiftyoneDegreesResultsHashFree` method,
and the data set with the `fiftyoneDegreesManagerFree` method.

@endsnippet
@startsnippet{cpp}
<!-- ===================================================================================
     |                                       C++                                       |
     =================================================================================== -->

First, add the device detection libraries from the
[GitHub repo](https://github.com/51degrees/device-detection-cxx). These can be included
using the Visual Studio projects, the CMake projects, or just the files themselves.

The old (V3) device detection API used a `Provider` class initialized with the path
to the data file and the required properties, and was similar for Pattern and Hash.

```{cpp}
Provider *provider = Provider(fileName, properties);
```

An equivalent service can be set up using the V4 device detection API. Rather than a `Provider`,
the equivalent class is an "Engine" which extends the `EngineBase` base class. An engine is
constructed with the following:
1. Data file path. This is the path to the data file which should be loaded.
2. A configuration instance. This defines the way the data set is used. For example, whether the data set is loaded into memory, or streamed from file.
3. A required properties instance. This is a class which can contain a string or array indicating the properties which should be loaded.

After setting any configuration options required in the config structure, the engine is
constructed.

```{cpp}
RequiredPropertiesConfig *properties = new RequiredPropertiesConfig(propertiesString);
ConfigHash *config = new ConfigHash();

EngineHash *engine = new EngineHash(dataFile, config, properties);
```

To process HTTP headers with the old API, the `provider->getMatch` is called with either
a single User-Agent string, or a `map<string, string>` containing HTTP header names and values.
Instead, an `EvidenceDeviceDetection` instance should be created, then the `engine->process`
is used in a similar way to `provider->getMatch`. The `EvidenceBase` class actually extends
`map<string, string>` so usage is almost identical. The difference is that the keys will be
different to the old API. For example, instead of "User-Agent", the key would be "header.User-Agent".
This is because more evidence is supported in the new API (e.g. cookies, query params).

```{cpp}
EvidenceDeviceDetection *evidence = new EvidenceDeviceDetection();
evidence->operator[]("header.User-Agent") = userAgent;

ResultsHash *results = engine->process(evidence);
```

Getting values from a `ResultsHash` (or any class extending `ResultsBase`) instance is similar
to the old API, however the values returned are slightly different. Values follow the nullable
pattern. For example, rather than returning a boolean, the `results->getValueAsBool` method returns a
`Value<bool>` type that has `hasValue()` and `getValue()` methods (in addition to a `*` operator which
maps to the `getValue()` method). Calling `getValue()` on a property value that does not have a value
will result in an exception. For more detail see the @falsepositivecontrol feature page.

```{cpp}
Value<bool> value = results->getValueAsBool("IsMobile");

if (value.hasValue()) {
    bool isMobile = *value;
}
else {
    // No valid value.
    string reason = value.getNoValueMessage();
}
```

Once finished, the results, evidence, engine, and configuration are freed using their
destructors.
```{cpp}
delete results;
delete evidence;
delete engine;
delete config
```

@endsnippet
@startsnippet{dotnet}
<!-- ===================================================================================
     |                                      .NET                                       |
     =================================================================================== -->
Note: If you are working with a ASP.NET or ASP.NET Core web app then check those tabs for a more focused migration guide.

First, add the `FiftyOne.DeviceDetection` NuGet package.

The old (V3) device detection API generally had two initialization steps, one to create a `DataSet` and one to create a `Provider` from that `DataSet`.
The precise details would depend on:
- Whether you are using the Pattern or Hash algorithm.
- Whether you are loading all the data into memory for better performance or not.
- Other DataSet creation options being used.

```{cs}
DataSet dataSet = StreamFactory.Create(fileName, false)
Provider provider = new Provider(dataSet);   
```

There are several ways to set up an equivalent service using the Pipeline API. For example, you could create the device detection engine and then create the Pipeline.
However, the easiest method is to use a specific `DeviceDetectionPipelineBuilder`. This can be configured using a settings file or directly in code: 

```{cs}
var pipeline = new DeviceDetectionPipelineBuilder()
  .UseOnPremise(dataFile, true)
  .SetPerformanceProfile(PerformanceProfiles.LowMemory)
  .SetDataUpdateLicenseKey("yourkey")
  .Build()
```

The supplied settings will be dependent on your old implementation:

- If using the 51Degrees cloud service, you'll first need to use [the Configurator](configure.51degrees.com) to create a resource key (this will only take a few minutes and does not require any payment). Next, change the first line to `.UseCloud` and pass in the resource key you created.
- If using `MemoryFactory` rather that `StreamFactory` then change the performance profile to `MaxPerformance`.
- If using a custom caching configuration, you will need to create the device detection engine first using a `DeviceDetectionHashEngineBuilder`. The `SetCache` method can then be used to supply your custom configuration. Finally, the generic `PipelineBuilder` can be used to create a pipeline with the device detection engine added to it.
- If you have auto updates disabled then remove the `SetDataUpdateLinceseKey` line and instead use `SetAutoUpdate(false)` and `SetUpdateOnStartup(false)`.

Regardless of the details above, a configuration file can be used instead:

```{cs}
var config = new ConfigurationBuilder()
    // Use this line for a json-based config file.
    .AddJsonFile("appsettings.json")
    // Or this one for an xml-based config file.
    .AddXmlFile("App.config")
    .Build();
    
// Bind the configuration to a pipeline options instance
PipelineOptions options = new PipelineOptions();
config.Bind("PipelineOptions", options);  

// Create the pipeline using the options object
var pipeline = new FiftyOnePipelineBuilder()
    .BuildFromConfiguration(options)
```

The JSON configuration file for the same setup as above (on premise, low memory, auto updates enabled) would look like this:

```{json}
{
  "PipelineOptions": {
    "Elements": [
      {
        "BuilderName": "DeviceDetectionHashEngineBuilder",
        "BuildParameters": {
          "DataFile": "51Degrees-EnterpriseV4.1.hash",
          "CreateTempDataCopy": true,
          "DataUpdateLicenseKey": "yourkey",
          "PerformanceProfile": "LowMemory"
        }
      }
    ]
  }
}
```

If you are using the 51Degrees cloud then you'll need to add two elements using the builders `CloudRequestEngineBuilder` and `DeviceDetectionCloudEngineBuilder`. For example:

```{json}
{
  "PipelineOptions": {
    "Elements": [
      {
        "BuilderName": "CloudRequestEngineBuilder",
        "BuildParameters": {
          "ResourceKey": "yourresourcekey"
        }
      },
      {
        "BuilderName": "DeviceDetectionCloudEngineBuilder"
      }
    ]
  }
}
```

Once the @Pipeline has been created, you'll need to make a few changes to the way data is passed to it.
With the old API, you would do something like this:

```{cs}
match = provider.Match(userAgent);
```

The Pipeline API is far more flexible so splits this line into 3 parts:

```{cs}
// 1. Create a 'FlowData' instance from the Pipeline. This is used to pass data in and access results.
var data = pipeline.CreateFlowData()
// 2. Add 'evidence' to the FlowData and process it. In this case, we are adding a User-Agent HTTP header.
// Note that if you have an HTTPContext then there is a helper to add all the associated values to evidence for you.
  .AddEvidence("header.User-Agent", mobileUserAgent)
  .Process();
// 3. The Pipeline can return all sorts of different data so we need to tell it the type of data that we want. In this case, details about the device associated with the User-Agent.
var device = data.Get<IDeviceData>();
```

Finally, the way that data is accessed has also changed in several ways.
1. Values can now be accessed by strongly typed properties rather than having to remember 'magic strings' (although magic string accessors still work as well).
2. Many properties follow the nullable pattern. For example, rather than returning a boolean, the 'IsMobile' property returns a wrapper type that has 'HasValue' and 'Value' accessors. Calling '.Value' on a property that does not have a value will result in an exception. For more detail see the @falsepositivecontrol feature page.

As an example:

```{cs}
var isMobile = match["IsMobile"].ToBool();
```

becomes:

```{cs}
if(device.IsMobile.HasValue)
{
    var isMobile = device.IsMobile.Value;
}
```


<!--TODO: maybe offer this option? (I can't see why you would want to do it this way but I know others seem to prefer it!)-->
If you don't mind specifying the return type and dealing with magic strings, You can cut out a step and access properties directly from the flow data if desired. E.g:

```{cs}
if(data.GetAs<AspectPropertyValue>("IsMobile").HasValue)
{
    var isMobile = data.GetAs<AspectPropertyValue>("IsMobile").Value;
}
```
@endsnippet
@startsnippet{aspdotnet}
<!-- ===================================================================================
     |                                    ASP.NET                                      |
     =================================================================================== -->
This section describes how to migrate from the ASP.NET integration in version 3 of the device detection API to the ASP.NET integration in Pipeline API.
Note - The redirect, image optimization and performance monitoring services are no longer supported in the Pipeline API.

First, add the `FiftyOne.DeviceDetection` and `FiftyOne.Pipeline.Web` NuGet packages.

The main difference is in the configuration file supplied to the Pipeline. This must be in the App_Data folder and can be named:

* pipeline.xml
* pipeline.config (xml format expected)
* pipeline.json
* 51degrees.xml
* 51degrees.config (xml format expected)
* 51degrees.json

This file should follow the usual structure of a pipeline configuration file. For example, a typical device detection configuration would be:

```{json}
{
  "PipelineOptions": {
    "Elements": [
      {
        "BuilderName": "DeviceDetectionHashEngineBuilder",
        "BuildParameters": {
          "DataFile": "C:\\Absolute\\Path\\To\\Data\\File\\51Degrees-EnterpriseV4.1.hash",
          "CreateTempDataCopy": true,
          "DataUpdateLicenseKey": "yourkey",
          "PerformanceProfile": "LowMemory"
        }
      }
    ]
  }
}
```

- **IMPORTANT:** `C:\\Absolute\\Path\\To\\Data\\File\\51Degrees-EnterpriseV4.1.hash` is an absolute path to the data file. **Please amend this entry accordingly to your configuration.**
- Use the performance profile setting to control the trade-off between performance and memory. `LowMemory` is recommended if you're not sure. `MaxPerformance` uses the most memory but gives the best performance.
- If you have auto updates disabled then remove the `DataUpdateLicenseKey` line and instead use `"AutoUpdate": false` and `"DataUpdateOnStartup": false`
- If using the 51Degrees cloud service, you'll first need to use [the Configurator](configure.51degrees.com) to create a resource key (this will only take a few minutes and does not require any payment). See the next snippet below for an example of how to supply this resource key to the Pipeline.

```{json}
{
  "PipelineOptions": {
    "Elements": [
      {
        "BuilderName": "CloudRequestEngineBuilder",
        "BuildParameters": {
          "ResourceKey": "yourresourcekey"
        }
      },
      {
        "BuilderName": "DeviceDetectionCloudEngineBuilder"
      }
    ]
  }
}
```

- Modification to `Application_Start` method in the application class from `"global.asax.cs"` file to include loading of assemblies required by the pipeline is needed. See the snippet below for an example. 
```{cs}
// Make sure the assemblies that are needed by the pipeline
// are loaded into the app domain.
AppDomain.CurrentDomain.Load(
    typeof(DeviceDetectionHashEngineBuilder).Assembly.GetName());
AppDomain.CurrentDomain.Load(
    typeof(JavaScriptBuilderElement).Assembly.GetName());
AppDomain.CurrentDomain.Load(
    typeof(JsonBuilderElement).Assembly.GetName());
AppDomain.CurrentDomain.Load(
    typeof(SequenceElementBuilder).Assembly.GetName());
```

The old v3 web integration used the `Request.Browser` functionality that was built in to ASP.NET in order to access result values. The Pipeline integration uses the same approach so you can still do things like:

```{cs}
if (Request.Browser["IsMobile"] == "True")
```
@endsnippet
@startsnippet{aspdotnetcore}
<!-- ===================================================================================
     |                                  ASP.NET Core                                   |
     =================================================================================== -->
This section describes how to migrate from the ASP.NET integration in version 3 of the device detection API to the ASP.NET Core integration in Pipeline API.
Note - The redirect, image optimization and performance monitoring services are no longer supported in the Pipeline API.

First, add the `FiftyOne.DeviceDetection` and `FiftyOne.Pipeline.Web` NuGet packages.

Add the following lines to you 'ConfigureService' method:

```{cs}
services.AddSingleton<DeviceDetectionHashEngineBuilder>();
services.AddFiftyOne<PipelineBuilder>(Configuration);
```

Add the following line to the 'Configure' method:

```{cs}
app.UseFiftyOne();
```

Add a PipelineOptions section to your appsettings.json file and configure appropriately. For example:

```{json}
{
  "Logging": {
    "LogLevel": {
      "Default": "Warning"
    }
  },
  "AllowedHosts": "*",
  "PipelineOptions": {
    "Elements": [
      {
        "BuilderName": "DeviceDetectionHashEngineBuilder",
        "BuildParameters": {
          "DataFile": "51Degrees-EnterpriseV4.1.hash",
          "CreateTempDataCopy": true,
          "DataUpdateLicenseKey": "yourkey",
          "PerformanceProfile": "LowMemory"
        }
      }
    ]
  }
}
```

- Use the performance profile setting to control the trade-off between performance and memory. `LowMemory` is recommended if you're not sure. `MaxPerformance` uses the most memory but gives the best performance.
- If you have auto updates disabled then remove the `DataUpdateLicenseKey` line and instead use `"AutoUpdate": false` and `"DataUpdateOnStartup": false`
- If using the 51Degrees cloud service, you'll first need to use [the Configurator](configure.51degrees.com) to create a resource key (this will only take a few minutes and does not require any payment). See the next snippet below for an example of how to supply this resource key to the Pipeline.

```{json}
"PipelineOptions": {
  "Elements": [
    {
      "BuilderName": "CloudRequestEngineBuilder",
      "BuildParameters": {
        "ResourceKey": "yourresourcekey"
      }
    },
    {
      "BuilderName": "DeviceDetectionCloudEngineBuilder"
    }
  ]
}
```

You can now use dependency injection to access data from the Pipeline in your controllers.
For example:


```{cs}
public class HomeController : Controller
{
    private IFlowDataProvider _dataProvider;

    public HomeController(IFlowDataProvider dataProvider)
    {
        _dataProvider = dataProvider;
    }

    public IActionResult Index()
    {
        var data = _dataProvider.GetFlowData().Get<IDeviceData>();
        return View(data);
    }
}
```

The device properties can then be accessed in the corresponding view. For example:

```{html}
@model FiftyOne.DeviceDetection.IDeviceData
@{
    ViewData["Title"] = "Device detection example";
}

<h2>Example</h2>

<p>
    Hardware Vendor: @(hardwareVendor.HasValue ? hardwareVendor.Value : $"Unknown ({hardwareVendor.NoValueMessage})")<br />
    Hardware Name: @(hardwareName.HasValue ? string.Join(", ", hardwareName.Value) : $"Unknown ({hardwareName.NoValueMessage})")<br />
    Device Type: @(deviceType.HasValue ? deviceType.Value : $"Unknown ({deviceType.NoValueMessage})")<br />
    Platform Vendor: @(platformVendor.HasValue ? platformVendor.Value : $"Unknown ({platformVendor.NoValueMessage})")<br />
    Platform Name: @(platformName.HasValue ? platformName.Value : $"Unknown ({platformName.NoValueMessage})")<br />
    Platform Version: @(platformVersion.HasValue ? platformVersion.Value : $"Unknown ({platformVersion.NoValueMessage})")<br />
    Browser Vendor: @(browserVendor.HasValue ? browserVendor.Value : $"Unknown ({browserVendor.NoValueMessage})")<br />
    Browser Name: @(browserName.HasValue ? browserName.Value : $"Unknown ({browserName.NoValueMessage})")<br />
    Browser Version: @(browserVersion.HasValue ? browserVersion.Value : $"Unknown ({browserVersion.NoValueMessage})")
</p>

@await Component.InvokeAsync("FiftyOneJS")
```

The `FiftyOneJS` component handles the inclusion of @clientsideevidence.
The main use-case for this in device detection is in detecting iPhone and iPad models correctly.

<!-- TODO Add link to client-side evidence example or guide 
Refer to the specific guide for more detail on using client-side evidence.-->
@endsnippet
@startsnippet{java}
<!-- ===================================================================================
     |                                     Java                                        |
     =================================================================================== -->
First, add the `com.51degrees.device-detection` Maven package.

The old (V3) device detection API generally had two initialization steps, one to create a `DataSet` and one to create a `Provider` from that `DataSet`.
The precise details would depend on:
- Whether you are using the Pattern or Hash algorithm.
- Whether you are loading all the data into memory for better performance or not.
- Other DataSet creation options being used.

```{java}
DataSet dataSet = StreamFactory.create(filename, false);
Provider provider = new Provider(dataSet);   
```

There are several ways to set up an equivalent service using the Pipeline API. For example, you could create the device detection engine and then create the Pipeline.
However, the easiest method is to use a specific `DeviceDetectionPipelineBuilder`. This can be configured using a settings file or directly in code: 

```{java}
Pipeline pipeline = new DeviceDetectionPipelineBuilder()
  .useOnPremise(dataFile, false)
  .setPerformanceProfile(Constants.PerformanceProfiles.LowMemory)
  .setDataUpdateLicenseKey("yourkey")
  .build();
```

Settings will be dependent on your old implementation:

- If using the 51Degrees cloud service, you'll first need to use [the Configurator](configure.51degrees.com) to create a resource key (this will only take a few minutes and does not require any payment). Next, change the first line to `.useCloud` and pass in the resource key you created.
- If using `MemoryFactory` rather that `StreamFactory` then change the performance profile to `MaxPerformance`.
- If using a custom caching configuration, you will need to create the device detection engine first using a `DeviceDetectionHashEngineBuilder`. The `setCache` method can then be used to supply your custom configuration. Finally, the generic `PipelineBuilder` can be used to create a pipeline with the device detection engine added to it.
- If you have auto updates disabled then remove the `setDataUpdateLinceseKey` line and instead use `setAutoUpdate(false)` and `setUpdateOnStartup(false)`

Regardless of the details above, a configuration file can be used instead:

```{java}
// Create the configuration object
File file = new File("yourconfiguration.xml").getFile());
JAXBContext jaxbContext = JAXBContext.newInstance(PipelineOptions.class);
Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();
// Bind the configuration to a pipeline options instance
PipelineOptions options = (PipelineOptions) unmarshaller.unmarshal(file);

// Create a simple pipeline to access the engine with.
Pipeline pipeline = new FiftyOnePipelineBuilder()
    .buildFromConfiguration(options);
```

The XML configuration file for the same setup as above (on-premise, low memory, auto updates enabled) would look like this:

```{xml}
<?xml version="1.0" encoding="utf-8" ?>
<PipelineOptions>
    <Elements>
        <Element>
            <BuildParameters>
                <DataUpdateLicenseKey>yourkey</DataUpdateLicenseKey>
                <CreateTempDataCopy>true</CreateTempDataCopy>
                <DataFile>51Degrees-EnterpriseV4.1.hash</DataFile>
                <PerformanceProfile>LowMemory</PerformanceProfile>
            </BuildParameters>
            <BuilderName>DeviceDetectionHashEngineBuilder</BuilderName>
        </Element>
    </Elements>
</PipelineOptions>
```

If you are using the 51Degrees cloud then you'll need to add two elements using the builders `CloudRequestEngineBuilder` and `DeviceDetectionCloudEngineBuilder`. For example:

```{xml}
<?xml version="1.0" encoding="utf-8" ?>
<PipelineOptions>
    <Elements>
        <Element>
            <BuildParameters>
                <ResourceKey>yourresourcekey</ResourceKey>
            </BuildParameters>
            <BuilderName>CloudRequestEngine</BuilderName>
        </Element>
        <Element>
            <BuilderName>DeviceDetectionCloudEngine</BuilderName>
        </Element>
    </Elements>
</PipelineOptions>
```

Once the @Pipeline has been created, you'll need to make a few changes to the way data is passed to it.
With the old API, you would do something like this:

```{java}
match = provider.Match(userAgent);
```

The Pipeline API is far more flexible so splits this line into 3 parts:

```{java}
// 1. Create a 'FlowData' instance from the Pipeline. This is used to pass data in and access results.
FlowData data = pipeline.createFlowData()
// 2. Add 'evidence' to the FlowData and process it. In this case, we are adding a User-Agent HTTP header.
    .addEvidence("header.user-agent", userAgent)
    .process();
// 3. The Pipeline can return all sorts of different data so we need to tell it the type of data that we want. In this case, details about the device associated with the User-Agent.
DeviceData device = data.get(DeviceData.class);
```

Finally, the way that data is accessed has also changed in several ways.
1. Values can now be accessed by strongly typed properties rather than having to remember 'magic strings' (although magic string accessors still work as well).
2. Many properties follow the nullable pattern. For example, rather than returning a boolean, the 'IsMobile' property returns a wrapper type that has 'hasValue' and 'value' accessors. Calling '.gertValue' on a property that does not have a value will result in an exception. For more detail see the @falsepositivecontrol feature page.

As an example:

```{java}
boolean isMobile = match.getValues("IsMobile").ToBoolean();
```

becomes:

```{java}
if(device.getIsMobile().hasValue) {
    boolean isMobile = device.getIsMobile().getValue();
}
```
@endsnippet
@startsnippet{node}
<!-- ===================================================================================
     |                                      Node                                       |
     =================================================================================== -->
First, add the fiftyone.devicedetection package from NPM.

With the V3 API, a provider could be created with something like this:

```{node}
// Set the config.
var config = {"dataFile" : require("fiftyonedegreeslitepattern"),
              "properties" : "IsMobile",
              "cacheSize" : 10000,
              "poolSize" : 4,
              "stronglyTyped": false
             };
var provider = new fiftyonedegrees.provider(config);
```

Creating a Pipeline with a device detection engine is similar although the options are different:

```{node}
// Create a new device detection pipeline and set the config.
let pipeline = new deviceDetectionPipelineBuilder({    
    performanceProfile: "MaxPerformance",
    dataFile: "[your path]/51Degrees-LiteV4.1.hash",
    autoUpdate: false
}).build();
```

Settings will be dependent on your old implementation:

- If using the 51Degrees cloud service, you'll first need to use [the Configurator](configure.51degrees.com) to create a resource key (this will only take a few minutes and does not require any payment). Next, remove the dataFile line from the configuration and add the resource key you created.
- If you want to trade some performance for system memory then change the performance profile to `MaxPerformance`, `Balanced` or `LowMemory`
- If you want the data file to be updated automatically then remove `autoUpdate: false` and add your license key to the configuration. (Not available for free users)

You can also build a @Pipeline from a JSON configuration file:

```{node}
let pipeline = new pipelineBuilder().buildFromConfigurationFile("settings.json");
```
Where settings.json contains the following: 

```{node}
{
    "PipelineOptions": {
        "Elements": [
        {
            "elementName": "fiftyone.pipeline.devicedetection/deviceDetectionOnPremise",  
            "elementParameters": {
                "performanceProfile": "MaxPerformance",
                "dataFile": "51Degrees-LiteV4.1.hash",
                "autoUpdate": false
            }
        }
        ]
    }
}
```

Once the @Pipeline has been created, you'll need to make a few changes to the way data is passed to it and accessed.
With the old API, you would do something like this:

```{node}
var device = provider.getMatch(userAgent);
```

In the new API, this is slightly more complicated as it needs to deal with the potential for different types of data in and out.

```{node}
// 1. Create a 'FlowData' instance from the Pipeline. This is used to pass data in and access results.
let flowData = pipeline.createFlowData();
// 2. Add 'evidence' to the FlowData and process it. In this case, we are adding a User-Agent HTTP header.
flowData.evidence.add("header.user-agent", userAgent);
flowData.process().then(function () {
    // 3. The Pipeline can return all sorts of different data so we need to tell it the type of data that we want. In this case, details about the device associated with the User-Agent.
    var device = flowData.device;
});
```

Accessing the property values is similar in the new API and the old API. The main difference is the addition of the 'hasValue' property that is used to indicate when no match has been found. For more detail on this see the @falsepositivecontrol feature page.

As an example:

```{node}
var isMobile = device.isMobile;
```

Becomes:

```{node}
if(device.isMobile.hasValue) {
    var isMobile = device.isMobile.value;
}
```
@endsnippet
@startsnippet{php}
<!-- ===================================================================================
     |                                      PHP                                        |
     =================================================================================== -->
If you currently use an on-premise data file with PHP then you will need to get the on-premise version of the PHP API from [GitHub](https://github.com/51Degrees/device-detection-php-onpremise).
<!--TODO: Add complete steps for on-premise PHP.-->
If you use the cloud version then you can install the fiftyone.devicedetection package from composer.

With the V3 API, a provider could be created with something like this:

```{php}
$provider = FiftyOneDegreesPatternV3::provider_get();
```

If using the 51Degrees cloud service, you'll first need to use [the Configurator](configure.51degrees.com) to create a resource key (this will only take a few minutes and does not require any payment). Next, create a device detection pipeline using the resource key you created:

```{php}
$deviceDetectionPipeline = new deviceDetectionPipelineBuilder(array(
    "resourceKey" => "[Yourkey]"
));
$deviceDetectionPipeline = $deviceDetectionPipeline->build();
```

Once the @Pipeline has been created, you'll need to make a few changes to the way data is passed to it and accessed.
With the old API, you would do something like this:

```{php}
$match = $provider->getMatch($mobileUserAgent);
```

In the new API, this is slightly more complicated as it needs to deal with the potential for different types of data in and out.

```{node}
// 1. Create a 'FlowData' instance from the Pipeline. This is used to pass data in and access results.
$flowData = $deviceDetectionPipeline->createFlowData();
// 2. Add 'evidence' to the FlowData. In this case, we are adding a User-Agent HTTP header.
$flowData->evidence->set("header.user-agent", userAgent);
// 3. Process the evidence.
$pipelineResult = $flowData->process();
// 4. The Pipeline can return all sorts of different data so we need to tell it the type of data that we want. In this case, details about the device associated with the User-Agent.
$device = $result->get("device")
```

Accessing the property values is similar in the new API and the old API. The main difference is the addition of the 'hasValue' property that is used to indicate when no match has been found. For more detail on this see the @falsepositivecontrol feature page.

As an example:

```{php}
$isMobile = $match->getValue("IsMobile");
```

Becomes:

```{php}
if($device->get("ismobile")->hasValue) {
    $isMobile = $device->get("ismobile").value;
}
```

@endsnippet
@startsnippet{nginx}
<!-- ===================================================================================
     |                                    Nginx                                        |
     =================================================================================== -->
Nginx module comes only with an on-premise version, you will need to get the on-premise version of the Nginx API from [GitHub](https://github.com/51Degrees/device-detection-nginx).
 
The implementation of 51Degrees Device Detection V4 module is based on the V3 version and the migration process from V3 to V4 is straightforward. Existing V3 customers can build and use V4 in a similar way as V3. Please make sure to obtain a V4 Hash data file at [pricing](https://51degrees.com/pricing)  and be aware of the changes described below. 
 
Removed in V4:
- V4 version supports only one method of detection which is Hash.
  - Building V4 module is done as below without specifying the detection method:
```{nginx}
make install
```
- The following build options are not available:
  - `FIFTYONEDEGREES_CACHE_KEY_LENGTH`
  - `FIFTYONEDEGREES_VALUE_SEPARATOR`
- The following directives are removed or changed:
  - `51D_cache` is removed.
  - `51D_filePath` changed to `51D_file_path`.
  - `51D_valueSeparator` changed to `51D_value_separator`.
 
New in V4:
- `51D_drift`
- `51D_difference`
- `51D_allow_unmatched`
- `51D_use_performance_graph`
- `51D_use_predictive_graph`
- `51D_get_javascript_single`
- `51D_get_javascript_all`
- `51D_set_resp_headers`
 
Changes in behaviour:
- `51D_match_all` also takes evidence from query string and cookie.
 - Evidence input from query string takes precedence over header evidence.
   - For example, if `User-Agent` is supplied via query string, the value will be used instead of the header `User-Agent`.
 - Properties that are overridable can now be overridden by value supplied as input from cookie and query string.
Further reads:
- [Nginx Integration](@ref OtherIntegrations_Nginx)
@endsnippet

@endsnippets

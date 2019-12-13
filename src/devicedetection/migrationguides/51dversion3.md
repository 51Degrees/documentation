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
@startsnippet{none,block}
Select a language to view a language specific migration guide.
@endsnippet
<!-- ===================================================================================
     |                                        C                                        |
     =================================================================================== -->
@startsnippet{c}

@endsnippet
<!-- ===================================================================================
     |                                       C++                                       |
     =================================================================================== -->
@startsnippet{cpp}

@endsnippet
<!-- ===================================================================================
     |                                      .NET                                       |
     =================================================================================== -->
@startsnippet{dotnet}
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

The builder will work out whether to use the Pattern or Hash algorithm based on the supplied data file.
Other settings will be dependent on your old implementation:

- If using the 51Degrees cloud service, you'll first need to use [the Configurator](configure.51degrees.com) to create a resource key (this will only take a few minutes and does not require any payment). Next, change the first line to `.UseCloud` and pass in the resource key you created.
- If using `MemoryFactory` rather that `StreamFactory` then change the performance profile to `MaxPerformance`.
- If using a custom caching configuration, you will need to create the device detection engine first using a `DeviceDetectionPatternEngineBuilder` or `DeviceDetectionHashEngineBuilder` depending on your data file. The `SetCache` method can then be used to supply your custom configuration. Finally, the generic `PipelineBuilder` can be used to create a pipeline with the device detection engine added to it.
- If you have auto updates disabled then remove the `SetDataUpdateLinceseKey` line and instead use `SetAutoUpdate(false)`

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
        "BuilderName": "DeviceDetectionPatternEngineBuilder",
        "BuildParameters": {
          "DataFile": "51Degrees-EnterpriseV3.2.dat",
          "CreateTempDataCopy": true,
          "DataUpdateLicenseKey": "yourkey",
          "PerformanceProfile": "LowMemory"
        }
      }
    ]
  }
}
```

Note that the 'BuilderName' parameter must be set to the correct type for the data file. Either `DeviceDetectionPatternEngineBuilder` or `DeviceDetectionHashEngineBuilder`.
If you are using the 51Degrees cloud then you'll need to add two elements using the builders `CloudRequestEngineBuilder` and `DeviceDetectionCloudEngineBuilder`. For example:

```{json}
{
  "PipelineOptions": {
    "Elements": [
      {
        "BuilderName": "CloudRequestEngineBuilder",
        "BuildParameters": {
          "ResourceKey": "yourresourcekey",
          "LicenseKey": "yourlicensekey",
          "EndPoint": "cloud.51degrees.com"
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
2. Many properties follow the nullable pattern. For example, rather than returning a boolean, the 'IsMobile' property returns a wrapper type that has 'HasValue' and 'Value' accessors. Calling '.Value' on a property that does not have a value will result in an exception.

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


TODO: maybe offer this option? (I can't see why you would want to do it this way but I know others seem to prefer it!) If you don't mind specifying the return type and dealing with magic strings, You can cut out a step and access properties directly from the flow data if desired. E.g:

```{cs}
if(data.GetAs<AspectPropertyValue>("IsMobile").HasValue)
{
    var isMobile = data.GetAs<AspectPropertyValue>("IsMobile").Value;
}
```
@endsnippet
<!-- ===================================================================================
     |                                    ASP.NET                                      |
     =================================================================================== -->
@startsnippet{aspdotnet}
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
        "BuilderName": "DeviceDetectionPatternEngineBuilder",
        "BuildParameters": {
          "DataFile": "51Degrees-EnterpriseV3.2.dat",
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
- If you have auto updates disabled then remove the `DataUpdateLicenseKey` line and instead use `"AutoUpdate": "false)`
- If using the 51Degrees cloud service, you'll first need to use [the Configurator](configure.51degrees.com) to create a resource key (this will only take a few minutes and does not require any payment). See the next snippet below for an example of how to supply this resource key to the Pipeline. If you are accessing paid-for properties then a license key will also be required.

```{json}
{
  "PipelineOptions": {
    "Elements": [
      {
        "BuilderName": "CloudRequestEngineBuilder",
        "BuildParameters": {
          "ResourceKey": "yourresourcekey",
          "LicenseKey": "yourlicensekey",
          "EndPoint": "https://cloud.51degrees.com/api/v4/json"
        }
      },
      {
        "BuilderName": "DeviceDetectionCloudEngineBuilder"
      }
    ]
  }
}
```

The previous web integration used the `Request.Browser` functionality that was built in to ASP.NET in order to access result values. The Pipeline integration uses the same approach so you can still do things like:

```{cs}
if (Request.Browser["IsMobile"] == "True")
```
@endsnippet
<!-- ===================================================================================
     |                                  ASP.NET Core                                   |
     =================================================================================== -->
@startsnippet{aspdotnetcore}
This section describes how to migrate from the ASP.NET integration in version 3 of the device detection API to the ASP.NET Core integration in Pipeline API.
Note - The redirect, image optimization and performance monitoring services are no longer supported in the Pipeline API.

First, add the `FiftyOne.DeviceDetection` and `FiftyOne.Pipeline.Web` NuGet packages.

Add the following lines to you 'ConfigureService' method:

```{cs}
services.AddSingleton<DeviceDetectionPatternEngineBuilder>();
services.AddFiftyOne<PipelineBuilder>(Configuration);
```

If you are using the @Hash algorithm, you will need to specify the `DeviceDetectionHashEngineBuilder` instead.

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
        "BuilderName": "DeviceDetectionPatternEngineBuilder",
        "BuildParameters": {
          "DataFile": "51Degrees-EnterpriseV3.2.dat",
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
- If you have auto updates disabled then remove the `DataUpdateLicenseKey` line and instead use `"AutoUpdate": "false)`
- If using the 51Degrees cloud service, you'll first need to use [the Configurator](configure.51degrees.com) to create a resource key (this will only take a few minutes and does not require any payment). See the next snippet below for an example of how to supply this resource key to the Pipeline. If you are accessing paid-for properties then a license key will also be required.

```{json}
"PipelineOptions": {
  "Elements": [
    {
      "BuilderName": "CloudRequestEngineBuilder",
      "BuildParameters": {
        "ResourceKey": "yourresourcekey",
        "LicenseKey": "yourlicensekey",
        "EndPoint": "https://cloud.51degrees.com/api/v4/json"
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
    Hardware: @Model.HardwareVendor @string.Join(',', Model.HardwareName)<br />
    Device Type: @Model.DeviceType<br />
    Platform: @Model.PlatformVendor @Model.PlatformName @Model.PlatformVersion<br />
    Browser: @Model.BrowserVendor @Model.BrowserName @Model.BrowserVersion<br />
</p>

@await Component.InvokeAsync("FiftyOneJS")
```

The `FiftyOneJS` component handles the inclusion of client-side evidence.
The main use-case for this in device detection is in detecting iPhone and iPad models correctly.
@endsnippet
<!-- ===================================================================================
     |                                     Java                                        |
     =================================================================================== -->
@startsnippet{java}
First, add the `com.51degrees.device-detection` Maven package.

The old (V3) device detection API generally had two initialization steps, one to create a `DataSet` and one to create a `Provider` from that `DataSet`.
The precise details would depend on:
- Whether you are using the Pattern or Hash algorithm.
- Whether you are loading all the data into memory for better performance or not.
- Other DataSet creation options being used.

```{java}
DataSet dataSet = StreamFactory.create(filename, false)
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

The builder will work out whether to use the Pattern or Hash algorithm based on the supplied data file.
Other settings will be dependent on your old implementation:

- If using the 51Degrees cloud service, you'll first need to use [the Configurator](configure.51degrees.com) to create a resource key (this will only take a few minutes and does not require any payment). Next, change the first line to `.UseCloud` and pass in the resource key you created.
- If using `MemoryFactory` rather that `StreamFactory` then change the performance profile to `MaxPerformance`.
- If using a custom caching configuration, you will need to create the device detection engine first using a `DeviceDetectionPatternEngineBuilder` or `DeviceDetectionHashEngineBuilder` depending on your data file. The `SetCache` method can then be used to supply your custom configuration. Finally, the generic `PipelineBuilder` can be used to create a pipeline with the device detection engine added to it.
- If you have auto updates disabled then remove the `SetDataUpdateLinceseKey` line and instead use `SetAutoUpdate(false)`

Regardless of the details above, a configuration file can be used instead:

```{java}
// Create the configuration object
File file = new File(getClass().getClassLoader().getResource("hash.xml").getFile());
JAXBContext jaxbContext = JAXBContext.newInstance(PipelineOptions.class);
Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();
// Bind the configuration to a pipeline options instance
PipelineOptions options = (PipelineOptions) unmarshaller.unmarshal(file);

FiftyOnePipelineBuilder builder = new FiftyOnePipelineBuilder();
// Create a simple pipeline to access the engine with.
Pipeline pipeline = new FiftyOnePipelineBuilder()
    .buildFromConfiguration(options);
```

The XML configuration file for the same setup as above (on premise, low memory, auto updates enabled) would look like this:

```{xml}
<?xml version="1.0" encoding="utf-8" ?>
<PipelineOptions>
    <Elements>
        <Element>
            <BuildParameters>
                <DataUpdateLicenseKey>yourkey</DataUpdateLicenseKey>
                <CreateTempDataCopy>true</CreateTempDataCopy>
                <DataFile>51Degrees-EnterpriseV3.4.trie</DataFile>
                <PerformanceProfile>LowMemory</PerformanceProfile>
            </BuildParameters>
            <BuilderName>DeviceDetectionPatternEngineBuilder</BuilderName>
        </Element>
    </Elements>
</PipelineOptions>
```

Note that the 'BuilderName' parameter must be set to the correct type for the data file. Either `DeviceDetectionPatternEngineBuilder` or `DeviceDetectionHashEngineBuilder`.
If you are using the 51Degrees cloud then you'll need to add two elements using the builders `CloudRequestEngineBuilder` and `DeviceDetectionCloudEngineBuilder`. For example:

```{xml}
<?xml version="1.0" encoding="utf-8" ?>
<PipelineOptions>
    <Elements>
        <Element>
            <BuildParameters>
                <EndPoint>https://cloud.51degrees.com/api/v4/json</EndPoint>
                <ResourceKey>yourresourcekey</ResourceKey>
                <LicenseKey>yourlicensekey</LicenseKey>
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
    .addEvidence("header.user-agent", mobileUserAgent)
    .process();
// 3. The Pipeline can return all sorts of different data so we need to tell it the type of data that we want. In this case, details about the device associated with the User-Agent.
DeviceData device = data.get(DeviceData.class);
```

Finally, the way that data is accessed has also changed in several ways.
1. Values can now be accessed by strongly typed properties rather than having to remember 'magic strings' (although magic string accessors still work as well).
2. Many properties follow the nullable pattern. For example, rather than returning a boolean, the 'IsMobile' property returns a wrapper type that has 'hasValue' and 'value' accessors. Calling '.value' on a property that does not have a value will result in an exception.

As an example:

```{java}
boolean isMobile = match.getValues("IsMobile").ToBoolean();
```

becomes:

```{java}
if(device.getIsMobile().hasValue)
{
    boolean isMobile = device.getIsMobile().value;
}
```
@endsnippet
<!-- ===================================================================================
     |                                      Node                                       |
     =================================================================================== -->
@startsnippet{node}
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
    dataFile: require("fiftyonedegreeslitepattern"),
    autoUpdate: false
}).build();
```

The builder will work out whether to use the Pattern or Hash algorithm based on the supplied data file.
Other settings will be dependent on your old implementation:

- If using the 51Degrees cloud service, you'll first need to use [the Configurator](configure.51degrees.com) to create a resource key (this will only take a few minutes and does not require any payment). Next, remove the dataFile line from the configuration and add the resource key you created (along with your license key if you're using paid-for properties).
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
                "dataFile": "51Degrees-LiteV3.2.dat",
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

Accessing the property values is similar in the new API and the old API. The main difference is the addition of the 'hasValue' property that is used to indicate when no match has been found:

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
<!-- ===================================================================================
     |                                      PHP                                        |
     =================================================================================== -->
@startsnippet{php}
If you currently use an on-premise data file with PHP then you will need to get the on-premise version of the PHP API from GitHub (TODO add link).  
TODO: Add complete steps for on-premise PHP.
If you use the cloud version then you can install the fiftyone.devicedetection package from composer.

With the V3 API, a provider could be created with something like this:

```{php}
$provider = FiftyOneDegreesPatternV3::provider_get();
```

If using the 51Degrees cloud service, you'll first need to use [the Configurator](configure.51degrees.com) to create a resource key (this will only take a few minutes and does not require any payment). Now create a device detection pipeline using the resource key you created (along with your license key if you're using paid-for properties).:

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

Accessing the property values is similar in the new API and the old API. The main difference is the addition of the 'hasValue' property that is used to indicate when no match has been found:

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
@endsnippets
@page ReverseGeocoding_Quickstart Reverse Geocoding Quick Start

# Getting Started with Reverse Geocoding

Reverse geocoding turns GPS coordinates into real places like countries, cities, and addresses. Here's how to set it up in minutes.

## Step 1: Get Your Resource Key

You'll need a Resource Key to access our reverse geocoding service. Follow the @configuratorexplanation to create one. Make sure your Resource Key includes at least the Country field.

## Step 2: Install the Library

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{node,Node.js}
@showsnippet{php,PHP}
@showsnippet{python,Python}
@defaultsnippet{Select a language.}
@startsnippet{dotnet}
Install the [FiftyOne.GeoLocation](https://www.nuget.org/packages/FiftyOne.GeoLocation) package via Nuget.
@endsnippet
@startsnippet{java}
Install the [com.51degrees.pipeline.geo-location](https://search.maven.org/artifact/com.51degrees/pipeline.geo-location) package via Maven.
@endsnippet
@startsnippet{node}
Install the [fiftyone.geolocation](https://www.npmjs.com/package/fiftyone.geolocation) package from NPM with `npm install fiftyone.geolocation`
@endsnippet
@startsnippet{php}
Install the [51degrees/fiftyone.geolocation](https://packagist.org/packages/51degrees/fiftyone.geolocation) package using [Composer](https://getcomposer.org) with `composer require 51degrees/fiftyone.geolocation`
@endsnippet
@startsnippet{python}
Install the [fiftyone-location](https://pypi.org/project/fiftyone-location/) package from PyPI with `pip install fiftyone-location`.
@endsnippet


## Step 3: Set Up Your Pipeline

The pipeline is how you connect to 51Degrees APIs (learn more in @pipelinebasics and @pipeline). Use the Resource Key you created in step 1.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{node,Node.js}
@showsnippet{php,PHP}
@showsnippet{python,Python}
@defaultsnippet{Select a language.}

@startsnippet{dotnet}
```
string resourceKey = "AAAAAAABBBBBBCCCCCC";
using (var pipeline =
    new GeoLocationPipelineBuilder(_loggerFactory)
    .UseCloud(resourceKey, FiftyOne.GeoLocation.Core.GeoLocationProvider.FiftyOneDegrees)
    .UseLazyLoading(TimeSpan.FromSeconds(10))
    .Build())
        {
            ...
        }
```
@endsnippet
@startsnippet{java}
```java
/* See full example code for required imports */
String resourceKey = "AAAAAAABBBBBBCCCCC";
Pipeline pipeline = new GeoLocationPipelineBuilder(loggerFactory)
    .useCloud(resourceKey, Enums.GeoLocationProvider.FiftyOneDegrees)
    .setEndPoint("https://cloud.51degrees.com/api/v4")
    .useLazyLoading(1000)
    .setAutoCloseElements(true)
    .build();
```
@endsnippet
@startsnippet{node}
```js
const FiftyOneDegreesGeoLocation = require('./index');
let localResourceKey = 'AAAAAAAABBBBBBCC';
const pipeline = new FiftyOneDegreesGeoLocation.GeoLocationPipelineBuilder({
  resourceKey: localResourceKey
}).build();
```
@endsnippet
@startsnippet{php}
\verbatim
require(__DIR__ . "/vendor/autoload.php");
use fiftyone\pipeline\geolocation\GeoLocationPipelineBuilder;
$resourceKey = "AAAAAAAABBBBBBCC";
$settings = array(
    "resourceKey" => $resourceKey,
    "locationProvider" => "fiftyonedegrees"
);
$builder = new GeoLocationPipelineBuilder($settings);
$pipeline = $builder->build();
\endverbatim
@endsnippet
@startsnippet{python}
```python
from fiftyone_location.location_pipelinebuilder import LocationPipelineBuilder
resourceKey = "AAAAAAAABBBBBBCC"
pipeline = LocationPipelineBuilder({"resourceKey": resourceKey}).build()
```
@endsnippet

## Step 4: Add Your Coordinates

You need to provide latitude and longitude coordinates (called @evidence). Use these specific keys:

* query.51D_pos_latitude
* query.51D_pos_longitude

The keys aren't case-sensitive.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{node,Node.js}
@showsnippet{php,PHP}
@showsnippet{python,Python}
@defaultsnippet{Select a language.}

@startsnippet{dotnet}
```
var data = pipeline.CreateFlowData();
data.AddEvidence("query.51D_Pos_latitude", "51.458048");
data.AddEvidence("query.51D_Pos_longitude", "-0.9822207999999999");
```
@endsnippet
@startsnippet{java}
```java
FlowData flowData = pipeline.createFlowData();
flowData.addEvidence(EVIDENCE_GEO_LAT_PARAM_KEY, "51.458048")
    .addEvidence(EVIDENCE_GEO_LON_PARAM_KEY, "-0.9822207999999999")
    .process();
```
@endsnippet
@startsnippet{node}
```js
const flowData = pipeline.createFlowData();
const latitude = "51.457739";
const longitude = "-0.975978";
flowData.evidence.add('query.51D_Pos_latitude', latitude);
flowData.evidence.add('query.51D_Pos_longitude', longitude);
```
@endsnippet
@startsnippet{php}
```php
$flowData = $pipeline->createFlowData();
$latitude = "51.457739";
$longitude = "-0.975978";
$flowData->evidence->set('query.51D_Pos_latitude', $latitude);
$flowData->evidence->set('query.51D_Pos_longitude', $longitude);
```
@endsnippet
@startsnippet{python}
```python
fd = pipeline.create_flowdata()
latitude = "51.457739"
longitude = "-0.975978"
fd.evidence.add("query.51D_Pos_latitude", latitude)
fd.evidence.add("query.51D_Pos_longitude", longitude)
```
@endsnippet

## Step 5: Run the Query

Call `process()` to start the reverse geocoding lookup.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{node,Node.js}
@showsnippet{php,PHP}
@showsnippet{python,Python}
@defaultsnippet{Select a language.}

@startsnippet{dotnet}
```
data.Process();
```
@endsnippet
@startsnippet{java}
(see previous step)
@endsnippet
@startsnippet{node}
```js
await flowData.process()
```
@endsnippet
@startsnippet{php}
```php
$result = $flowData->process();
```
@endsnippet
@startsnippet{python}
```python
fd.process()
```
@endsnippet

## Step 6: Get Your Results

Your results are in the `flowData` object (not returned from `process()`). Each property has a `hasValue` boolean. If it's populated, `hasValue` is true and `value` contains the result. If not, `hasValue` is false and you'll find why in the null reason property.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{node,Node.js}
@showsnippet{php,PHP}
@showsnippet{python,Python}
@defaultsnippet{Select a language.}

@startsnippet{dotnet}
```
var country = data.Get<IGeoData>().Country;
Console.Write($"Awaiting response");
CancellationTokenSource cancellationSource = new CancellationTokenSource();
Task.Run(() => { OutputUntilCancelled(".", 1000, cancellationSource.Token); });
cancellationSource.Cancel();
Console.WriteLine();
Console.WriteLine($"Country: {country.ToString()}");
```
@endsnippet
@startsnippet{java}
```java
AspectPropertyValue<String> country = flowData.get(GeoData.class).getCountry();
Future future = flowData.get(GeoData.class).getProcessFuture();
System.out.print("Awaiting response");
System.out.println(flowData.get(CloudRequestData.class).getJsonResponse());
System.out.println("Country: " + country.toString());
pipeline.close();
```
@endsnippet
@startsnippet{node}
```js
if (flowData.country.hasValue) {
    console.log("Country name:", flowData.country.value)
} else {
    console.error("Country not available:", flowData.countrynullreason)
}
```
@endsnippet
@startsnippet{php}
```php
$country = $flowData->location->country;

if ($country->hasValue) {
    echo "Which country is the location [" . $latitude . "," . $longitude . "] in?";
    echo "<br />";
    echo $flowData->location->country->value;
} else {
    // Echo out why the value isn't meaningful
    echo $country->noValueMessage;
};
```
@endsnippet
@startsnippet{python}
```python
if fd.location.country.has_value():
    print(fd.location.country.value())
else:
    print(fd.location.country.no_value_message())
```
@endsnippet

Find complete working code examples on GitHub for each language:

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{node,Node.js}
@showsnippet{php,PHP}
@showsnippet{python,Python}
@defaultsnippet{Select a language.}

@startsnippet{dotnet}
https://github.com/51Degrees/location-dotnet/blob/master/Examples/Cloud/GettingStarted/Program.cs
@endsnippet
@startsnippet{java}
https://github.com/51Degrees/location-java/blob/master/geo-location.shell.examples/src/main/java/fiftyone/geolocation/examples/cloud/GettingStarted.java
@endsnippet
@startsnippet{node}
https://github.com/51Degrees/location-node/blob/master/examples/gettingStarted.js
@endsnippet
@startsnippet{php}
https://github.com/51Degrees/location-php/blob/master/examples/cloud/gettingstarted.php
@endsnippet
@startsnippet{python}
https://github.com/51Degrees/location-python/blob/master/examples/cloud/gettingstarted.py
@endsnippet

# Troubleshooting

Having issues? Here are common problems and fixes:

## Resource Key Problems

**"Resource Key not found" error:** Your Resource Key is invalid. Create a new one with the properties you need.

**Properties missing from results:** Your Resource Key might not have access to location properties. Check what your key can access at https://configure.51degrees.com/YOUR_RESOURCE_KEY or create a new key with the right permissions.

## Wrong Evidence Keys

If you get an error about missing evidence, check you're using the correct keys:

* query.51d_pos_latitude
* query.51d_pos_longitude

Wrong keys get ignored, which can cause errors if you don't have any valid evidence.

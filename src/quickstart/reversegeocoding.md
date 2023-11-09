@page Quickstart_ReverseGeocoding Reverse Geocoding Quick Start

This example demonstrates how to look up a latitude and longitude to a geographical location.

## Step 1: Create a Resource Key

First, obtain a Resource Key by following the @configuratorexplanation. For this example, ensure that the Resource Key is authorized for at least the Country field provided by 51Degrees.

## Step 2: Install the relevant library

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


## Step 3: Create a Pipeline and authorize it with the Resource Key

The pipeline, as explained in the @pipelinebasics and @pipeline, is the way to consume 51Degrees APIs. Set the Resource Key to be the one you obtained above in step 1.

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

## Step 4: Create a FlowData on the Pipeline and add evidence to it

For reverse geocoding, two pieces of query data (called @evidence) are required: latitude and longitude. Each piece of data is passed to the APIs with a key naming the type of data that it is. The relevant evidence keys for reverse geocoding are:

* query.51D_pos_latitude
* query.51D_pos_longitude

Keys are not case-sensitive. Add each piece of evidence with its key.

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

## Step 5: Start a query with `process()`

This actually initiates the query and contacts your data source, whether the 51Degrees cloud API or a local deployment.

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

## Step 6: Read the results

Results are available in the existing `flowData` object (note: they are not returned from the `process()` call) in an @aspectdata dictionary with relevant properties. Each property has a `hasValue` boolean; if the property is populated, `flowData.property.hasValue` will be true and `flowData.property.value` will be the relevant value. If the property is not populated, `flowData.property.hasValue` will be false and `flowData.propertynullreason` will be populated.

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

You can get all this code from the examples attached to each library on GitHub, and other examples as well. See below for the link to the appropriate getting-started example and other examples for each language.

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

If you are finding unexpected results from querying the APIs, this section may give some indication of where to start debugging.

## Invalid Resource Key

If your Resource Key is invalid or unrecognized by the server, you should receive a server error reading "Resource key not found", but you may also receive an error like "An invalid IP address was specified. Parameter name: address". In both of these cases, generate a new Resource Key with access to the properties you require and use that.

## Unauthorized Resource Key

If you find that properties are unexpectedly undefined on your `flowData` object (for example, if `flowData.location.country` is not present at all, rather than being present with `hasValue` false) then your Resource Key may not be authorized to access any location properties at all. Try generating a new Resource Key and using it, or visiting https://configure.51degrees.com/YOUR_RESOURCE_KEY to see the properties which that Resource Key can access. Note that a Resource Key's properties cannot be changed once created; create a new key instead of trying to edit an existing one.

(If you can inspect the JSON response from the HTTP APIs, you may find that `device.geolocationnullreason` is set, which is another indicator of this problem.)

## Incorrect evidence keys

The list of @evidence keys which are used to add @evidence must be adhered to. If you provide evidence with an invalid key, it will be ignored. If you do not have any valid keys (or have insufficient valid evidence), then an error like this will be returned:

This property requires evidence values from JavaScript running on the client. It cannot be populated until a future request is made that contains this additional data.

If this happens, check your calls to `flowData.evidence.add` and ensure that you are using valid evidence keys. There is deliberately no comprehensive list of evidence keys, because they vary depending on source and API queried. For geocoding, the evidence keys that are likely to be useful are:

* query.51d_pos_latitude
* query.51d_pos_longitude

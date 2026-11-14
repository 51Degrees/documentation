@page PipelineApi_Features_DerivedProperties Derived properties

# Introduction

The **derived property element** works out new properties from properties that other elements in the @Pipeline have already produced. It follows rules written in a short script, in YAML or JSON, with one script for each property it produces.

The element holds no @datafile, sends no request over the network and needs no Resource Key or License Key. It reads no @evidence from the request either. Everything it reads is a property another element has already written into the @flowdata, so it goes in the @Pipeline after those elements.

A script is for a property that follows simply from properties already in the @flowdata, such as putting a number into bands or combining two flags into one answer. Work that needs a network call, needs to keep something between requests, or needs the raw @evidence (headers, query string or cookies) belongs in an element of your own instead, as @ref PipelineApi_Features_CustomElements describes.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/pipeline-elements/derived-property-element.md#)
for more technical details, and the
[script format reference](https://github.com/51Degrees/derived-properties/blob/main/docs/format-1.md)
for everything a script can say.

# The properties it gives

Each script writes one property, named by the script, into the element data under the key `derived`. A script that produces `HumanConfidence` is read as `derived.HumanConfidence`, and the cloud's JSON gives it as `derived.humanconfidence`.

The packages carry the scripts in the [derived-properties](https://github.com/51Degrees/derived-properties/tree/main/scripts) repository, which you can add by name.

| Property | Values | Reads properties from | Script |
|----------|--------|-----------------------|--------|
| `HumanConfidence` | High, Medium, Low or Unknown | @DeviceDetection and @IpIntelligence | [HumanConfidence.yaml](https://github.com/51Degrees/derived-properties/blob/main/scripts/HumanConfidence.yaml) |
| `IsGdpr` | True or False | @IpIntelligence, being the country code | [IsGdpr.yaml](https://github.com/51Degrees/derived-properties/blob/main/scripts/IsGdpr.yaml) |

`HumanConfidence` is described on @ref HumanConfidence_Overview. `IsGdpr` is defined by its script as "Whether the General Data Protection Regulation, or the United Kingdom's version of it, is likely to apply to the person making the request, judged from the country of the supplied location", and its script says that it is a default for a caller that knows nothing about its own position, and not a determination.

A script below version 1.0.0 is a draft and may change. Both of these are below 1.0.0 today.

Each script names every property it reads, so the elements that supply them have to be in the @Pipeline, and the properties have to be in your @datafiles or your Resource Key. Where one is missing, the property has no value and says why, as the next section describes.

## Scripts of your own

You can write a script for a property of your own. The [authoring guide](https://github.com/51Degrees/derived-properties/blob/main/docs/authoring.md) works through one from a blank file, and the [script tester](https://51degrees.github.io/derived-properties/) runs a script in a browser against values you type, showing which rule matched.

# When a property has no value

Where every property a script reads is available, the script's rules run and it gives a value. Where any one of them is not available, the property has no value, and its message names every property that could not be read and what the element that supplies it said. The specification gives a message of this shape.

> Derived property 'HumanConfidence' has no value because 2 source properties were not available. 'device.BrowserReleaseYear' (element 'device' has no value for 'BrowserReleaseYear': ...). 'ip.HumanProbability' (...). Usual causes are the element that supplies the property not being in the pipeline, the property being excluded in the engine configuration, the property not being included in the resource key, or JavaScript that populates the property not having run yet.

There is no third state. A value that cannot be read as the type the script expects counts as not available, so a value such as `Unknown` or `N/A` never turns into false or zero.

# When the Pipeline is built

Building the element checks every script and reports every fault in one message, rather than stopping at the first one. Each fault names the script, where it came from, the place in the document and what is wrong.

Building the @Pipeline then fails, naming the property, when no element in the @Pipeline supplies a property a script reads, or when two derived property elements write a property of the same name. Where the elements sit is not checked, so the @aspectengines that supply the properties can run in a [parallel](@ref PipelineApi_Features_ParallelExecution) group ahead of the derived property element.

# Configuration

A script reaches the element in one of three ways, and one element can take all three.

1. **By name**, for a script the package carries.
2. **From a file** in your own environment, where a path can hold a wildcard such as `derived/*.yaml`.
3. **As text** held by your own code, in YAML or JSON. This one is available in code only.

In a configuration file, `Scripts` names the scripts the package carries and `ScriptFiles` gives the paths of your own. Write each as one string with commas between the entries, not as a JSON array.

```{json}
{
  "PipelineOptions": {
    "Elements": [
      {
        "BuilderName": "DerivedPropertyElement",
        "BuildParameters": {
          "Scripts": "HumanConfidence",
          "ScriptFiles": "derived/*.yaml"
        }
      }
    ]
  }
}
```

In PHP the builder name is the class's full name, written in JSON as `"BuilderName": "fiftyone\\pipeline\\derivedproperty\\DerivedPropertyElement"`, the way other PHP elements are named on @ref PipelineApi_Concepts_Configuration_Builders_BuildFromConfiguration.

# Using it

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{php,PHP}
@showsnippet{rust,Rust}
@defaultsnippet{Select a language.}
@startsnippet{dotnet}
Add the [FiftyOne.Pipeline.DerivedProperty](https://www.nuget.org/packages/FiftyOne.Pipeline.DerivedProperty) package from NuGet. The source is in [pipeline/DerivedProperty](https://github.com/51Degrees/51degrees-dotnet/tree/main/pipeline/DerivedProperty), and the [DerivedProperty example](https://github.com/51Degrees/51degrees-dotnet/tree/main/pipeline/Examples/DerivedProperty) runs with no data file, key or network, building the element both from a configuration file and in code, and showing a property with no value.

```{cs}
var derived = new DerivedPropertyElementBuilder(loggerFactory)
    // A script the package carries.
    .AddScript(BuiltInScript.HumanConfidence)
    // A file, or every file a wildcard matches.
    .AddScriptFile("derived/*.yaml")
    // The text of a script held by your own code, YAML or JSON.
    .AddScript("MyProperty", scriptText)
    .Build();

// Add the element after the engines that supply what its scripts read.
var pipeline = new PipelineBuilder(loggerFactory)
    .AddFlowElement(deviceDetectionEngine)
    .AddFlowElement(ipIntelligenceEngine)
    .AddFlowElement(derived)
    .Build();

using (var flowData = pipeline.CreateFlowData())
{
    flowData.AddEvidence("header.user-agent", userAgent)
        .AddEvidence("server.client-ip", clientIp)
        .Process();
    var confidence = flowData
        .Get<IDerivedPropertyData>()
        .GetAs<IAspectPropertyValue<string>>("HumanConfidence");
    Console.WriteLine(confidence.HasValue ?
        confidence.Value :
        confidence.NoValueMessage);
}
```
@endsnippet
@startsnippet{php}
The `51degrees/fiftyone.pipeline.derivedproperty` package is not on Packagist yet, so use it from a clone of the [51degrees-php](https://github.com/51Degrees/51degrees-php) repository through a Composer path repository. The source and its readme are in [pipeline/derivedproperty](https://github.com/51Degrees/51degrees-php/tree/main/pipeline/derivedproperty).

```{php}
use fiftyone\pipeline\core\PipelineBuilder;
use fiftyone\pipeline\derivedproperty\DerivedPropertyElementBuilder;

$derived = (new DerivedPropertyElementBuilder())
    // A script the package carries.
    ->addBuiltInScript('HumanConfidence')
    // A file, or every file a wildcard in the file name matches.
    ->addScriptFile('derived/*.yaml')
    // The text of a script held by your own code, YAML or JSON.
    ->addScript('MyProperty', $scriptText)
    ->build();

// Add the element after the engines that supply what its scripts read.
$pipeline = (new PipelineBuilder())
    ->add($cloudRequestEngine)
    ->add($deviceDetectionCloud)
    ->add($ipIntelligenceCloud)
    ->add($derived)
    ->build();

$flowData = $pipeline->createFlowData();
$flowData->evidence->setFromWebRequest();
$flowData->process();

$humanConfidence = $flowData->derived->humanconfidence;
echo $humanConfidence->hasValue ?
    $humanConfidence->value :
    $humanConfidence->noValueMessage;
```
@endsnippet
@startsnippet{rust}
Add the [fiftyone-derived-properties](https://crates.io/crates/fiftyone-derived-properties) crate from crates.io. The source and its readme are in [derived-properties](https://github.com/51Degrees/51degrees-rust/tree/main/derived-properties). The scripts are compiled into the crate, so the element runs where there is no file system, such as in WebAssembly.

```{rust}
use std::sync::Arc;

use fiftyone_derived_properties::{BuiltInScript, DerivedPropertyElement};
use fiftyone_pipeline_core::Pipeline;

let derived = DerivedPropertyElement::builder()
    // A script the crate carries.
    .add_built_in(BuiltInScript::HumanConfidence)
    // The text of a script held by your own code, YAML or JSON.
    .add_script("MyProperty", my_script_text)
    // A file, or every file a wildcard matches.
    .add_script_file("derived/*.yaml")
    .build()?;

// Add the element after the engines that supply what its scripts read.
let pipeline = Pipeline::builder()
    .add_element(device_detection)
    .add_element(ip_intelligence)
    .add_element(Arc::new(derived))
    .build()?;

let mut data = pipeline.create_flow_data_with(evidence);
data.process()?;

match data.get_str("derived").unwrap().get("HumanConfidence") {
    Ok(value) => println!("{value:?}"),
    // Names every property that could not be read, and why.
    Err(no_value) => println!("{}", no_value.message),
}
```
@endsnippet
@endsnippets

The [feature matrix](@ref ProductSummaries_FeatureMatrix) shows which languages have the element.

# The cloud

The 51Degrees cloud gives a derived property by running this same element in its own @Pipeline, so a cloud answer and an answer from your own servers come from the same script. Choose the property for your Resource Key like any other. Where a property a script reads was not available, the cloud gives the property as `null` with the reason alongside it, for example `humanconfidencenullreason`.

# Example

@startsnippets
@grabexample{pipeline-dotnet,_derived_property_2_program_8cs,.NET}
@grabbedexample
@endsnippets

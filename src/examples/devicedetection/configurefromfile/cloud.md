@page Examples_DeviceDetection_ConfigureFromFile_Cloud Cloud

# Introduction

This example shows how to get set up with a Device Detection Cloud @aspectengine configured from a file,
and begin using it to process User-Agents.

Firstly, the configuration file used for this example will set up a @pipeline with a cloud request
@aspectengine and a Device Detection Cloud @aspectengine.

@startsnippets
@showsnippet{XML}
@showsnippet{JSON}
@defaultsnippet{Select a tab to view the configuration file in XML or JSON format.}
@startsnippet{XML}
```{xml}
<PipelineOptions>
    <Elements>
        <Element>
            <BuildParameters>
                <ResourceKey>YourKey</ResourceKey>
            </BuildParameters>
            <BuilderName>CloudRequestEngine</BuilderName>
        </Element>
        <Element>
            <BuilderName>DeviceDetectionCloudEngine</BuilderName>
        </Element>
    </Elements>
</PipelineOptions>
```
@endsnippet
@startsnippet{JSON}
```{json}
{
  "PipelineOptions": {
    "Elements": [
      {
        "BuilderName": "CloudRequestEngine",
        "BuildParamters": {
          "ResourceKey": "YourKey"
        }
      },
      {
        "BuilderName": "DeviceDetectionCloudEngine"
      }
    ]
  }
}
```
@endsnippet
@endsnippets

@startsnippets
@grabexample{device-detection-dotnet,_cloud_2_configure_from_file_2_program_8cs,C#}
@grabexample{device-detection-java,cloud_2_configure_from_file_8java,Java}
@grabexample{device-detection-php,cloud_2configure_from_file_8php,PHP}
@grabexample{device-detection-node,cloud_2configure_from_file_8js,Node.js}
@grabbedexample
@endsnippets

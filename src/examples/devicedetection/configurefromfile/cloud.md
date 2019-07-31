@page Examples_DeviceDetection_ConfigureFromFile_Cloud Device Detection Configure From File Cloud Examples

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
<PipelineOptions>
    <Elements>
        <Element>
            <BuildParameters>
                <EndPoint>https://cloud.51degrees.com/api/v4/json</EndPoint>
            </BuildParameters>
            <BuilderName>CloudRequestEngine</BuilderName>
        </Element>
        <Element>
            <BuilderName>DeviceDetectionCloudEngine</BuilderName>
        </Element>
    </Elements>
</PipelineOptions>
@endsnippet
@startsnippet{JSON}
{
  "PipelineOptions": {
    "Elements": [
      {
        "BuilderName": "CloudRequestEngine,
        "BuildParamters": {
          "EndPoint": "https://cloud.51degrees.com/api/v4/json"
        }
      },
      {
        "BuilderName": "DeviceDetectionCloudEngine"
      }
    ]
  }
}
@endsnippet
@endsnippets

@startsnippets
@grabexample{pipeline-dotnet,_cloud_2_configure_from_file_2_program_8cs,C#}
@grabexample{device-detection-cxx,_cloud_2_configure_from_file_8c,C}
@grabexample{device-detection-cxx,_cloud_2_configure_from_file_8cpp,C++}
@grabexample{pipeline-java,_cloud_2_configure_from_file_8java,Java}
@grabexample{pipeline-dotnet,_cloud_2_configure_from_file_8php,PHP}
@grabexample{pipeline-dotnet,_cloud_2_configure_from_file_8js,Node.js}
@grabbedexample
@endsnippets

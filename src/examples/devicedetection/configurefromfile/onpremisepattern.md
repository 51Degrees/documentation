@page Examples_DeviceDetection_ConfigureFromFile_OnPremisePattern On-Premise Pattern

# Introduction

This example shows how to get set up with a Device Detection @aspectengine using the Pattern algorithm
configured from a file, and begin using it to process User-Agents.

Firstly, the configuration file used for this example will set up a @pipeline with a Pattern @aspectengine.

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
                <AutoUpdate>false</AutoUpdate>
                <CreateTempDataCopy>false</CreateTempDataCopy>
                <DataFile>51Degrees-LiteV3.2.dat</DataFile>
                <PerformanceProfile>LowMemory</PerformanceProfile>
            </BuildParameters>
            <BuilderName>DeviceDetectionPatternEngine</BuilderName>
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
        "BuilderName": "DeviceDetectionPatternEngine",
        "BuildParameters": {
          "DataFile": "51Degrees-LiteV3.2.dat",
          "CreateTempDataCopy": false,
          "AutoUpdate": false,
          "PerformanceProfile": "LowMemory"
        }
      }
    ]
  }
}
```
@endsnippet
@endsnippets

@startsnippets
@grabexample{device-detection-dotnet,_pattern_2_configure_from_file_2_program_8cs,C#}
@grabexample{device-detection-java,pattern_2_configure_from_file_8java,Java}
@grabexample{device-detection-php,_pattern_2_configure_from_file_8php,PHP}
@grabexample{device-detection-node,pattern_2configure_from_file_8js,Node.js}
@grabbedexample
@endsnippets

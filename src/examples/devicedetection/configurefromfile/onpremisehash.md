@page Examples_DeviceDetection_ConfigureFromFile_OnPremiseHash On-Premise Hash

# Introduction

This example shows how to get set up with a Device Detection @aspectengine using the Hash algorithm
configured from a file, and begin using it to process User-Agents.

Firstly, the configuration file used for this example will set up a @pipeline with a Hash @aspectengine.

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
                <DataFile>51Degrees-LiteV3.4.trie</DataFile>
                <PerformanceProfile>LowMemory</PerformanceProfile>
            </BuildParameters>
            <BuilderName>DeviceDetectionHashEngine</BuilderName>
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
        "BuilderName": "DeviceDetectionHashEngine",
        "BuildParameters": {
          "DataFile": "51Degrees-LiteV3.4.trie",
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
@grabexample{device-detection-dotnet,_hash_2_configure_from_file_2_program_8cs,C#}
@grabexample{device-detection-java,hash_2_configure_from_file_8java,Java}
@grabexample{device-detection-php,_hash_2_configure_from_file_8php,PHP}
@grabexample{device-detection-node,hash_2configure_from_file_8js,Node.js}
@grabbedexample
@endsnippets

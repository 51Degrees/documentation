@page DeviceDetection_Features_ConcurrentProcessing Concurrent Processing

# Introduction

When using a @PerformanceProfile that loads collections completely into memory, running parallel
processing using a single @Pipeline is not limited. However, when using a lower memory @PerformanceProfile
where collections are partially or fully read from file, consideration needs to be given to how
many parallel threads will be accessing the @Pipeline. 

# Detail

For @PerformanceProfiles such as `LowMemory` and `Balanced`, the concurrency is limited by the number
of file handles available in the file pool. In most implementations, the default value for this, is
the number of cores available on the machine. If more threads than this will be used, the expected
concurrency must be configured when creating the engine, so that
the file pool is created with the correct size to handle the expected number of concurrent accesses.

The snippet below shows how to set this when creating the engine:
@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{node,Node.js}
@showsnippet{php,PHP}
@showsnippet{python,Python}
@showsnippet{c,C}
@showsnippet{cpp,C++}
@defaultsnippet{Select a tab to view language specific information on setting the concurrency.}
@startsnippet{dotnet}
In code:
```{cs}
var pipeline =  new DeviceDetectionPipelineBuilder(loggerFactory)
    .UseOnPremise(dataFile, null, false)
    // Set performance profile
    .SetPerformanceProfile(PerformanceProfiles.LowMemory)
    // Set the expected concurrency
    .SetConcurrency(threadCount)
    .Build();
```
Or in config file:
```{json}
"PipelineOptions": {
    "Elements": [
        {
            "BuilderName": "DeviceDetectionHashEngineBuilder",
            "BuildParameters": {
                "DataFile": "51Degrees-LiteV4.1.hash",
                "PerformanceProfile": "LowMemory",
                "Concurrency": 30
            }
        }
    ...
    ]
}
```
@endsnippet
@startsnippet{java}
In code:
```{java}
DeviceDetectionOnPremisePipelineBuilder builder = new DeviceDetectionPipelineBuilder()
    .useOnPremise(dataFileLocation, false)
    // Set performance profile
    .setPerformanceProfile(PerformanceProfiles.LowMemory)
    // Set the expected concurrency
    .setConcurrency(threadCount)
    .build();
```
Or in config file:
```{xml}
<PipelineOptions>
    <Elements>
        <Element>
            <BuildParameters>
                <DataFile>51Degrees-LiteV4.1.hash</DataFile>
                <PerformanceProfile>LowMemory</PerformanceProfile>
                <Concurrency>30</Concurrency>
            </BuildParameters>
            <BuilderName>DeviceDetectionHashEngine</BuilderName>
        </Element>
        ...
    </Elements>
</PipelineOptions>
```
@endsnippet
@startsnippet{node}
In code:
```{js}
const pipeline = new DeviceDetectionOnPremisePipelineBuilder({
    dataFile: datafile,
    performanceProfile: 'LowMemory',
    concurrency: threadCount
}).build();
```
Or in config file:
```{json}
"PipelineOptions": {
    "Elements": [
        {
            "elementName": "deviceDetectionOnPremise",
            "elementParameters": {
                "performanceProfile": "LowMemmory",
                "dataFilePath": "51Degrees-LiteV4.1.hash",
                "concurrency": 30
            }
        }
        ...
    ]
}
```
@endsnippet
@startsnippet{php}
For PHP, the concurrency options is set in the php.ini file.
```
extension=/usr/lib/php/20170718/FiftyOneDegreesHashEngine.so
FiftyOneDegreesHashEngine.data_file=/path to your file/51Degrees-LiteV4.1.hash
FiftyOneDegreesHashEngine.performance_profile=LowMemory
FiftyOneDegreesHashEngine.concurrency=30
```
@endsnippet
@startsnippet{python}
In code:
```{py}
pipeline = DeviceDetectionOnPremisePipelineBuilder(
    data_file_path = data_file, 
    performance_profile = 'LowMemory', 
    concurrency = thread_count).build()
```
Or in config file:
```{json}
"PipelineOptions": {
    "Elements": [
        {
            "elementName": "DeviceDetectionOnPremise",
            "elementPath": "fiftyone_devicedetection_onpremise.devicedetection_onpremise",
            "elementParameters": {
                "data_file_path": "51Degrees-LiteV4.1.hash",
                "performance_profile": "LowMemory",
                "concurrency": 30
            }
        }
    ...
    ]
}
```
@endsnippet
@startsnippet{c}
```{c}
ConfigHash config = HashLowMemoryConfig;

config.strings.concurrency = threadCount;
config.properties.concurrency = threadCount;
config.values.concurrency = threadCount;
config.profiles.concurrency = threadCount;
config.nodes.concurrency = threadCount;
config.profileOffsets.concurrency = threadCount;
config.maps.concurrency = threadCount;
config.components.concurrency = threadCount;

StatusCode status = HashInitManagerFromFile(
    &manager,
    &dataSetConfig,
    &properties,
    dataFileLocation,
    exception);
```
@endsnippet
@startsnippet{cpp}
```{cpp}
ConfigHash* config = new ConfigHash();
config->setLowMemory();
config->setConcurrency(threadCount);

EngineHash *engine =
	new DeviceDetection::Hash::EngineHash(
	dataFilePath,
	config,
	properties);
```
@endsnippet
@endsnippets

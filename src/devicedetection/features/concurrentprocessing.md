@page DeviceDetection_Features_ConcurrentProcessing Concurrent processing

# Introduction

With a @PerformanceProfile that loads collections completely into memory, available hardware limits concurrent requests. When collections are read partly or entirely from a file, configure concurrency for the number of threads that will access the @Pipeline.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/advanced-features/parallel-processing.md#)
for more technical details.

# Configure concurrency

For @PerformanceProfiles such as `LowMemory` and `Balanced`, the concurrency is limited by the number
of file handles available in the file pool. In most implementations, the default value for this is
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
@showsnippet{rust,Rust}
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
For PHP, set the concurrency option in the php.ini file.
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

The resource manager can be shared by every thread. Each thread creates its
own results with `ResultsHashCreate`, because reading a value writes into the
results, so a set of results is used by one thread at a time.
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

The engine can be shared by every thread. Each call to `process` returns new
results for the thread that made it, because reading a value writes into the
results, so a set of results is used by one thread at a time.
@endsnippet
@startsnippet{rust}
In code:
```{rust}
use fiftyone_device_detection::{DeviceDetectionPipelineBuilder, PerformanceProfile};

let pipeline = DeviceDetectionPipelineBuilder::on_premise(data_file)
    // Set the performance profile
    .performance_profile(PerformanceProfile::LowMemory)
    // Set the expected concurrency (the number of threads that will share the
    // pipeline); this sizes the data set's file-handle pool.
    .concurrency(thread_count)
    .build()?;
```
@endsnippet
@endsnippets

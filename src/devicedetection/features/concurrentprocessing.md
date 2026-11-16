@page DeviceDetection_Features_ConcurrentProcessing Concurrent processing

# Introduction

An on-premise device detection engine can be shared by many threads. The Concurrency setting tells the engine how many of those threads will use it at the same time. Concurrency matters only when the @PerformanceProfile reads part of the data from the data file while the engine runs. When every collection is held in memory, available hardware limits concurrent requests and Concurrency has no effect.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/advanced-features/parallel-processing.md#)
for more technical details.

# What Concurrency controls

For each collection that is read from the data file, Concurrency sets two things.

1. **How many operations can read from the data file at the same time.** The engine keeps a pool of file handles, one for each concurrent operation. Set Concurrency to at least the number of threads that use the engine at once.
2. **How each cache is split into parts.** Each part of a cache has its own lock, so threads that need different parts do not block each other.

How these apply depends on the performance profile.

| Profile | Effect of Concurrency |
|---|---|
| `LowMemory` | Every collection is read from the data file without a cache, so only the number of file handles applies. |
| `Balanced` and `BalancedTemp` | Some collections are held in memory and the rest are read from the data file through caches, so both the file handles and the cache parts apply. |
| `HighPerformance` and `MaxPerformance` | Every collection is held in memory while the engine runs, so Concurrency has no effect. |

Choosing a performance profile replaces Concurrency with the profile's own value, so set the profile first and Concurrency after it.

# Limits in the current release

In the current release, each cache is split into as many parts as the value of Concurrency, and each part must hold at least that many entries. So a Concurrency above the square root of the capacity of a profile's smallest cache, rounded down, stops the engine from building. The error says the data file is not in the correct format (`CORRUPT_DATA`), although the file is fine.

The smallest cache in `Balanced` and `BalancedTemp` holds 500 values, so in the current release those profiles build only with a Concurrency of 22 or less. `LowMemory` has no caches, so it builds with any Concurrency.

# Default value

The table gives the default in the current release of each language.

| Language | Default Concurrency |
|---|---|
| C | 10, from `FIFTYONE_DEGREES_CACHE_CONCURRENCY`, in every profile except `MaxPerformance` (1 when compiled with `FIFTYONE_DEGREES_NO_THREADING`). |
| C++ | 10, because `ConfigHash` starts from the C profiles. |
| .NET | 10, because the native default is kept unless `SetConcurrency` is called. |
| Java | 10 with `DeviceDetectionPipelineBuilder`. `DeviceDetectionHashEngineBuilder` starts at the number of processors, and `setPerformanceProfile` puts Concurrency back to 10. |
| Node.js | The number of processors, from `os.cpus().length`. |
| Python | The number of processors, from `multiprocessing.cpu_count()`. |
| PHP | Not used, because the PHP extension always holds the data in memory. |
| Rust | 10. |

Where the default is the number of processors, a machine with more than 22 processors cannot build the `Balanced` profile in the current release unless Concurrency is set to 22 or less.

# Choose a value

1. Count the threads that will use the engine at the same time. For a web server, that number is the most requests the server processes at once.
2. With `LowMemory`, set Concurrency to that number.
3. With `Balanced`, set Concurrency to that number, up to the 22 that the current release accepts. For more threads than that, use `MaxPerformance`, which holds the data in memory and needs no file handles, or `LowMemory` where memory use matters more than speed.
4. With `HighPerformance` or `MaxPerformance`, leave Concurrency unset.

# Configure concurrency

The snippets below set the performance profile and then the concurrency when creating the engine.
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
In the current release, a configuration file applies `PerformanceProfile`
after `Concurrency`, and the profile puts Concurrency back to its own value
of 10. So set Concurrency in code whenever the configuration also names a
performance profile.
@endsnippet
@startsnippet{java}
In code:
```{java}
Pipeline pipeline = new DeviceDetectionPipelineBuilder()
    .useOnPremise(dataFileLocation, false)
    // Set performance profile
    .setPerformanceProfile(PerformanceProfiles.LowMemory)
    // Set the expected concurrency
    .setConcurrency(threadCount)
    .build();
```
In the current release, a configuration file applies `PerformanceProfile`
after `Concurrency`, and the profile puts Concurrency back to its own value
of 10. So set Concurrency in code whenever the configuration also names a
performance profile.
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
            "elementName": "fiftyone.devicedetection.onpremise/deviceDetectionOnPremise",
            "elementParameters": {
                "performanceProfile": "LowMemory",
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
The PHP extension always holds the whole data file in memory, using the
`MaxPerformance` profile, so Concurrency has no effect in PHP. Setting
`FiftyOneDegreesHashEngine.performance_profile` in the php.ini file to any
other profile raises an exception.
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
    &config,
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
    // Set the number of threads that will use the pipeline at once
    .concurrency(thread_count)
    .build()?;
```
@endsnippet
@endsnippets

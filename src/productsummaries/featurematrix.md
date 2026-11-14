@page ProductSummaries_FeatureMatrix Feature matrix

# Data services

| Language / Framework | <center>@DeviceDetection</center> | <center>@IpIntelligence</center>  | <center>@ReverseGeocoding</center> | <center>@Pipeline</center> |
|----------------------|------------------|------------------|-------------------|-----------|
| C/C++                | <center>On-premise only</center>  | <center>On-premise only</center>  |                   |           |
| .NET                 | <center>@tick</center>            | <center>@tick</center>            | <center>Cloud only</center>        | <center>@tick</center>     |
| Java                 | <center>@tick</center>            | <center>@tick</center>            | <center>Cloud only</center>        | <center>@tick</center>     |
| JavaScript           | <center>Cloud only</center>       |                  | <center>Cloud only</center>        |           |
| Node.js              | <center>@tick</center>            | <center>@tick</center>            | <center>Cloud only</center>        | <center>@tick</center>     |
| PHP                  | <center>@tick*</center>           | <center>@tick†</center>            | <center>Cloud only</center>        | <center>@tick</center>     |
| Python               | <center>@tick</center>            | <center>@tick</center>            | <center>Cloud only</center>        | <center>@tick</center>     |
| Go                   | <center>On-premise only</center>  | <center>@tick</center>            |                   | <center>@tick‡</center>    |
| Rust                 | <center>@tick</center>            | <center>@tick</center>            |                   | <center>@tick</center>     |

*On-premise is not on Packagist. Install it from a clone of [51degrees-php](https://github.com/51Degrees/51degrees-php).<BR>
†Not on Packagist yet, for the cloud or on-premise. Install it from a clone of [51degrees-php](https://github.com/51Degrees/51degrees-php).<BR>
‡The Go Device Detection and IP Intelligence on-premise engines do not run in the Pipeline yet. The Pipeline runs the IP Intelligence cloud engine and your own elements.<BR>

# Web integrations and plugins

| Language / Framework | Web frameworks / CMS plugins |
|----------------------|------------------------------|
| C/C++                | Nginx<BR>Varnish             |
| .NET                 | ASP.NET Core<BR>ASP.NET      |
| Java                 | Java Servlet<BR>Spring MVC   |
| JavaScript           | N/A                          |
| Node.js              | N/A                          |
| PHP                  | WordPress                    |
| Python               | Flask                        |
| Go                   | net/http                     |
| Rust                 | axum                         |

# Pipeline API features

| Feature | <center>.NET</center> | <center>Java</center> | <center>Node.js</center> | <center>PHP</center> | <center>Python</center> | <center>Go</center> | <center>Rust</center> |
|---------|------|------|---------|-----|--------|----|------|
| [Automatic data file updates](@ref PipelineApi_Features_AutomaticDatafileUpdates) | <center>@tick</center> | <center>@tick</center> | <center>@tick</center> |  | <center>@tick</center> | <center>@tick</center> | <center>@tick</center> |
| [File system watcher](@ref PipelineApi_Features_AutomaticDatafileUpdates) | <center>@tick</center> | <center>@tick</center> | <center>@tick</center> |  | <center>@tick</center> | <center>@tick</center> | <center>@tick</center> |
| [Client-side evidence](@ref PipelineApi_Features_ClientSideEvidence) | <center>@tick</center> | <center>@tick</center> | <center>@tick</center> | <center>@tick</center> | <center>@tick</center> | <center>@tick</center> | <center>@tick</center> |
| [Usage sharing](@ref PipelineApi_Features_UsageSharing) | <center>@tick</center> | <center>@tick</center> | <center>@tick</center> |  | <center>@tick</center> | <center>@tick</center> | <center>@tick</center> |
| [Asynchronous execution](@ref PipelineApi_Features_AsynchronousExecution) |  |  | <center>@tick</center> |  |  |  |  |
| [Lazy loading](@ref PipelineApi_Features_LazyLoading) | <center>@tick</center> | <center>@tick</center> |  |  |  | <center>@tick</center> |  |
| [Parallel execution](@ref PipelineApi_Features_ParallelExecution) | <center>@tick</center> | <center>@tick</center> | <center>@tick</center> |  |  | <center>@tick</center> | <center>@tick</center> |
| [Result caching](@ref PipelineApi_Features_ResultCaching) | <center>@tick†</center> | <center>@tick†</center> | <center>@tick†</center> | <center>@tick*</center> | <center>@tick†</center> | <center>@tick†</center> | <center>@tick†</center> |
| [Derived properties](@ref PipelineApi_Features_DerivedProperties) | <center>@tick</center> |  |  | <center>@tick</center> |  | <center>@tick</center> | <center>@tick</center> |
| [Agent signature](@ref PipelineApi_Features_AgentSignature) | <center>@tick</center> |  |  |  |  |  | <center>@tick</center> |

*Session cache only.<BR>
†For cloud engines and your own engines. The on-premise Device Detection and IP Intelligence engines take no results cache, because each result reads its values from memory the native code owns. See @ref PipelineApi_Features_ResultCaching.<BR>

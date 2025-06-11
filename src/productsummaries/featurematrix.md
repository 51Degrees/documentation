@page ProductSummaries_FeatureMatrix Feature Matrix

# Data services

| Language / Framework | @Pipeline | @DeviceDetection | @ReverseGeocoding |
|----------------------|-----------|------------------|-------------------|
| C/C++                |           | On-premise only  |                   |
| .NET                 | @tick     | @tick            | Cloud only        |
| Java                 | @tick     | @tick            | Cloud only        |
| JavaScript           |           | Cloud only       | Cloud only        |
| Node.js              | @tick     | @tick            | Cloud only        |
| PHP                  | @tick     | @tick*           | Cloud only        |
| Python               | @tick     | Cloud only       | Cloud only        |
| Go                   |           | On-premise only  |                   |

*On-premise not available through composer.<BR>

# Web integrations and plugins

| Language / Framework | Web frameworks / CMS plugins |
|----------------------|------------------------------|
| C/C++                | Nginx<BR>Varnish             |
| .NET                 | ASP.NET Core<BR>ASP.NET      | 
| Java                 | Java Servlet                 |
| JavaScript           | N/A                          |
| Node.js              | N/A                          |
| PHP                  | WordPress                    |
| Python               | Flask                        |
| Go                   | N/A                          |

# Pipeline API Features

| Language / Framework | [Automatic Data Updates](@ref Features_AutomaticDatafileUpdates) | [Client-side Evidence](@ref Features_ClientSideEvidence) | [Usage Sharing](@ref Features_UsageSharing) | [Asynchronous Execution](@ref Features_AsynchronousExecution) | [Lazy Loading](@ref Features_LazyLoading) | [Parallel Execution](@ref Features_ParallelExecution) | [Result Caching](@ref Features_ResultCaching) |
|----------------------|------------------------------------------------------------------|----------------------------------------------------------|---------------------------------------------|---------------------------------------------------------------|-------------------------------------------|-------------------------------------------------------|-----------------------------------------------|
| .NET                 | @tick                                                            | @tick                                                    | @tick                                       |                                                               | @tick                                     | @tick                                                 | @tick                                         |
| Java                 | @tick                                                            | @tick                                                    | @tick                                       |                                                               | @tick                                     | @tick                                                 | @tick                                         | 
| Node.js              | @tick                                                            | @tick                                                    | @tick                                       | @tick                                                         |                                           | @tick                                                 | @tick                                         |
| PHP                  |                                                                  | @tick                                                    |                                             |                                                               |                                           |                                                       | @tick*                                        |
| Python               | @tick                                                            | @tick                                                    | @tick                                       |                                                               |                                           |                                                       | @tick                                         |
| Go                   | @tick                                                            |                                                          |                                             |                                                               |                                           |                                                       |                                               |

*Session cache only.

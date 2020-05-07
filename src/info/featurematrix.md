@page Info_FeatureMatrix Feature Matrix

# Data services

|Language / Framework|@Pipeline|@DeviceDetection|@ReverseGeocoding|
|---|---|---|---|
|C/C++    |       |On-premise only   |       | 
|.NET     |@tick|@tick | Cloud only   | 
|Java     |@tick|@tick | Cloud only   | 
|PHP      |@tick|@tick** | Cloud only |
|Node.js  |@tick|@tick | Cloud only |
|JavaScript|      |Cloud only | Cloud only |
|Python*  |@tick|@tick| Cloud only |
|Go*      |@tick|@tick| Cloud only |

*Coming soon.
**On-premise not available through composer.

# Web integrations and plugins

|Language / Framework|Web frameworks / CMS plugins|
|---|---|
|C/C++    |Nginx*<BR>HAProxy*<BR>Varnish* |
|.NET     |ASP.NET Core<BR>ASP.NET | 
|Java     |Java Servlet<BR>Java Spring MVC Interceptor| 
|PHP      |WordPress*<BR>Drupal*|
|Node.js  | N/A |
|JavaScript| N/A |
|Python*  |Flask*|

*Coming soon

# Pipeline API Features

|Language / Framework|[Automatic Data Updates](@ref Features_AutomaticDatafileUpdates)|[Client-side Evidence](@ref Features_ClientSideEvidence)|[Asynchronous Execution](@ref Features_AsynchronousExecution)|[Lazy Loading](@ref Features_LazyLoading)|[Parallel Execution](@ref Features_ParallelExecution)|[Result Caching](@ref Features_ResultCaching)|
|---|---|---|---|---|---|---|
|.NET     |@tick|@tick|       |@tick  |@tick  |@tick|
|Java     |@tick|@tick|       |@tick  |@tick  |@tick| 
|PHP      |     |@tick|       |       |       |@tick*|
|Node.js  |@tick|@tick|@tick  |       |@tick  |@tick|

*Session cache only.
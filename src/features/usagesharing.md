@page Features_UsageSharing Usage Sharing Feature

# Introduction

Some of the services offered by 51Degrees benefit from @evidence (optionally) being sent back to
51Degrees data processing system from live installations of the @Pipeline. We use
this evidence to ensure that our data is up-to-date, comprehensive, and continues to
provide accurate results.

A specific set of evidence must be seen a number of times, from a number of sources to be
deemed reliable enough to contribute to the data file.

@dotfile usagesharing.gvdot

# How to enable usage sharing

**Usage sharing** is enabled by default if you are using a pipeline builder that is derived from a 51Degrees pipeline builder (for example, DeviceDetetctionPipelineBuilder or FiftyOnePipelineBuilder). To configure the **usage sharing** feature, please refer to our @ref Examples_UsageSharing.

To enable **usage sharing** for low-level APIs such as C, Nginx, and Varnish, please refer to the [Usage Sharing for low-level APIs section](@ref Low_Level_Usage_Sharing) further down this page. 

Please refer to the @ref Examples_UsageSharing section to check if **user sharing** is implemented for a particular language or API. To request an additional implementation of this feature, please [get in touch](https://51degrees.com/contact-us).

If you have any questions on how we use the data you share with us via usage sharing, please refer to our blog [Usage sharing: how do we use your data](https://51degrees.com/blog/usage-sharing-how-do-we-use-your-data).

@anchor Internals
[#](@ref Internals)	
# Internals

To minimize any overhead of this feature, received requests are grouped and sent in batches,
rather than sending each request individually.

**Usage sharing** is designed such that any failure within it should not impact the 
result of the @Pipeline. If a failure does occur then **usage sharing** will simply be disabled 
and an appropriate warning logged.

In languages that support multiple threading, **Usage sharing** will typically use a producer/consumer model,
where the 'main' thread adds the evidence to a queue while a background thread takes items from this queue,
transforms them into the appropriate format, adds them into a message, and sends the message when ready.
This is done to avoid blocking the @Pipeline process thread.

@anchor RepeatEvidence
[#](@ref RepeatEvidence)
## Repeated evidence 

To avoid situations where the same @evidence is sent multiple times (for example, a single user
visiting multiple pages on a website), we keep track of the @evidence that has been shared over
a defined time period (maximum 20 minutes by default) and only share @evidence which is different to any
already shared during the window.

Note that the amount of @evidence tracked is also constrained based upon available memory.
In high-traffic scenarios, this may mean that the time period covered by the @evidence in the tracker
is much smaller than the configured maximum.

# Configuration

The **usage sharing** feature is provided by a @flowelement that is added to the @Pipeline.
Certain @pipelinebuilders will do this automatically. For example, the @devicedetection @pipelinebuilder
will add the **usage sharing** element by default.
This can be disabled using the SetShareUsage method on the builder.

There are also several configuration options when building a **usage sharing** element. These can be used to 
control what is shared and how it is collected:

## Evidence shared

The **usage sharing** element will not be interested in all @evidence in the @flowdata. 
These are the rules for whether or not a particular piece of evidence is shared:

- Any evidence named 'header.&lt;name&gt;', if &lt;name&gt; is **not** on a configured blocklist.
- Any evidence named 'query.&lt;name&gt;', if &lt;name&gt; **is** on a configured allowlist.
- Any evidence named 'cookie.&lt;name&gt;' is ignored, unless &lt;name&gt; starts with '51D_'.
- Any other evidence is shared if it is not on a configured blocklist.

The various blocklists and allowlists can be configured using the **share usage** @elementbuilder.

### Evidence detail

Some of the values sent as evidence are more important for our backend processing than others.
This section describes some of the most important, along with why they are useful to us.
Any values marked with 'REQUIRED' must be included, or our backend systems will discard the data.

- server.client-ip - REQUIRED - The IP address of the client that is connecting to the 
  website/service. This is useful in order for us to evaluate the quality of the data. For an 
  over-simplified example, large numbers of requests coming from a single IP are more likely to 
  be bot or test traffic with spoofed details, which we do not want in our database.
- header.user-agent - REQUIRED - The value from the HTTP Header 'User-Agent'. This is the primary 
  means of device detection (before @uach began to supplant it)
- header.usage-from - This is not from a real HTTP header, but is added to usage data by customers 
  in order for us to more easily identify where data is coming from. This can assist with 
  troubleshooting problems.
- header.host - The value from the HTTP Header 'Host'. Identifies the website that the traffic 
  is coming from. Similar to usage-from above, this can assist with troubleshooting problems.
- header.sec-ch-ua* - The various [UA-CH](@ref DeviceDetection_Features_UACH_Overview) headers are becoming ever more important for device 
  detection. In order for us to be able to provide a good detection service, we require data from
  the real world to train our machine learning algorithm.

When using our @webintegration solutions, these values (with the exception of usage-from) will
be added as evidence automatically. If you are not using web integration, then you will need to 
ensure these values are added to evidence manually. The snippet below illustrates this:

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{node,Node.js}
@showsnippet{php,PHP}
@showsnippet{python,Python}
@defaultsnippet{Select a tab to view language specific information on configuring **logging**}
@startsnippet{dotnet}
```{cs}
data.AddEvidence(“header.user-agent”, [User-Agent HTTP header])
  .AddEvidence(“server.client-ip”, [source IP address of client connection])
  // The website root e.g. 51degrees.com
  .AddEvidence(“header.host”, [Host HTTP header])
  // Provide simple name to allow 51Degrees to identify source of usage data
  .AddEvidence(“header.usage-from”, [Business name])
  // Repeat for each user-agent client hints header (sec-ch-ua, sec-ch-ua-full-version-list, sec-ch-ua-platform, etc)
  .AddEvidence(“header.sec-ch-ua-mobile”, [Sec-CH-UA-Mobile HTTP header])
  .Process();
```
@endsnippet
@startsnippet{java}
```{java}
data.addEvidence(“header.user-agent”, [User-Agent HTTP header])
  .addEvidence(“server.client-ip”, [source IP address of client connection])
  // The website root e.g. 51degrees.com
  .addEvidence(“header.host”, [Host HTTP header])
  // Provide simple name to allow 51Degrees to identify source of usage data
  .addEvidence(“header.usage-from”, [Business name])
  // Repeat for each user-agent client hints header (sec-ch-ua, sec-ch-ua-full-version-list, sec-ch-ua-platform, etc)
  .addEvidence(“header.sec-ch-ua-mobile”, [Sec-CH-UA-Mobile HTTP header])
  .process();
```
@endsnippet
@startsnippet{node}
```{js}
data.evidence.add(“header.user-agent”, [User-Agent HTTP header]);
data.evidence.add(“server.client-ip”, [source IP address of client connection]);
// The website root e.g. 51degrees.com
data.evidence.add(“header.host”, [Host HTTP header]);
// Provide simple name to allow 51Degrees to identify source of usage data
data.evidence.add(“header.usage-from”, [Business name]);
// Repeat for each user-agent client hints header (sec-ch-ua, sec-ch-ua-full-version-list, sec-ch-ua-platform, etc)
data.evidence.add(“header.sec-ch-ua-mobile”, [Sec-CH-UA-Mobile HTTP header]);
data.process();
```
@endsnippet
@startsnippet{php}
```{php}
$data->evidence->set(“header.user-agent”, [User-Agent HTTP header]);
$data->evidence->set(“server.client-ip” => [source IP address of client connection]);
// The website root e.g. 51degrees.com
$data->evidence->set(“header.host” => [Host HTTP header]);
// Provide simple name to allow 51Degrees to identify source of usage data
$data->evidence->set(“header.usage-from” => [Business name]);
// Repeat for each user-agent client hints header (sec-ch-ua, sec-ch-ua-full-version-list, sec-ch-ua-platform, etc)
$data->evidence->set(“header.sec-ch-ua-mobile” => [Sec-CH-UA-Mobile HTTP header]);
$data->process();
```
@endsnippet
@startsnippet{python}
```{js}
data.evidence.add(“header.user-agent”, [User-Agent HTTP header])
data.evidence.add(“server.client-ip”, [source IP address of client connection])
# The website root e.g. 51degrees.com
data.evidence.add(“header.host”, [Host HTTP header])
# Provide simple name to allow 51Degrees to identify source of usage data
data.evidence.add(“header.usage-from”, [Business name])
# Repeat for each user-agent client hints header (sec-ch-ua, sec-ch-ua-full-version-list, sec-ch-ua-platform, etc)
data.evidence.add(“header.sec-ch-ua-mobile”, [Sec-CH-UA-Mobile HTTP header])
data.process()
```
@endsnippet
@endsnippets

## Share percentage

**Usage sharing** can be configured to only share a certain percentage of requests that 
pass through the @Pipeline.
This can be useful in very high-traffic scenarios where **usage sharing** is desired, but sharing every
request could put too much strain on the web server. 

This is based on a randomized value, so the exact amount shared may not be precisely the percentage specified. 
For example, if  generating a number between 0 and 1, the result will be above 0.5 roughly 50% of 
the time but it's unlikely to be exact.

## Timeouts

There may be one or multiple configurable timeouts depending on the language. Typically, these 
are used to suspend **usage sharing** if its internal mechanisms are responding too slowly.

## Maximum queue size

In languages that support multiple threads, this settings controls the size of the [internal](@ref Internals) 
producer/consumer queue.

## Minimum entries per message

The minimum number of @evidence entries that must be added before the message will be sent
to the **usage sharing** web service.

## Repeat evidence interval

The maximum time period which @evidence is stored for the purpose of filtering 
[repeat evidence](@ref RepeatEvidence).

## ShareUsageURL

The target destination for **usage sharing** data. The default is https://devices-v4.51degrees.com/new.ashx. 

@anchor Low_Level_Usage_Sharing
[#](@ref Low_Level_Usage_Sharing)	
# Usage Sharing for low-level APIs

The low-level device detection APIs such as C, Nginx, and Varnish do not support **usage sharing** 
out of the box. However, some customers using these technologies still want to share usage with 
us in order to help us improve the accuracy of results.

Our recommended approach in this situation is to have the low-level code write a log file containing
the necessary evidence values from requests. This file can then be processed offline at a later 
date using one of the higher-level languages in order to share the data with 51Degrees.

The [offline processing](@ref Examples_DeviceDetection_OfflineProcessing_OnPremiseHash) examples 
provide a good sample for how this might work. These take a YAML file where each record represents 
a request. For example:

```
---
header.User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 15_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.3 Mobile/15E148 Safari/604.1
---
header.Sec-CH-UA-Mobile: ?0
header.Sec-CH-UA-Platform: '"Windows"'
header.Sec-CH-UA: '" Not A;Brand";v="99", "Chromium";v="98", "Google Chrome";v="98"'
header.User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36
...
```

You will need to modify your low-level code to output this data to a file (or memory stream, etc.). 
As a minimum, the values below MUST be present for each record. If not, the record 
will be discarded by our backend processing system.

```
header.user-agent [The value of the User-Agent HTTP header]
header.host: [The value of the Host HTTP header]
server.client-ip: [The source public IP that is making the request to your server]
```

The output will then need to be consumed by a process using one of the higher-level APIs.
You can of course use whatever format you wish for transferring the data between your low-level 
code and the usage sharing process. If using the suggested YAML format and the offline processing 
example, the following changes will need to be made to the example:

1. Configure the input stream to take the output stream that is producing the YAML formatted data.
2. Device detection is not needed, only usage sharing, so replace the `DeviceDetectionPipelineBuilder` with `FiftyOnePipelineBuilder` and remove all the builder options that are no longer valid.
3. Configure the `setShareUsage` option to true.
4. Remove the code to get the device detection result and write an output file.

This code should now be able to consume the output from the low-level code and send the usage data 
back to 51Degrees for analysis.

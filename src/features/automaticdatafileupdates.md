@page Features_AutomaticDatafileUpdates Automatic Data File Updates

# Introduction

@Onpremiseengines added to a @pipeline can have their @datafiles registered for automatic
updates. When there is a new version of a @datafile available, it will be downloaded
and the @onpremiseengine refreshed with it. The file location where the @datafile was loaded
from can also be monitored for changes, so when a @datafile is manually replaced, the
@onpremiseengine will be refreshed with it.

This page describes the functionality and options for data updates in the pipeline API. 
In addition, it is worth being familiar with the [Distributor](@ref Info_Distributor) web API, 
which supplies the updated data files.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/features/data-updates.md#)
for more technical details.

# Registering for updates

All @datafiles added to an @onpremiseengine have the option to enable **automatic updates**.
By enabling this, the @datafile is automatically registered when the @onpremiseengine is added
to a @pipeline.

A @datafile can also be manually registered for **automatic updates** by registering with the
@dataupdateservice. This works in exactly the same way as if it was registered by the @pipelinebuilder,
but in most cases is not necessary as the @pipelinebuilder will do this.

# Configuration

There are a number of configuration options available when registering a @datafile for **automatic updates**, which specify
when and how the @datafile is updated.

## Data update URL

To download a new @datafile when one becomes available, the @dataupdateservice must have a URL to download
it from. This can be a constant URL, or a
[URL formatter](@ref Features_AutomaticDatafileUpdates_UrlFormatter) can be used to dynamically
generate the URL based on other options.

## License Keys

A License Key may be required when downloading certain types of data files. The
@dataupdateservice uses the License Key, in combination with a [URL formatter](@ref Features_AutomaticDatafileUpdates_UrlFormatter),
to ensure the @datafile is only made available to licensed users.

## File watcher

The location of the @datafile in the file system can be monitored by enabling the file system watcher. If
the @datafile changes, then the @dataupdateservice will be called to refresh the @onpremiseengine using that file.
This can be useful when distributing @datafiles to a local cluster.

## Polling interval

The polling interval tells the @dataupdateservice the frequency with which to check for the availability of
a new @datafile when the expected date is not known. If the @datafile itself provides the date when the next
update is expected, then the @dataupdateservice will not check for updates at all until after that date is passed.

## Randomization

In large clusters of servers, it is beneficial to stagger an update. If all servers download a new @datafile and
refresh at the same time, a service's overall performance can be affected. To prevent this, the randomization option
enables a random time interval to be added to the time at which the new @datafile is downloaded. For example, if there
are 10 servers, and a full download and refresh takes around 10 seconds, it is sensible to set the randomization to
above 10 seconds. In this case, there should only be one server updating at any one time.

## URL formatter @anchor Features_AutomaticDatafileUpdates_UrlFormatter

Where an @onpremiseengine needs to download a @datafile from a URL which is not constant, a URL formatter is used.
@Onpremiseengines generally provide the correct URL formatter automatically, but the option to override this is available.

URL formatters are necessary in many cases where multiple @datafiles are available for an @onpremiseengine. For example,
the required format or version of the @datafile may need to be specified as a parameter in the URL. This is handled by the
URL formatter by looking at the current @datafile to see what is needed.

## Temporary file

It is good practice to set a @datafile to be copied to a temporary location for use by an @onpremiseengine. This means that
whatever mode the file is being used in (e.g., in memory or streamed from file) an **update** can occur smoothly.

By setting the @onpremiseengine to use a temporary file location, the original @datafile is free to be changed by the
**autoupdateservice**. Once the file has been replaced, the @onpremiseengine will be informed and manage the removal of the
temporary file and creation of a new one.

## Decompression

@Datafiles are often served as GZipped content from their download URL to minimize the amount of data which needs to be
downloaded. When this is the case, the @dataupdateservice will unzip the @datafile before carrying on with the process.

Usually an @onpremiseengine will set this option, along with the URL/[URL formatter](@ref Features_AutomaticDatafileUpdates_UrlFormatter).
But if an alternative URL has been set, then this option may need to be overridden too.

## Verify MD5

A server will often provide the MD5 hash of the @datafile which it has served in the `Content-MD5` response header. This can then
be checked against that which was actually downloaded to ensure the integrity of the @datafile. By default this is usually enabled,
however not all download servers support it.

## Verify 'If-Modified-Since'

Unnecessary downloads can be prevented by providing the download server with an `If-Modified-Since` HTTP header. If this option
is enabled (which it is by default for most @onpremiseengines) the `If-Modified-Since` header will be set to the date at which the
current @datafile was last modified. If there is not a newer @datafile on the server then the service will not attempt to download a file.

@anchor Large_Clusters
[#](@ref Large_Clusters) 
# Recommendations for large clusters

The [Distributor](@ref Info_Distributor) API is limited in the number of requests it can 
service per day. This is enforced by each License Key being limited to a certain number of 
requests (max 100, although some Keys will have a lower threshold than this) in each 
30-minute period.

Environments that use large numbers of independent nodes can easily exceed this threshold 
if the automatic update functionality provided by the pipeline API is switched on.

Instead, we recommend that a single machine (with secondaries as necessary for redundancy, etc.) 
is tasked with downloading the data file each day using curl or similar.

There are then several approaches for deploying the new data file within your environment:

## Shared network location

The data file can be placed in a shared network location that is visible to many nodes. The
pipeline can then be created using this shared file as the data file location. 

If the ‘File System Watcher’ option (described in the sections above) is enabled in the API, 
it will watch the file for changes and refresh the API when it is updated. Where File System Watcher
is not supported by the language, the pipeline will need to be re-created using the new data file.

This approach is very simple to implement, but bear in mind that there is no staggering of
the update. When the nodes see the new file, they will all attempt to reload from it in a short 
space of time. This may cause too much infrastructure load.

This could be mitigated by using multiple shared locations that are updated in a staggered 
way from a single master copy of the data file. Alternatively, one of the approaches below 
gives you more control over when updates happen.

In addition, we would only recommend using this setup with the 'MaxPerformance' 
[performance option](@ref DeviceDetection_Features_PerformanceOptions) enabled.
Other options will stream data from the data file as needed, which will be relatively 
slow and bandwidth-heavy. 

## Push data file to nodes

You can use whatever tools are provided by your environment to push the new file out to the 
nodes in the cluster.

As above, the File System Watcher must be enabled in order for the API to notice the new data 
file and refresh its internal data structures.

## Self-hosted HTTP update

If the data file is hosted and made available on a static URL that is accessible within your 
environment, the nodes can be configured to check this location for updates, instead of the 
Distributor service.

An example of how to configure a device detection engine in this scenario is shown below. 
You can also configure it in code using the relevant engine builder.

```
{
  "BuilderName": "DeviceDetectionHashEngine",
  "BuildParameters": {
    "DataFile": "data/TAC-HashV41.hash",
    "TempDirPath": "data/tmp",
    "AutoUpdate": true,
    "DataUpdateOnStartup": true,
    "UpdatePollingInterval": 14400,
    "UpdateRandomisationMax": 600,
    "CreateTempDataCopy": true,
    "DataUpdateUrl": "https://myhost.net/51Ddatafile",
    "DataUpdateVerifyMd5": false,
    "DataUpdateUseUrlFormatter": false,
    "DataUpdateLicenseKey": "KEY"
  }
}
```

The key settings for our purposes are:
- **DataUpdateUrl** - The static URL to use when checking for a new data file.
- **DataUpdateVerifyMd5** - You can either configure your endpoint to also response with an MD5 HTTP 
  Header, or set this to false to prevent it trying to verify the content.
- **DataUpdateUseUrlFormatter** - This must be set to false to prevent the API from appending the 
  query string parameters that are required when calling the 51Degrees Distributor service. 

Be aware that the compute nodes will start checking the URL for updates as soon as the 
'next published date', which is stored in the data file, is reached.
This may be before a new data file is actually available from the static URL.

This means that you will probably need to configure your URL to accept and make use of 
the `If-Modified-Since` HTTP header to allow the API to check if it needs an update without 
downloading the entire data file.

See the [Distributor](@ref Info_Distributor) documentation for details of how this works.

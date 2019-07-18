@page Features_AutomaticDatafileUpdates Automatic Datafile Updates

# Introduction

@Onpremiseengines added to a @pipeline can have their @datafiles registered for automatic
updates. When there is a new version of a @datafile available, it will be downloaded,
and the @onpremiseengine refreshed with it. The file location where the @datafile was loaded
from can also be monitored for changes, so when a @datafile is manually replaced, the
@onpremiseengine will be refreshed with it.


# Registering for Updates

All @datafiles added to an @onpremiseengine have the option to enable **automatic updates**.
By enabling this, the @datafile is automatically registered when the @onpremiseengine is added
to a @pipeline.

A @datafile can also be manually registered for **automatic updates** by registering with the
@dataupdateservice. This works in exactly the same way as if it was registered by the @pipelinebuilder,
but in most cases is not necessary as the @pipelinebuilder will do the job.


# Configuration

There are options available when registering a @datafile for **automatic updates** which deal with
when and how the @datafile is updated.

### Data Update URL

To download a new @datafile when one is available, the @dataupdateservice must have a URL to download
the new @datafile from. This can be a constant URL, or a
[URL formatter](@ref Features_AutomaticDatafileUpdates_UrlFormatter) can be used to dynamically
generate the URL based on other options.

### License Keys

Premium @datafiles often require a license key to download as they are not freely available. The
@dataupdateservice will use this, in combination with a [URL formatter](@ref Features_AutomaticDatafileUpdates_UrlFormatter)
to download a @datafile which is only available to licensed users.

### File Watcher

The location of the @datafile in the file system can be monitored by enabling the file system watcher. If
the @datafile changes, then the @dataupdateservice will be called on to refresh the @onpremiseengine which
is using the @datafile. This can be useful when distributing @datafiles to a local cluster.

### Polling Interval

The polling interval tells the @dataupdateservice the frequency with which to check for the availability of
a new @datafile if the expected data is not known. If the @datafile itself provides the data which the next
update will be available, then this option is ignored.

### Randomization

In large clusters of servers, it is beneficial to stagger an update. If all servers download a new @datafile and
refresh at the same time, a service's overall performance can be affected. To prevent this, the randomization option
enables a random time interval to be added to the time at which the new @datafile is downloaded. For example, if there
are 10 servers, and a full download and refresh takes around 10 seconds, it is sensible to set the randomization to
above 10 seconds. In this case, there should only be one server updating at any one time.

### URL Formatter @anchor Features_AutomaticDatafileUpdates_UrlFormatter

Where an @onpremiseengine needs to download a @datafile from a URL which is not constant, a URL formatter is used.
@Onpremiseengines generally provide the correct URL formatter automatically, but the option to override this is available.

URL formatters are necessary in many cases where multiple @datafiles are available for an @onpremiseengine. For example,
the required format or version of the @datafile may need to be specified as a parameter in the URL. This is handled by the
URL formatter by looking at the current @datafile to see what is needed.

### Temporary File

It is good practice to set a @datafile to be copied to a temporary location for use by an @onpremiseengine. This means that
whatever mode the file is being used in (e.g. in memory or streamed from file) an **update** can occur smoothly.

By setting the @onpremiseengine to use a temporary file location, the original @datafile is free to be changed by the
@autoupdateservice. Once it has been replaced, the @onpremiseengine will be informed and will take care of removing the
temporary file and creating a new one.

### Decompression

@Datafiles are often served as GZipped content from their download URL to minimize the amount of data which needs to be
downloaded. When this is the case, the @dataupdateservice will unzip the @datafile before carrying on with the process.

Usually an @onpremiseengine will set this, along with the URL/[URL formatter](@ref Features_AutomaticDatafileUpdates_UrlFormatter).
But if an alternative URL has been set, then this option may need to be set also.

### Verify MD5

A server will often provide the MD5 hash of the @datafile which it has served in the 'Content-MD5' response header. This can then
be checked against what has actually been downloaded to ensure the integrity of the @datafile. By default this is usually enabled,
however not all download servers support this.

### Verify 'If-Modified-Since'

Unnecessary downloads can be prevented by providing the download server with an 'If-Modified-Since' HTTP header. If this option
is enabled (which it is by default for most @onpremiseengines) the 'If-Modified-Since' header will be set to the data at which the
current @datafile was last modified. So if the server doesn't have a @datafile newer than that yet, then the @datafile will not be
served.

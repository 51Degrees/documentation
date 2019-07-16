@page Concepts_FlowElements_OnPremiseEngine On-Premise Engine

# Introduction

**On-Premise engines** are a specialization of @aspectengine where additional data exists locally to
the **engine**, either in memory or a @datafile. This is in contrast to a @cloudengine where data
exists in a cloud service which is called by the **engine**. Having data which does not reside in the
**engine** itself means that the same **engine** can be used with multiple data sets.

An **on-premise engine** builds on the @aspectengine concept to introduce the ability to:
* load data either from memory or a @datafile
* keep @datafiles up to date


# Use Cases

An **on-premise engine** has no external dependencies, so is limited only by the hardware it is running on.
This makes it best suited to cases where performance it critical and the supporting hardware implementation
reflects this. To provide optimal performance, an **on-premise engine** can
be configured to run entirely in memory, so that there are no calls to disk.

There are also situations where the security demands of a service make sending sensitive data to an
external [cloud service](@term{CloudService}) problematic. Using an **on-premise engine** will address this issue.


# Data Files

An @aspectengine can make use of a @datafile to carry out its processing. This is typically the case when an **engine**
relies on data being updated, so the data is not stored statically in the **engine** itself.

## Updates

To facilitate keeping the data up to date, an **engine** may be registered with the @dataupdateservice, to provide 'automatic updates'. Enabling this feature
in an **engine** means that when it is added to a @pipeline, it will be registered for updates, and the @dataupdateservice
will handle the updating of the @datafile automatically.

An **engine**'s data can also be refreshed manually by giving the **engine** either a new @datafile or memory location and requesting
it use that. Refreshing the data in an **engine** happens without downtime, so any processing or other access to the **engine** will
be uninterrupted.

## Temporary Data Files

An **engine** can optionally create a temporary copy of the @datafile to use. This is good practice when making use of the
update functionality, as an **engine** can be configured so that it streams data from the @datafile. When a temporary @datafile
is used, the original @datafile is free to be updated without affecting the @datafile currently in use.

## Metadata

Each @datafile in an **engine** contains metadata, some of which is used by the @dataupdateservice. This metadata provides
the @dataupdateservice with the age of the @datafile, the time at which a new one will be available, and the URL of where the new @datafile can be obtained.


The location of the @datafile is also exposed, as is the location of the temporary copy - if one has been made. 

## Multiple Files

An **on-premise engine** can require more than one @datafile. Files can be individually registered with the @dataupdateservice, which will handle each file according to its own metadata. This allows different @datafiles to have distinct update requirements.

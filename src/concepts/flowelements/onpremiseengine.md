@page Concepts_FlowElements_OnPremiseEngine On Premise Engine

# Introduction

**On premise engines** are a specialization of @aspectengine where additional data exists locally to
the **engine**, either in memory or a @datafile. This is in contrast to a @cloudengine where data
exists in a cloud service which is called by the **engine**. Having data which does not reside in the
**engine** itself means that the same **engine** can be used with multiple data sets.

An **on premise engine** builds on the @aspectengine concept to introduce the ability to:
* load data either from memory or a @datafile
* keep @datafiles up to date


# Use Cases

An **on premise engine** has no external dependencies, so is limited only by the hardware it is running on.
This makes it best suited to cases where performance it critical, and the hardware the service is running on
reflects that. For cases where there performance is not compromised for anything, **on premise engines** can
be configured to run entirely in memory, so that there are no calls to disk.

There are also situations where security of a service is particularly tight, and sending sensitive data to an
external [cloud service](@term{CloudService}) is something to be avoided. This is where an **on premise engine**
is a must over a @cloudengine.


# Data Files

An **aspect engine** can make use of a @datafile to carry out its processing. This is typically the case when an **engine**
relies on data being updated, so the data is not stored statically in the **engine** itself.

## Updates

To facilitate keeping the data up to date, an **engine** may be registered with the @dataupdateservice. Enabling automatic
updates in an **engine** means that when it is added to a @pipeline, it will be registered for updates, and the @dataupdateservice
will handle the updating of the @datafile automatically.

An **engine**'s data can also be refreshed manually by giving the **engine** either a new @datafile or memory location and requesting
that it use that. Refreshing the data in an **engine** happens without downtime, so any processing or other access to the **engine** will
be uninterrupted.

## Temporary Data Files

An **engine** can optionally create a temporary copy of the @datafile to use. This is good practice when updates when making use of the
update functionality, as an **engine** may be configured in a way that means it is streaming data from the @datafile. When a temporary @datafile
is used, the original @datafile is freed up to be updated without affecting the @datafile currently in use.

## Metadata

Each @datafile in an **engine** contains metadata, some of which is used by the @dataupdateservice. This metadata provides
the @dataupdateservice with the age of the @datafile, the time at which a new one will be available, and a URL to get the new @datafile
from when it is available.

The location of the @datafile is also exposed, along with the location of the temporary copy if one has been made. 

## Multiple Files

An **on premise engine** can require more than one @datafile. This does not change how they are handled by the @dataupdateservice if
they are registered with it, and can be individually registered. So if only one of two @datafiles needs to be kept up to date, then
this is handled just as well as if both needed to be kept up to date.
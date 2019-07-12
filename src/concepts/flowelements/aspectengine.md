@page Concepts_FlowElements_AspectEngine Aspect Engine

# Introduction

An **aspect engine** builds on the @flowelement concept to introduce the ability to:
* load @datafiles and keep them up to date
* cache processing results
* handle cases where a property value does not exist in the @flowdata
* lazily load values in the @flowdata

In the same way a @flowelement can produce an @elementdata containing results of its processing, an 
**engine** can produce an @aspectdata. This builds on @elementdata to add some of the extra functionality
listed above.


# Data Files

An **aspect engine** can make use of a @datafile to carry out its processing. This is typically the case when an **engine**
relies on data being updated, so the data is not stored statically in the **engine** itself.

To facilitate keeping the data up to date, an **engine** may be registered with the @dataupdateservice. Enabling automatic
updates in an **engine** means that when it is added to a @pipeline, it will be registered for updates, and the @dataupdateservice
will handle the updating of the @datafile automatically.


# Caching

For performance reasons, it may be desirable to add results @caching to an **engine** which has a particularly large overhead for 
processing.

Logic in an **engine** makes use of a @flowcache provided to it to avoid doing any processing when a result has already been found
for a certain set of @evidence. The key for a @flowcache is based of the @evidence which is relevant to an **engine**. So an **engine**'s
cache is independent of @evidence which is irrelevant to its processing, resulting in a much higher hit to miss ratio in the cache.


# Missing Property Handling

An **engine** adds handling of cases where a value is requested for a @property which is not available for some reason.

Consider the case where an **engine** is set up with a free data file, and the user attempts to retrieve a value for a premium @property.
An error would be returned stating that the @property was only available in a the premium [data tier](@term{DataTier}).

Consider another case where an **engine** has been built with specific @properties included rather than the full set, and the user
attempts to retrieve a value for a @property which was not included. An error would be returned stating that the **engine** was not
configured correctly to return values for that @property.

Both these cases are distinct from the case where the **engine** simply does not know what the @property is, and cannot return values
for it. So it is important to distinguish between these scenarios.


# Lazy Loading

The @aspectdata produced by an **engine** can be returned before it has been completely populated. This means that the caller does not
need to wait for processing to finish before carrying on with other things, and the processing will continue in the background. This is
particularly useful in a [web server](@term{WebServer}) where processing can start the instant a [web request](@term{WebRequest}) is
received, and the [server](@term{WebServer}) can continue serving the page until it reaches a point where the result of the processing
is needed.

By default @lazyloading is not enabled, and can be enabled in an **engine**'s builder.
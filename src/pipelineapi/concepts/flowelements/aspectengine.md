@page PipelineApi_Concepts_FlowElements_AspectEngine Aspect Engine

# Introduction

An **aspect engine** builds on the @flowelement concept to introduce the ability to:
* cache processing results
* handle cases where a property has not been populated by an **aspect engine**, but it could be if certain configuration changes were made
* [lazily load] (@ref PipelineApi_Features_LazyLoading) values in the @flowdata

In the same way a @flowelement can produce an @elementdata containing results of its processing, an 
**engine** can produce an @aspectdata. This builds on @elementdata to add some of the extra functionality
listed above.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/conceptual-overview.md#aspect-engine)
for more technical details.

# Caching

For performance reasons, it may be desirable to add results @caching to an **engine** which has a particularly large overhead for 
processing.

Logic in an **engine** makes use of a cache passed at construction time to avoid doing any processing when a result has already been found
for a certain set of @evidence. The key for this cache is a @datakey generated using the @evidencekeyfilter from the **engine**.
This means that only @evidence relevant to the **engine** is used in the key for the cache, making the cache more space-efficient.


# Missing property handling

An **engine** adds handling of cases where a value is requested for a @property that is not available for some reason.

Consider the case where an **engine** is set up with free data, and the user attempts to retrieve a value for an enterprise @property.
An error would be returned stating that the @property was only available in an enterprise [data tier](@term{DataTier}).

Consider another case where an **engine** has been built with specific @properties included rather than the full set, and the user
attempts to retrieve a value for a @property which was not included. An error would be returned stating that the **engine** was not
configured correctly to return values for that @property.

Both these cases are distinct from that, where the **engine** simply does not know what the @property is, and cannot return values
for it. So, it is important to distinguish between these scenarios, and be clear to the user about what they need to do to get 
access to the property they want.


# Lazy loading

The @aspectdata produced by an **engine** can be returned before it has been completely populated. This means that the caller does not
need to wait for processing to finish before carrying on with other things, and the processing will continue in the background. This is
particularly useful in a [web server](@term{WebServer}) where processing can start the instant a [web request](@term{WebRequest}) is
received, and the [server](@term{WebServer}) can continue serving the page until it reaches a point where the result of the processing
is needed.

By default, @lazyloading is not enabled but can be via the **engine's** builder.

Please note that @lazyloading is only available in a subset of languages. This is because it either is not possible, or doesn't make sense
in some cases.
For example, PHP is single threaded so @lazyloading is not possible.
The Node.js @Pipeline is entirely @asynchronous so a @lazyloading capability is unnecessary.

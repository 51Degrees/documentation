@page Features_ResultCaching Result Caching

# Introduction

**Results caching** refers to a cache that exists at the level of an @aspectengine.
If **caching** is enabled then when a request arrives at the @aspectengine, it will first check
to see if it has recently processed a request with the same evidence. If it has then the 
result determined from the previous processing will be returned without any further work
being required.

**Results caching** results in improved performance in most scenarios where the processing
time of an @aspectengine is significant. However, profiling should always be undertaken to 
ensure that the configuration used is providing real benefit in the relevant environment.

Note that some @aspectengines (for example, the 51Degrees on-premise @devicedetection engines) 
may have internal caches for various reasons, these are separate to the @Pipeline 
**results cache** and may or may not be configurable depending on the implementation of the @aspectengine.

# Internals

The @evidence encapsulated within @flowdata will often contain many more values than are relevant 
to a particular @aspectengine. Consequently, we don't want to use the whole of the @evidence 
structure as a key to the **results cache**.

Instead, we make use of the @evidencekeyfilter on an @aspectengine to produce a
@datakey for the sub-set of the total @evidence that the @aspectengine will make use of.

This @datakey is then used to access the **cache** and check for an existing result.
If one is found then it will be added to the @flowdata as normal. 
If not then the @aspectengine performs the usual processing and then stores the result 
in the cache using the @datakey.

The size of the cache and it's implementation are configurable as described below.   

# Configuration

The **result cache** can be configured using the @elementbuilder associated with the @aspectengine.

Any cache that implements the 51Degrees cache interface can be used but by default, we provide
a fairly simple sharded LRU (least recently used) cache that has a low overhead, copes 
well with concurrent access and enables good performance in a wide range of scenarios.

This cache has a single 'size' parameter that determines how many result instances will be stored.
Increasing this value will generally improve performance at the cost of increased memory usage. 
Profiling should always be used to determine appropriate settings for your use-case.

# Examples

There are [examples](@ref Examples_Caching) on how to enable **result caching** for each language 
that supports it.
Additionally, there are [examples](@ref Examples_CustomCache) on implementing and using a custom 
caching implementation.

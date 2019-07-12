@page Concepts_FlowElements_AspectEngine Aspect Engine

# Introduction

An **aspect engine** builds on the @flowelement concept to introduce the ability to:
* load data files and keep them up to date **TODO link to data file if there is a section for it**
* cache processing results **TODO link to cache**
* handle cases where a property value does not exist in the @flowdata **TODO link to missing property service**
* lazily load values in the @flowdata **TODO: Link to lazy loading**

# Data Files

An **aspect engine** can make use of a data file to carry out its processing. This is typically the case when an **engine**
relies on data being updated, so the data is not stored statically in the **engine** itself.

To facilitate keeping the data up to date, an **engine** may be registered with the @dataupdateservice. Enabling automatic
updates in an **engine** means that when it is added to a @pipeline, it will be registered for updates, and the @dataupdateservice
will handle the updating of the data file automatically.


# Caching

For performance reasons, it may be desirable to add results caching to an **engine** which has a particularly large overhead for 
processing.

Logic in an **engine** makes use of a @flowcache provided to it to avoid doing any processing when a result has already been found
for a certain set of @evidence. The key for a @flowcache is based of the @evidence which is relevant to an **engine**. So an **engine**'s
cache is independent of @evidence which is irrelevant to its processing, resulting in a much higher hit to miss ratio in the cache.


# Missing Property Handling

An **engine** adds handling of cases where a value is requested for a @property which is not available for some reason

Consider the case where an **engine** is set up with a free data file, and the user attempts to retrieve a value for a premium @property.
An error would be returned stating that the @property was only available in a the premium @datatier.

Consider another case where an **engine** has been built with specific @properties included rather than the full set, and the user
attempts to retrieve a value for a @property which was not included. An error would be returned stating that the **engine** was not
configured correctly to return values for that @property.

Both these cases are distinct from the case where the **engine** simply does not know what the @property is, and cannot return values
for it. So it is important to distinguish between these scenarios.


# Lazy Loading


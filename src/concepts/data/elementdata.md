@page Concepts_Data_ElementData Element Data

# Introduction

**Element data** is the container for data that is returned as a result of the processing 
performed by a @flowelement.

# Data structure

The precise details of the storage structure used internally by **element data** will
vary by language and even by @flowelement implementation.
However, **element data** must always expose its contents as a collection of [key](@ref Concepts_Data_ElementDataKey)/value pairs.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific information on the internal data structure.}
@startsnippet{dotnet}
By default, the `Dictionary` class is used with a case-insensitive key comparer.
This can be overridden in the constructor to use any other `IDictionary` implementation 
or an alternative key comparer.
@endsnippet
@startsnippet{java}
By default, the `TreeMap` class is used with a case-insensitive key comparator. This can be
overridden in the constructor to use any other `Map<String,Object>` implementation or an alternative
key comparator.
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets

An **element data** also contains references to the @pipeline it is associated with.
This is useful for data that may just be a translation layer for other data, or if metadata
needs to be retrieved by the **element data**.

# Lifecycle

**Element data** instances are typically created by a specific factory method that is 
associated with a given @flowelement.
This can be used by the @flowelement to create new **element data** instances 
before they are added to @flowdata.

Although **element data** instances are stored within @flowdata, they must not be 
disposed of at the same time.
This is because the **element data** may be stored in other locations such as a @cache.
Equally, it must not be disposed of when it leaves a @cache as it may still be in use
externally to the @Pipeline.

As such, memory managed languages rely on the finalizer to dispose of any
associated resources cleanly.


# Thread-safety

The thread-safety of a given **element data** instance is directly tied to its internal 
data structure.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific information on thread safety.}
@startsnippet{dotnet}
By default, the `Dictionary` class is used. As such, accessing **element data's** stored values
will not be thread-safe.
However, this can be overridden to use another `IDictionary` implementation such as the `ConcurrentDictionary`. 
In this case, the accessing of the stored values will be thread-safe.
@endsnippet
@startsnippet{java}
By default, the `TreeMap` class is used. As such, accessing **element data's** stored values
will not be thread-safe.
However, this can be overridden to use another `Map<String,Object>` implementation such as the `ConcurrentHashMap`. 
In this case, the accessing of the stored values will be thread-safe.
@endsnippet
@startsnippet{php}
PHP runs in a single thread. Consequently, concurrency issues are not a concern.
@endsnippet
@startsnippet{node}
Node runs in a single thread with asynchronous execution, except where worker threads are used. It is strongly recommended to not share an element data object with a worker thread.
@endsnippet
@endsnippets

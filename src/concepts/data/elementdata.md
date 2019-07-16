@page Concepts_Data_ElementData Element Data

# Introduction

**Element data** is the container for data that is returned as a result of the processing 
performed by a @flowelement.

# Data Structure

The precise details of the storage structure used internally by **element data** will
vary by language and even by @flowelement implementation.
However, **element data** must always expose it's contents as a collection of key/value pairs.

=========

@showsnippet{datastructure,dotnet,C#}
@showsnippet{datastructure,java,Java}
@showsnippet{datastructure,php,PHP}
@showsnippet{datastructure,node,Node.js}

@startsnippets{datastructure}
@startsnippet{dotnet}
By default, the Dictionary class is used with a case-insensitive key comparer.
This can be overridden in the constructor to use any other IDictionary implementation 
or an alternative key comparer.
@endsnippet

@startsnippet{java}
**todo**
@endsnippet

@startsnippet{php}
**todo**
@endsnippet

@startsnippet{node}
**todo**
@endsnippet
@endsnippets

=========


# Life Cycle

**Element data** instances are typically created by a specific factory method that is 
associated with a given @flowelement.
This can be used by the @flowelement to create new **element data** instances 
before they are added to @flowdata.

Although **element data** instances are stored within @flowdata, they must not be 
disposed of at the same time.
This is because the **element data** may be stored in other locations such as a @cache.
Equally, it must not be disposed when it leaves a @cache as it may still be in use
externally to the @Pipeline.

As such, memory managed languages rely on the finalizer to dispose of any
associated resources cleanly.


# Thread Safety

The thread-safety of a given **element data** instance is directly tied to it's internal 
data structure.

=========

@showsnippet{concurrency,dotnet,C#}
@showsnippet{concurrency,java,Java}
@showsnippet{concurrency,php,PHP}
@showsnippet{concurrency,node,Node.js}

@startsnippets{concurrency}
@startsnippet{dotnet}
By default, the Dictionary class is used. As such, accessing **element data**'s stored values
will not be thread-safe.
However, this can be overridden to use another IDictionary implementation such as the ConcurrentDictionary. 
In this case, the accessing the stored values will be thread-safe.
@endsnippet

@startsnippet{java}
**todo**
@endsnippet

@startsnippet{php}
PHP runs in a single thread. Consequently, concurrency issues are not a concern.
@endsnippet

@startsnippet{node}
**todo**
@endsnippet
@endsnippets

=========

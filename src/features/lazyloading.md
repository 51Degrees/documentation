@page Features_LazyLoading Lazy Loading

# Introduction

**Lazy loading** is a concept whereby an object is not loaded until it is actually needed. This can mean that it
does not start loading until it is needed, or it is loaded in the background so other logic is not held
up until the object is requested. The latter is  usually preferable, as loading in the background often means 
that there is no waiting at all (i.e. by the time the object is needed, it has already been loaded).

In the context of a @pipeline, **lazy loading** refers to the way values are populated in an @aspectdata. Usually
the default is to not **lazily load** them, so the @pipeline's processing does not finish until all values
have been populated. When **lazy loading** is configured in an @aspectengine, values begin to load in another
thread, and the processing can continue.


# Configuration


# Implementation
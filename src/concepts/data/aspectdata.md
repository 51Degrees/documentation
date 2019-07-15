@page Concepts_Data_AspectData AspectData

# Introduction

**Aspect data** is the container for data that is returned as a result of the processing 
performed by an @aspectengine.
Just as an @aspectengine is a specialization of a @flowelement, **aspect data** is a 
specialization of @elementdata. 

**Aspect data** works with @aspectengine to provide the features associated with @engines.
For example, much of the @lazyloading functionality in .NET actually resides in the 
**aspect data** class.

For details on data structure, life cycle and thread safety, see @elementdata.
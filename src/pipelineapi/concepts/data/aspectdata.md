@page PipelineApi_Concepts_Data_AspectData Aspect Data

# Introduction

**Aspect data** is the container for data that is returned as a result of the processing 
performed by an @aspectengine.
Just as an @aspectengine is a specialization of a @flowelement, **aspect data** is a 
specialization of @elementdata. 

**Aspect data** works with @aspectengine to provide the features associated with engines.
For example, much of the @lazyloading functionality in .NET actually resides in the 
**aspect data** class. For more details see the @lazyloading feature page.

For details on data structure, lifecycle and thread-safety, see @elementdata.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/conceptual-overview.md#aspect-data)
for more technical details.

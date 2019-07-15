@page Concepts_MetaData_Profiles Profiles

# Introduction

A **profile** defines a unique set of @values for all @properties
(specifically [51Degrees properties](@ref Concepts_MetaData_Properties_FiftyOneAspectProperties))
of a single @component. A @fiftyoneengine will populate an @aspectdata with at least one **profile**
for each @component in the @datafile to enable the retrieval of all @properties.

A 51Degrees **profile** relates to @properties, @values and @components consistently across different @datafiles.

@dotfile 51d-data-structure.gvdot

There is no constraint on non 51Degrees @aspectengines to stop them exposing **profiles** in the same
form, however it may be that a different form better reflects the internal data structure of the @aspectengine.

# Metadata

The metadata contained in a **profile** is:

| Metadata | Description |
| -------- | ----------- |
| Id       | The unique id of the **profile**. This is usually a number and will remain unique across all @datafiles. |
| Name     | The name of the **profile** which gives a more 'human' identifier than id, usually describing what the @values it contains are. By convention this is unique within the @datafile. |
| Component| The @component which the **profile** relates to. This is the @component which the **profile** contains @values for. |
| Values   | The @values which define the **profile**. These are the reason for a **profile**, to return @values for @properties. |
| Signature count| The number of signatures which define how to find the **profile**. This is internal to the @fiftyoneengine and differs slightly in meaning between each. |

# Retrieval

**Profiles** can be retrieved from a @fiftyoneengine where the id is known. The id remains unique across
@datafiles (both different @datatiers and different release dates), so can be used as an efficient way to store
results with the intention of retrieving the @values at a later date.

All **profiles** can also be returned as a collection to be iterated.
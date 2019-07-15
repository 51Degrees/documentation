@page Concepts_MetaData_Components Components

# Introduction

A **component** defines a group of @properties
(specifically [51Degrees properties](@ref Concepts_MetaData_FiftyOneAspectProperties))
whose @values must be defined by a @profile for the **component**. Typically an @aspectdata
produced by a @fiftyoneengine contains a @profile for each **component** in its @datafile,
therefore enabling retrieval of @values for all @properties.

A 51Degrees **component** relates to @properties, @values and @profiles consistently across different @datafiles.

@dotfile 51d-data-structure.gvdot


There is no constraint on non 51Degrees @aspectengines to stop them exposing **components** in the same
form, however it may be that a different form better reflects the internal data structure of the @aspectengine.

# Metadata

The metadata contained in a **component** is:

| Metadata | Description |
| -------- | ----------- |
| Id       | The unique id of the **component**. This is usually a number and will remain unique across all @datafiles. |
| Name     | The name of the **component** which gives a more 'human' identifier than id. By convention this is unique within the @datafile. |
| Default profile| The default @profile for the **component** if it is not otherwise known. |
| Properties| The @properties which a @profile for the **component** must provide values for. |
@page Concepts_MetaData_Values Values

# Introduction

**Values** refer to the **values** which @properties (specifically
[51Degrees properties](@ref Concepts_MetaData_Properties_FiftyOneAspectProperties)) can take.
The metadata for **values** of a @property are exposed by @fiftyoneengines.

A 51Degrees **value** relates to @properties, @components and @profiles consistently across different @datafiles.
 
@dotfile 51d-data-structure.gvdot

There is no constraint on non 51Degrees @aspectengines to stop them exposing **values** in the same
form, however it may be that a different form better reflects the internal data structure of the @aspectengine.

# Metadata
The metadata contained in a **value** is:

| Metadata | Description |
| -------- | ----------- |
| Name     | The **value** as a string. This uniquely identifies the **value** only within the **values** relating to the same @property. |
| Property | The @property which the **value** relates to. This, in combination with the name, uniquely identifies the **value** within the @fiftyoneengine it belongs to. For example, there may be many **values** whose name is ``true``, but each be a **value** for a different @property. |
| Description| A description of the **value** explaining what it refers to, and what it means if a @profile has this **value**. |
| URL      | A URL where more information on the **value** can be found. |

# Retrieval

**Values** can be retrieved from a @fiftyoneengine using its unique id (the combination of its name and @property).
The id remains unique across @datafiles (both different [data tiers](@term{DataTier}) and different release dates).

All **values** can also be returned as a collection to be iterated.
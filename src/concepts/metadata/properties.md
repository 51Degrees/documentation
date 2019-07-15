@page Concepts_MetaData_Properties Properties

# Introduction

**Properties** refer to the individual **properties** whose values are populated in
an @elementdata by a @flowelement.

A **property**'s unique identifier is its name, but has other metadata describing it. The
concept of a **property** is built up in a hierarchy, where the base level has a small amount
of metadata, which is then added to in inheriting **property** types.


# Element Properties @anchor Concepts_MetaData_Properties_ElementProperties

An **element property** is the simplest description of a property which a @flowelement populates
the values of. The metadata contained in an **element property** is:

## Metadata
The metadata contained in an **element property** is:

| Metadata | Description |
| -------- | ----------- |
| Name     | The name of the property. This is uniquely identifies the **property** within a @flowelement. |
| Element  | The @flowelement which the **property** belongs to. While the **property**'s name is unique within the @flowelement, that does not prevent another @flowelement from containing a **property** with the same name. This, in combination with the name, uniquely identifies the **property** globally. |
| Category | The group of **properties** sharing a similar theme which a **property** belongs to. For example ``Browser Name`` and ``Browser Vendor`` would belong to the ``Browser`` category. |
| Type     | The type of value which the property has e.g. ``string`` or ``integer``. Note this is only relevant for strongly typed languages. |
| Available| Whether the **property** is available in a certain setup. This is not a constant, and depends on how the @flowelement in built (e.g. what @datafile is used). |

# Aspect Properties @anchor Concepts_MetaData_Properties_AspectProperties

As @aspectengines consume external data from either a @datafile or [cloud service](@term{CloudService}), extra metadata
included to indicate where the **property** is available.

## Metadata
The metadata contained in an **aspect property** is:

| Metadata | Description |
| -------- | ----------- |
| Date tier| Which product tiers the **property** is available in. For example, an @aspectengine could consume both a free, and premium @datafile, a certain **property** may not be available in both. |

# 51Degrees Aspect Properties @anchor Concepts_MetaData_Properties_FiftyOneAspectProperties

Most @fiftyoneengines make use of @datafiles with a similar data structure. This means **properties** will always have
certain meta data related to them. Some to do with how the **property** should be used, and others to do with how the **property**
is populated before releasing a @datafile.

A **51Degrees property** relates to @values, @components and @profiles consistently across different @datafiles.

@dotfile 51d-data-structure.gvdot

## Metadata
The metadata contained in an **51Degrees aspect property** is:

| Metadata | Description |
| -------- | ----------- |
| Description| A description of the **property** explaining what it refers to, and what significance its values have. |
| URL      | A URL where more information on the **property** can be found. |
| Component| The @component which the **property** belongs to. This is subtly different to the category, in that a @profile defines the values for all the **properties** of a single @component, which likely contains multiple categories of **properties**. |
| Values   | The @values which the **property** can have. As a simple example, a **property** named ``'supports a thing'`` might have three values: ``true``, ``false`` and ``unknown``.|
| Default value| The default @value for the **property** if it is not otherwise known. In the above example, the **property** named ``'supports a thing'`` would probably have ``unknown`` as the default value. |
| List     | Whether or not the **property** has values in the for of a list. For example, the connectivity types a device supports would be a list. |
| Obsolete | Whether the **property** is obsolete and only exists to maintain backwards compatibility. |
| Display order| The order in which to display the **property** when listing **properties**. |
| Mandatory| Whether the **property** is mandatory or not. If a **property** is mandatory, a @profile must have values for it to be classed as valid. |
| Show     | Whether the **property** should be displayed in situations such as a page listing **properties**. Less important **properties** may not be displayed. |
| Show values| Whether values of the **property** should be displayed in situations such as a page listing the **property**'s values. Showing all the values can make a very long list. |

# Retrieval

**Properties** can be retrieved from a @flowelement using its name. The name remains unique across
@datafiles (both different @datatiers and different release dates).

All **properties** can also be returned as a collection to be iterated.
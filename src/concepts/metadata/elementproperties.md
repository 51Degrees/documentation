@page Concepts_MetaData_ElementProperties Element Properties

# Introduction

**Element properties** refer to the individual **properties** whose values are populated in
an @elementdata by a @flowelement.

A **property**'s unique identifier is its name, but has other metadata describing it. The
concept of a **property** is built up in a hierarchy, starting at an **element property**,
which is then added to in inheriting **property** types.

An **element property** is the simplest description of a property which a @flowelement populates
the values of.


# Name

The name of the property uniquely identifies the **property** within a @flowelement. 

# Element

The @flowelement which the **property** belongs to is exposed by an **element property.
While the **property**'s name is unique within the @flowelement, that does not prevent another
@flowelement from containing a **property** with the same name. This, in combination with the
name, uniquely identifies the **property** globally.

# Category

The category an **element property** belongs to is a group of **properties** sharing a similar
theme which a **property** belongs to. For example ``Browser Name`` and ``Browser Vendor``
would belong to the ``Browser`` category.

# Type

The type of value which the **property** has e.g. ``string`` or ``integer`` is exposed by an
**element property**. Note this is only relevant for strongly typed languages.

# Availability

The availability of a **property** is exposed, and lets the user know whether the **property** is
available in a certain setup. This is not a constant, and depends on how the @flowelement in built
(e.g. what @datafile is used).


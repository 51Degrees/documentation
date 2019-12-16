@page Concepts_MetaData_ElementProperties Element Properties

# Introduction

**Element properties** refer to the individual **properties** whose values are populated in
an @elementdata by a @flowelement.

A **property**'s unique identifier is its name, but it also has other metadata which describe it. The
concept of a **property** is built up in a hierarchy, starting at an **element property**,
which is then added to in inheriting **property** types.

# Name

The name of the property uniquely identifies the **property** within a @flowelement. 

# Element

The @flowelement which the **property** belongs to.
Although the **property**'s name is unique within the @flowelement, this does not prevent another
@flowelement from containing a **property** with the same name. This, in combination with the
name, uniquely identifies the **property** globally.

# Category

The category groups **element properties** sharing a similar
theme. For example ``FrontCameraMegaPixels`` and ``Has3DCamera``
both belong to the ``Camera`` category.

# Type

The type of value which the **property** has e.g. ``string`` or ``integer``. 
Note, this is only relevant for strongly typed languages.

# Availability

Availability lets the user know whether the **property** is available in a certain configuration. 
This is not a constant, and depends on how the @flowelement is built
(e.g. what @datafile is used).


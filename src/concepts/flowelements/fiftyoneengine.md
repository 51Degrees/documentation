@page Concepts_FlowElements_FiftyOneOnPremiseEngine 51Degrees On-Premise Engine

# Introduction

A **51Degrees on-premise engine** adds functionality to an @onpremiseengine which is
specific to 51Degrees. @Metadata is exposed which relates to the data structure
common to most 51Degrees data files.

In many cases, a **51Degrees engine** contains a [native](@term{NativeCode}) binary which
the **engine** acts as a wrapper for. This gives the improved performance achievable with [native](@term{NativeCode}) code,
while still seamlessly slotting in with the target language (it is not always obvious that a 
[native](@term{NativeCode}) binary has been used). It also means that all languages the **engine** is
implemented in can more readily benefit from any optimizations or features which are added to the
[native](@term{NativeCode}) library.

# Metadata

The majority of **51Degrees engines** share a similar data structure. This means @metadata is exposed
in a common way for all **51Degrees engines** that share this structure.

@dotfile 51d-data-structure.gvdot

### Properties @anchor Concepts_FlowElements_FiftyOneOnPremiseEngine_Properties

The **properties** exposed by a **51Degrees engine** should not be seen differently from the @elementproperties
or @aspectproperties which are exposed by any other **engine**. They merely extend @aspectproperty to add @metadata
that is specific to the **properties** in 51Degrees' data structures.

The metadata contained in an **51Degrees aspect property** is everything in an @aspectproperty with the addition of:

| Metadata | Description |
| -------- | ----------- |
| Description| A description of the **property** explaining what it refers to, and what significance its values have. |
| URL      | A URL where more information on the **property** can be found. |
| Component| The **component** which the **property** belongs to. This is subtly different to the category, in that a **profile** defines the values for all the **properties** of a single **component**, which likely contains multiple categories of **properties**. |
| Values   | The **values** which the **property** can have. As a simple example, a **property** named ``'IsSmartPhone'`` might have three values: ``true``, ``false`` and ``unknown``.|
| Default value| The default **value** for the **property** if it is not otherwise known. In the above example, the **property** named ``'IsSmartPhone'`` would probably have ``unknown`` as the default value. |
| List     | Whether or not the **property** may have multiple values. For example, the connectivity types a device supports would be a list as a single device might support Bluetooth, HSDPA, LTE, WiFi, etc. |
| Obsolete | Whether the **property** is obsolete and only exists to maintain backwards compatibility. |
| Display order| The suggested order in which to display the **property** when listing **properties**. |
| Mandatory| Whether the **property** is mandatory or not. If a **property** is mandatory, a **profile** must have a non-default value for it to be classed as valid. |
| Show     | Whether the **property** should be displayed in situations such as a page listing **properties**. Less important **properties** may not be displayed. |
| Show values| Whether values of the **property** should be displayed in situations such as a page listing the **property**'s values. Showing all the values can make a very long list. |

### Values @anchor Concepts_FlowElements_FiftyOneOnPremiseEngine_Values

**Values** refer to all **values** which the associated **properties** can take in the current @datafile.
The metadata for **values** of a **property** are exposed by an **engine**.

Each **property** has a set of **values** which it can return. These **values** are exposed by a **51Degrees
engine** and give more information on what the implications of a **value** are.

The metadata contained in a **value** is:

| Metadata | Description |
| -------- | ----------- |
| Name     | The **value** as a string. This uniquely identifies the **value** only within the **values** relating to the same **property**. |
| Property | The **property** which the **value** relates to. This, in combination with the name, uniquely identifies the **value** within the **51Degrees engine** it belongs to. For example, there may be many **values** whose name is ``true``, but each is a **value** for a different **property**. |
| Description| A description of the **value** explaining what it refers to, and what it means if a **profile** has this **value**. |
| URL      | A URL where more information on the **value** can be found. |

### Components @anchor Concepts_FlowElements_FiftyOneOnPremiseEngine_Components

A **component** defines a group of **properties** that are related.

In a 51Degrees data set, a **property** only exists in a single **component**. For example, the ``Browser Name``
**property** is part of the ``Software`` **component**, whereas the ``Model Name`` **property** is part of
the ``Hardware`` **component**.

The metadata contained in a **component** is:

| Metadata | Description |
| -------- | ----------- |
| Id       | The unique id of the **component**. This is usually a number and will remain the same when a @datafile is updated. |
| Name     | The name of the **component** which gives a more 'human' identifier than id. By convention this is unique within the @datafile. |
| Default profile| The default **profile** for the **component**. This is used to provide **values** for the **component's** **properties** when a **profile** matching the @evidence cannot be found. |
| Properties| The **properties** associated with this **component**. |


### Profiles @anchor Concepts_FlowElements_FiftyOneOnPremiseEngine_Profiles

A **profile** defines a unique set of **values** for all **properties** of a single **component**. 

An **engine** will populate @aspectdata with at least one **profile** for each **component** 
in the @datafile. This means that all properties should be able to present a value, even if that value is 'Unknown'. 

Internally, this is how **values** are stored in @elementdata once @evidence has been processed. However,
these **profiles** are also exposed directly as @metadata so all possible results can be interrogated.
The metadata contained in a **profile** is:

| Metadata | Description |
| -------- | ----------- |
| Id       | The unique id of the **profile**. This is usually a number and will remain the same when a @datafile is updated. |
| Name     | The name of the **profile** which gives a more 'human' identifier than id, usually describing what the **values** it contains are. By convention this is unique within the @datafile. |
| Component| The **component** which the **profile** relates to. This is the **component** which the **profile** contains **values** for. |
| Values   | The **values** which define the **profile**. |
| Signature count| The number of signatures which define how to find the **profile**. This is internal to the **engine** and differs slightly in meaning between each. |


# Native Library

Most **51Degrees on-premise engines** act as a wrapper between the target language and a [native](@term{NativeCode}) library.

When the **engine** is packaged for release to a package manager for the target language, multiple
[native](@term{NativeCode}) binaries  are included. Each is compiled for a specific platform (e.g. 32 bit Windows, or 64 bit OS X)
and the correct binary is automatically selected at startup.
@page Concepts_FlowElements_FiftyOneOnPremiseEngine 51Degrees On-Premise Engine

# Introduction

A @51degrees **on-premise engine** add functionality to an @onpremiseengine which is
specific to @51degrees. @Metadata is exposed which relates to the data structure
common to most @51degrees data files.

In many cases, a @51degrees **engine** contains a [native](@term{NativeCode}) binary which
the **engine** acts as a wrapper for. This gives the added performance of [native code](@term{NativeCode})
while still slotting in seamlessly with the target language (it is often not be obvious that a 
[native](@term{NativeCode}) binary was being used). This also means that all languages the **engine** is
implemented in quickly benefit from any optimizations or features which are added to the
[native](@term{NativeCode}) library.

# Meta Data

The majority of @51degrees **engines** share a similar data structure. This means @metadata is exposed
is a common way for all @51degrees **engines**.

@dotfile 51d-data-structure.dot

## Properties

The @properties exposed by a @51degrees **engine** should not be seen differently from the @properties
which are exposed by any other **engine**. They merely extend the @property to add some @metadata specific
to the @properties in @51degrees data structures.


## Values

Each @property has a set of @values which it can return. These @vales are exposed by a @51degrees **engine**
and give more information on what the implications of a @value are.


## Components

In a @51degrees data set, a @property exists in a single @component. For example, the **Browser Name** @property
is part of the **Software** @component, whereas the **Model Name** @property is part of the **Hardware** @component.


## Profiles

A @profile contains a unique set of @values relating to all the @properties in a single @component. Internally, this
is how @values are stored in a @flowdata once @evidence has been processed. However, these @profiles are also exposed
directly as @metadata so all possible results can be interrogated.


# Native Library

Most @51degrees **on-premise engines** act as a wrapper between the target language and a [native library](@term{NativeCode}).
When the **engine** is packaged for release to a package manager for the target language, multiple
[native binaries](@term{NativeCode}) are included. Each is compiled for a specific platform (e.g. 32 bit Windows, or 64 bit OS X)
and the correct binary is automatically selected at startup.
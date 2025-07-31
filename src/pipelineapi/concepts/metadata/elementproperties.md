@page PipelineApi_Concepts_MetaData_ElementProperties Element Properties

# Introduction

**Element properties** refer to the individual **properties** whose values are populated in
an @elementdata by a @flowelement.

A **property's** unique identifier is its name, but it also has other metadata which describe it. The
concept of a **property** is built up in a hierarchy, starting at an **element property**,
which is then added to by inheriting **property** types.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/features/properties.md#property-metadata)
for more technical details.

# Name

The name of the property uniquely identifies the **property** within a @flowelement. 

# Element

The @flowelement which the **property** belongs to.
Although the **property's** name is unique within the @flowelement, this does not prevent another
@flowelement from containing a **property** with the same name. This, in combination with the
name, uniquely identifies the **property** globally.

# Category

The category groups **element properties** sharing a similar
theme. For example ``FrontCameraMegaPixels`` and ``Has3DCamera``
both belong to the ``Camera`` category.

# Type

The type of value which the **property** has e.g. ``string`` or ``integer``. 
Note, this is only relevant for strongly typed languages.

# Available

Available lets the user know whether the **property** is available in a certain configuration. 
This is not a constant, and depends on how the @flowelement is built
(e.g. what @datafile is used).

# Item properties

This is only relevant where Type is a collection of complex objects. It contains a list of the 
**property** metadata for the items in the value for this **property**. For example, if this metadata 
instance represents a list of hardware devices, ItemProperties will contain a list of the metadata for **properties** available on each hardware device element within that list.

# Delay execution

This is only relevant if the type of value is ``JavaScript`` and defaults to false.
If set to true then the JavaScript in this **property** will not be executed automatically on the 
client device.
This is used where executing the JavaScript would result in undesirable behavior. 
For example, attempting to access the location of the device will cause the browser to show a 
pop-up confirming if the user is happy to allow the website access to their location.
In general, we don't want this to happen immediately when a user enters a website, but when 
they try to use a feature that requires location data (e.g. show restaurants near me).

# Evidence properties

Get the names of any JavaScript **properties** that, when executed, will obtain additional 
@evidence that can help in determining the value of this **property**.
For example, the ``ScreenPixelsWidthJavascript`` **property** will get the pixel width of the client-device's screen.
This is used to update the ``ScreenPixelsWidth`` **property**. As such, ``ScreenPixelsWidth`` will have 
``ScreenPixelWidthJavascript`` in its list of @evidence **properties**.

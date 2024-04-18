@page Features_FlexibleAccessors Flexible Accessors

# Introduction

The @Pipeline API has been designed to be easy to use, adding IDE auto-complete support where possible. 
However, one of our key design goals was to allow new properties to be added without the API software 
needing to be updated. These goals are often in conflict and lead to the creation of several possible 
mechanisms to retrieve property values.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/features/access-to-results.md#)
for more technical details.

# Detail

The precise nature of the available accessors depend on the language being used but we have aimed 
to support the following use cases:

1. Accessing properties without any 'magic strings' and with IDE auto-complete support.
2. Accessing a property that has been returned by the data source but that did not exist when the 
current version of the @flowelement was built.
3. Accessing a property without first accessing the associated @aspectdata.  

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{node,Node.js}
@showsnippet{php,PHP}
@showsnippet{python,Python}
@defaultsnippet{Select a tab to view language specific information on the internal data structure.}
@startsnippet{dotnet}
In .NET, IDE auto-complete support is dependent on having a specific interface/type with defined properties.
This is supported by allowing the @aspectdata type and associated interface to be extended for each engine.
@Flowdata can then return this specific type/interface.
For example, the 51Degrees device detection engines use the IDeviceData interface to define all 
the properties that are available.
After @flowdata has been processed, you can request the IDeviceData from it:

```{cs}
var deviceData = flowdata.Get<IDeviceData>();
```

If you have an instance of the element that you want to get data for, this can also be used to 
get the data populated by that instance:

```{cs}
var deviceData = flowdata.getFromElement(deviceDetectionEngine);
```

After you have the specific element data instance, the individual properties can be accessed as 
normal using strongly typed property accessors. For example, accessing the `IsMobile` property looks like this:

```{cs}
flowdata.Get<IDeviceData>().IsMobile;
```

Where a new property is present in the data source that did not exist when the code was compiled, 
a string-based accessor can be used instead. As long as you know the string name of the property you 
can access it, even if it does not exist in the interface. The downside is that this is not strongly-typed 
so you will need to deal with casting. For example, accessing the `IsMobile` property in this way 
can be done like this:

```{cs}
flowdata.Get<IDeviceData>()["IsMobile"];
```

The `GetAs` variation can be used if you know the type of the property:

```{cs}
flowdata.Get<IDeviceData>().GetAs<AspectPropertyValue<bool>>("IsMobile");
```

In addition, a shortcut can be used to access the property without specifying the associated flow 
element/engine at all. However, this has the downside that you will need to know the type of the property 
you are accessing. For example, the `IsMobile` property can be accessed like this:

```{cs}
flowdata.GetAs<AspectPropertyValue<bool>>("IsMobile");
```
@endsnippet
@startsnippet{java}
In Java, IDE auto-complete support is dependent on having a specific interface/type with defined properties.
This is supported by allowing the @aspectdata interface to be extended for each engine.
@Flowdata can then return this specific interface.
For example, the 51Degrees device detection engines use the DeviceData interface to define all the 
properties that are available.
After @flowdata has been processed, you can request the DeviceData from it:

```{java}
DeviceData deviceData = flowdata.get(DeviceData.class);
```

If you have an instance of the element that you want to get data for, this can also be used to get 
the data populated by that instance:

```{java}
DeviceData deviceData = flowdata.getFromElement(deviceDetectionEngine);
```

After you have the specific element data instance, the individual properties can be accessed as normal 
using strongly typed property getters. For example, accessing the `IsMobile` property looks like this:

```{java}
flowdata.get(DeviceData.class).getIsMobile();
```

Where a new property is present in the data source that did not exist when the code was compiled, 
a string-based accessor can be used instead. As long as you know the string name of the property you can access it, 
even if it does not exist in the interface. The downside is that this is not strongly-typed so you will need to 
deal with casting. For example, accessing the `IsMobile` property in this way can be done like this:

```{java}
flowdata.get(DeviceData.class).get("IsMobile");
```

In addition, a shortcut can be used to access the property without specifying the associated flow element/engine at all. 
However, this has the downside that you will need to know the type of the property you are accessing. 
For example, the `IsMobile` property can be accessed like this:

```{java}
flowdata.getAs("IsMobile", AspectPropertyValue.class, Boolean.class);
```
@endsnippet
@startsnippet{node}
In Node, auto-complete support is not feasible so you need to know the name of the element and property that 
you're accessing.
For example, if you are using the 51Degrees device detection engine then after the @flowdata has been processed, 
you can request the device data from it:

```{js}
let deviceData = flowdata.device;
```

If you have an instance of the element that you want to get data for, this can also be used to get the data
populated by that instance without having to know the associated name:

```{js}
let deviceData = flowdata.getFromElement(deviceDetectionEngine);
```

After you have the specific element data instance, the individual properties can be accessed using normal 
property accessors. 
Node's weakly typed nature means that the scenario where a new property is available in the data source is 
not a problem. 
Wherever it's come from, you just need to know the name of the property you want to retrieve. For example, 
accessing the `IsMobile` property looks like this:

```{js}
flowdata.device.ismobile;
```
@endsnippet
@startsnippet{php}
In PHP, auto-complete support is not feasible so you need to know the name of the element and property that you're accessing.
For example, if you are using the 51Degrees device detection engine then after the @flowdata has been processed, 
you can request the device data from it:

```{php}
$deviceData = flowdata->device;
```

If you have an instance of the element that you want to get data for, this can also be used to get the 
data populated by that instance without having to know the associated name:

```{php}
$deviceData = $flowdata->getFromElement(deviceDetectionEngine);
```

After you have the specific element data instance, the individual properties can be accessed using normal property accessors. 
PHP's weakly typed nature means that the scenario where a new property is available in the data source is not a problem. 
Wherever it's come from, you just need to know the name of the property you want to retrieve. For example, 
accessing the `IsMobile` property looks like this:

```{php}
$flowdata->device->ismobile;
```
@endsnippet
@startsnippet{python}
In python, auto-complete support is not feasible so you need to know the name of the element and property that you're accessing.
For example, if you are using the 51Degrees device detection engine then after the @flowdata has been processed, 
you can request the device data from it:

```{python}
deviceData = flowdata.device;
```

If you have an instance of the element that you want to get data for, this can also be used to get the 
data populated by that instance without having to know the associated name:

```{python}
deviceData = flowdata.get_from_element(deviceDetectionEngine);
```

After you have the specific element data instance, the individual properties can be accessed using normal property accessors. 
Python's weakly typed nature means that the scenario where a new property is available in the data source is not a problem. 
Wherever it's come from, you just need to know the name of the property you want to retrieve. For example, 
accessing the `IsMobile` property looks like this:

```{python}
flowdata.device.ismobile;
```
@endsnippet
@endsnippets
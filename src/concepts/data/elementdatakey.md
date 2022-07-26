@page Concepts_Data_ElementDataKey Element Data Key

# Introduction

**Element data key** is the key that is used to store and retrieve @elementdata
within the @flowdata.
Each @flowelement has a hard-coded key value.

# Structure

**Element data key** will always have a string name that is used as the key 
when storing the @elementdata within @flowdata.

In addition, in strongly-typed languages such as Java and C#, **element data key** 
will also contain the specific type of the @elementdata that it corresponds to.
This allows the @flowdata to return the @elementdata instance as the correct type.

# Name conflicts

The @Pipeline does not require that each @flowelement has a unique 
**element data key**. In fact, it is sometimes desirable for this to be the case.
However, care must be taken to ensure that conflicting key names do not cause
unexpected behavior or errors.

The @Pipeline does not define what happens in the case of **element data key** 
conflicts. The handling of such conflicts is left up to individual @flowelements.
The @flowelement base functionality also does not specify what should happen. 
This is because @flowelements are not even required to create an @elementdata
instance at all.

The @aspectengine base class does explicitly allow conflicting key names, although
it is still up to specific implementations to operate responsibly.

## Name conflict example

Consider a @Pipeline with two @devicedetection engines. One determines values relating 
to the device hardware. (i.e. manufacturer, screen information, CPU/GPU specs, etc.)
The other determines values relating to the software platform or operating system running 
on the device. (i.e. software vendor, name, version, etc.)

Each of these engines uses the same **element data key** as shown below:

@dotfile elementdatakey-conflict-example.gvdot

At step 1, the @flowdata enters the @Pipeline with no @elementdata.
At step 2, the Hardware @devicedetection engine has created the @elementdata and added 
it to @flowdata using the key 'device'. It will be populated with details of the 
device hardware but other values relating to the software platform will not have been
set.
The Platform/OS @devicedetection engine will see that an @elementdata instance already
exists in the @flowdata for its **element data key**. Rather than creating a new
one, it will take that instance and update it with values relating to the OS running 
on the device.

Note that, as long as the @flowdata has been 
[set up correctly](@ref Concepts_Data_FlowData_ThreadSafety) for it, this example 
will continue to work if the two engines are configured to run in @parallel.






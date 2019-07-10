@page Concepts_Terminology


## Terminology



#### Web request

A web request is a message sent from a client device to a server where a web site is hosted.
This message will usually be a simple request for a particular web page or other resource. 
However, it contains a lot of additional information (evidence) that can be used to infer 
details about different contexts within which the request takes place (aspects). 

#### Aspect

An aspect of a web request is a specific entity that is involved in that request. 
Some examples of aspects are:

* The device hardware being used to make the request.
* The operating system running on that device.
* The physical location of the device.
* The ISP that is being used to service the request.
* The cell tower that services the request (If the device is a mobile using its network 
data access)
* etc

Each aspect can have one or more associated properties. For example, the device hardware
aspect has properties such as:

* Type of device (smart phone, computer, smart TV, games console, etc)
* Screen size in pixels
* Screen size in inches
* etc

#### Evidence

Evidence refers to all the information associated with a given web request. The evidence 
values are used by [aspect engines](@ref Concepts_FlowElements_AspectEngine) to determine 
the details of the aspects they are concerned with.

Evidence will usually be drawn from one of 4 places:

* HTTP headers
* Cookies
* Query parameters
* Request meta-data such as source IP address

Generally, any device making a request will be sending some of this data. However, in
some cases, additional evidence can be obtained from code running directly on the client
device. As an example, this technique is used to retrieve the latitude and longitude 
from devices that have this capability.
Typically, this evidence will be sent back to the server as a cookie in the next request.

This use of client-side code requires additional JavaScript to be sent to the client
device. The Pipeline [web integration](@ref Concepts_Web_Index) is designed to handle 
this seamlessly for a variety of languages and web frameworks.
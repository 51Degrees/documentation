@page Features_ClientSideEvidence Client-side Evidence

# Introduction

@Evidence will usually be drawn from one of 4 places:

* HTTP headers
* Cookies
* Query parameters
* Request metadata such as source IP address

Any device making a request to a web site will include some of this information.
For example, the User-Agent HTTP header is almost always populated as part of a
request.
In some cases though, additional @evidence providing more detail can be obtained
from code running directly on the client device. In some cases, this may even be 
required.
For example, this technique can be used to retrieve the latitude and longitude 
from devices that have this capability.

# JavaScript Properties

@Elementproperties include a 'Type' property that indicates the type of the 
data represented by the property's values.

JavaScript properties are simply properties that have their Type set to 'JavaScript'.
The value of such a property should be a snippet of JavaScript code that, when run on
the client device, will determine something about the device and then set a cookie 
to record the value.

When the device requests the next page from the web server, these cookies will be 
included in the request and added to the @evidence passed to the @pipeline.

The example below shows the process flow between client and server.

@dotfile client-side-evidence.gvdot

# Web Integration

The only part of the **client-side evidence** feature that the @Pipeline does not handle
automatically is how the values of any JavaScript properties actually end up embedded
in the payload sent to the client device.

This can be managed manually. However, there are many @webintegration solutions, covering
a wide variety of languages and web frameworks, that will handle it automatically.

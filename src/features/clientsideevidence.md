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
In some cases though, additional @evidence allowing more detail can be obtained
from code running directly on the client device. In some cases, this may even be 
required.
For example, this technique can be used to retrieve the latitude and longitude 
from devices that have this capability.

# JavaScript Properties

@Elementproperties include a 'Type' property that indicates the type of the 
data represented by the property's values.

JavaScript properties are simply properties that have their Type set to 'Javascript'.
The value of such a property should be a snippet of JavaScript code that, when run on
the client device, will determine something about the device and then set a cookie 
to record the value.

When the device requests the next page from the web server, these cookies will be 
included in the request and added to the @evidence passed to the @pipeline.

The example below shows the process flow between client and server.

@dotfile client-side-evidence.gvdot

# Web Integration

The only part of the **client-side evidence** that the @Pipeline does not handle
by default is how the values of any JavaScript properties actually end up embedded
in the payload sent to the client device.

This can be managed manually. However, there are many @webintegration solutions, covering
a wide variety of languages and web frameworks, that will handle it automatically .

This section covers the specifics of how this works for each web framework:

TODO: Add details for other web frameworks.

=========

@startsnippets
@showsnippet{aspnet,ASP.NET}
@showsnippet{aspnetcore,ASP.NET Core}
@emptysnippet
@startsnippet{aspnetcore}
The ASP.NET Core integration makes use of a 
[View Component](https://docs.microsoft.com/en-us/aspnet/core/mvc/views/view-components)
that is embedded in the @webintegration assembly.
This view component simply requests a JavaScript file called '51Degrees.core.js' 
if **client-side evidence** is enabled:

```
@if (Model.Value.ClientsidePropertiesEnabled)
{
    <script src='51Degrees.core.js' type='text/javascript'></script>
}
```

The view component can be included in pages as needed. If it is needed on all
pages then adding it to your _layout.cshtml is often the easiest solution.

```
@await Component.InvokeAsync("FiftyOneJS")
```

When 51Degrees.core.js is requested, the 
[FiftyOneDegreesMiddleware](@ref Features_WebIntegration) component will 
intercept the request and pass it to a service class.
This service will aggregate all JavaScript properties that have been returned by
@flowelements in the @Pipeline into a single block of JavaScript code.
This will then be returned to the caller as the response.

Additionally, this service implements a caching mechanism, so the resulting 
JavaScript will not need to be regenerated if successive requests contain the
same evidence values.
@endsnippet
@startsnippet{aspnet}

@endsnippet
@endsnippets

=========
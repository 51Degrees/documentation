@page Features_WebIntegration Web Integration Feature

# Introduction

One of the primary use cases for the @Pipeline is as part of the request processing for a website 
or web service. 
To make using the 51Degrees @Pipeline as simple as possible in this scenario, we
have produced a range of packages to integrate with different web frameworks.

# Features

The details of each integration vary significantly. However, the features provided
are largely the same:

- Create a @Pipeline directly from configuration with little or no other direction from the developer.
- Automatically feed relevant @evidence to the @Pipeline from incoming web requests.
- Make the results of the @Pipeline available to all other components.
- Option to automatically bundle property values into the response, in order to 
provide @clientsideevidence in the next request and/or to allow client-side code access to the 
results from the @Pipeline API.

# Implementations

- ASP.NET Core
- ASP.NET
- Java Servlet
- Node.js
- PHP
- Python
- [Varnish](@ref OtherIntegrations_Varnish) (@devicedetection only)
- [Nginx](@ref OtherIntegrations_Nginx) (@devicedetection only)

# Client-side evidence

One feature that is implemented very differently in each framework is the integration with the
@clientsideevidence feature of the @Pipeline.

This section covers the specifics of how it works for each web framework.
Additionally the [web integration examples](@ref Examples_WebIntegration) include details of how
to enable @clientsideevidence for each framework.

@startsnippets
@showsnippet{aspnet,C# - ASP.NET Framework}
@showsnippet{aspnetcore,C# - ASP.NET Core}
@showsnippet{javaservlet,Java Servlet}
@defaultsnippet{Select a web framework to view details of how client-side evidence is supported.}
@startsnippet{aspnetcore}
The ASP.NET Core integration makes use of a 
[View Component](https://docs.microsoft.com/en-us/aspnet/core/mvc/views/view-components)
that is embedded in the **webintegration** assembly.
This view component simply requests a JavaScript file called '51Degrees.core.js' 
if @clientsideevidence is enabled:

```{html}
@if (Model.Value.ClientsidePropertiesEnabled)
{
    <script src='51Degrees.core.js' type='text/javascript'></script>
}
```

The view component can be included in pages as needed. If it is required on all
pages then adding it to your _layout.cshtml is often the easiest solution.

```{cs}
@await Component.InvokeAsync("FiftyOneJS")
```

When 51Degrees.core.js is requested, the 
**FiftyOneDegreesMiddleware** component will 
intercept the request and pass it to a service class.
This service will aggregate all JavaScript properties that have been returned by
@flowelements in the @Pipeline into a single block of JavaScript code.
This will then be returned to the caller as the response.
If configured to do so, this JavaScript will also be minified.

Additionally, this service implements a caching mechanism, 
so the resulting JavaScript will not need to be regenerated if successive requests contain
the same evidence values.

Also see the [getting started web examples](@ref Examples_DeviceDetection_GettingStarted_Web_Index).
@endsnippet
@startsnippet{aspnet}
See the [getting started web examples](@ref Examples_DeviceDetection_GettingStarted_Web_Index).
@endsnippet
@startsnippet{javaservlet}
See the [getting started web examples](@ref Examples_DeviceDetection_GettingStarted_Web_Index).
@endsnippet
@endsnippets

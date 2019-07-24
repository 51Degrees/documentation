@page Features_WebIntegration Web Integration

# Introduction

One of the primary use-cases for the @Pipeline is as part of the request processing for a web site 
or web service. 
To make using the 51Degrees' @Pipeline as simple as possible in this scenario, we
have produced a range of packages to integrate with different web frameworks.

# Features

The details of each integration vary significantly. However, the features provided
remain largely the same.

- Create a @Pipeline directly from configuration with little or no other direction from the developer.
- Automatically feed relevant @evidence to the @Pipeline from incoming web requests.
- Make the results of the @Pipeline available to all other components.
- Option to automatically bundle any values from JavaScript properties into the response, in order to 
provide @clientsideevidence in the next request.

# Implementations

- ASP.NET Core
- ASP.NET
- Java (TODO something)
- PHP
- Node.js
- Nginx (@devicedetection only)
- HAProxy (@devicedetection only)
- Varnish (@devicedetection only)

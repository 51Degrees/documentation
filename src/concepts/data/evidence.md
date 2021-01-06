@page Concepts_Data_Evidence Evidence


# Introduction

**Evidence** is the term for input data used in the @Pipeline. **Evidence** can be 
anything but will usually be details relating to a [web request](@term{WebRequest})
such as HTTP headers, source IP address or query string parameters.

The **evidence** values are used by @aspectengines to determine the details of the 
[apsect](@term{Aspect}) they are concerned with.

# Data Structure

The precise details of the data structure behind **evidence** will vary depending on the
language. However, all languages use a similar approach of exposing the stored evidence
values as a collection of string key/value pairs.

By convention, the key is all lower-case and uses a '.' character to separate the
values into categories based on the source of that data.
For example, all keys starting with 'header.' will have come from an HTTP header.

The second part of the key indicates the specific name within the category.
For example 'header.user-agent' refers to the 'User-Agent' HTTP header.

Categories used by 51Degrees are:

- header - For values from HTTP headers
- cookie - For values from cookies
- query - For values from the query string
- server - For values from the request metadata

# Life Cycle

**Evidence** is fully managed by the @flowdata that contains it.

# Thread Safety

**Evidence** is not thread-safe and should never be written to by @flowelements.

# Client Side Evidence

**Evidence** will usually be drawn from one of 4 places:

* HTTP headers
* Cookies
* Query parameters
* Request metadata such as source IP address

Any device making a request to a web site will include some of this information.
For example, the User-Agent HTTP header is almost always populated as part of a
request.
In some cases though, additional **evidence** providing more detail can be obtained
from code running directly on the client device. In some cases, this may even be 
required.
For example, this technique can be used to retrieve the latitude and longitude 
from devices that have this capability.
Typically, this **evidence** will be sent back to the server as a cookie in the next request.

For more details, see the @clientsideevidence page.

This use of client-side code requires additional JavaScript to be sent to the client
device. The Pipeline @webintegration is designed to handle 
this seamlessly for a variety of languages and web frameworks.


@page Concepts_Data_Evidence Evidence


## Introduction

Evidence refers to all the information associated with a given web request. The evidence 
values are used by [aspect engines](@ref Concepts_FlowElements_AspectEngine) to determine 
the details of the [aspects](@ref Concepts_Terminology) they are concerned with.

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
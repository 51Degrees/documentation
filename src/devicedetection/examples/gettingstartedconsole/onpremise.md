@page DeviceDetection_Examples_GettingStarted_Console_OnPremise Getting started with on-premise detection in a console application

# Introduction

This example shows how to set up an on-premise Device Detection @aspectengine to process User-Agents, User-Agent Client Hints, or both.

The table shows how each example configures the pipeline. You can combine elements from different examples to suit your application.

|            | Console             | Web                 |
|------------|---------------------|---------------------|
| On-premise | Configure in code   | Configure from file |
| Cloud      | Configure from file | Configure in code   |

@startsnippets
@grabexample{device-detection-cxx,_hash_2_getting_started_8c,C}
@grabexample{device-detection-cxx,_hash_2_getting_started_8cpp,C++}
@grabexample{device-detection-dotnet,_on_premise_2_getting_started-_console_2_program_8cs,C#}
@grabexample{device-detection-java,console_2_getting_started_on_prem_8java,Java}
@grabexample{device-detection-php-onpremise,onpremise_2getting_started_console_8php,PHP}
@grabexample{device-detection-node,onpremise_2gettingstarted-console_2getting_started_8js,Node.js}
@grabexample{device-detection-python,onpremise_2gettingstarted_console_8py,Python}
@showsnippet{varnish,Varnish}
@grabexample{device-detection-nginx,hash_2getting_started_8conf,Nginx}
@grabexample{rust,dd-onprem-getting-started,Rust}
@grabbedexample
@startsnippet{varnish}
This example shows how to use 51Degrees On-premise device detection to determine details about a device based on its User-Agent and User-Agent Client Hint HTTP header values.

This example is available in full on [GitHub](https://github.com/51Degrees/51degrees-varnish/blob/main/examples/hash/gettingStarted.vcl).

@include{doc} example-require-datafile.txt

Update the data file path before running the example.

In a Linux environment, run the following commands:

```bash
$ curl localhost:8080 -I -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.97 Safari/537.36"
$ curl localhost:8080 -I -A "Mozilla/5.0 (iPhone; CPU iPhone OS 11_2 like Mac OS X) AppleWebKit/604.4.7 (KHTML, like Gecko) Mobile/15C114"
```

<BR>

Expected output:

```
HTTP/1.1 200 OK
...
X-IsMobile: False
...

...
HTTP/1.1 200 OK
...
X-IsMobile: True
```

<BR>

Code:

```varnish
vcl 4.0;

import fiftyonedegrees;

backend default {
	.host = "127.0.0.1";
	.port = "80";
}

sub vcl_recv {
	set req.http.X-IsMobile = fiftyonedegrees.match_single(req.http.user-agent, "IsMobile");
}

sub vcl_deliver {
	set resp.http.X-IsMobile = fiftyonedegrees.match_single(req.http.user-agent, "IsMobile");
}

sub vcl_init {
	fiftyonedegrees.start("/etc/varnish/51Degrees-LiteV4.1.hash");
}
```
@endsnippet
@endsnippets

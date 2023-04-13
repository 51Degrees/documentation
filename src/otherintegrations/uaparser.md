@page OtherIntegrations_UAParser UAParser.js

# 51Degrees UAParser

We've forked the popular UAParser.js library (which relies solely on a 
[deprecated User-Agent](https://51degrees.com/blog/countdown-to-gday-phase-6-reduced-mobile-tablet-ua)) to create the
[51Degrees UAParser](https://github.com/51Degrees/ua-parser-js), which has support for both User-Agents and User-Agent 
Client Hints (UA-CH).

Depending on your environment, you may need to delegate UA-CH to the third-party cloud.51degrees.com domain.
There are two ways to tell the browser that it is allowed to pass the Client Hints to the third-party domain:

- Setting the Accept-CH and Permissions-Policy HTTP response headers when serving the page. 
- Adding the `<meta http-equiv="Delegate-CH">` tag in the page head. 
     
You can find out more on which method is more suitable for your environment via 
[this UAParser blog](https://51degrees.com/blog/introducing-51degrees-uaparser). You can also see the 51Degrees UAParser 
in action with this [UAParser demonstration page.](https://51degrees.github.io/ua-parser-js/)

@anchor Download_UAParser
## Download the 51D UAParser

The packages are available via:

- [npm](https://www.npmjs.com/package/@51degrees/ua-parser-js)
- [GitHub](https://github.com/51Degrees/ua-parser-js)
- [jsDelivr](https://www.jsdelivr.com/package/npm/@51degrees/ua-parser-js)

## Migrating from UAParser.js to 51Degrees UAParser

### Creating a Resource Key

Before integrating 51Degrees UAParser, you need to register and configure a 51Degrees Resource Key using the 
[Cloud Configurator](https://configure.51degrees.com/). The Configurator tool allows you to choose the device 
properties you would like to get as a result of the call to UAParser. Follow the @configuratorexplanation for 
more detail on how to create a Resource Key. 

We recommend following this URL [https://configure.51degrees.com/S6fGMDKw](https://configure.51degrees.com/S6fGMDKw) 
to create a Resource Key, as it contains the minimum recommended properties that you will need for the UAParser to work.

The minimum recommended properties to include in your Resource Key are:
- IsMobile
- HardwareVendor
- HardwareModel
- HardwareName
- PlatformVendor
- PlatformName
- PlatformVersion
- LayoutEngine
- BrowserVendor
- BrowserName
- BrowserVersion
- JavascriptHardwareProfile
- DeviceType
- SetHeaderBrowserAccept-CH
- SetHeaderHardwareAccept-CH
- SetHeaderPlatformAccept-CH

The majority of the above recommended properties are equivalent to the properties that the original UAParser.js returned. 
However, the 51Degrees UAParser requires additional properties for accurate device detection. JavascriptHardwareProfile is 
needed for [reliable detection of Apple devices]@ref DeviceDetection_Features_AppleDetection, and the trio of Accept-CH 
properties are needed for [User-Agent Client Hints detection](@ref DeviceDetection_Features_UACH_Overview).

## Migrating client-side code

To migrate from the original ua-parser-js, you probably had the page code similar to the below:

```json
<!doctype html>
    <html>
        <head>
            <script src="ua-parser.min.js"></script>
            <script>
                let result = UAParser();
                console.log(result);
            </script>
        </head>
    <body>
    </body> 
    </html>
```

To migrate this code to use 51Degrees UAParser:

1. [Download the 51Degrees UAParser package](@ref Download_UAParser) 
2. We need to either use Accept-CH and Permissions-Policy headers or add a Delegate-CH meta tag within the `<head>` 
element. We chose the latter in the below migrated code snippet example.
3. Change the script import statement to use the path to the new package in the src attribute or use a CDN link.
4. The new 51Degrees UAParser is inherently asynchronous, thus UAParser is a promise. We prefer resolving promises 
using the await keyword – in order to use the [top-level await](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/await), we must set the script [type="module" ()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules). 
It is possible, hwoever, to use the UAParser without await, calling then () instead.
5. Here is the code to obtain the result object, notice the await keyword and the Resource Key: 
`let result = await UAParser("<your resource key>");`
6. The code below obtaining the result can stay the same, but if you had additional properties configured for 
this Resource Key, you can access them directly (using lowercase key names) inside the result.device object.

The migrated code snippet looks like this:

```json
<!doctype html> 
    <html> 
        <head> 
            <meta http-equiv="Delegate-CH" content="Sec-CH-UA-Model https://cloud.51degrees.com; Sec-CH-UA https://cloud.51degrees.com; Sec-CH-UA-Arch https://cloud.51degrees.com; Sec-CH-UA-Full-Version https://cloud.51degrees.com; Sec-CH-UA-Mobile https://cloud.51degrees.com; Sec-CH-UA-Platform https://cloud.51degrees.com; Sec-CH-UA-Platform-Version https://cloud.51degrees.com" /> 
            <script src="ua-parser.min.js"></script> 
            <script type="module"> 
               let result = await UAParser("resource key");  
               console.log(result); 
            </script> 
        </head> 
        <body> 
        </body> 
    </html>
``` 
    
Alternatively, if the server adds Accept-CH and Permissions-Policy response headers, the snippet becomes even 
simpler as you can omit the Delegate-CH meta tag.

```json
<!doctype html> 
    <html>
        <head> 
            <script src="https://cdn.jsdelivr.net/npm/@51degrees/ua-parser-js"></script> 
            <script type="module"> 
                let result = await UAParser("resource key");  
                console.log(result); 
            </script> 
        </head> 
        <body> 
        </body> 
    </html> 
```
    
## Migrating server-side code

A common scenario on the server is to receive a User-Agent as a request header and pass it to the UAParser 
to recognize the device. The Node.js server code could look something like this:

```json
var http = require('http'); 
var parser = require('ua-parser-js'); 
 
http.createServer(function (req, res) { 
    // parse user-agent header 
    var result = parser(req.headers['user-agent']); 
    res.end(JSON.stringify(result, null, ' ')); 
}) 
.listen(80, '0.0.0.0');
```
    
Here is what we need to change to migrate this to use 51Degrees UAParser:

1. We want to use a HTTPS server instead of HTTP so that the browser would send us User-Agent Client Hints 
(as UA-CH are only sent over HTTPS connections)
2. The package name in the require statement should be changed to @51degrees/ua-parser-js.
3. The function passed to the server should now be marked async, as we are going to use await inside it.
4. The parser call should be prepended with await.
5. The parser call now takes the Resource Key and the request header map as a parameter.
    
```json
        // the self-signed certificate for the test environment 
            var fs = require('fs'); 
            var options = { 
                key: fs.readFileSync('.cert/key.pem'), 
                cert: fs.readFileSync('.cert/cert.pem') 
            };

        // the new package name 
            const UAParser = require("@51degrees/ua-parser-js"); 
            var https = require('https');

        // note the async function 
            https.createServer(options, async function (req, res) { 
            // note the await keyword and parameters 
                let result = await UAParser("your resource key", req.headers); 
                res.end("
51Degrees:
" + JSON.stringify(result, null, ' ') + "
                ");
            })
            .listen(443, '0.0.0.0');
```
    
Now we assume that this would be a secondary call to the server from within the page that has already 
been rendered and had an Accept-CH header in the response that listed all the necessary User-Agent Client Hints. 
The Accept-CH header in the original page would make it send the Client Hints in all subsequent requests to the same origin. 
This feature is called the Accept-CH cache.

Here is a quick and dirty example where we'll show how to ask the browser to immediately send the User-Agent Client Hints 
by setting two response headers: Accept-CH and Critical-CH. The latter tells the browser to immediately come back with the 
Client Hints if it did not send them on the first attempt, so it starts another request before loading the response body.

```json
        // the self-signed certificate for the test environment 
        var fs = require('fs'); 
        var options = { 
            key: fs.readFileSync('.cert/key.pem'), 
            cert: fs.readFileSync('.cert/cert.pem') 
        }; 
 
        // the new package name 
        const UAParser = require("@51degrees/ua-parser-js"); 
        var https = require('https'); 
 
        // note the async function 
        https.createServer(options, async function (req, res) { 
        // note the await keyword and parameters 
        let result = await UAParser("your resource key", req.headers); 
 
        ch = 'Sec-CH-UA, Sec-CH-UA-Arch, Sec-CH-Bitness, Sec-CH-UA-Full-Version, \ 
        Sec-CH-UA-Full-Version-List, Sec-CH-UA-Mobile, Sec-CH-UA-Model, \ 
        Sec-CH-UA-Platform, Sec-CH-UA-Platform-Version, Sec-CH-UA-WoW64' 
 
        res.setHeader('Critical-CH',ch) 
        res.setHeader('Accept-CH', ch) 
 
        res.end("
51Degrees:
" + JSON.stringify(result, null, ' ') + ""); 
        }) 
        .listen(443, '0.0.0.0'); 
```
    
## Live code demo

We hosted a live code demo of the 51Degrees UAParser during a webinar.

\htmlonly
<iframe src="https://player.vimeo.com/video/805500329" width="640" height="360" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe>
\endhtmlonly


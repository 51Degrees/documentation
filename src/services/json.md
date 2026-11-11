@page Services_Json Your connection and device as JSON

[51degrees.com/json](https://51degrees.com/json) returns what 51Degrees finds for the request that asks for it: the IP address with its location and network, and the device, operating system, and browser that sent the request. It needs no Resource Key and no account.

```
curl https://51degrees.com/json
```

Open the same address in a browser to see the answer for that browser.

# Paste the answer into a support request

The answer is indented JSON, so it can be copied as it is into a ticket, an email, or a chat. Ask the person with the problem to open https://51degrees.com/json in the browser where the problem happens and paste what it shows. Support then has the browser and its version, the operating system, the type of device, and the connection in one block, rather than asking for each in turn.

# What it returns

This is the answer for Chrome 157 on Windows 11. The IP address, its location, and its network name are replaced with example values, using an address reserved for documentation.

```
{
  "ip": {
    "ip": "192.0.2.10",
    "town": "Manchester",
    "region": "England",
    "country": "United Kingdom",
    "countrygeonameid": "2635167",
    "latitude": 53.4794,
    "longitude": -2.2453,
    "locationconfidence": "High",
    "registeredname": "TEST-NET-1",
    "connectiontype": "Broadband"
  },
  "device": {
    "hardwarevendor": "Unknown",
    "hardwaremodel": "Unknown",
    "devicetype": "Desktop",
    "releaseage": 0,
    "platformname": "Windows",
    "platformversion": "11.0",
    "platformreleaseage": 65,
    "browsername": "Chrome",
    "browserversion": "157",
    "browserreleaseage": 1,
    "iscrawler": false
  }
}
```

The `ip` part describes the IP address the request came from.

| Key | What it holds |
|-----|---------------|
| `ip` | The IP address the answer is for. |
| `town`, `region`, `country` | The town, region, and country the address is in. |
| `countrygeonameid` | The [GeoNames](https://www.geonames.org/) identifier of the country. |
| `latitude`, `longitude` | The average location of the address, moved at random by up to about 1 kilometer. See @ref IpIntelligence_Features_Randomization "Randomization". |
| `locationconfidence` | High, Medium, Low, or Unknown. Check it before relying on the town or the coordinates. |
| `registeredname` | The name of the IP range, which is usually its owner. |
| `connectiontype` | The kind of connection, such as Broadband or Cellular. |

The `device` part describes what sent the request, from its headers.

| Key | What it holds |
|-----|---------------|
| `hardwarevendor`, `hardwaremodel` | The company that makes or sells the device, and the model name or number it uses. |
| `devicetype` | The type of device, such as Desktop, SmartPhone, or Tablet. |
| `releaseage` | Months since the device was released. |
| `platformname`, `platformversion` | The operating system and its version. |
| `platformreleaseage` | Months since that operating system version was released. |
| `browsername`, `browserversion` | The browser and its version. |
| `browserreleaseage` | Months since that browser version was released. |
| `iscrawler` | `true` when the request comes from software that says it runs without a person, such as a search engine crawler or a monitoring tool. |

Unknown, or 0 for an age, means the request did not carry enough to tell. A desktop computer, for example, does not say who made it. If the 51Degrees cloud service gives no answer, that part is `null`.

The [Property Dictionary](https://51degrees.com/developers/property-dictionary) describes each property in full.

# Call it from code

From a script or a terminal, use curl. It sends no browser User-Agent, so the device part reports `"browsername": "Unknown Crawler"` and `"iscrawler": true`.

```
curl https://51degrees.com/json
```

From a web page on any website, use `fetch`. The answer carries `Access-Control-Allow-Origin: *`, so browsers allow the call from any site.

```
const response = await fetch('https://51degrees.com/json');
const you = await response.json();
console.log(you.device.browsername, you.device.browserversion, you.ip.country);
```

The answer is always fresh, because it is sent with `Cache-Control: no-store`.

# Throttling

51degrees.com/json is throttled to prevent abuse, and the throttling can change. A request that is turned away does not get the JSON answer, so code that calls it should check the response before using it.

For more requests, other IP addresses or User-Agents, or more properties, @ref Services_Configurator "create a Resource Key" and call the @ref Services_Cloud_Overview "cloud service" yourself. Moving from IPinfo? @ref IpIntelligence_Migration_IpInfo "From IPInfo" maps its fields to 51Degrees properties.

# What is sent to the cloud

To answer, 51degrees.com sends the IP address and headers of the request to the 51Degrees cloud service, leaving out cookies and authorization headers. It also counts the requests from each caller, to throttle the page.

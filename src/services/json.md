@page Services_Json Your connection and device as JSON

[51degrees.com/json](https://51degrees.com/json) is for support. A customer opens it in the browser that is giving them trouble and pastes the answer into their ticket, so support has the details without asking for each in turn.

It returns what 51Degrees finds for the request that asks for it: the IP address with its location and network, and the device, operating system, and browser that sent the request. It needs no Resource Key and no account.

It only works in a real web browser. Open it in a browser to see the answer for that browser. Curl and other command-line tools are treated as crawlers, and crawlers of any kind are sent to [the AI notice](https://51degrees.com/ai-notice), which explains how to license the data, rather than given an answer.

# Paste the answer into a support request

The answer is indented JSON, so it can be copied as it is into a ticket, an email, or a chat. Ask the person with the problem to open https://51degrees.com/json in the browser where the problem happens and paste what it shows. Support then has the browser and its version, the operating system, the type of device, and the connection in one block, rather than asking for each in turn.

# What it returns

This is the answer 51degrees.com/json gave a computer at 51Degrees on 11 November 2026, for Edge 157 on Windows 11, with the IP address replaced by one reserved for documentation, the town and position replaced by a position in Reading, and the network's registered name replaced by an example. The data can't yet date Edge 157, and a desktop computer doesn't say who made it, so both release years are 0.

```
{
  "ip": {
    "ip": "192.0.2.10",
    "town": "Reading",
    "region": "England",
    "country": "United Kingdom",
    "countrygeonameid": "2635167",
    "latitude": 51.454,
    "longitude": -0.978,
    "locationconfidence": "High",
    "registeredname": "EXAMPLE-NETWORK",
    "connectiontype": "Broadband"
  },
  "device": {
    "hardwarevendor": "Unknown",
    "hardwaremodel": "Unknown",
    "devicetype": "Desktop",
    "releaseyear": 0,
    "releaseage": 0,
    "platformname": "Windows",
    "platformversion": "11.0",
    "platformreleaseyear": 2021,
    "platformreleaseage": 65,
    "browsername": "Edge (Chromium) for Windows",
    "browserversion": "157",
    "browserreleaseyear": 0,
    "browserreleaseage": 0
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
| `releaseyear`, `releaseage` | The year the device was released, and the months since. |
| `platformname`, `platformversion` | The operating system and its version. |
| `platformreleaseyear`, `platformreleaseage` | The year that operating system version was released, and the months since. |
| `browsername`, `browserversion` | The browser and its version. |
| `browserreleaseyear`, `browserreleaseage` | The year that browser version was released, and the months since. |

Unknown, or a release year of 0, means the request did not carry enough to tell, and the age beside a release year of 0 is 0 too. A desktop computer, for example, does not say who made it. A release year is also 0 where the data has no release date for a version it did identify, such as Edge 157 in the sample above. An age of 0 with a release year means the release was this month. If the 51Degrees cloud service gives no answer, that part is `null`.

The [Property Dictionary](https://51degrees.com/developers/property-dictionary) describes each property in full.

# Call it from code

From a web page on any website, use `fetch`. The answer carries `Access-Control-Allow-Origin: *`, so browsers allow the call from any site. A request that is throttled, or that comes from a crawler, is redirected to a page that doesn't allow calls from other sites, so the call fails rather than returning an answer. Catch that, and check the response before reading it.

```
try {
  const response = await fetch('https://51degrees.com/json');
  if (!response.ok || response.redirected) {
    throw new Error('51degrees.com/json gave no answer');
  }
  const you = await response.json();
  console.log(you.device.browsername, you.device.browserversion, you.ip.country);
} catch (error) {
  console.log('No answer from 51degrees.com/json', error);
}
```

The answer is always fresh, because it is sent with `Cache-Control: no-store`.

# Throttling

51degrees.com/json is throttled to prevent abuse, and the throttling can change. A request that is turned away, or that comes from a crawler, is redirected and does not get the JSON answer, so code that calls it should check the response before using it.

For more requests, other IP addresses or User-Agents, or more properties, @ref Services_Configurator "create a Resource Key" and call the @ref Services_Cloud_Overview "cloud service" yourself.

# What is sent to the cloud

To answer, 51degrees.com sends the IP address and headers of the request to the 51Degrees cloud service, leaving out cookies and authorization headers. It also counts the requests from each caller, to throttle the page.

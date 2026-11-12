@page DeviceDetection_OtherIntegrations_Wordpress WordPress

# Optimize by device and location

Optimize your website for a range of devices and personalize your content based on your user’s location.

Our plugin uses device and location data to help you adapt your website and analytics reports. Install it from the WordPress plugin manager by searching for “51Degrees”.

\htmlonly
<iframe src="https://player.vimeo.com/video/631017900?h=8e8c844804" width="640" height="360" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe>
\endhtmlonly

## After activation

1.  Visit the new `51Degrees` Settings menu.

2.  To start using this plugin, you will need to create a `Resource Key`. This enables access to the data you need via the 51Degrees Cloud service. You can 
    create a `Resource Key` for free, at [51degrees.com/configure](https://51degrees.com/configure/), selecting the properties you want.


## Integration with Google Analytics

1.  The plugin works with Google Analytics 4 (GA4). Your Resource Key must have your site's domain added to it, or the connection is refused. If your key does not, create a new key with the domain at [51degrees.com/configure](https://51degrees.com/configure/). Then go to the `Google Analytics` tab and click `Connect Google Analytics`. Authorize the 51Degrees plugin on the Google consent screen. You are returned to the tab, which confirms the connection.

2.  Once connected, select the GA4 property that receives the Custom Dimensions from the `Analytics Account/Property` dropdown.

3.  Check `Send Page View` if you want to send Default Page View hits along with Custom Dimensions. It is only recommended if you have not already integrated with any other Google Analytics plugin to avoid data duplication.

4.  Click `Save Changes` to open the Custom Dimensions screen, which lists the dimensions available with your Resource Key.

5.  Click on `Enable Google Analytics Tracking` to enable tracking of all the Device Data Properties as Custom Dimensions.


## Robots.txt and crawler control

The `Robots.txt` tab lets you host a virtual `/robots.txt` file and, optionally, enforce crawler access in real time using 51Degrees crawler detection. Hosting the file is advisory only. The plugin fetches the file from the cloud when you save the tab and once a day after that, and serves the stored copy in between, so serving the file uses no cloud requests. Enforcement uses live device detection and consumes one cloud request per page load, so enable it only when you want active bot blocking.

1.  **Enable Robots.txt Hosting** generates a virtual `/robots.txt` from your configured rules and the selected crawler categories. If a physical `robots.txt` file exists in your WordPress root, WordPress serves that file instead, so delete or rename it to use the virtual one.

2.  **Enable Crawler Enforcement** turns on real-time detection and 302-redirects detected bots to your configured `Redirect URL` (leave it empty to deny access without redirecting). The `/robots.txt` file itself always stays reachable to crawlers regardless of the enforcement policy.

3.  **Allowed Crawler Categories** lets crawlers in the selected categories through. Category-based enforcement requires the `CrawlerUsage` property in your Resource Key. Without `CrawlerUsage`, the plugin neither blocks nor redirects any crawler, and only the rules in the hosted `robots.txt` file apply.

4.  **Terms Document Locators (TDL)** add `TDL:` lines to the generated file, emitted at the end between the final wildcard `User-agent: *` line and its `Allow: /`. Each TDL points to an immutable legal document that defines the terms under which crawlers may access your site, following the proposed robots.txt extension described in the <a href="https://github.com/jwrosewell/data-labels/blob/main/IETF-Robots.md">data-labels IETF Robots proposal</a>. You can select standard TDLs (currently the MOW Search Only Terms Web, SOCW), which are maintained externally and checked daily for updated versions, or supply your own custom TDL URLs, one per line.

5.  **Custom Top Entries** and **Custom Bottom Entries** let you prepend or append your own lines around the generated 51Degrees section.

Crawler detection needs the `IsCrawler` and `CrawlerUsage` properties, and file generation from the cloud needs the `robotstxt.plaintext` property. Create a key with these at <a href="https://51degrees.com/configure/">51degrees.com/configure</a> if your key does not already include them.


## Suspicious activity detection

The `Suspicious` tab detects and blocks visitors who make too many requests in a short window. From the tab you can set the request threshold (`Number of requests`), the time window (`Within seconds`), and the `Redirect URL` that blocked visitors are sent to.

When your Resource Key is working, detection runs in advanced mode and counts requests by each visitor's 51Did, which can tell apart visitors who share a network. If the key is missing or invalid, it falls back to basic mode, where visitors with the same IP address and User-Agent are grouped and blocked together.

Advanced mode relies on a probabilistic identifier from your Resource Key, which is `IdProbLic` if present, otherwise `IdProbGlobal` (see @ref Identifiers_51Did). These are generated with `id.usage=non-marketing`, so they do not require a License Key or a specific product, but they do need to be present on the key. If your existing key does not include either property, create a new Resource Key that adds it at <a href="https://51degrees.com/configure/">51degrees.com/configure</a>. Without these properties the plugin falls back to a hash of the visitor's IP address and User-Agent, which groups visitors who share both the IP address and the User-Agent.


## Preference Management Platform (PMP)

The `PMP` tab adds the 51Degrees marketing preference popup to your public pages. Visitors choose `Standard`, `Personalized`, or a publisher-defined alternative (for example "Remove ads" or "Subscribe"). The choice is kept in a first party cookie on your own domain, `__mtm_pref`, holding one of `standard`, `personalized` or `non-marketing`. The answer is a cookie rather than browser storage because a request carries cookies, and carries nothing else PMP could write, so your own server, and anything in front of it, can act on the answer. The cookie carries no `HttpOnly` flag, which would stop a script reading it, because the page reads it back and replaces it when the visitor changes their mind. PMP also acts as the consent management platform (CMP) by exposing the consent state through the IAB Transparency and Consent Framework (TCF) API, so a separate consent manager is not needed. For the underlying concept and the cloud endpoint, see @ref Identifiers_PMP.

Configure the popup from the `PMP` tab:

-  **Enable PMP** shows the popup on public pages.
-  **Alternative Button Label** and **Alternative Button URL** define the opt-out button and where it sends the visitor (typically a subscription, checkout, or paywall page). Both are required.
-  **Terms / Privacy URL** is linked from the popup, so a visitor can read your terms before answering, and is required.
-  **Brand Name** and **Brand Logo URL** set the branding shown in the popup. Replace the placeholder defaults with your own.
-  **Show Standard Marketing Option** shows the `Standard` choice alongside `Personalized` and the alternative button.
-  **TCF Vendor String** is the base IAB TCF v2 consent string onto which PMP overlays the visitor's purpose consents at runtime. The built-in default gives consent to every vendor that asks for it on one fixed version of the IAB Global Vendor List, so vendors added to the list after that version are not included. Override it to restrict the vendor set or to cover a later version of the list.

The popup works out of the box. To react to the visitor's choice, override the global callback on your page - the plugin ships a no-op default:

```json
<script>
window.onPMPCompletion = function (preference) {
    // preference is 'standard', 'personalized' or 'non-marketing'
};
</script>
```


## Developer information and advanced features

*Value replacement*

Insert a snippet such as `{Pipeline::get("device", "browsername")}` into your page to display the corresponding value, such as `Chrome`, `Safari`, or `Firefox`. Copy snippets from the 'Usage in Content' column on the plugin's 'Properties' tab.

*Conditional blocks*

This feature allows you to show/hide content based on the property values supplied by the Pipeline API. To start, click 'add a new block' and select the `51Degrees conditional group block`. Select the block to display the configuration UI on the right-hand side. For example, you can configure the block to only appear if the hardware vendor property is 'Apple'.


## Accessing properties in PHP code

To get a specific property, look it up on the available properties list and use the get() method specified.

`Pipeline::get("device", "ismobile")`
You can also get a list of properties by category as an array.

`Pipeline::getCategory("Supported Media")`
The code snippet above will give you all the properties with `Supported Media` category included in the Resource Key.

## JavaScript integration

The 51Degrees library exposes the same property values in JavaScript. These are accessed through the global `fod` object

```json
<script type="text/javascript" >
     window.onload = function() {
       fod.complete(function(data){
       // console.log(data.device.screenpixelswidth);
       });
     }
</script>
```

In some cases, additional evidence needs to be gathered by running JavaScript on the client. This is mostly handled automatically by the plugin and the fod object. For specific examples, see the 'Location' and 'Apple device models' sections below.


## Location

Location works slightly differently to other properties. Currently, the address is determined from the location provided by the client's device. When this data is requested, a confirmation pop-up will appear. It is good practice to delay the appearance of this pop-up until the location is really needed. Otherwise, the user may not know why they are being asked for the information and is more likely to refuse. To facilitate this, the location data needs to be explicitly requested by adding some additional JavaScript. There are many ways to do this but for an example, we have gone with the simplest approach.

Firstly, add a button to your page. Make sure to set a css class that we can use to identify this button and add an event to it.

Next, add an HTML element and paste the following snippet of code into it:

```json
<script type="text/javascript" >
     window.onload = function() {
       var elements = document.getElementsByClassName('get-user-location');

       for(var i = 0; i < elements.length; i++) {
          elements[i].addEventListener('click', function() {
            fod.complete(function(data) { /* use values here if needed e.g. data.location.country will contain country the user is in */ }, 'location');
          });
       }
     };
</script>
```

Now, when the user clicks on the 'Use my location' button, the JavaScript that we pasted in will execute. This lets the global `fod` object know that we want access to the location data, which in turn causes the 'wants to know your location' confirmation pop-up to be displayed.

**Note:** On the first request, the server will not have the location information so the location properties will not have values. After the button is clicked, we need to make another request to the server for the location values to be populated. The content on the page can also be updated by using JavaScript, rather than waiting for the user to make a second request. This involves editing the JavaScript snippet above to update the page within the callback function that is passed to fod.complete.


## Apple device models

Apple includes limited hardware information in the 'User-Agent' HTTP header. We use client-side JavaScript to gather more evidence and identify an Apple model or narrow the result to a group of models.

The WordPress plugin will handle this for you automatically. However, be aware that, due to having to get additional data from the client, the model may be less clear on the first request than on subsequent requests. After the JavaScript runs on the client, a second request is made and the array of values would be significantly narrowed down.

**Note:** The content on the page can also be updated by using JavaScript, rather than waiting for the user to make a second request. The global `fod` object can be used to pass a callback that is executed when the updated values are available. For example:

```json
<script type="text/javascript" >
     window.onload = function() {
       fod.complete(function(data) { /* access values here. e.g. data.device.hardwarename */ });
     };
</script>
```

## Manual installation from the WordPress plugin directory

1. Download the plugin zip file from the [51Degrees plugin page](https://wordpress.org/plugins/51degrees-optimize-by-device-location/) in the WordPress plugin directory.

2. Unzip it and upload the `51degrees-optimize-by-device-location` folder to the `/wp-content/plugins/` directory.

3. Visit `Plugins`.

4. Activate the 51Degrees plugin.


## Manual installation from GitHub

If you want to build the plugin yourself and install locally, you will need to follow these steps:

1.  Clone the [51Degrees WordPress plugin repository](https://github.com/51Degrees/pipeline-wordpress/).

2.  Execute `composer install` in the `lib` directory.

3.  Create a new directory outside this repo called `fiftyonedegrees` and copy all directories and php files from the root of this repo into it.

4.  Copy the `fiftyonedegrees` directory into your 'wp-content/plugins' directory.

5.  Activate the 51Degrees plugin.


This plugin is free and licensed under the [European Union Public Licence (EUPL) v1.2](https://opensource.org/licenses/EUPL-1.2), which provides it without warranty and limits the liability of 51Degrees. Always back up your data before installing a new plugin.

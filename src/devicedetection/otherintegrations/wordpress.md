@page DeviceDetection_OtherIntegrations_Wordpress WordPress

# 51Degrees - Optimize by Device & Location

Optimize your website for a range of devices and personalize your content based on your user’s location.

Using real-time data, our plugin can optimize your website for users, based on device type and location. Upgrade your analytic reporting with a click of a button. Install from the WordPress plugin manager by searching for “51Degrees”.

\htmlonly
<iframe src="https://player.vimeo.com/video/631017900?h=8e8c844804" width="640" height="360" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe>
\endhtmlonly

## After activation

1.  Visit the new `51Degrees` Settings menu.

2.  To start using this plugin, you will need to create a `Resource Key`. This enables access to the data you need via the 51Degrees Cloud service. You can 
    create a `Resource Key` for free, using the [configurator](https://configure.51degrees.com/) to select the properties you want.


## Integration with Google Analytics

1.  To integrate with Google Analytics, go to the `Google Analytics` tab and click `Connect Google Analytics`. Authorize the 51Degrees plugin on the Google consent screen. You are returned to the tab, which confirms the connection.

2.  Once connected, select your preferred properties for which you want to enable Custom Dimensions Tracking via the `Google Analytics Property` dropdown.

3.  Check `Send Page View` if you want to send Default Page View hits along with Custom Dimensions. It is only recommended if you have not already integrated with any other Google Analytics plugin to avoid data duplication.

4.  Click `Save Changes`. This will prompt to the new Custom Dimensions screen where you can find all the Custom Dimensions available with the Resource Key.

5.  Click on `Enable Google Analytics Tracking` to enable tracking of all the Device Data Properties as Custom Dimensions.


## Robots.txt and crawler control

The `Robots.txt` tab lets you host a virtual `/robots.txt` file and, optionally, enforce crawler access in real time using 51Degrees crawler detection. Hosting the file is advisory only and does not consume cloud requests; enforcement uses live device detection and consumes one cloud request per page load, so enable it only when you want active bot blocking.

1.  **Enable Robots.txt Hosting** generates a virtual `/robots.txt` from your configured rules and the selected crawler categories. If a physical `robots.txt` file exists in your WordPress root, WordPress serves that file instead, so delete or rename it to use the virtual one.

2.  **Enable Crawler Enforcement** turns on real-time detection and 302-redirects detected bots to your configured `Redirect URL` (leave it empty to deny access without redirecting). The `/robots.txt` file itself always stays reachable to crawlers regardless of the enforcement policy.

3.  **Allowed Crawler Categories** lets crawlers in the selected categories through. Category-based enforcement requires the `CrawlerUsage` property in your Resource Key; without it, only path-based rules apply.

4.  **Terms Document Locators (TDL)** add `TDL:` lines to the generated file, emitted at the end between the final wildcard `User-agent: *` line and its `Allow: /`. Each TDL points to an immutable legal document that defines the terms under which crawlers may access your site, following the proposed robots.txt extension described in the <a href="https://github.com/jwrosewell/data-labels/blob/main/IETF-Robots.md">data-labels IETF Robots proposal</a>. You can select standard TDLs (for example the MOW Standard Terms), which are maintained externally and checked daily for updated versions, or supply your own custom TDL URLs, one per line.

5.  **Custom Top Entries** and **Custom Bottom Entries** let you prepend or append your own lines around the generated 51Degrees section.

Crawler detection needs the `IsCrawler` and `CrawlerUsage` properties, and file generation from the cloud needs the `RobotsTxt` `PlainText` property. Create a key with these using the <a href="https://configure.51degrees.com/">configurator</a> if your key does not already include them.


## Suspicious activity detection

The `Suspicious` tab detects and blocks visitors who make too many requests in a short window. From the tab you can set the request threshold (`Number of requests`), the time window (`Within seconds`), and the `Redirect URL` that blocked visitors are sent to.

When your Resource Key is working, detection runs in advanced mode and identifies visitors individually, even when they share a network. If the key is missing or invalid, it falls back to basic mode, where visitors that look identical to the site are grouped and blocked together.

Advanced mode relies on a probabilistic identifier from your Resource Key - `IdProbLic` if present, otherwise `IdProbGlobal` (see @ref Identifiers_51Did). These are generated with `id.usage=non-marketing`, so they do not require a license key or a specific product, but they do need to be present on the key. If your existing key does not include either property, create a new Resource Key that adds it using the <a href="https://configure.51degrees.com/">configurator</a>. Without these properties the plugin falls back to a hash of the visitor's IP address and User-Agent, which groups visitors that share a network.


## Preference Management Platform (PMP)

The `PMP` tab adds a 51Degrees consent popup to your public pages. Visitors choose `Standard`, `Personalized`, or a publisher-defined alternative (for example "Remove ads" or "Subscribe"). The choice is stored client-side in `localStorage` under the `__51d_pmp_pref` key - no cookies and no extra server round-trips - and PMP acts as the CMP by exposing the consent state through the IAB TCF API, so a separate consent manager is not needed. For the underlying concept and the cloud endpoint, see @ref Identifiers_PMP.

Configure the popup from the `PMP` tab:

-  **Enable PMP** shows the popup on public pages.
-  **Alternative Button Label** and **Alternative Button URL** define the opt-out button and where it sends the visitor (typically a subscription, checkout, or paywall page). Both are required.
-  **Terms / Privacy URL** is linked from the popup and is required for a meaningful consent record.
-  **Brand Name** and **Brand Logo URL** set the branding shown in the popup. Replace the placeholder defaults with your own.
-  **Show Standard Marketing Option** shows the `Standard` choice alongside `Personalized` and the alternative button.
-  **TCF Vendor String** is the base IAB TCF v2 consent string onto which PMP overlays the visitor's purpose consents at runtime. The built-in default consents every vendor on the current IAB Global Vendor List; override it to restrict the vendor set.

The popup works out of the box. To react to the visitor's choice, override the global callback on your page - the plugin ships a no-op default:

```json
<script>
window.onPMPCompletion = function (preference) {
    // preference is 'standard' or 'personalized'
};
</script>
```


## Developer information and advanced features

*Value replacement*

You can insert snippets into your pages that will be replaced with the corresponding value. For example, the text `{Pipeline::get("device", "browsername")}` would be replaced with `Chrome`, `Safari` and `Firefox`, etc, depending on the browser being used by the person visiting your site. To set this up, take the text from the 'Usage in Content' column on the 'Properties' tab of the plugin.

*Conditional blocks*

This feature allows you to show/hide content based on the property values supplied by the Pipeline API. To start, click 'add a new block' and select the `51Degrees conditional group block`. Select the block to display the configuration UI on the right-hand side. For example, you can configure the block to only appear if the hardware vendor property is 'Apple'.


## Accessing properties in PHP code

To get a specific property, look it up on the available properties list and use the get() method specified.

`Pipeline::get("device", "ismobile")`
You can also get a list of properties by category as an array.

`Pipeline::getCategory("Supported Media"))`
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

Determining the exact model of Apple devices is more difficult that others. This is because Apple include limited information about the device hardware in the 'User-Agent' HTTP header that is sent to the webserver. To get around this problem, device detection uses JavaScript that runs directly on the client to gather some additional information. This can usually be used to determine the exact model of device and will at least narrow down the possibilities.

The WordPress plugin will handle this for you automatically. However, be aware that, due to having to get additional data from the client, the model may be less clear on the first request than on subsequent requests. After the JavaScript runs on the client, a second request is made and the array of values would be significantly narrowed down.

**Note:** The content on the page can also be updated by using JavaScript, rather than waiting for the user to make a second request. The global `fod` object can be used to pass a callback that is executed when the updated values are available. For example:

```json
<script type="text/javascript" >
     window.onload = function() {
       fod.complete(function(data) { /* access values here. e.g. data.device.hardwarename */ });
     };
</script>
```

## Manual installation using WordPress Plugin Manager

1. Download `fiftyonedegrees` zip package from [WordPress Plugin Manager](https://wordpress.org/plugins/wp-plugin-manager/).

2. Upload the entire `fiftyonedegrees` zip folder to the `/wp-content/plugins/` directory.

3. Visit `Plugins`.

4. Activate the 51Degrees plugin.


## Manual installation using GitHub Repository

If you want to build the plugin yourself and install locally, you will need to follow these steps:

1.  Clone the [51Degrees WordPress plugin repository](https://github.com/51Degrees/pipeline-wordpress/).

2.  Execute `composer install` in the `lib` directory.

3.  Create a new directory outside this repo called `fiftyonedegrees` and copy all directories and php files from the root of this repo into it.

4.  Copy the `fiftyonedegrees` directory into your 'wp-content/plugins' directory.

5.  Activate the 51Degrees plugin.


This plugin is free and provided without warranty of any kind. Use it at your own risk; 51Degrees is not responsible for any improper use of this plugin, nor for any damage it might cause to your site. Always backup all your data before installing a new plugin.

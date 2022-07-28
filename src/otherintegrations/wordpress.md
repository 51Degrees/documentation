@page OtherIntegrations_Wordpress WordPress

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

1.  To integrate with Google Analytics, go to the `Google Analytics` tab and click `Log in with Google Analytics Account` button. Follow the steps and give the 51Degrees plugin the required permissions. Copy the provided Google Analytics `Access Code`.

2.  Enter the copied Code in the `Access Code` text field and click `Authenticate`. This will connect your Google Analytics account to the 51Degrees plugin.

3.  After authentication, select your preferred profiles for which you want to enable Custom Dimensions Tracking via the `Google Analytics Property` dropdown.

4.  Check `Send Page View` if you want to send Default Page View hits along with Custom Dimensions. It is only recommended if you have not already integrated with any other Google Analytics plugin to avoid data duplication.

5.  Click `Save Changes`. This will prompt to the new Custom Dimensions screen where you can find all the Custom Dimensions available with the Resource Key.

6.  Click on `Enable Google Analytics Tracking` to enable tracking of all the Device Data Properties as Custom Dimensions.


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

1.  Clone 51Degrees plugin GitHub repository from [here](https://github.com/51Degrees/pipeline-wordpress/).

2.  Execute `composer install` in the `lib` directory.

3.  Create a new directory outside this repo called `fiftyonedegrees` and copy all directories and php files from the root of this repo into it.

4.  Copy the `fiftyonedegrees` directory into your 'wp-content/plugins' directory.

5.  Activate the 51Degrees plugin.


This plugin is free and provided without warranty of any kind. Use it at your own risk; 51Degrees is not responsible for any improper use of this plugin, nor for any damage it might cause to your site. Always backup all your data before installing a new plugin.
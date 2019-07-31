@page Examples_CustomElement_ClientSideEvidence Custom Engine Using Client-Side Evidence

# Introduction

This example takes the very simple @flowelement described in the
[simple flow element example](@ref Examples_CustomElement_FlowElement), and adds
a JavaScript @property to use @clientsideevidence. 

Instead of using @evidence which is already available, as the [simple flow element example](@ref Examples_CustomElement_FlowElement)
did, this example will send JavaScript to the a client to get the @evidence.

# Download Example

The source code used in this example is available here:
- [C# Visual Studio project **todo**](add link)
- [Java project **todo**](add link)
- [PHP project **todo**](add link)
- [Node.js project **todo**](add link)

# Dependencies

The @flowelement will need a dependency on the @pipeline core package

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific dependencies.}
@startsnippet{dotnet}
The only dependency needed for .NET is the `FiftyOne.Pipeline.Core` NuGet package.
@endsnippet
@startsnippet{java}
The only dependency needed for Java is the `pipeline.core` Maven package from `com.51degrees`.
To include this, add the following to the `<dependencies>` section of the project's `pom.xml`:
```{xml}
<dependency>
    <groupId>com.51degrees</groupId>
    <artifactId>pipeline.core</artifactId>
    <version>4.0</version>
</dependency>
```
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets


# Data

The @elementdata being added to the @flowdata by this @flowelement is a star sign. So this should
have its own 'getter' in its @elementdata. The additional @property containing the JavaScript to
get the date of birth is also added using the appropriate type.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific @elementdata implementation.}
@startsnippet{dotnet}
.NET supports interfaces, so the @elementdata should have a public interface and an internal
concrete implementation with easy 'setters'.

In this example, values for star sign and JavaScript are populated. So an interface `IStarSign`
will extend `IElementDataReadOnly` to add a 'getter' for it.
```{cs}
public interface IStarSignData : IElementDataReadOnly
{
    string StarSign { get; }
    JavaScript DobJavaScript { get; }
}
```

Now the internal implementation of it will implement this 'getter' and add a 'setter' for the @flowelement
to use.
```{cs}
internal class StarSignData : ElementDataBase, IStarSignData
{
    public StarSignData(
        ILogger<ElementDataBase> logger,
        IFlowData flowData)
        : base(logger, flowData)
    {
    }

    public string StarSign
    {
        // Get the star sign from the internal IDictionary as a string.
        get { return GetAs<string>("starsign"); }
        // Add the star sign to the internal IDictionary.
        set { AsDictionary().Add("starsign", value); }
    }
    
    public JavaScript DobJavaScript
    {
        get { return GetAs<JavaScript>("dobjavascript"); }
        set { AsDictionary().Add("dobjavascript", value); }
    }

    protected override void ManagedResourcesCleanup()
    {
        // Nothing to clean up here.
    }

    protected override void UnmanagedResourcesCleanup()
    {
        // Nothing to clean up here.
    }
}
```
@endsnippet
@startsnippet{java}
Java supports interfaces, so the @elementdata should have a public interface and a package private
concrete implementation with easy 'setters'.

In this example, values for star sign and JavaScript are populated. So an interface `StarSignData`
will extend `ElementDataReadOnly` to add a 'getter' for it.
```{java}
public interface StarSignData extends ElementDataReadOnly {
    String getStarSign();
    
    JavaScript getDobJavaScript();
}
```

Now the internal implementation of it will implement this 'getter' and add a 'setter' for the @flowelement
to use.
```{java}
class StarSignDataInternal extends ElementDataBase implements StarSignData {

    public StarSignDataInternal(Logger logger, FlowData flowData) {
        super(logger, flowData);
    }

    @Override
    public String getStarSign() {
        return getAs("starsign", String.class);
    }

    void setStarSign(String starSign) {
        asKeyMap().put("starsign", starSign);
    }
    
    @Override
    public JavaScript getDobJavaScript() {
        return getAs("dobjavascript", JavaScript.class);
    }

    void setDobJavaScript(JavaScript dobJavaScript) {
        asKeyMap().put("dobjavascript", dobJavaScript);
    }

    @Override
    protected void managedResourcesCleanup() {
        // Nothing to clean up here
    }

    @Override
    protected void unmanagedResourcesCleanup() {
        // Nothing to clean up here
    }
}
```

Note that this concrete implementation of `StarSignData` sits in the same package as the @flowelement,
not the `StarSignData` interface, as it only needs to be accessible by the @flowelement.
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets

# JavaScript

The client-side JavaScript for this example will be fairly simple. It will create a popup asking the user
to enter their date of birth. It will then store the date of birth in a cookie named 'date-of-birth' and
reload the page with the new cookie present. 

The JavaScript to do this looks like:
```{js}
// Ask the user for their data of birth.
var dob = window.prompt('Enter your date of birth.','dd/mm/yyyy');
if (dob != null) {
    // Store it in a cookie.
    document.cookie='date-of-birth='+dob;
    // Reload the page with the new cookie.
    location.reload();
}
```

# Flow Element

Now the actual @flowelement needs to be implemented. For this, the @flowelement's base class
can be used which deals with most of the logic. The @elementproperties,
@evidencekeys and the processing are all that need implementing.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific @flowelement implementation.}
@startsnippet{dotnet}
First let's define a class which extends `FlowElementBase` (and partially implements `IFlowElement`).
This has the type arguments of `IStarSignData` - the interface extending @elementdata which will be 
added to the @flowdata, and  `IElementPropertyMetaData` - as we only need the standard metadata for
@elementproperties.

This needs a constructor matching the `FlowElementBase` class. So it takes a logger, and an
@elementdata factory which will be used to construct an `IStarSignData`:
```{cs}
public class SimpleClientSideElement : FlowElementBase<IStarSignData, IElementPropertyMetaData>
{
    public SimpleClientSideElement(
        ILogger<FlowElementBase<IStarSignData, IElementPropertyMetaData>> logger,
        Func<IFlowData, FlowElementBase<IStarSignData, IElementPropertyMetaData>, IStarSignData> elementDataFactory)
        : base(logger, elementDataFactory)
    {
        Init();
    }

```

The `Init` method in this example will simply initialize a list of star signs with the start and end dates of
each star sign and add each to a list of a new class named `StarSign` which has the following simple implementation:
```{cs}
internal class StarSign
{
    public StarSign(string name, DateTime start, DateTime end)
    {
        Name = name;
        Start = start.AddYears(-start.Year + 1);
        End = end.AddYears(-end.Year + 1);
    }

    public string Name { get; private set; }

    public DateTime Start { get; private set; }

    public DateTime End { get; private set; }
}
```

Note that the year of the start and end date are both set to 1, as the year should be ignored, but
the year 0 cannot be used in a `DateTime`.

The new `Init` method looks like this:

```{cs}
private void Init()
{
    var starSigns = new List<StarSign>();
    foreach (var starSign in _starSignData)
    {
        starSigns.Add(new StarSign(
            starSign[0],
            DateTime.Parse(starSign[1]),
            DateTime.Parse(starSign[2])));
    }
    _starSigns = starSigns;
}
```

Now the abstract methods can be implemented to create a functional @flowelement.
```{cs}
public class SimpleClientSideElement : FlowElementBase<IStarSignData, IElementPropertyMetaData>
{
    public SimpleClientSideElement(
        ILogger<FlowElementBase<IStarSignData, IElementPropertyMetaData>> logger,
        Func<IFlowData, FlowElementBase<IStarSignData, IElementPropertyMetaData>, IStarSignData> elementDataFactory)
        : base(logger, elementDataFactory)
    {
        Init();
    }

    private IList<StarSign> _starSigns;

    private static string[][] _starSignData = {
        new string[3] {"Aries","21/03","19/04"},
        new string[3] {"Taurus","20/04","20/05"},
        new string[3] {"Gemini","21/05","20/06"},
        new string[3] {"Cancer","21/06","22/07"},
        new string[3] {"Leo","23/07","22/08"},
        new string[3] {"Virgo","23/08","22/09"},
        new string[3] {"Libra","23/09","22/10"},
        new string[3] {"Scorpio","23/10","21/11"},
        new string[3] {"Sagittarius","22/11","21/12"},
        new string[3] {"Capricorn","22/12","19/01"},
        new string[3] {"Aquarius","20/01","18/02"},
        new string[3] {"Pisces","19/02","20/03"}
    };

    private void Init()
    {
        var starSigns = new List<StarSign>();
        foreach (var starSign in _starSignData)
        {
            starSigns.Add(new StarSign(
                starSign[0],
                DateTime.Parse(starSign[1]),
                DateTime.Parse(starSign[2])));
        }
        _starSigns = starSigns;
    }

    // The IAgeData will be stored with the key "starsign" in the FlowData.
    public override string ElementDataKey => "starsign";

    // The only item of evidence needed is "date-of-birth".
    public override IEvidenceKeyFilter EvidenceKeyFilter =>
        new EvidenceKeyFilterWhitelist(new List<string>() { "cookie.date-of-birth" });

    public override IList<IElementPropertyMetaData> Properties =>
        new List<IElementPropertyMetaData>()
        {
            // The properties which will be returned are "starsign" and the
            // JavaScript to get the date of birth.
            new ElementPropertyMetaData(this, "starsign", typeof(string), true),
            new ElementPropertyMetaData(this, "dobjavascript", typeof(JavaScript), true)
        };

    protected override void ProcessInternal(IFlowData data)
    {
        DateTime zero = new DateTime(1, 1, 1);
        // Create a new IStarSignData, and cast to StarSignData so the 'setter' is available.
        StarSignData starSignData = (StarSignData)data.GetOrAdd(ElementDataKey, CreateElementData);

        DateTime monthAndDay = new DateTime();
        bool validDateOfBirth = false;
        if (data.TryGetEvidence("cookie.date-of-birth", out DateTime dateOfBirth))
        {
            // "date-of-birth" is there, so parse it.
            monthAndDay = new DateTime(1, dateOfBirth.Month, dateOfBirth.Day);
            validDateOfBirth = true;
        }
        // "date-of-birth" is valid, so set the star sign.
        if (validDateOfBirth)
        {
            foreach (var starSign in _starSigns)
            {
                if (monthAndDay > starSign.Start &&
                    monthAndDay < starSign.End)
                {
                    starSignData.StarSign = starSign.Name;
                    break;
                }
            }
            // No need to run the client side code again.
            starSignData.DobJavaScript = new JavaScript("");
        }
        else
        {
            // "date-of-birth" is not there, so set the star sign to unknown.
            starSignData.StarSign = "Unknown";
            // Set the client side JavaScript to get the date of birth.
            starSignData.DobJavaScript = new JavaScript(
            "var dob = window.prompt('Enter your date of birth.','dd/mm/yyyy');" +
            "if (dob != null) {" +
            "document.cookie='date-of-birth='+dob;" +
            "location.reload();" +
            "}");
        }
    }

    protected override void ManagedResourcesCleanup()
    {
        // Nothing to clean up here.
    }

    protected override void UnmanagedResourcesCleanup()
    {
        // Nothing to clean up here.
    }
}
```
@endsnippet
@startsnippet{java}

First let's define a class which extends `FlowElementBase` (which partially implements `FlowElement`).
This has the type arguments of `StarSignData` - the interface extending @elementdata which will be 
added to the @flowdata, and  `ElementPropertyMetaData` - as we only need the standard metadata for
@elementproperties.

This needs a constructor matching the `FlowElementBase` class. So it takes a logger, and an
@elementdata factory which will be used to construct a `StarSignData`:
```{java}
public class SimpleClientSideElement extends FlowElementBase<AgeData, ElementPropertyMetaData> {

    public SimpleClientSideElement(
        Logger logger,
        ElementDataFactory<StarSignData> elementDataFactory) {
        super(logger, elementDataFactory);
        init();
    }

```

The `init` method in this example will simply initialize a list of star signs with the start and end dates of
each star sign and add each to a list of a new class named `StarSign` which has the following simple implementation:
```{java}
public class StarSign {
    private Calendar end;
    private Calendar start;
    private String name;

    public StarSign(String name, String start, String end) {
        this.name = name;
        this.start = Calendar.getInstance();
        String[] startDate = start.split("/");
        this.start.set(
            0,
            Integer.parseInt(startDate[1]) - 1,
            Integer.parseInt(startDate[0]));
        this.end = Calendar.getInstance();
        String[] endDate = end.split("/");
        this.end.set(
            0,
            Integer.parseInt(endDate[1]) - 1,
            Integer.parseInt(endDate[0]));
    }

    public String getName() {
        return name;
    }

    public Calendar getStart() {
        return start;
    }

    public Calendar getEnd() {
        return end;
    }
}
```

Note that the year of the start and end date are both set to 0, as the year should be ignored.

The new `init` method looks like this:

```{java}
List<StarSign> starSigns = new ArrayList<>();
for (String[] starSign : starSignData) {
    starSigns.add(new StarSign(
        starSign[0],
        starSign[1],
        starSign[2]));
}
this.starSigns = starSigns;
```


Now the abstract methods can be implemented to create a functional @flowelement.
```{java}
public class SimpleClientSideElement extends FlowElementBase<StarSignData, ElementPropertyMetaData> {

    public SimpleClientSideElement(
        Logger logger,
        ElementDataFactory<StarSignData> elementDataFactory) {
        super(logger, elementDataFactory);
        init();
    }

    private static String[][] starSignData = {
        {"Aries","21/03","19/04"},
        {"Taurus","20/04","20/05"},
        {"Gemini","21/05","20/06"},
        {"Cancer","21/06","22/07"},
        {"Leo","23/07","22/08"},
        {"Virgo","23/08","22/09"},
        {"Libra","23/09","22/10"},
        {"Scorpio","23/10","21/11"},
        {"Sagittarius","22/11","21/12"},
        {"Capricorn","22/12","19/01"},
        {"Aquarius","20/01","18/02"},
        {"Pisces","19/02","20/03"}
    };

    private List<StarSign> starSigns;

    private void init() {
        List<StarSign> starSigns = new ArrayList<>();
        for (String[] starSign : starSignData) {
            starSigns.add(new StarSign(
                starSign[0],
                starSign[1],
                starSign[2]));
        }
        this.starSigns = starSigns;
    }

    @Override
    protected void processInternal(FlowData data) throws Exception {
        // Create a new StarSignData, and cast to StarSignDataInternal so the 'setter' is available.
        StarSignDataInternal elementData = (StarSignDataInternal)data.getOrAdd(getElementDataKey(),getDataFactory());

        boolean validDateOfBirth = false;

        TryGetResult<String> dateString = data.tryGetEvidence("cookie.date-of-birth", String.class);
        Calendar monthAndDay = Calendar.getInstance();

        if (dateString.hasValue()) {
            // "date-of-birth" is there, so parse it.
            String[] dateSections = dateString.getValue().split("/");
            try {
                monthAndDay.set(
                    0,
                    Integer.parseInt(dateSections[1]) - 1,
                    Integer.parseInt(dateSections[0]));
                validDateOfBirth = true;
            }
            catch (Exception e) {

            }
        }
        if (validDateOfBirth) {
            // "date-of-birth" is valid, so set the star sign.
            for (StarSign starSign : starSigns) {
                if (monthAndDay.compareTo(starSign.getStart()) >= 0 &&
                    monthAndDay.compareTo(starSign.getEnd()) <= 0) {
                    elementData.setStarSign(starSign.getName());
                    break;
                }
            }
            // No need to run the client side code again.
            elementData.setDobJavaScript(new JavaScript(""));

        }
        else
        {
            // "date-of-birth" is not there, so set the star sign to unknown.
            elementData.setStarSign("Unknown");
            // Set the client side JavaScript to get the date of birth.
            elementData.setDobJavaScript(new JavaScript(
                "var dob = window.prompt('Enter your date of birth.','dd/mm/yyyy');" +
                "if (dob != null) {" +
                "document.cookie='date-of-birth='+dob;" +
                "location.reload();" +
                "}"));
        }
    }

    @Override
    public String getElementDataKey() {
        // The StarSignData will be stored with the key "starsign" in the FlowData.
        return "starsign";
    }

    @Override
    public EvidenceKeyFilter getEvidenceKeyFilter() {
        // The only item of evidence needed is "date-of-birth".
        return new EvidenceKeyFilterWhitelist(Arrays.asList("cookie.date-of-birth"));
    }

    @Override
    public List<ElementPropertyMetaData> getProperties() {
        // The properties which will be returned are "starsign" and the
        // JavaScript to get the date of birth.
        return Arrays.asList(
            (ElementPropertyMetaData)new ElementPropertyMetaDataDefault(
                "starsign",
                this,
                "starsign",
                String.class,
                true),
            (ElementPropertyMetaData)new ElementPropertyMetaDataDefault(
                "dobjavascript",
                this,
                "javascript",
                JavaScript.class,
                true));
    }

    @Override
    protected void managedResourcesCleanup() {
        // Nothing to clean up here.
    }

    @Override
    protected void unmanagedResourcesCleanup() {
        // Nothing to clean up here.
    }
}
```
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets


# Builder

Now the @flowelement needs one final thing, an @elementbuilder to construct it.
This only needs to provide the @flowelement with a logger and an @elementdata factory -
as this example has no extra configuration options.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific @elementbuilder implementation.}
@startsnippet{dotnet}
The @elementbuilder has one important method, and that is `Build`. This returns a new @flowelement
which the @elementbuilder provides with a logger and an @elementdata factory.

The @elementdata factory is implemented in the @elementbuilder class to make use of the same
logger factory.
```{cs}
[AlternateName("SimpleClientSideElement")]
public class SimpleClientSideElementBuilder
{
    private ILoggerFactory _loggerFactory;

    public SimpleClientSideElementBuilder(ILoggerFactory loggerFactory)
    {
        _loggerFactory = loggerFactory;
    }

    public SimpleClientSideElement Build()
    {
        return new SimpleClientSideElement(
            _loggerFactory.CreateLogger<SimpleClientSideElement>(),
            CreateData);
    }

    // This is the element data factory, and is called in the Process method of the element.
    public IStarSignData CreateData(IFlowData flowData, FlowElementBase<IStarSignData,IElementPropertyMetaData> element)
    {
        return new StarSignData(_loggerFactory.CreateLogger<StarSignData>(), flowData);
    }
}
```
@endsnippet
@startsnippet{java}
The @elementbuilder has one important method, and that is `build`. This returns a new @flowelement
which the @elementbuilder provides with a logger and an @elementdata factory.

The @elementdata factory is implemented in the @elementbuilder class to make use of the same
logger factory.
```{java}
@ElementBuilder(alternateName = "SimpleClientSideElement")
public class SimpleClientSideElementBuilder {
    private final ILoggerFactory loggerFactory;

    public SimpleClientSideElementBuilder(ILoggerFactory loggerFactory) {
        this.loggerFactory = loggerFactory;
    }

    public SimpleClientSideElement build() {
        return new SimpleClientSideElement(
            loggerFactory.getLogger(SimpleClientSideElement.class.getName()),
            new ElementDataFactory<StarSignData>() {
                @Override
                public StarSignData create(
                    FlowData flowData,
                    FlowElement<StarSignData, ?> flowElement) {
                    return new StarSignDataInternal(
                        loggerFactory.getLogger(StarSignDataInternal.class.getName()),
                        flowData);
                }
            });
    }
}
```
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets

# Usage

As this example gathers its @evidence using client-side JavaScript, it will need to be run in
a web environment. Using a @webintegration will mean that the @flowelement can be added, and the
client-side JavaScript automatically run.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific usage.}
@startsnippet{dotnet}
Using a ASP.NET Core project (full example included in the source), a [pipeline configuration](@ref Concepts_Configuration_Builders_BuildFromConfiguration) file can be
added to the 'appsettings.json' to load the new @flowelement and a 'JavaScriptBundlerElement' to
include the client-side JavaScript:
```{json}
{
  ...
  "PipelineOptions": {
    "Elements": [
      {
        "BuilderName": "SimpleClientSideElement"
      },
      {
        "BuilderName": "JavaScriptBundlerElement"
      }
    ]
  }
}
```

Then a simple view can be added which includes '51Degrees.core.js' to run the JavaScript, and displays
the message which is passed from the controller:
```{html}
@{
    ViewData["Title"] = "Home Page";
}

<script type="application/javascript"  src="~/51Degrees.core.js"></script>

<div class="row">
    @ViewData["message"]
</div>
```

The message is constructed in the controller in the same way as in the [previous example](@ref Examples_CustomElement_FlowElement):
```{cs}
public class HomeController : Controller
{
    private IFlowDataProvider _flowDataProvider;

    public HomeController(IFlowDataProvider flowDataProvider)
    {
        _flowDataProvider = flowDataProvider;
    }

    public IActionResult Index()
    {
        var flowData = _flowDataProvider.GetFlowData();

        ViewData["message"] = $"With a date of birth of" +
            $" {flowData.GetEvidence()["cookie.date-of-birth"]}," +
            $" your star sign is" +
            $" {flowData.Get<IStarSignData>().StarSign}.";
        return View();
    }
}
```

@endsnippet
@startsnippet{java}
Using a Spring MVC project (full example included in the source), a [pipeline configuration](@ref Concepts_Configuration_Builders_BuildFromConfiguration) file
can be added to load the new @flowelement and a 'JavaScriptBundlerElement' to include the client-side
JavaScript:
```{xml}
<PipelineOptions>
    <Elements>
        <Element>
            <BuilderName>SimpleClientSideElement</BuilderName>
        </Element>
        <Element>
            <BuilderName>JavaScriptBundlerElement</BuilderName>
        </Element>
    </Elements>
</PipelineOptions>
```

Then a simple view can be added which includes '51Degrees.core.js' to run the JavaScript, and displays
the star sign which is passed from the controller:
```{html}
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Example page</title>
<script src="/simple-clientside-element-mvc/51Degrees.core.js"></script>
</head>
<body>
    <p>${message}</p>
</body>
</html>
```
The message is constructed in the controller in the same way as in the [previous example](@ref Examples_CustomElement_FlowElement):
```{java}
@Controller
@RequestMapping("/")
public class ExampleController {

    private FlowDataProvider flowDataProvider;

    @Autowired
    public ExampleController(FlowDataProvider flowDataProvider) {
        this.flowDataProvider = flowDataProvider;
    }

    @RequestMapping(method = RequestMethod.GET)
    public String get(ModelMap model, HttpServletRequest request) {
        FlowData data = flowDataProvider.getFlowData(request);

        model.addAttribute(
            "message",
            "With a date of birth of " +
        data.getEvidence().get("cookie.date-of-birth") +
        ", your star sign is " +
        data.get(StarSignData.class).getStarSign());
        return "example";
    }
}
```
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets

# Next Steps
The examples for [Custom On-premise Engine](@ref Examples_CustomElement_OnPremise) and [Custom Cloud Engine](@ref Examples_CustomElement_Cloud) show how you can extend the functionality of this **flow element** to use a @datafile rather than hard coded values.
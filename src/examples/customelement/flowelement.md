@page Examples_CustomElement_FlowElement Simple Custom Flow Element

# Introduction

This example shows a very simple @flowelement which takes a date of birth
and returns an star sign. Although a basic (and not all that useful) @flowelement, the
example demonstrates how you can start to implement your own @flowelement's.

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
have its own 'getter' in its @elementdata.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific @elementdata implementation.}
@startsnippet{dotnet}
.NET supports interfaces, so the @elementdata should have a public interface and an internal
concrete implementation with easy 'setters'.

In this example, only one value is populated. So an interface `IStarSign` will extend `IElementDataReadOnly`
to add a 'getter' for it.
```{cs}
public interface IStarSignData : IElementDataReadOnly
{
    string StarSign { get; }
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

In this example, only one value is populated. So an interface `StarSignData` will extend `ElementDataReadOnly`
to add a 'getter' for it.
```{java}
public interface StarSignData extends ElementDataReadOnly {
    String getStarSign();
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
public class SimpleFlowElement : FlowElementBase<IStarSignData, IElementPropertyMetaData>
{
    public SimpleFlowElement(
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
public class SimpleFlowElement : FlowElementBase<IStarSignData, IElementPropertyMetaData>
{
    public SimpleFlowElement(
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
        new EvidenceKeyFilterWhitelist(new List<string>() { "date-of-birth" });

    public override IList<IElementPropertyMetaData> Properties =>
        new List<IElementPropertyMetaData>()
        {
            // The only property which will be returned is "starsign" which will be
            // a string.
            new ElementPropertyMetaData(this, "starsign", typeof(string), true)
        };

    protected override void ProcessInternal(IFlowData data)
    {
        DateTime zero = new DateTime(1, 1, 1);
        // Create a new IStarSignData, and cast to StarSignData so the 'setter' is available.
        StarSignData ageData = (StarSignData)data.GetOrAdd(ElementDataKey, CreateElementData);

        if (data.TryGetEvidence("date-of-birth", out DateTime dateOfBirth))
        {
            // "date-of-birth" is there, so set the star sign.
            var monthAndDay = new DateTime(1, dateOfBirth.Month, dateOfBirth.Day);
            foreach (var starSign in _starSigns)
            {
                if (monthAndDay > starSign.Start &&
                    monthAndDay < starSign.End)
                {
                    ageData.StarSign = starSign.Name;
                    break;
                }
            }
        }
        else
        {
            // "date-of-birth" is not there, so set the star sign to unknown.
            ageData.StarSign = "Unknown";
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
public class SimpleFlowElement extends FlowElementBase<AgeData, ElementPropertyMetaData> {

    public SimpleFlowElement(
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
public class SimpleFlowElement extends FlowElementBase<StarSignData, ElementPropertyMetaData> {

    public SimpleFlowElement(
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

        TryGetResult<Date> date = data.tryGetEvidence("date-of-birth", Date.class);
        if (date.hasValue()) {
            // "date-of-birth" is there, so set the star sign.
            Calendar dob = Calendar.getInstance();
            dob.setTime(date.getValue());
            Calendar monthAndDay = Calendar.getInstance();
            monthAndDay.set(
                0,
                dob.get(Calendar.MONTH),
                dob.get(Calendar.DATE));
            for (StarSign starSign : starSigns) {
                if (monthAndDay.compareTo(starSign.getStart()) >= 0 &&
                    monthAndDay.compareTo(starSign.getEnd()) <= 0) {
                    elementData.setStarSign(starSign.getName());
                    break;
                }
            }
        }
        else
        {
            // "date-of-birth" is not there, so set the star sign to unknown.
            elementData.setStarSign("Unknown");
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
        return new EvidenceKeyFilterWhitelist(Arrays.asList("date-of-birth"));
    }

    @Override
    public List<ElementPropertyMetaData> getProperties() {
        // The only property which will be returned is "starsign" which will be
        // an String.
        return Arrays.asList(
            (ElementPropertyMetaData)new ElementPropertyMetaDataDefault(
                "starsign",
                this,
                "starsign",
                String.class,
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
public class SimpleFlowElementBuilder
{
    private ILoggerFactory _loggerFactory;

    public SimpleFlowElementBuilder(ILoggerFactory loggerFactory)
    {
        _loggerFactory = loggerFactory;
    }

    public SimpleFlowElement Build()
    {
        return new SimpleFlowElement(
            _loggerFactory.CreateLogger<SimpleFlowElement>(),
            CreateData);
    }

    // This is the element data factory, and is called in the Process method of the element.
    public IStarSignData CreateData(
        IFlowData flowData,
        FlowElementBase<IStarSignData,IElementPropertyMetaData> element)
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
public class SimpleFlowElementBuilder {
    private final ILoggerFactory loggerFactory;

    public SimpleFlowElementBuilder(ILoggerFactory loggerFactory) {
        this.loggerFactory = loggerFactory;
    }

    public SimpleFlowElement build() {
        return new SimpleFlowElement(
            loggerFactory.getLogger(SimpleFlowElement.class.getName()),
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

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific usage.}
@startsnippet{dotnet}
This new @flowelement can now be added to a @pipeline and used like:
```{cs}
var starSignElement = new SimpleFlowElementBuilder(_loggerFactory)
    .Build();
var pipeline = new PipelineBuilder(_loggerFactory)
    .AddFlowElement(starSignElement)
    .Build();
var dob = new DateTime(1992, 12, 18);
var flowData = pipeline.CreateFlowData();
flowData
    .AddEvidence("date-of-birth", dob)
    .Process();
Console.WriteLine($"With a date of birth of " +
    $"{dob.ToString("dd/MM/yyyy")}" +
    $", your star sign is " +
    $"{flowData.GetFromElement(starSignElement).StarSign}.");
```

to give an output of:
```{bash}
With a date of birth of 18/12/1992, your star sign is Sagittarius.
```
@endsnippet
@startsnippet{java}
This new @flowelement can now be added to a @pipeline and used like:
```{java}
SimpleFlowElement starSignElement =
    new SimpleFlowElementBuilder(loggerFactory)
    .build();

Pipeline pipeline = new PipelineBuilder(loggerFactory)
    .addFlowElement(starSignElement)
    .build();
Calendar dob = Calendar.getInstance();
dob.set(1992, Calendar.DECEMBER, 18);

FlowData flowData = pipeline.createFlowData();
flowData
    .addEvidence("date-of-birth", dob.getTime())
    .process();

System.out.println("With a date of birth of " +
    new SimpleDateFormat("yyyy/MM/dd").format(dob.getTime()) +
    ", your star sign is " +
    flowData.getFromElement(starSignElement).getStarSign() + ".");
```

to give an output of:
```{bash}
With a date of birth of 18/12/1992, your star sign is Sagittarius.
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

To increase the functionality of this **flow element** to use a @datafile, see the next examples:
[Custom On-premise Engine](@ref Examples_CustomElement_OnPremise) and [Custom Cloud Engine](@ref Examples_CustomElement_Cloud).
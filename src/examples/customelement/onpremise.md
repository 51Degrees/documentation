@page Examples_CustomElement_OnPremise Custom On-Premise Engine

# Introduction

This example takes the very simple @flowelement described in the
[simple flow element example](@ref Examples_CustomElement_FlowElement), and adds
a @datafile, upgrading the @flowelement to an @aspectengine. 

Instead of storing data statically, as the [simple flow element example](@ref Examples_CustomElement_FlowElement)
did, this example will store it in a @datafile which will be loaded, and can be updated.
# Download Example

The source code used in this example is available here:
- [C# Visual Studio project **todo**]()
- [Java project **todo**]()
- [PHP project **todo**]()
- [Node.js project **todo**]()

# Dependencies

The @aspectengine will need a dependency on the @pipeline engines package now
it is implementing an @aspectengine instead of a @flowelement

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific dependencies.}
@startsnippet{dotnet}
The only dependency needed for .NET is the `FiftyOne.Pipeline.Engines` NuGet package.
@endsnippet
@startsnippet{java}
The only dependency needed for Java is the `pipeline.engines` Maven package from `com.51degrees`.
To include this, add the following to the `<dependencies>` section of the project's `pom.xml`:
```{xml}
<dependency>
    <groupId>com.51degrees</groupId>
    <artifactId>pipeline.engines</artifactId>
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

The @elementdata implemented in the previous example can now be upgraded to implement an
@aspectdata.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific @aspectdata implementation.}
@startsnippet{dotnet}
Instead of implementing `IElementDataReadOnly`, the `IStarSignData` will now implement `IAspectData`
which extends `IElementDataReadOnly`.
```{cs}
//public interface IStarSignData : IElementDataReadOnly
public interface IStarSignData : IAspectData
{
    string StarSign { get; }
}
```

Now the internal implementation of it will implement a 'getter' and add a 'setter' for `StarSign` in the
same way as the [previous example](@ref Examples_CustomElement_FlowElement).
```{cs}
//internal class StarSignData : ElementDataBase, IStarSignData
internal class StarSignData : AspectDataBase, IStarSignData
{
    public StarSignData(
        ILogger<AspectDataBase> logger,
        IFlowData flowData,
        IAspectEngine engine,
        IMissingPropertyService missingPropertyService)
        : base(logger, flowData, engine, missingPropertyService)
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
Instead of implementing `ElementDataReadOnly`, the `StarSignData` will now implement `AspectData`
which extends `ElementDataReadOnly`.
```{java}
//public interface StarSignData : ElementDataReadOnly
public interface StarSignData extends AspectData {

    String getStarSign();
}
```

Now the internal implementation of it will implement a 'getter' and add a 'setter' for `StarSign` in the
same way as the [previous example](@ref Examples_CustomElement_FlowElement).
```{java}
//class StarSignDataInternal extends ElementDataBase implements StarSignData {
class StarSignDataInternal extends AspectDataBase implements StarSignData {

    public StarSignDataInternal(
        Logger logger,
        FlowData flowData,
        AspectEngine engine,
        MissingPropertyService missingPropertyService) {
        super(logger, flowData, engine, missingPropertyService);
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

Note that this concrete implementation of `StarSignData` sits in the same package as the @aspectengine,
not the `StarSignData` interface, as it only needs to be accessible by the @aspectengine.
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets


# Aspect Engine

Now the actual @aspectengine needs to be implemented. For this, the class from the
[previous example](@ref Examples_CustomElement_FlowElement) will now implement the
@onpremiseengine's base class.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific @aspectengine implementation.}
@startsnippet{dotnet}
First let's change the class to extend `OnPremiseAspectEngineBase` (which partially implements
`IOnPremiseAspectEngine`). This has the type arguments of
`IStarSignData` - the interface extending @aspectdata which will be added to the @flowdata, and 
`IAspectPropertyMetaData` - instead of `IElementPropertyMetaData`.

The existing constructor needs to change to match the `OnPremiseAspectEngineBase` class. So it takes
the additional arguments of a @datafile path, and a temporary @datafile path. This is the location of the @datafile
that the @aspectengine will use, and where to make a temporary copy if required.

The constructor will also read the @datafile containing the star signs into memory. This is done in another
method so that it can also be used by the `RefreshData` method when a new @datafile is downloaded (this is not
applicable for this example as star sign data will not change).
```{cs}
//public class SimpleFlowElement : FlowElementBase<IStarSignData, IElementPropertyMetaData>
public class SimpleOnPremiseEngine : OnPremiseAspectEngineBase<IStarSignData, IAspectPropertyMetaData>
{
    public SimpleOnPremiseEngine(
        string dataFilePath,
        ILogger<AspectEngineBase<IStarSignData, IAspectPropertyMetaData>> logger,
        Func<IFlowData, FlowElementBase<IStarSignData, IAspectPropertyMetaData>, IStarSignData> aspectDataFactory,
        string tempDataFilePath)
        : base(logger, aspectDataFactory, tempDataFilePath)
    {
        _dataFile = datafilePath;
        Init();
    }
}
```

The `Init` method in this example will simply read a CSV file with the start and end dates of each
star sign, which looks like:
```{csv}
Aries,21/03,19/04
Taurus,20/04,20/05
Gemini,21/05,20/06
Cancer,21/06,22/07
...
```

and add each to a list of a new class named `StarSign` which has the following simple implementation:
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
    using (TextReader reader = File.OpenText(_dataFile))
    {
        string line = reader.ReadLine();
        while (line != null)
        {
            var columns = line.Split(',');
            starSigns.Add(new StarSign(
                columns[0],
                DateTime.Parse(columns[1]),
                DateTime.Parse(columns[2])));

            line = reader.ReadLine();
        }
    }
    _starSigns = starSigns;
}
```


Now the abstract methods can be implemented to create a functional @aspectengine.
```{cs}
public class SimpleOnPremiseEngine : OnPremiseAspectEngineBase<IStarSignData, IAspectPropertyMetaData>
{
    public SimpleOnPremiseEngine(
        string dataFilePath,
        ILogger<AspectEngineBase<IStarSignData, IAspectPropertyMetaData>> logger,
        Func<IFlowData, FlowElementBase<IStarSignData, IAspectPropertyMetaData>, IStarSignData> aspectDataFactory,
        string tempDataFilePath)
        : base(logger, aspectDataFactory, tempDataFilePath)
    {
        _dataFile = dataFilePath;
        Init();
    }

    private string _dataFile;

    private IList<StarSign> _starSigns;

    private void Init()
    {
        var starSigns = new List<StarSign>();
        using (TextReader reader = File.OpenText(_dataFile))
        {
            string line = reader.ReadLine();
            while (line != null)
            {
                var columns = line.Split(',');
                starSigns.Add(new StarSign(
                    columns[0],
                    DateTime.Parse(columns[1]),
                    DateTime.Parse(columns[2])));

                line = reader.ReadLine();
            }
        }
        _starSigns = starSigns;
    }

    // The IAgeData will be stored with the key "age" in the FlowData.
    public override string ElementDataKey => "age";

    // The only item of evidence needed is "date-of-birth".
    public override IEvidenceKeyFilter EvidenceKeyFilter =>
        new EvidenceKeyFilterWhitelist(new List<string>() { "date-of-birth" });

    public override IList<IAspectPropertyMetaData> Properties => new List<IAspectPropertyMetaData>() {
        // The only property which will be returned is "starsign" which will be
        // a string.
        new AspectPropertyMetaData(this, "starsign", typeof(string), "starsign", new List<string>(){"free"}, true),
    };

    // The data file is free.
    public override string DataSourceTier => "free";

    public override DateTime GetDataFilePublishedDate(string dataFileIdentifier = null)
    {
        return DataFiles[0].DataPublishedDateTime;
    }

    public override DateTime GetDataFileUpdateAvailableTime(string dataFileIdentifier = null)
    {
        // Just return a date which will never be reached as this will never
        // need updating.
        return DateTime.MaxValue;
    }

    public override void RefreshData()
    {
        // Reload star signs from the data file.
        Init();
    }

    public override void RefreshData(string dataFileIdentifier)
    {
        // Reload star signs from the data file.
        Init();
    }

    public override void RefreshData(string dataFileIdentifier, byte[] data)
    {
        // We won't implement this logic in this example.
        throw new NotImplementedException();
    }

    protected override void ProcessEngine(IFlowData data, IStarSignData aspectData)
    {
        DateTime zero = new DateTime(1, 1, 1);
        // Cast aspectData to AgeData so the 'setter' is available.
        StarSignData starSignData = (StarSignData)aspectData;

        if (data.TryGetEvidence("date-of-birth", out DateTime dateOfBirth))
        {
            // "date-of-birth" is there, so set the star sign.
            var monthAndDay = new DateTime(1, dateOfBirth.Month, dateOfBirth.Day);
            foreach (var starSign in _starSigns)
            {
                if (monthAndDay > starSign.Start &&
                    monthAndDay < starSign.End)
                {
                    starSignData.StarSign = starSign.Name;
                    break;
                }
            }
        }
        else
        {
            // "date-of-birth" is not there, so set the star sign to unknown.
            starSignData.StarSign = "Unknown";
        }
    }

    protected override void UnmanagedResourcesCleanup()
    {
        // Nothing to clean up here.
    }
}
```
@endsnippet
@startsnippet{java}
First let's change the class to extend `OnPremiseAspectEngineBase` (which partially implements
`OnPremiseAspectEngine`). This has the type arguments of
`StarSignData` - the interface extending @aspectdata which will be added to the @flowdata, and 
`AspectPropertyMetaData` - instead of `ElementPropertyMetaData`.

The existing constructor needs to change to match the `OnPremiseAspectEngineBase` class. So it takes
the additional arguments of a @datafile path, and a temporary @datafile path. This is  the location of the @datafile
that the @aspectengine will use, and where to make a temporary copy if required.

The constructor will also read the @datafile containing the star signs into memory. This is done in another
method so that it can also be used by the `refreshData` method when a new @datafile is downloaded (this is not
applicable for this example as star sign data is static).
```{java}
//public class SimpleFlowElement extends FlowElementBase<StarSignData, ElementPropertyMetaData> {
public class SimpleOnPremiseEngine extends OnPremiseAspectEngineBase<StarSignData, AspectPropertyMetaData> {

    public SimpleOnPremiseEngine(
        String dataFile,
        Logger logger,
        ElementDataFactory<StarSignData> elementDataFactory,
        String tempDir) throws IOException {
        super(logger, elementDataFactory, tempDir);
        this.dataFile = dataFile;
        init();
    }
```

The `init` method in this example will simply read a CSV file with the start and end dates of each
star sign, which looks like:
```{csv}
Aries,21/03,19/04
Taurus,20/04,20/05
Gemini,21/05,20/06
Cancer,21/06,22/07
...
```

and add each to a list of a new class named `StarSign` which has the following simple implementation:
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
private void init() throws IOException {
    List<StarSign> starSigns = new ArrayList<>();
    try (FileReader fileReader = new FileReader(dataFile)) {
        try (BufferedReader reader = new BufferedReader(fileReader)) {
            String line = null;
            while ((line = reader.readLine()) != null) {
                String[] columns = line.split(",");
                starSigns.add(new StarSign(
                    columns[0],
                    columns[1],
                    columns[2]));
            }
        }
    }
    this.starSigns = starSigns;
}
```


Now the abstract methods can be implemented to create a functional @aspectengine.
```{java}
public class SimpleOnPremiseEngine extends OnPremiseAspectEngineBase<StarSignData, AspectPropertyMetaData> {

    public SimpleOnPremiseEngine(
        String dataFile,
        Logger logger,
        ElementDataFactory<StarSignData> elementDataFactory,
        String tempDir) throws IOException {
        super(logger, elementDataFactory, tempDir);
        this.dataFile = dataFile;
        init();
    }

    private String dataFile;

    private List<StarSign> starSigns;

    private void init() throws IOException {
        List<StarSign> starSigns = new ArrayList<>();
        try (FileReader fileReader = new FileReader(dataFile)) {
            try (BufferedReader reader = new BufferedReader(fileReader)) {
                String line = null;
                while ((line = reader.readLine()) != null) {
                    String[] columns = line.split(",");
                    starSigns.add(new StarSign(
                        columns[0],
                        columns[1],
                        columns[2]));
                }
            }
        }
        this.starSigns = starSigns;
    }


    @Override
    public String getTempDataDirPath() {
        return dataFile;
    }

    @Override
    public Date getDataFilePublishedDate(String dataFileIdentifier) {
        return null;
    }

    @Override
    public Date getDataFileUpdateAvailableTime(String dataFileIdentifier) {
        return null;
    }

    @Override
    public void refreshData() {
        try {
            init();
        } catch (IOException e) {

        }
    }

    @Override
    public void refreshData(String dataFileIdentifier) {
        try {
            init();
        } catch (IOException e) {

        }
    }

    @Override
    public void refreshData(String dataFileIdentifier, byte[] data) {
        // Lets not implement this logic in this example.
    }

    @Override
    protected void processEngine(FlowData data, StarSignData aspectData) throws Exception {
        // Cast the StarSignData to StarSignDataInternal so the 'setter' is available.
        StarSignDataInternal starSignData = (StarSignDataInternal)aspectData;

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
                    starSignData.setStarSign(starSign.getName());
                    break;
                }
            }
        }
        else
        {
            // "date-of-birth" is not there, so set the star sign to unknown.
            starSignData.setStarSign("Unknown");
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
    public List<AspectPropertyMetaData> getProperties() {
        // The only property which will be returned is "starsign" which will be
        // an String.
        return Arrays.asList(
            (AspectPropertyMetaData)new AspectPropertyMetaDataDefault(
                "starsign",
                this,
                "starsign",
                String.class,
                Arrays.asList("free"),
                true));
    }

    @Override
    public String getDataSourceTier() {
        return "free";
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

Now the @aspectengine needs one final thing, an @elementbuilder to construct it.
This needs to provide the @aspectengine with a logger and an @aspectdata factory as in
the previous example. However, it also now needs a data file.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific @elementbuilder implementation.}
@startsnippet{dotnet}
As this @aspectengine is using a @datafile, the builder can make use of the logic in the
`SingleFileAspectEngineBuilderBase`.
```{cs}
public class SimpleOnPremiseEngineBuilder : SingleFileAspectEngineBuilderBase<SimpleOnPremiseEngineBuilder, SimpleOnPremiseEngine>
{
    public SimpleOnPremiseEngineBuilder(
        ILoggerFactory loggerFactory,
        IDataUpdateService dataUpdateService) : base(dataUpdateService)
    {
        _loggerFactory = loggerFactory;
    }

    private ILoggerFactory _loggerFactory;

    public override SimpleOnPremiseEngineBuilder SetPerformanceProfile(PerformanceProfiles profile)
    {
        throw new NotImplementedException();
    }

    protected override SimpleOnPremiseEngine BuildEngine(string tempPath, List<string> properties)
    {
        if (DataFileConfigs.Count != 1)
        {
            throw new Exception(
                "This builder requires one and only one configured file " +
                $"but it has {DataFileConfigs.Count}");
        }
        var config = DataFileConfigs.First();

        return new SimpleOnPremiseEngine(
            config.DataFilePath,
            _loggerFactory.CreateLogger<SimpleOnPremiseEngine>(),
            CreateData,
            TempDir);
    }
    public IStarSignData CreateData(
        IFlowData flowData,
        FlowElementBase<IStarSignData, IAspectPropertyMetaData> aspectEngine)
    {
        return new StarSignData(
            _loggerFactory.CreateLogger<StarSignData>(),
            flowData,
            (SimpleOnPremiseEngine)aspectEngine,
            MissingPropertyService.Instance);
    }
}
```
@endsnippet
@startsnippet{java}
As this @aspectengine is using a @datafile, the builder can make use of the logic in the
`SingleFileAspectEngineBuilderBase`.
```{java}
public class SimpleOnPremiseEngineBuilder
    extends SingleFileAspectEngineBuilderBase<
        SimpleOnPremiseEngineBuilder,
        SimpleOnPremiseEngine> {

    public SimpleOnPremiseEngineBuilder(ILoggerFactory loggerFactory) {
        super(loggerFactory);
    }

    @Override
    public SimpleOnPremiseEngineBuilder setPerformanceProfile(Constants.PerformanceProfiles profile) {
        // Lets not implement multiple performance profiles in this example.
        return this;
    }

    @Override
    protected SimpleOnPremiseEngine buildEngine(String tempPath, List<String> properties) {
        if (dataFileConfigs.size() != 1)
        {
            throw new RuntimeException(
                "This builder requires one and only one configured file " +
                    "but it has " + dataFileConfigs.size());
        }
        DataFileConfiguration config = dataFileConfigs.get(0);

        try {
            return new SimpleOnPremiseEngine(
                config.getDataFilePath(),
                loggerFactory.getLogger(SimpleOnPremiseEngine.class.getName()),
                new ElementDataFactory<StarSignData>() {
                    @Override
                    public StarSignData create(
                        FlowData flowData,
                        FlowElement<StarSignData, ?> flowElement) {
                        return new StarSignDataInternal(
                            loggerFactory.getLogger(StarSignDataInternal.class.getName()),
                            flowData,
                            (SimpleOnPremiseEngine)flowElement,
                            MissingPropertyServiceDefault.getInstance());
                    }
                },
                tempDir);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
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
This new @aspectengine can now be added to a @pipeline and used like:
```{cs}
var starSignEngine = new SimpleOnPremiseEngineBuilder(_loggerFactory, null)
    .SetAutoUpdate(false)
    .Build("starsigns.csv", false);
var pipeline = new PipelineBuilder(_loggerFactory)
    .AddFlowElement(starSignEngine)
    .Build();
var dob = new DateTime(1992, 12, 18);
var flowData = pipeline.CreateFlowData();
flowData
    .AddEvidence("date-of-birth", dob)
    .Process();
Console.WriteLine($"With a date of birth of {dob}, " +
    $"your star sign is {flowData.GetFromElement(starSignEngine).StarSign}.");
```

to give an output of:
```{bash}
With a date of birth of 18/12/1992, your star sign is Sagittarius.
```
@endsnippet
@startsnippet{java}
This new @aspectengine can now be added to a @pipeline and used like:
```{java}
SimpleOnPremiseEngine starSignEngine =
    new SimpleOnPremiseEngineBuilder(loggerFactory)
    .setAutoUpdate(false)
    .build(
        Main.class.getClassLoader().getResource("starsigns.csv").getPath(),
        false);

Pipeline pipeline = new PipelineBuilder(loggerFactory)
    .addFlowElement(starSignEngine)
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
    flowData.getFromElement(starSignEngine).getStarSign() + ".");
```

to give an output of:
```{bash}
With a date of birth of 18/12/1992, your tar sign is Sagittarius.
```
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets
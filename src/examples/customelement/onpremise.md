@page Examples_CustomElement_OnPremise Custom On-Premise Engine

# Introduction

This example takes the very simple @flowelement described in the
[simple flow element example](@ref Examples_CustomElement_GettingStarted), and adds
a @datafile, upgrading the @flowelement to an @aspectengine, to provide additional properties.

To follow this example, the reader should be familiar with the previous [example](@ref Examples_CustomElement_GettingStarted).

The previous example took a date of birth, and returned an age. This example will add a @datafile
containing star signs to provide the extra property 'star sign'.


# Download Example

The source code used in this example is available here:
- [C# Visual Studio project **todo**]()
- [Java project **todo**]()
- [PHP project **todo**]()
- [Node.js project **todo**]()

# Dependencies

The @aspectengine will need to a dependency on the @pipeline engines package now that
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
Instead of implementing `IElementDataReadOnly`, the `IAgeData` will now implement `IAspectData`
which extends `IElementDataReadOnly`. A 'getter' is also added for the new property.
```{cs}

//public interface IAgeData : IElementDataReadOnly
public interface IAgeData : IAspectData
{
    int Age { get; }
    string StarSign { get; }
}
```

Now the internal implementation of it will implement a 'getter' and add an 'setter' for `StarSign` in the
same way as `Age`.
```{cs}
//internal class AgeData : ElementDataBase, IAgeData
internal class AgeData : AspectDataBase, IAgeData
{
    public AgeData(
        ILogger<AspectDataBase> logger,
        IFlowData flowData,
        IAspectEngine engine,
        IMissingPropertyService missingPropertyService)
        : base(logger, flowData, engine, missingPropertyService)
    {
    }

    public int Age
    {
        // Get the age from the internal IDictionary as an int.
        get { return GetAs<int>("age"); }
        // Add the age to the internal IDictionary.
        set { AsDictionary().Add("age", value); }
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
**todo**
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets


# Aspect Engine

Now the actual @aspectengine needs to be implemented. For this, the class from the previous
example will now implement the @onpremiseengine's base class.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific @aspectengine implementation.}
@startsnippet{dotnet}
First lets change the class to extend `OnPremiseAspectEngineBase` (which partially implements
`IOnPremiseAspectEngine`). This has the type arguments of
`IAgeData` - the interface extending @aspectdata which will be added to the @flowdata, and 
`IAspectPropertyMetaData` instead of `IElementPropertyMetaData`.

The existing constructor needs to change to match the `OnPremiseAspectEngineBase` class. So it takes
the additional arguments of a @datafile path, and a temporary @datafile path. This is where the @datafile
will that the @aspectengine will use, and the location to make a temporary copy if required.

The constructor will also read the @datafile containing the star signs into memory. This is done in another
method so that it can also be used by the `RefreshData` method when a new @datafile is downloaded (this will
not happen in this example as it is only star signs).
```{cs}
//public class SimpleFlowElement : FlowElementBase<IAgeData, IElementPropertyMetaData>
public class SimpleOnPremiseEngine : OnPremiseAspectEngineBase<IAgeData, IAspectPropertyMetaData>
{
    public SimpleOnPremiseEngine(
        string dataFilePath,
        ILogger<AspectEngineBase<IAgeData, IAspectPropertyMetaData>> logger,
        Func<IFlowData, FlowElementBase<IAgeData, IAspectPropertyMetaData>, IAgeData> aspectDataFactory,
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
public class SimpleOnPremiseEngine : OnPremiseAspectEngineBase<IAgeData, IAspectPropertyMetaData>
{
    public SimpleOnPremiseEngine(
        string dataFilePath,
        ILogger<AspectEngineBase<IAgeData, IAspectPropertyMetaData>> logger,
        Func<IFlowData, FlowElementBase<IAgeData, IAspectPropertyMetaData>, IAgeData> aspectDataFactory,
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

    // These properties now implement IAspectPropertyMetaData.
    public override IList<IAspectPropertyMetaData> Properties => new List<IAspectPropertyMetaData>() {
        // The age property.
        new AspectPropertyMetaData(this, "age", typeof(int), "age", new List<string>(){"free"}, true),
        // The new star sign property.
        new AspectPropertyMetaData(this, "starsign", typeof(string), "age", new List<string>(){"free"}, true),
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

    protected override void ProcessEngine(IFlowData data, IAgeData aspectData)
    {
        DateTime zero = new DateTime(1, 1, 1);
        // Create a new IAgeData, and cast to AgeData so the 'setter' is available.
        AgeData ageData = (AgeData)data.GetOrAdd(ElementDataKey, CreateElementData);

        if (data.TryGetEvidence("date-of-birth", out DateTime dateOfBirth))
        {
            // "date-of-birth" is there, so set the age and star sign.
            ageData.Age = (zero + (DateTime.Now - dateOfBirth)).Year - 1;
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
            // "date-of-birth" is not there, so set the properties to defaults.
            ageData.Age = -1;
            ageData.StarSign = "Unknown";
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
**todo**
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets


# Builder

Now the @aspectengine needs one final thing. An @elementbuilder to construct it.
This needs to provide the @aspectengine with a logger and an @aspectdata factory, as in
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
        // Lets not implement multiple performance profiles in this example.
        throw new NotImplementedException();
    }

    // This method is called by the Build method in the base class which contains
    // general logic.
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
    // This is the aspect data factory, and is called in the Process method of the engine.
    public IAgeData CreateData(
        IFlowData flowData,
        FlowElementBase<IAgeData, IAspectPropertyMetaData> aspectEngine)
    {
        return new AgeData(
            _loggerFactory.CreateLogger<AgeData>(),
            flowData,
            (SimpleOnPremiseEngine)aspectEngine,
            MissingPropertyService.Instance);
    }
}
```
@endsnippet
@startsnippet{java}
**todo**
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets
@page Examples_CustomElement_OnPremise Custom On-Premise Engine

# Introduction

This example takes the very simple @flowelement described in the
[simple flow element example](@ref Examples_CustomElement_GettingStarted), and adds
a @datafile, upgrading the @flowelement to an @aspectengine, to provide additional properties.

To follow this example, the reader should be familiar with the previous [example](@ref Examples_CustomElement_GettingStarted).

The previous example took a date of birth, and returned an age. This example will add a @datafile
containing star signs to provide the extra property 'star sign'.


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
    TimeSpan Age { get; }
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
        ILogger<ElementDataBase> logger,
        IFlowData flowData)
        : base(logger, flowData)
    {
        // No need to do anything here, lets use the internal IDictionary.
    }

    public TimeSpan Age
    {
        // Get the age from the internal IDictionary as a TimeSpan.
        get { return GetAs<TimeSpan>("age"); }
        // Add the age to the internal IDictionary.
        set { AsDictionary().Add("age", value); }
    }

    public string Age
    {
        // Get the star sign from the internal IDictionary as a TimeSpan.
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
star sign, and add each to a list.
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

    public override IList<IAspectPropertyMetaData> Properties => new List<IAspectPropertyMetaData>() {
        new AspectPropertyMetaData(this, "age", typeof(TimeSpan), "age", new List<string>(){"free"}, true)};

    public override string DataSourceTier => "free";

    public override DateTime GetDataFilePublishedDate(string dataFileIdentifier = null)
    {
        return DataFiles[0].DataPublishedDateTime;
    }

    public override DateTime GetDataFileUpdateAvailableTime(string dataFileIdentifier = null)
    {
        return DataFiles[0].UpdateAvailableTime;
    }

    public override void RefreshData()
    {
        Init();
    }

    public override void RefreshData(string dataFileIdentifier)
    {
        Init();
    }

    public override void RefreshData(string dataFileIdentifier, byte[] data)
    {
        // We won't implement this logic in this example.
        throw new NotImplementedException();
    }

    protected override void ProcessEngine(IFlowData data, IAgeData aspectData)
    {
        // Create a new IAgeData, and cast to AgeData so the 'setters' are available.
        AgeData ageData = (AgeData)data.GetOrAdd(ElementDataKey, CreateElementData);

        if (data.TryGetEvidence("data-of-birth", out DateTime dateOfBirth))
        {
            // "date-of-birth" is there, so set the age and find the star sign.
            ageData.Age = DateTime.Now - dateOfBirth;
            var monthAndDay = new DateTime(0, dateOfBirth.Month, dateOfBirth.Day);
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
            ageData.Age = TimeSpan.MinValue;
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
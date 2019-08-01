@page Examples_CustomElement_Cloud Custom Cloud Engine

# Introduction

This example takes the very simple @flowelement described in the
[simple flow element example](@ref Examples_CustomElement_FlowElement),
and delegates all the logic to a cloud service.

Instead the data being stored locally and processing being carried out by the @flowelement
directly, as the [simple flow element example](@ref Examples_CustomElement_FlowElement)
did, this example will call a cloud service.

# Download Example

The source code used in this example is available here:
- [C# Visual Studio project **todo**](add link)
- [Java project **todo**](add link)
- [PHP project **todo**](add link)
- [Node.js project **todo**](add link)

# Dependencies

The @aspectengine will need a dependency on the @pipeline engines package, and cloud request engine package

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific dependencies.}
@startsnippet{dotnet}
The dependencies needed for .NET are the `FiftyOne.Pipeline.Engines` and
`FiftyOne.Pipeline.CloudRequestEngine` NuGet packages.
@endsnippet
@startsnippet{java}
The only dependency needed for Java is the `pipeline.core` Maven package from `com.51degrees`.
To include this, add the following to the `<dependencies>` section of the project's `pom.xml`:
```{xml}
<dependency>
    <groupId>com.51degrees</groupId>
    <artifactId>pipeline.cloudrequestengine</artifactId>
    <version>4.0</version>
</dependency>
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
@cloudaspectengine's base class.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific @aspectengine implementation.}
@startsnippet{dotnet}
First let's change the class to extend `CloudAspectEngineBase`. This has the type arguments of
`IStarSignData` - the interface extending @aspectdata which will be added to the @flowdata, and 
`IAspectPropertyMetaData` - instead of `IElementPropertyMetaData`.

The existing constructor needs to change to match the `CloudAspectEngineBase` class.

The constructor will also take a `CloudRequestEngine` instance to get the available properties
from.
```{cs}
//public class SimpleFlowElement : FlowElementBase<IStarSignData, IElementPropertyMetaData>
public class SimpleCloudEngine : CloudAspectEngineBase<IStarSignData, IAspectPropertyMetaData>
{
    public SimpleCloudEngine(
        ILogger<SimpleCloudEngine> logger,
        Func<IFlowData, FlowElementBase<IStarSignData, IAspectPropertyMetaData>, IStarSignData> deviceDataFactory,
        CloudRequestEngine engine)
        : base(logger, deviceDataFactory)
    {
        if (LoadAspectProperties(engine) == false)
        {
            _logger.LogCritical("Failed to load aspect properties");
        }
    }
```

The `LoadAspectProperties` method in this example will get the @aspectproperties from the `CloudRequestEngine`
and store them. In this case we know the only property will be 'star sign', but more complex @cloudengines can have many
properties which may change.
```{cs}
private bool LoadAspectProperties(CloudRequestEngine engine)
{
    var dictionary = engine.PublicProperties;

    if (dictionary != null &&
        dictionary.Count > 0 &&
        dictionary.ContainsKey(ElementDataKey))
    {
        _aspectProperties = new List<IAspectPropertyMetaData>();
        _dataSourceTier = dictionary[ElementDataKey].DataTier;

        foreach (var item in dictionary[ElementDataKey].Properties)
        {
            var property = new AspectPropertyMetaData(this,
                item.Name,
                item.GetPropertyType(),
                item.Category,
                new List<string>(),
                true);
            _aspectProperties.Add(property);
        }
        return true;
    }
    else
    {
        _logger.LogError($"Aspect properties could not be loaded for" +
            $" the cloud engine", this);
        return false;
    }
}
```


Now the abstract methods can be implemented to create a functional @aspectengine.
```{cs}
public class SimpleCloudEngine : CloudAspectEngineBase<IStarSignData, IAspectPropertyMetaData>
{
    public SimpleCloudEngine(
        ILogger<SimpleCloudEngine> logger,
        Func<IFlowData, FlowElementBase<IStarSignData, IAspectPropertyMetaData>, IStarSignData> deviceDataFactory,
        HttpClient httpClient,
        CloudRequestEngine engine)
        : base(logger, deviceDataFactory)
    {
        if (LoadAspectProperties(engine) == false)
        {
            _logger.LogCritical("Failed to load aspect properties");
        }
    }

    public override IList<IAspectPropertyMetaData> Properties => _aspectProperties;

    public override string DataSourceTier => _dataSourceTier;

    public override string ElementDataKey => "device";

    public override IEvidenceKeyFilter EvidenceKeyFilter =>
        // This engine needs no evidence. 
        // It works from the cloud request data.
        new EvidenceKeyFilterWhitelist(new List<string>());

    private IList<IAspectPropertyMetaData> _aspectProperties;
    private string _dataSourceTier;
    private bool _checkedForCloudEngine = false;
    private CloudRequestEngine _cloudRequestEngine = null;

    protected override void ProcessEngine(IFlowData data, IStarSignData aspectData)
    {
        // Cast aspectData to StarSignData so the 'setter' is available.
        StarSignData starSignData = (StarSignData)aspectData;
        if (_checkedForCloudEngine == false)
        {
            _cloudRequestEngine = data.Pipeline.GetElement<CloudRequestEngine>();
            _checkedForCloudEngine = true;
        }

        if (_cloudRequestEngine == null)
        {
            throw new PipelineConfigurationException(
                $"The '{GetType().Name}' requires a 'CloudRequestEngine' " +
                $"before it in the Pipeline. This engine will be unable " +
                $"to produce results until this is corrected.");
        }
        else
        {
            var requestData = data.GetFromElement(_cloudRequestEngine);
            var json = requestData.JsonResponse;

            // Extract data from json to the aspectData instance.
            var dictionary = JsonConvert.DeserializeObject<Dictionary<string, object>>(json);

            var starSign = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
            JsonConvert.PopulateObject(dictionary["starsign"].ToString(), starSign);
            starSignData.StarSign = starSign["starsign"].ToString();
        }
    }

    protected override void UnmanagedResourcesCleanup()
    {
        // Nothing to clean up here.
    }

    private bool LoadAspectProperties(CloudRequestEngine engine)
    {
        var dictionary = engine.PublicProperties;

        if (dictionary != null &&
            dictionary.Count > 0 &&
            dictionary.ContainsKey(ElementDataKey))
        {
            _aspectProperties = new List<IAspectPropertyMetaData>();
            _dataSourceTier = dictionary[ElementDataKey].DataTier;

            foreach (var item in dictionary[ElementDataKey].Properties)
            {
                var property = new AspectPropertyMetaData(this,
                    item.Name,
                    item.GetPropertyType(),
                    item.Category,
                    new List<string>(),
                    true);
                _aspectProperties.Add(property);
            }
            return true;
        }
        else
        {
            _logger.LogError($"Aspect properties could not be loaded for" +
                $" the cloud engine", this);
            return false;
        }
    }
}
```
@endsnippet
@startsnippet{java}
First let's change the class to extend `CloudAspectEngineBase`. This has the type arguments of
`StarSignData` - the interface extending @aspectdata which will be added to the @flowdata, and 
`AspectPropertyMetaData` - instead of `ElementPropertyMetaData`.

The existing constructor needs to change to match the `CloudAspectEngineBase` class.

The constructor will also take a `CloudRequestEngine` instance to get the available properties
from.
```{java}
//public class SimpleFlowElement : FlowElementBase<StarSignData, ElementPropertyMetaData> {
public class SimpleCloudEngine extends CloudAspectEngineBase<StarSignData, AspectPropertyMetaData> {
    public SimpleCloudEngine(
        Logger logger,
        ElementDataFactory<StarSignData> dataFactory,
        CloudRequestEngine engine) {
        super(logger, dataFactory);
        this.engine = engine;
        if (this.engine != null) {
            if (loadAspectProperties(engine) == false) {
                logger.error("Failed to load aspect properties");
            }
        }
    }
```

The `loadAspectProperties` method in this example will get the @aspectproperties from the `CloudRequestEngine`
and store them. In this case we know the only property will be 'star sign', but more complex @cloudengines can have many
properties which may change.
```{java}
private boolean loadAspectProperties(CloudRequestEngine engine) {
    Map<String, AccessiblePropertyMetaData.ProductMetaData> map =
        engine.getPublicProperties();

    if (map != null &&
        map.size() > 0 &&
        map.containsKey(getElementDataKey())) {
        aspectProperties = new ArrayList<>();
        dataSourceTier = map.get(getElementDataKey()).dataTier;

        for (AccessiblePropertyMetaData.PropertyMetaData item :
            map.get(getElementDataKey()).properties) {
            AspectPropertyMetaData property = new AspectPropertyMetaDataDefault(
                item.name,
                this,
                item.category,
                item.getPropertyType(),
                new ArrayList<String>(),
                true);
            aspectProperties.add(property);
        }
        return true;
    }
    else {
        logger.error("Aspect properties could not be loaded for" +
            " the cloud engine", this);
        return false;
    }
}
```


Now the abstract methods can be implemented to create a functional @aspectengine.
```{java}
public class SimpleCloudEngine extends CloudAspectEngineBase<StarSignData, AspectPropertyMetaData> {

    public SimpleCloudEngine(
        Logger logger,
        ElementDataFactory<StarSignData> dataFactory,
        HttpClient httpClient,
        CloudRequestEngine engine) {
        super(logger, dataFactory);
        this.httpClient = httpClient;
        this.engine = engine;
        if (this.engine != null) {
            if (loadAspectProperties(engine) == false) {
                logger.error("Failed to load aspect properties");
            }
        }
    }

    @Override
    public List<AspectPropertyMetaData> getProperties() {
        return aspectProperties;
    }

    @Override
    public String getDataSourceTier() {
        return dataSourceTier;
    }

    @Override
    public String getElementDataKey() {
        return "starsign";
    }

    @Override
    public EvidenceKeyFilter getEvidenceKeyFilter() {
        // This engine needs no evidence.
        // It works from the cloud request data.
        return new EvidenceKeyFilterWhitelist(new ArrayList<String>());
    }

    private boolean checkedForCloudEngine = false;
    private CloudRequestEngine cloudRequestEngine = null;
    private List<AspectPropertyMetaData> aspectProperties;
    private String dataSourceTier;
    private CloudRequestEngine engine;

    @Override
    protected void processEngine(FlowData data, StarSignData aspectData) {
        // Cast aspectData to StarSignDataDefault, so the 'setter' is available.
        StarSignDataInternal starSignData = (StarSignDataInternal)aspectData;

        if (checkedForCloudEngine == false) {
            cloudRequestEngine = data.getPipeline().getElement(CloudRequestEngine.class);
            checkedForCloudEngine = true;
        }

        if (cloudRequestEngine == null) {
            throw new PipelineConfigurationException(
                "The '" + getClass().getName() + "' requires a " +
                    "'CloudRequestEngine' before it in the Pipeline. This " +
                    "engine will be unable to produce results until this is " +
                    "corrected.");
        }
        else {
            CloudRequestData requestData = data.getFromElement(cloudRequestEngine);
            String json = "";
            json = requestData.getJsonResponse();

            // Extract data from json to the aspectData instance.
            JSONObject jsonObj = new JSONObject(json);
            JSONObject deviceObj = jsonObj.getJSONObject("starsign");

            starSignData.setStarSign(deviceObj.getString("starsign"));
        }
    }

    @Override
    protected void unmanagedResourcesCleanup() {
        // Nothing to clean up here.
    }

    private boolean loadAspectProperties(CloudRequestEngine engine) {
        Map<String, AccessiblePropertyMetaData.ProductMetaData> map =
            engine.getPublicProperties();

        if (map != null &&
            map.size() > 0 &&
            map.containsKey(getElementDataKey())) {
            aspectProperties = new ArrayList<>();
            dataSourceTier = map.get(getElementDataKey()).dataTier;

            for (AccessiblePropertyMetaData.PropertyMetaData item :
                map.get(getElementDataKey()).properties) {
                AspectPropertyMetaData property = new AspectPropertyMetaDataDefault(
                    item.name,
                    this,
                    item.category,
                    item.getPropertyType(),
                    new ArrayList<String>(),
                    true);
                aspectProperties.add(property);
            }
            return true;
        }
        else {
            logger.error("Aspect properties could not be loaded for" +
                " the cloud engine", this);
            return false;
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


# Builder

Now the @aspectengine needs one final thing, an @elementbuilder to construct it.
This needs to provide the @aspectengine with a logger and an @aspectdata factory as in
the previous example. However, it also now needs a cloud request @aspectengine.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@defaultsnippet{Select a tab to view language specific @elementbuilder implementation.}
@startsnippet{dotnet}
As this @aspectengine is using a @datafile, the builder can make use of the logic in the
`CloudAspectEngineBuilderBase`.
```{cs}
public class SimpleCloudEngineBuilder : CloudAspectEngineBuilderBase<SimpleCloudEngineBuilder, SimpleCloudEngine>
{
    private ILoggerFactory _loggerFactory;
    private CloudRequestEngine _engine;

    public SimpleCloudEngineBuilder(
        ILoggerFactory loggerFactory,
        CloudRequestEngine engine)
    {
        _loggerFactory = loggerFactory;
        _engine = engine;
    }

    public SimpleCloudEngine Build()
    {
        SimpleCloudEngine engine = new SimpleCloudEngine(
            _loggerFactory.CreateLogger<SimpleCloudEngine>(),
            CreateData,
            _engine);
        ConfigureEngine(engine);
        return engine;
    }

    private IStarSignData CreateData(IFlowData flowData, FlowElementBase<IStarSignData, IAspectPropertyMetaData> engine)
    {
        return new StarSignData(
            _loggerFactory.CreateLogger<StarSignData>(),
            flowData,
            (IAspectEngine)engine,
            MissingPropertyService.Instance);
    }

}
```
@endsnippet
@startsnippet{java}
As this @aspectengine is using a @datafile, the builder can make use of the logic in the
`CloudAspectEngineBuilderBase`.
```{java}
public class SimpleCloudEngineBuilder
    extends CloudAspectEngineBuilderBase<
            SimpleCloudEngineBuilder,
            SimpleCloudEngine> {
    private CloudRequestEngine cloudRequestEngine;

    public SimpleCloudEngineBuilder(
        ILoggerFactory loggerFactory,
        CloudRequestEngine engine) {
        super(loggerFactory);
        this.cloudRequestEngine = engine;
    }

    public SimpleCloudEngine build() throws Exception {
        SimpleCloudEngine engine = new SimpleCloudEngine(
            loggerFactory.getLogger(SimpleCloudEngine.class.getName()),
            new ElementDataFactory<StarSignData>() {
                @Override
                public StarSignData create(
                    FlowData flowData,
                    FlowElement<StarSignData, ?> flowElement) {
                    return new StarSignDataInternal(
                        loggerFactory.getLogger(StarSignDataInternal.class.getName()),
                        flowData,
                        (SimpleCloudEngine)flowElement,
                        MissingPropertyServiceDefault.getInstance());
                }
            },
            cloudRequestEngine);
        configureEngine(engine);
        return engine;
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
This new @aspectengine can now be added to a @pipeline along with a `CloudRequestEngine`,
and used like:
```{cs}
var cloudRequestEngine =
    new CloudRequestEngineBuilder(_loggerFactory, new HttpClient())
    .Build();

var starSignEngine =
    new SimpleCloudEngineBuilder(_loggerFactory, cloudRequestEngine)
    .SetEndPoint("https://your-cloud-service.com")
   .Build();
var pipeline = new PipelineBuilder(_loggerFactory)
    .AddFlowElement(cloudRequestEngine)
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
This new @aspectengine can now be added to a @pipeline along with a `CloudRequestEngine`,
and used like:
```{java}
CloudRequestEngine cloudRequestEngine =
    new CloudRequestEngineBuilder(loggerFactory, httpClient)
        .setEndpoint("https://your-cloud-service.com")
        .build();

SimpleCloudEngine ageElement =
    new SimpleCloudEngineBuilder(
        loggerFactory,
        cloudRequestEngine)
        .build();

Pipeline pipeline = new PipelineBuilder(loggerFactory)
    .addFlowElement(cloudRequestEngine)
    .addFlowElement(ageElement)
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
    flowData.getFromElement(ageElement).getStarSign() + ".");
```
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets
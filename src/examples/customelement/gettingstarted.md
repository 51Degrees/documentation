@page Examples_CustomElement_GettingStarted Simple Custom Flow Element

# Introduction

This example shows a very simple @flowelement which takes a date of birth
and returns an age. Although a basic (and not all that useful) @flowelement, the
example demonstrates how you can start to implement your own @flowelement's.

# Download Example

The source code used in this example is available here:
- [C# Visual Studio project **todo**]()
- [Java project **todo**]()
- [PHP project **todo**]()
- [Node.js project **todo**]()

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

The @elementdata being added to the @flowdata by this @flowelement is an age. So this should
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

In this example, only one value is populated. So an interface `IAgeData` will extend `IElementDataReadOnly`
to add a 'getter' for it.
```{cs}
public interface IAgeData : IElementDataReadOnly
{
    int Age { get; }
}
```

Now the internal implementation of it will implement this 'getter' and add a 'setter' for the @flowelement
to use.
```{cs}
internal class AgeData : ElementDataBase, IAgeData
{
    public AgeData(
        ILogger<ElementDataBase> logger,
        IFlowData flowData)
        : base(logger, flowData)
    {
        // No need to do anything here, lets use the internal IDictionary.
    }

    public int Age
    {
        // Get the age from the internal IDictionary as an int.
        get { return GetAs<int>("age"); }
        // Add the age to the internal IDictionary.
        set { AsDictionary().Add("age", value); }
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

In this example, only one value is populated. So an interface `AgeData` will extend `ElementDataReadOnly`
to add a 'getter' for it.
```{java}
public interface AgeData extends ElementDataReadOnly {
    int getAge();
}
```

Now the internal implementation of it will implement this 'getter' and add a 'setter' for the @flowelement
to use.
```{java}
class AgeDataDefault extends ElementDataBase implements AgeData {

    private int age;

    public AgeDataDefault(Logger logger, FlowData flowData) {
        super(logger, flowData);
    }

    @Override
    public int getAge() {
        return age;
    }

    void setAge(int age) {
        this.age = age;
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

Note that this concrete implementation of `AgeData` sits in the same package as the @flowelement,
not the `AgeData` interface, as it only needs to be accessible by the @flowelement.
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
This has the type arguments of `IAgeData` - the interface extending @elementdata which will be 
added to the @flowdata, and  `IElementPropertyMetaData` - as we only need the standard metadata for
@elementproperties.

This needs a constructor matching the `FlowElementBase` class. So it takes a logger, and an
@elementdata factory which will be used to construct an `IAgeData`:
```{cs}
public class SimpleFlowElement : FlowElementBase<IAgeData, IElementPropertyMetaData>
{
   public SimpleFlowElement(
        ILogger<FlowElementBase<IAgeData, IElementPropertyMetaData>> logger,
        Func<IFlowData, FlowElementBase<IAgeData, IElementPropertyMetaData>, IAgeData> elementDataFactory)
        : base(logger, elementDataFactory)
    {
    }
}
```

Now the abstract methods can be implemented to create a functional @flowelement.
```{cs}
public class SimpleFlowElement : FlowElementBase<IAgeData, IElementPropertyMetaData>
{
    public SimpleFlowElement(
        ILogger<FlowElementBase<IAgeData, IElementPropertyMetaData>> logger,
        Func<IFlowData, FlowElementBase<IAgeData, IElementPropertyMetaData>, IAgeData> elementDataFactory)
        : base(logger, elementDataFactory)
    {
    }

    // The IAgeData will be stored with the key "age" in the FlowData.
    public override string ElementDataKey => "age";

    // The only item of evidence needed is "date-of-birth".
    public override IEvidenceKeyFilter EvidenceKeyFilter =>
        new EvidenceKeyFilterWhitelist(new List<string>() { "date-of-birth" });

    public override IList<IElementPropertyMetaData> Properties =>
        new List<IElementPropertyMetaData>()
        {
            // The only property which will be returned is "age" which will be
            // an int.
            new ElementPropertyMetaData(this, "age", typeof(int), true)
        };

    protected override void ProcessInternal(IFlowData data)
    {
        DateTime zero = new DateTime(1, 1, 1);
        // Create a new IAgeData, and cast to AgeData so the 'setter' is available.
        AgeData ageData = (AgeData)data.GetOrAdd(ElementDataKey, CreateElementData);

        if (data.TryGetEvidence("date-of-birth", out DateTime dateOfBirth))
        {
            // "date-of-birth" is there, so set the age.
            ageData.Age = (zero + (DateTime.Now - dateOfBirth)).Year - 1;
        }
        else
        {
            // "date-of-birth" is not there, so set the age to -1.
            ageData.Age = -1;
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
This has the type arguments of `AgeData` - the interface extending @elementdata which will be 
added to the @flowdata, and  `ElementPropertyMetaData` - as we only need the standard metadata for
@elementproperties.

This needs a constructor matching the `FlowElementBase` class. So it takes a logger, and an
@elementdata factory which will be used to construct an `AgeData`:
```{java}
public class SimpleFlowElement extends FlowElementBase<AgeData, ElementPropertyMetaData> {

    public SimpleFlowElement(
        Logger logger,
        ElementDataFactory<AgeData> elementDataFactory) {
        super(logger, elementDataFactory);
    }

```

Now the abstract methods can be implemented to create a functional @flowelement.
```{java}
public class SimpleFlowElement extends FlowElementBase<AgeData, ElementPropertyMetaData> {

    public SimpleFlowElement(
        Logger logger,
        ElementDataFactory<AgeData> elementDataFactory) {
        super(logger, elementDataFactory);
    }

    @Override
    protected void processInternal(FlowData data) throws Exception {
        // Create a new AgeData, and cast to AgeDataDefault so the 'setter' is available.
        AgeDataDefault ageData = (AgeDataDefault)data.getOrAdd(getElementDataKey(),getDataFactory());

        TryGetResult<Date> date = data.tryGetEvidence("date-of-birth", Date.class);
        if (date.hasValue()) {
            // "date-of-birth" is there, so set the age.
            Calendar age = Calendar.getInstance();
            Calendar dob = Calendar.getInstance();
            dob.setTime(date.getValue());

            age.add(Calendar.YEAR, - dob.get(Calendar.YEAR));
            age.add(Calendar.MONTH, - dob.get(Calendar.MONTH));
            age.add(Calendar.DATE, - dob.get(Calendar.DATE));

            ageData.setAge(age.get(Calendar.YEAR));
        }
        else
        {
            // "date-of-birth" is not there, so set the age to -1.
            ageData.setAge(-1);
        }
    }

    @Override
    public String getElementDataKey() {
        // The AgeData will be stored with the key "age" in the FlowData.
        return "age";
    }

    @Override
    public EvidenceKeyFilter getEvidenceKeyFilter() {
        // The only item of evidence needed is "date-of-birth".
        return new EvidenceKeyFilterWhitelist(Arrays.asList("date-of-birth"));
    }

    @Override
    public List<ElementPropertyMetaData> getProperties() {
        // The only property which will be returned is "age" which will be
        // an Integer.
        return Arrays.asList(
            (ElementPropertyMetaData)new ElementPropertyMetaDataDefault(
                "age",
                this,
                "age",
                Integer.class,
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
which the @elementbuilder provides with a logger, and an @elementdata factory.

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
    public IAgeData CreateData(
        IFlowData flowData,
        FlowElementBase<IAgeData,IElementPropertyMetaData> element)
    {
        return new AgeData(_loggerFactory.CreateLogger<AgeData>(), flowData);
    }
}
```
@endsnippet
@startsnippet{java}
The @elementbuilder has one important method, and that is `build`. This returns a new @flowelement
which the @elementbuilder provides with a logger, and an @elementdata factory.

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
            new ElementDataFactory<AgeData>() {
                @Override
                public AgeData create(
                    FlowData flowData,
                    FlowElement<AgeData, ?> flowElement) {
                    return new AgeDataDefault(
                        loggerFactory.getLogger(AgeDataDefault.class.getName()),
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
var ageElement = new SimpleFlowElementBuilder(_loggerFactory)
    .Build();
var pipeline = new PipelineBuilder(_loggerFactory)
    .AddFlowElement(ageElement)
    .Build();
var dob = new DateTime(1992, 12, 18);
var flowData = pipeline.CreateFlowData();
flowData
    .AddEvidence("date-of-birth", dob)
    .Process();
Console.WriteLine($"With a date of birth of " +
    $"{dob.ToString("dd/MM/yyy")}" +
    $", your age is " +
    $"{flowData.GetFromElement(ageElement).Age}.");
Console.ReadKey();
```

to give an output of:
```{bash}
With a date of birth of 18/12/1992, your age is 26.
```
@endsnippet
@startsnippet{java}
This new @flowelement can now be added to a @pipeline and used like:
```{java}
SimpleFlowElement ageElement =
    new SimpleFlowElementBuilder(loggerFactory)
    .build();

Pipeline pipeline = new PipelineBuilder(loggerFactory)
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
    ", your age is " +
    flowData.getFromElement(ageElement).getAge() + ".");
```

to give an output of:
```{bash}
With a date of birth of 18/12/1992, your age is 26.
```
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet
@endsnippets
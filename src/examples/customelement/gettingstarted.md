@page Examples_CustomElement_GettingStarted Simple Custom Flow Element

# Introduction

This example looks at a very simple @flowelement which will take a date of birth
and return an age. This is a very simple (and not all that useful) @flowelement which
demonstrates the way in which a @flowelement should be implemented.

# Dependencies

The @flowelement will need to a dependency on the @pipeline core package

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
    TimeSpan Age { get; }
}
```

Now the internal implementation of it will implement this 'getter' and add an 'setter' for the @flowelement
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

    public TimeSpan Age
    {
        // Get the age from the internal IDictionary as a TimeSpan.
        get { return GetAs<TimeSpan>("age"); }
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
**todo**
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
First lets define a class which extends `FlowElementBase` (which partially implements `IFlowElement`).
This has the type arguments of `IAgeData` - the interface extending @elementdata which will be 
added to the @flowdata, and  `IElementPropertyMetaData` as we only need the standard metadata for
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
        new EvidenceKeyFilterWhitelist(new List<string>(){"date-of-birth"});

    public override IList<IElementPropertyMetaData> Properties =>
        new List<IElementPropertyMetaData>()
        {
            // The only property which will be returned is "age" which will be
            // a TimeSpan.
            new ElementPropertyMetaData(this, "age",typeof(TimeSpan),true)
        };

    protected override void ProcessInternal(IFlowData data)
    {
        // Create a new IAgeData, and cast to AgeData so the 'setter' is available.
        AgeData ageData = (AgeData)data.GetOrAdd(ElementDataKey, CreateElementData);

        if (data.TryGetEvidence("data-of-birth", out DateTime dateOfBirth))
        {
            // "date-of-birth" is there, so set the age.
            ageData.Age = DateTime.Now - dateOfBirth;
        }
        else
        {
            // "data-of-birth" is not there, so set the age to minimum.
            ageData.Age = TimeSpan.MinValue;
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

Now the @flowelement needs one final thing. An @elementbuilder to construct it.
This only needs to provide the @flowelement with a logger and an @elementdata factory
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
    public IAgeData CreateData(IFlowData flowData, FlowElementBase<IAgeData,IElementPropertyMetaData> element)
    {
        return new AgeData(_loggerFactory.CreateLogger<AgeData>(), flowData);
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
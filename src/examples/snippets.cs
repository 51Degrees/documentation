using System;
using namespace FiftyOne.Pipeline.Core.FlowElements;

//! [Using a builder]
IFlowElement element = new ElementBuilder(loggerFactory)
    .SetOption(value)
    .SetAnotherOption(anotherValue)
    .Build(compulsoryOption);
//! [Using a builder]

//! [Using a pipeline builder]
IPipeline pipeline = new PipelineBuilder(loggerFactory)
    .SetAutoDisposeElements(true)
    .SetSuppressProcessException(true)
    .AddFlowElement(element)
    .Build();
//! [Using a pipeline builder]

//! [Build from xml]
var config = new ConfigurationBuilder()
    .AddXmlFile("configuration.xml")
    .Build();
PipelineOptions options = new PipelineOptions();
config.Bind("PipelineOptions", options);

IPipeline pipeline = new PipelineBuilder(loggerFactory)
    .BuildFromConfiguration(options);
//! [Build from xml]

//! [Build from json]
var config = new ConfigurationBuilder()
    .AddJsonFile("configuration.json")
    .Build();
PipelineOptions options = new PipelineOptions();
config.Bind("PipelineOptions", options);

IPipeline pipeline = new PipelineBuilder(loggerFactory)
    .BuildFromConfiguration(options);
//! [Build from json]

//! [Get or add]
var elementData = flowData.GetOrAdd(ElementDataKeyTyped, CreateElementData);
//! [Get or add]

//! [Build in sequence]
IPipeline pipeline = new PipelineBuilder(loggerFactory)
    .AddFlowElement(E1)
    .AddFlowElement(E2)
    .Build();
//! [Build in sequence]

//! [Build in parallel]
IPipeline pipeline = new PipelineBuilder(loggerFactory)
    .AddFlowElementsParallel(E1, E2)
    .Build();
//! [Build in parallel]

//! [Iterate properties]
foreach (var elementProperties in pipeline.ElementAvailableProperties)
{
    var elementName = elementProperties.Key;
    
    foreach (var item in elementProperties.Value)
    {
        var propertyName = item.Key;
        var property = item.Value;
    }
}
//! [Iterate properties]
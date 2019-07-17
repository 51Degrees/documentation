
//! [Using a builder]
FlowElement element = new ElementBuilder(loggerFactory)
    .setOption(value)
    .setAnotherOption(anotherValue)
    .build(compulsoryOption);
//! [Using a builder]

//! [Using a pipeline builder]
Pipeline pipeline = new PipelineBuilder(loggerFactory)
    .setAutoDisposeElements(true)
    .setSuppressProcessException(true)
    .addFlowElement(element)
    .build();
//! [Using a pipeline builder]

//! [Build from xml]
File file = new File("configuration.xml");
Unmarshaller unmarshaller = JAXBContext
    .newInstance(PipelineOptions.class)
    .createUnmarshaller();
PipelineOptions options = (PipelineOptions) unmarshaller.unmarshal(file);

Pipeline pipeline = new PipelineBuilder(loggerFactory)
    .buildFromConfiguration(options);
//! [Build from xml]

//! [Build from json]
// **todo**
//! [Build from json]

//! [Get or add]
final TData aspectData = flowData.getOrAdd(getTypedDataKey(), getDataFactory());
//! [Get or add]

//! [Build in sequence]
Pipeline pipeline = new PipelineBuilder(loggerFactory)
    .addFlowElement(E1)
    .addFlowElement(E2)
    .build();
//! [Build in sequence]

//! [Build in parallel]
Pipeline pipeline = new PipelineBuilder(loggerFactory)
    .addFlowElementsParallel(new FlowElement[]{ E1, E2 })
    .build();
//! [Build in parallel]

//! [Iterate properties]
for (Map.Entry<String, Map<String, ElementPropertyMetaData>> elementProperties
    : pipeline.getElementAvailableProperties().entrySet()) {
    
    String elementName = elementProperties.getKey();
    
    for (Map.Entry<String, ElementPropertyMetaData> item
        : elementProperties.getValue().entrySet()) {
        
        String propertyName = item.getKey();
        ElementPropertyMetaData property = item.getValue();
    }
}
//! [Iterate properties]

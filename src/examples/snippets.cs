

//! [Using a builder]
IFlowElement element = new ElementBuilder(loggerFactory)
    .SetOption(value)
    .SetAnotherOption(anotherValue)
    .Build(compulsoryOption);
//! [Using a builder]

//! [Get or add]
var elementData = flowData.GetOrAdd(ElementDataKeyTyped, CreateElementData);
//! [Get or add]
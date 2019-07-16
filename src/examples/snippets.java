
//! [Using a builder]
FlowElement element = new ElementBuilder(loggerFactory)
    .setOption(value)
    .setAnotherOption(anotherValue)
    .build(compulsoryOption);
//! [Using a builder]

//! [Get or add]
final TData aspectData = flowData.getOrAdd(getTypedDataKey(), getDataFactory());
//! [Get or add]
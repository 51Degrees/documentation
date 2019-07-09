@page Concepts_FlowElements_FlowElement FlowElement

## Introduction

A FlowElement is an element which takes an input in the form of [Evidence](@ref Concepts_Data_Evidence),
and outputs results in the form of [ElementData](@ref Concepts_Data_ElementData). These are the building
blocks of a [Pipeline](@ref Concepts_Pipeline_Pipeline) and do all the processing as instructed by the
Pipeline they live in.

@dot
digraph FlowElement {
    bgcolor=transparent;
    node [shape=record, fontname=Helvetica, fontsize=10];
    FlowElements [ URL="@ref Concepts_FlowElements_FlowElement"];
    AspectEngines [ URL="@ref Concepts_FlowElements_AspectEngine"];
    "51Degrees Engines" [ URL="@ref Concepts_FlowElements_FiftyOneEngine"];
    "On-Premise Engines" [ URL="@ref Concepts_FlowElements_OnPremiseEngine"];
    "Cloud Engines" [ URL="@ref Concepts_FlowElements_CloudEngine"];
    Implementations [ URL="@ref Concepts_FlowElements_Implementations"];
    
    FlowElements -> AspectEngines -> "51Degrees Engines" -> "On-Premise Engines";
    "51Degrees Engines" -> "Cloud Engines";
    FlowElements -> Implementations;
    AspectEngines -> Implementations;
    "51Degrees Engines" -> Implementations;
    "On-Premise Engines" -> Implementations;
    "Cloud Engines" -> Implementations;
}
@enddot
@page Concepts_FlowElements_FlowElement FlowElement

## Introduction

A FlowElement is an element which takes an input in the form of [Evidence](@ref Concepts_Data_Evidence),
and outputs results in the form of [ElementData](@ref Concepts_Data_ElementData). These are the building
blocks of a [Pipeline](@ref Concepts_Pipeline_Pipeline) and do all the processing as instructed by the
Pipeline they live in.

## Creation

FlowElements are built using their [Builder](@ref Concepts_Configuration_Builders_ElementBuilder) which
follows the fluent builder pattern.

## Processing

The primary function of a FlowElement is to process data. Acting on a [FlowData](@ref Concepts_Data_FlowData)
given to it, the FlowElement processes the [Evidence](@ref Concepts_Data_Evidence) which is contained within.

The results from this processing are then added to the FlowData in the form of
[ElementData](@ref Concepts_Data_ElementData).

@dot
digraph processing {
    compound=true;
    bgcolor=transparent;
    rankdir=LR;
    node [shape=record, fontname=Helvetica, fontsize=10];
    edge [fontname=Helvetica, fontsize=10];
    
    subgraph clusterFD {
        fontname=Helvetica;
        fontsize=10;
        label="FlowData";
        URL="@ref Concepts_Data_FlowData";
        E [label=Evidence, URL="@ref Concepts_Data_Evidence"];
        ED [label=ElementData, URL="@ref Concepts_Data_ElementData"];
    }
    FE [label=FlowElement, URL="@ref Concepts_FlowElements"];
    
    E -> FE [ltail=clusterFD, label=process];
    FE -> ED [label=output];
}
@enddot


## Hierarchy

While an implementation can implement just FlowElement, useful functionality is built up in layers which
can be used by an implementation depending on its requirements.

@dot
digraph hierarchy {
    bgcolor=transparent;
    node [shape=record, fontname=Helvetica, fontsize=10];
    
    FE [label=FlowElements, URL="@ref Concepts_FlowElements_FlowElement"];
    AE [label=AspectEngines, URL="@ref Concepts_FlowElements_AspectEngine"];
    FODE [label="51Degrees Engines", URL="@ref Concepts_FlowElements_FiftyOneEngine"];
    OPE [label="On-Premise Engines", URL="@ref Concepts_FlowElements_OnPremiseEngine"];
    CE [label="Cloud Engines", URL="@ref Concepts_FlowElements_CloudEngine"];
    I [label=Implementations, URL="@ref Concepts_FlowElements_Implementations"];
    
    FE -> AE -> FODE -> OPE;
    FODE -> CE;
    
    FE -> I;
    AE -> I;
    FODE -> I;
    OPE -> I;
    CE -> I;
}
@enddot
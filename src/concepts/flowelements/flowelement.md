@page Concepts_FlowElements_FlowElement FlowElement

## Introduction

A FlowElement is an element which takes an input in the form of [Evidence](@ref Concepts_Data_Evidence),
and outputs results in the form of [ElementData](@ref Concepts_Data_ElementData). These are the building
blocks of a [Pipeline](@ref Concepts_Pipeline) and do all the processing as instructed by the
Pipeline they live in.

## Creation

FlowElements are built using their [Builder](@ref Concepts_Configuration_Builders_ElementBuilder) which
follows the fluent builder pattern.

## Processing

The primary function of a FlowElement is to process data. Acting on a [FlowData](@ref Concepts_Data_FlowData)
given to it, the FlowElement processes the [Evidence](@ref Concepts_Data_Evidence) which is contained within.

The results from this processing are then added to the FlowData in the form of
[ElementData](@ref Concepts_Data_ElementData).

@dotfile flowelement-process.dot


## Hierarchy

While an implementation can implement just FlowElement, useful functionality is built up in layers which
can be used by an implementation depending on its requirements.

@dotfile flowelement-hierarchy.dot
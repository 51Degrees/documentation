@page Concepts_Data_FlowData FlowData

## Introduction

Flow data is a container that encapsulates all the data related to a single Pipeline process request.

Flow data has several sub-containers that are used to segment the data that it contains:
* Evidence
* Element data
* Errors

## Evidence

Before the flow data is passed into the Pipeline, input data is supplied. We refer to this data as
'[evidence](@ref Concepts_Data_Evidence)'.
The evidence can be set manually or set automatically by using a 
[web integration](@ref Concepts_Web_Index) package where available for your web framework of choice.

## Element data




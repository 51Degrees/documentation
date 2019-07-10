@page Concepts_Data_FlowData FlowData

## Introduction

Flow data is a container that encasulates all the data related to a single Pipeline process request.

Flow data has several sub-containers that are used to segment the data that it contains:
* Evidence
* Element data
* Errors

## Evidence

Before the flow data is passed into the Pipeline, input data is supplied. We refer to this data as
'evidence' as it is teh eveidence used by an element to determine the details relating to a given 
aspect of the request. 
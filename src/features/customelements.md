@page Features_CustomElements Custom Flow Elements

# Introduction

The @Pipeline has been designed as an extensible hierarchy of functionality.
This is all publicly accessible, which allows 3rd party developers to create custom @flowelements, 
focusing on their core business logic while gaining the features of the @Pipeline such as
@buildfromconfiguration, @automaticdataupdates, @resultcaching, @webintegration, etc.

# Choosing the Right Classes to Extend

At the most basic level, creating a custom flow element requires the creation of several classes.
Exactly how many will depend on the language being used but all will need at least:

- A class implementing IFlowElement



# Examples

There are several [examples](@ref Examples_CustomElement_Index) covering a variety of scenarios.



@page Concepts_MetaData_AspectProperties Aspect Properties

# Introduction

**Aspect properties** extend @elementproperties to add metadata relevant to @aspectengines.

As @aspectengines consume external data from either a @datafile or [cloud service](@term{CloudService}), extra metadata
is included to indicate where the **property** is available.

# Data Tier

The data tier of a **property** describes which product tiers the **property** is available in. For example,
an @aspectengine could consume both a free and premium @datafile, and certain **properties** may not be available in both.


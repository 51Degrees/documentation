@page Concepts_FlowElements_FlowElement Flow Element

## Introduction

A **flow element** is an element which takes an input in the form of @evidence,
and outputs results in the form of @elementdata. They can be seen as a black
box where the internal method of processing and the way in which it is used externally are decoupled in such a
way that any **element** can be used in the same manor, regardless of its input, output, or method of processing.
These are the building blocks of a @pipeline and do all the processing as instructed by
the @pipeline they reside in.

## Creation

**Flow elements** are built using their @elementbuilder which
follows the fluent builder pattern. All configuration of an **element** occurs in the
@elementbuilder, and once an **element** has been built it is
immutable.

## Processing

The primary function of a **flow element** is to process data. Both the input and the output
(@evidence and @elementdata respectively) of
the processing are contained in a single place called a @flowdata.

Acting on a @flowdata given to it, the **flow element** processes the
@evidence which is contained within.

The results from this processing are then added to the @flowdata in the form of
@elementdata.

@dotfile flowelement-process.dot


For example, a "user age" **element** might look for a date of birth in the @evidence, and add
the age of the user to @elementdata before adding the @elementdata into the same @flowdata which
the @evidence came from.

@dotfile ageelement-process.dot

## Hierarchy

While an implementation can implement just **flow element**, useful functionality is built up in layers as shown below.
Any of these layers can be built upon by an implementation depending on its requirements.

@dotfile flowelement-hierarchy.dot


## Properties

The @elementdata produced by an **element** contains values of @properties based on the
@evidence provided. Each **element** has a set of @properties it provides values for.

The @properties available in an **element** can be queried directly for meta data purposes, or to
retrieve the names of the @properties whos values are present in the @elementdata produced.


## Evidence Keys

Each **element** expects certain items of @evidence to be present during processing. In the **age element**
example, it expects a date of birth to be present in the @evidence.

The items of @evidence which an **element** expects is exposed via an @evidencekeyfilter, which is present in each **element** and an aggregated form in a @pipeline (equivalent to looking at each **element** of the @pipeline individually).

Using an @evidencekeyfilter means that instead of asking an **element** 'which items of @evidence do you want?', one would ask 'do you want this item of @evidence?'. This achieves the same result and gives an **element** a greater degree of flexibility in the @evidence it accepts.

@dotfile flowelement-evidencekeys.dot


## Data Keys

Results of an **element**'s processing are stored in the @flowdata, keyed on the **element**'s @datakey. While not required, it is
convention that each **element** has a unique key. For example, our "user age" example would likely have the key "user age".

An **element**'s @datakey contains not just a string key, but the type of @elementdata which the results are. 

## Concurrency

## Scope

An **element** is immutable once created, so the configuration cannot be altered.

An **element** can be added to any number of @pipelines. A @pipeline is merely an organizational layer which instructs **element**'s to
carry out processing on a @flowdata, so the **elemement** acts in isolation without the need to reference to the @pipeline.

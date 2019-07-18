@page Concepts_Data_DataKey Data Key

# Introduction

A **data key** is a multi-field key intended for use in caching and similar scenarios.

# Internals

Exact implementation details for **data key** may vary depending on language.
However, in each case, the primary features are an integer hash code and
a list of values in a specific order.

The hash code is calculated when the **data key** is created. It can subsequently be
used as an efficient method to identify if one **data key** instance may
match with another.

When a hash match occurs, each individual key field value should also checked 
for equality between the keys to ensure a true match.
This is necessary because the possibility space for a large number of keys with arbitrary 
value types is far larger than that of a 32 bit integer, so hash collisions 
can occur.

# Usage Example

A data key builder is used to construct **data keys** by specifying the details 
of the keys to be included.
This will often be a subset of the evidence keys stored in a @flowdata instance.
The diagram below shows an example **data key** being generated from the
latitude and longitude values in an @evidence collection.

@dotfile datakey-evidence.gvdot

The **data key** can then be used to quickly check if the current @flowdata
contains the same values for the subset of evidence keys we're interested in
as any other **data key** instance from a list.

@dotfile datakey-check.gvdot

First, the cache will look for a match on just hash code as this is a fast 
operation.
In the example above, the generated **data key** matches two of the items in
the cache on hash code. 
When the hashes are found to match, the cache will then compare the values of 
the key fields to check for a true match.

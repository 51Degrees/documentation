@page Features_UsageSharing Usage Sharing

# Introduction

Some of the services offered by 51Degrees require @evidence from live installations of the 
@Pipeline to be sent back to 51Degrees' data processing system. We use this evidence to ensure 
that our data is up-to-date, comprehensive and continues to provide accurate results.


@dotfile usagesharing.gvdot

# Internals @anchor Features_UsageSharing_Internals

To minimize any overhead of this feature, received requests are grouped and sent in batches,
rather than sending each request individually.

**Usage sharing** is designed such that any failure within it should not impact the 
result of the @Pipeline. If a failure does occur then **usage sharing** will simply be disabled 
and an appropriate warning logged.

In languages that support multiple threading, **Usage sharing** will typically use a producer/consumer model,
where the 'main' thread adds the evidence to a queue while a background thread takes items from this queue,
transforms them into the appropriate format, adds them into a message and sends the message when ready.
This is done to avoid blocking the @Pipeline process thread.

## Repeated Evidence @anchor Features_UsageSharing_RepeatEvidence

To avoid situations where the same @evidence is sent multiple times (for example, a single user
visiting multiple pages on a web site), we keep track of the @evidence that has been shared over
a defined time period (maximum 20 minutes by default) and only share @evidence which is different to any
already shared during the window.

Note that the amount of @evidence tracked is also constrained based upon available memory.
In high-traffic scenarios, this may mean that the time period covered by the @evidence in the tracker
is much smaller than the configured maximum.

# Configuration

The **usage sharing** feature is provided by a @flowelement that is added to the @Pipeline.
Certain @pipelinebuilders will do this automatically. For example, the @devicedetection @pipelinebuilder
will add the **usage sharing** element by default.
This can be disabled using the SetShareUsage method on the builder.

There are also several configuration options when building a **usage sharing** element. These can be used to 
control what is shared and how it is collected:

## Evidence Shared

The **usage sharing** element will not be interested in all @evidence in the @flowdata. 
These are the rules for whether or not a particular piece of evidence is shared:

- Any evidence named 'header.&lt;name&gt;', if &lt;name&gt; is **not** on a configured blacklist.
- Any evidence named 'query.&lt;name&gt;', if &lt;name&gt; **is** on a configured whitelist.
- Any evidence named 'cookie.&lt;name&gt;' is ignored, unless &lt;name&gt; starts with '51D_'
- Any other evidence is shared if it is not on a configured blacklist.

The various black' and whitelists can be configured using the **share usage** @elementbuilder.

## Share Percentage

**Usage sharing** can be configured to only share a certain percentage of requests that 
pass through the @Pipeline.
This can be useful in very high-traffic scenarios where **usage sharing** is desired, but sharing every
request could put too much strain on the web server. 

This is based on a randomized value, so the exact amount shared may not be precisely the percentage specified. 
For example, if  generating a number between 0 and 1, the result will be above 0.5 roughly 50% of 
the time but it's unlikely to be exact.

## Timeouts

There may be one or multiple configurable timeouts depending on the language. Typically, these 
are used to suspend **usage sharing** if its internal mechanisms are responding too slowly.

## Maximum Queue Size

In languages that support multiple threads, this settings controls the size of the [internal 
producer/consumer queue](@ref Features_UsageSharing_Internals).

## Minimum Entries per Message

The minimum number of @evidence entries that must be added before the message will be sent
to the **usage sharing** web service.

## Repeat Evidence Interval

The maximum time period which @evidence is stored for the purpose of filtering 
[repeat evidence](@ref Features_UsageSharing_RepeatEvidence).

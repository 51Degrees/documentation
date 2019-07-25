@page Features_UsageSharing Usage Sharing

# Introduction

Some of the services offered by 51Degrees require @evidence from live installations of the 
@Pipeline to be sent back to the 51Degrees data processing system in order to ensure 
the results stay up-to-date and as accurate as possible.

@dotfile usagesharing.gvdot

# Internals @anchor Features_UsageSharing_Internals

We want this feature to have as little overhead as possible so rather than sending 
every request as it arrives, they are grouped up and sent in batches.

**Usage sharing** is designed to prevent any sort of failure from impacting on the 
result of the @Pipeline. If a failure occurs then usage sharing will simply be disabled 
and a warning logged with details of the problem.

In languages that support multiple threads, **Usage sharing** will typically use a producer/consumer model
where the 'main' thread adds the evidence to a queue while a background thread takes items from this queue,
transforms them into the appropriate format, adds them into a message and sends the message when ready.
This is done to avoid blocking the @Pipeline process thread.

## Repeated Evidence @anchor Features_UsageSharing_RepeatEvidence

We want to avoid a situation where the same @evidence is shared multiple times 
(for example, a single user visiting multiple pages on a web site.) This is enforced by keeping
track of the @evidence that has been shared over a defined time period 
(maximum 20 minutes by default) and only sharing @evidence that does not match anything that
has already been shared during that window.

Note that the amount of @evidence that is tracked is also constrained to ensure it does 
not use too much memory. In high-traffic scenarios, this may mean that the time period covered
by the @evidence in the tracker is much smaller than the configured maximum.

# Configuration

The **usage sharing** feature is provided by a @flowelement that is added to the @Pipeline.
Certain @pipelinebuilders will do this automatically. For example, the @devicedetection 
pipeline builder will add the usage sharing element by default.
This can be disabled using the SetShareUsage method on the builder.

There are also several options when building a **usage sharing** element. These can be used to 
control what is shared and how it is collected:

## Evidence Shared

The **usage sharing** element will not be interested in all @evidence in the @flowdata. 
These are the rules for whether or not a particular piece of evidence is shared:

- Any evidence named 'header.&lt;name&gt;' if &lt;name&gt; is not on a configured blacklist.
- Any evidence named 'query.&lt;name&gt;' if &lt;name&gt; is on a configured whitelist.
- Any evidence named 'cookie.&lt;name&gt;' is ignored unless &lt;name&gt; starts with '51D_'
- Any other evidence is shared if it is not on a configured blacklist.

The various black and white lists can be configured using the **share usage** @element builder.

## Share Percentage

**Usage sharing** can be configured to only share a certain percentage of requests that 
pass through the @Pipeline.
This can be useful in very high-traffic scenarios where **usage sharing** is desired but sharing every
request would put too much additional strain on the web server. 

This is based on a randomized value so the percentage will not be exact. For example, if 
generating a number between 0 and 1, the result will be above 0.5 roughly 50% of the time but it's
unlikely to be exact.

## Timeouts

There may be one or multiple configurable timeouts depending on the language. Typically, these 
are used to suspend **usage sharing** if its internal mechanisms are responding too slowly.

## Maximum Queue Size

In languages that support multiple threads, this settings control the size of the [internal 
producer/consumer queue](@ref Features_UsageSharing_Internals).

## Minimum Entries Per Message

The minimum number of @evidence entries that must be added before the message will be sent
to the usage sharing web service.

## Repeat Evidence Interval

The maximum time period to keep evidence to check if incoming @evidence it is a 
[repeat](@ref Features_UsageSharing_RepeatEvidence) of previously shared @evidence.

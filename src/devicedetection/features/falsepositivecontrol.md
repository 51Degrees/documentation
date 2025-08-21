@page DeviceDetection_Features_FalsePositiveControl False Positives

# Introduction

Most device detection solutions rely primarily on the User-Agent HTTP header. However, the content of this header can be any string at all. This inevitably leads to situations where finding an exact match to a previously observed User-Agent is not possible. 

A false positive occurs when the service tells you it has found a match but in reality the details provided are incorrect.

In these scenarios, different use cases often demand different responses. 51Degrees Device Detection allows the developer to determine exactly what happens.

# HasValue

The Device Detection API returns many different properties. Every single one of these can either have a specified value or not.

Each language implements this differently but in all cases, there will be some form of `HasValue` method or property associated with each result property. Where `HasValue` is false, accessing the property value will cause an exception to be returned or thrown (depending on the language). 

The detail associated with this exception will explain why the property does not have a specified value.

# No Match Found

In some cases, the device detection algorithm can fail to find any match at all for the supplied evidence.

The `AllowUnmatched` setting can be used to control what happens in this situation.  
If `AllowUnmatched` is false (default) then no result will be returned and `HasValue` will be false for the requested properties.  
If `AllowUnmatched` is true then the default @profile will be returned.

The default @profile has specific values for properties but they may be incorrect. For example, the default hardware profile has `IsMobile = false`. In reality, if no match was found then we have no idea if the device is a mobile device or not.

# Bad Match

The `Difference` value is used to measure how different a potential match is from the supplied evidence.
The `Drift` value is used to measure how far a matching substring is from it's expected position.

The maximum allowable `Difference` and `Drift` values can be set when the engine is created. This is used to control how far the supplied evidence is allowed to differ from the real-world training data that was used to create the data file.  
For example, if the maximum `Difference` value is set to 0 (default) then a match will only be returned if the difference value is 0. 

If the maximum `Difference` or `Drift` setting prevents any result from being returned then `HasValue` will be false for the requested properties.

By default, `Difference` and `Drift` are set to 0 (i.e., no deviation from the expected substrings is permitted). Setting them to -1 will mean that there is no limit. However, note that this often results in highly inaccurate results and does not guarantee a match will always be found.

# Match metadata

Regardless of the settings used, the result will return additional metadata that can be queried to find out details about the match.

`Difference` - Contains the difference value between the supplied evidence and the returned match.  
`UserAgents` - Contains a list of the matching substrings from the User-Agent.  
`Drift` - Contains the drift value between the supplied evidence and the returned match.  
`MatchedNodes` - The number of 'nodes' in the @hash tree where a match was found. If this is zero then no match was found.  
`Method` - The method used to find a match. 'EXACT' indicates an exact match. 'NONE' indicates no match. Any other value is the name of the technique used to find the result that best matches the supplied evidence.

# The 'Unknown' value

Previous versions of the Device Detection API were unable to indicate that a property did not have a value.  
Therefore, in the past, the string values `Unknown` or `N/A` were used to indicate that the API did not have a value for a particular property.

These values are treated as distinct from `HasValue`, i.e., it is possible for `HasValue` to return `true` and `Value` to return `Unknown`.  
In the future, this may be changed so that `HasValue` will return false if `Value` is `Unknown`, `N/A`, or similar, but this is not currently planned.

# Use cases

- **I only want a result if the API is reasonably sure it is correct.**  
  Set `AllowUnmatched` to false.  
  Set `Difference` and `Drift` to 10.

- **I only want exact matches to previously observed User-Agents (default configuration).**  
  Set `AllowUnmatched` to false.  
  Set `Difference` and `Drift` to 0.  
  These settings will mean that a result is only returned if it exactly matches a unique substring from a User-Agent that has been included when building the data file.

- **If there is no match found then I want the API to assume that the device is a desktop running an unknown operating system.**  
  Set `AllowUnmatched` to true.  
  `Difference` and `Drift` do not influence this use case.  
  This setting will cause the default (desktop) profiles to be returned if there is no match.

- **I'm migrating from 51Degrees V3 Device Detection and want to retain the previous functionality.**  
  OR  
  **I want to keep my code simple as possible. I'm not worried about some false positives.**  
  Set `AllowUnmatched` to true.  
  Set `Difference` (and `Drift` if using @Hash) to -1.  
  These settings will mean that `HasValue` is never false. Each property will always have a value so you don't need to worry about dealing with a situation where they do not. 





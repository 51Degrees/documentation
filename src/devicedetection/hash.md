@page DeviceDetection_Hash Hash

# Introduction
During extensive analysis of hundreds of billions of web interactions over several years, we discovered that a smart method of identifying and hashing sub strings within User-Agents could be used to produce an optimum data set that displays the following characteristics:

- Speed : extremely fast performance with over 1 million detections per second per CPU core possible.
- Low Memory : memory overhead is reduced due to the use of hash values rather than the characters of the sub strings.
- Prediction : reasonable predictive capabilities when compared to a classic character based trie.

51Degrees **Hash** algorithm embodies these features. The algorithm is subject to EU Patent (EP3438848) and US Patent (10,482,175) and released under EUPL permissive open source licensed source code.

# Data Structure
The exact structure of the data is optimized at the time of the data file's production. Machine learning techniques are used to identify the smallest, most distinctive substrings within the 'training data' provided to the algorithm. By omitting irrelevant parts of a User-Agent, such as strings which identify the user, location or are repeated so often as to be meaningless, the data file size can be significantly reduced. These sub-strings are then processed to build a directed acyclic graph that is optimized to use the lowest possible number of operations needed to obtain a match and thus ensure that matches are achieved in as few CPU cycles as possible. In combination, these approaches ensure that the data file is not only relatively small and comprehensive, it is very fast.

Each @component of the data set has graphs which are separate to those of the others. Because of this, even more information can be considered irrelevant. For example, it's possible that the fact that a User-Agent contains `Android` is useful in identifying the hardware device, it's highly unlikely that the Android version `4.0.4` should be considered. While both of these substrings are vital in the OS graphs, they likely won't be found in a hardware graph. This separation achieve two things: firstly, by decoupling the @components, unexpected changes in one do not affect another (e.g. a device running an OS which it has not been seen running before); and secondly, performance can be improved even further by only processing the graphs that are required for the requested result (if only the hardware device is required, why bother determining which browser is being used?).

# Detection Process
A series of nodes arranged in a directed acyclic graph are evaluated from an entry point to leaf. There are separate graphs and entry points for each @component and for different use-cases. The device-detection API software will automatically determine the graphs and entry points to use based on the configuration provided at startup, the way the evidence is provided, and the properties required.

Each node can contain one or more hash values that occur between a given range of character positions. The characters in the target User-Agent are evaluated against the node to either match one of the hash values or not. If a hash value is matched then the corresponding next match node is evaluated. If none of the hash values match then an unmatched node is evaluated. This process continues until a leaf node is reached and the device identified. Consider the following User-Agent.


```
      0                   1                   2                   3                   4                   5
Col   0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9
Row                                                                                                                          
0     M o z i l l a / 5 . 0   ( L i n u x ;   U ;   A n d r o i d 4 . 0 . 4 ;   e n - u s ;   S P H - D 7 1 0   B u i l d / I
1     M M 7 6 I )   A p p l e W e b K i t / 5 3 4 . 3 0   ( K H T M L ,   l i k e   G e c k o )   V e r s i o n / 4 . 0   M o
2     b i l e   S a f a r i / 5 3 4 . 3 0
```

*Example User-Agent for analysis with Hash*

An entry point for a graph used to determine the OS @component could contain hash values for substrings of 10 characters at character position 23. One such substring could be `Android 4.`. By matching this substring using a hash value, the possible OSs that can be returned are immediately reduced considerably to a subset of Android 4 devices. As the hash value is only 4 bytes in length the space needed to store the substring is significantly smaller than using the full 10 characters. The evaluation of the operation is also quicker when using hashes than the characters. Hash collisions can be avoided by identifying them during the production of the data set at 51Degrees by choosing substrings that do not result in collisions within the training data.

Continuing the above example, the node that follows the matched node may then focus on identifying the exact Android version by choosing substrings starting at character position 32. At this point in the graph, it has already been determined that this character position is immediately preceded by `Android 4.`, so the possibilities are limited. The node here may contain all the possible Android versions with the major version 4 (e.g. 4.2.2 or 4.4.4). In the above example, the hash for the substring `0.4` would be matched and a leaf node reached, thus completing the graph search for the OS @component.

A separate graph is used to detect the hardware device. After matching a few nodes from the hardware entry point to narrow down the set of devices, the node may then focus on the device model by choosing substrings starting at character position 44. 

Many Android User-Agents will consistently place the substrings associated with the device at this position. A long list of hash values, perhaps tens of thousands, could then be evaluated to either identify the device or narrow down the options. Perhaps just thef irst 5 characters `SPH-D` will be used to reduce the possible devices. This is very efficient as it considerably narrows the possible devices with a single hash value calculation and lookup. This process of hashing the most relevant substrings will continue until a complete device including hardware, operating system and browser has been identified using the graphs for each.

# Data Set Production @anchor DeviceDetection_Hash_DataSetProduction
The production of the optimized data set is computationally intensive as training data is evaluated. However the resulting data set is small and fast for 51Degrees users. As only the relevant characters are evaluated and some tolerance for substrings drifting within the User-Agent can be allowed for, the predictive features of **Hash** are better than character based trie solutions.

With the help of optional @usagesharing, anonymized real world data is fed back into the data set production. This is constant learning cycle where new data, unknown to the system, is processed using the knowledge the system already has to enhance the graphs it produces. Not just for the data it has already seen, but for data it expects to be seen.

Graphs are constructed using a series of decision trees to determine the best structure for finding a result as fast as possible. The exact structure of the graphs contained in the **Hash** data set is determined using decision trees in a few different ways.

## Performance Graphs @anchor DeviceDetection_Hash_DataSetProduction_Performance
Performance optimized graphs are constructed using decision trees which result in the fastest detection. This equates to the least number of hash comparisons. The resulting graphs end up looking for exact matches at very specific character positions. Using the example above, it may be that the characters `SPH-D` are only found at character position 44 in this User-Agent. This is unlikely, but for the sake of example, let's continue with that assumption. To determine the hardware device for this User-Agent, we need only look for this. The result is found in a single operation. It's more complex when also considering the quickest way for billions of other User-Agents in the same graph, but that's the challenge we enjoy.

## Predictive Graphs @anchor DeviceDetection_Hash_DataSetProduction_Predictive
Predictive optimized graphs are constructed using decision trees which result in the most accurate result for evidence not in the training data. Generally, this results in nodes where a short hash is looked for in a large range. For example, the substring `Android` is usually found around the same area of the User-Agent. So, when constructing a graph for the OS @component, instead of looking for an exact position, why not look for it in the general area it is expected to be? This narrows down the result to Android, then it can be narrowed down further. In contrast to the performance graphs, the above example will probably not be found by matching `4.0.4` next. It's more likely that it will be narrowed down in stages. For example, `4.0.` then `4 `. Constructing a graph in this way ensures that things which do not have an exact match in the training data are still matched to a sufficient degree of accuracy in practice. Consider a new Android version 4.0.5 which is not yet in the training data. Using the predictive graph, `4.0.` would be matched, and the best known match would be correct. If we had looked for `4.0.4`, nothing would have been found after `Android` and the result would have been an unknown Android version.

# Predictive Power @anchor DeviceDetection_Hash_PredictivePower
When constructing graphs, there is always the risk of over (or under) fitting the data to the training data. The graphs contained in the **Hash** data set are produced to fit "just right" to the training data seen from optional @usagesharing, and data which has not yet been seen. This is a delicate balance, which we have perfected for most use cases. For cases where some tweaking is required, the algorithm can be configured to be more accommodating (or less) to unknown data.

The **Hash** algorithm has two tolerances which can be enabled through the API to enhance the predictive power of the algorithm. Predictive power of a matching algorithm can be measured by how accurately it can match things it has not yet encountered based solely on the information it already has. By ignoring irrelevant sub strings, the **Hash** algorithm already fairs well when matching unknown User-Agents. But by configuring drift and difference, the predictive power can be fine tuned by the user.

## Drift
The drift tolerance allows for a substring to be matched in a wider range of character positions. As an example, the User-Agent may be altered by inserting a space near the start of the string. If we require the characters to be in the exact expected positions then this could match as something other than we might expect.

To allow for drift in sub strings within a User-Agent, the drift tolerance can be set. In the case of the above example, setting the drift to one would mean that even though the whole User-Agent was shifted by one character position, it would be matched as the original User-Agent.

This feature can also be useful in predicting new devices which have not yet been seen in the wild. For example, if a User-Agent containing the sub string `iPhone 8` was known, then along came one containing the sub string `iPhone 8s`, all sub strings to the right of this would be shifted by one character. Setting the drift allows the Browser and OS to be correctly identified even though the sub strings used to identify them are not in the position they are expected to be in.

## Difference
The difference tolerance allows for User-Agents where some characters differ slightly from what is expected. For example, if a new Android version is released that is not contained in the data set, it can be identified.

Take the example User-Agent (assuming we are using a performance graph) for a known browser version which contains the sub string `Android 4.0.4`, and an unknown version containing the sub string `Android 4.0.5`. Due to the nature of the chosen **hash** algorithm, the hashes of the two sub strings vary proportionally to the difference in ASCII value of the last character. This means that if the difference is set to one, the unknown sub string will be allowed as a match for the known Android version.

# The Algorithm in Action @anchor Device_Detection_Hash_InAction
Now that you've got an idea of how the algorithm and data structure work, why not try our [User-Agent Tester](https://51degrees.com/developers/user-agent-tester) to see the algorithm in action. Or try it for yourself with our [Getting Started](@ref Examples_DeviceDetection_GettingStarted_OnPremiseHash) examples.
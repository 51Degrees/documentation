@page DeviceDetection_Hash Hash algorithm

# Introduction
The Hash algorithm identifies and hashes substrings in User-Agents to produce a data set with the following characteristics:

- Speed: over 1 million detections per second on an eight-core AWS Graviton3 instance with the whole data file in memory, as measured in the [hardware benchmarks](@ref ProductSummaries_Benchmarks_Hardware).
- Fast startup: the whole data file loads into memory, ready to detect, in under 150 milliseconds on the same Graviton3 instance, which matters most where servers start and stop as demand changes.
- Low Memory: memory overhead is reduced due to the use of hash values rather than the characters of the substrings.
- Prediction: reasonable predictive capabilities when compared to a classic character based trie.

51Degrees **Hash** algorithm embodies these features. The algorithm is subject to European patent EP3438848 and US patent 10,482,175, and its source code is released under the open source European Union Public Licence (EUPL).

# Data structure
The exact structure of the data is optimized at the time of the data file's production. Machine learning techniques are used to identify the smallest, most distinctive substrings within the 'training data' provided to the algorithm. By omitting irrelevant parts of a User-Agent, such as strings which identify the user, location, or are repeated so often as to be meaningless, the data file size can be significantly reduced. These substrings are then processed to build a directed acyclic graph that is optimized to use the lowest possible number of operations needed to obtain a match and thus ensure that matches are achieved in as few CPU cycles as possible. In combination, these approaches ensure that the data file is not only relatively small and comprehensive, it is very fast.

Each @component of the data set has graphs which are separate to those of the others. Because of this, even more information can be considered irrelevant. For example, it's possible that the fact that a User-Agent contains `Android` is useful in identifying the hardware device, it's highly unlikely that the Android version `4.0.4` should be considered. While both of these substrings are vital in the OS graphs, they likely won't be found in a hardware graph. This separation achieves two things. Firstly, by decoupling the @component, unexpected changes in one do not affect another (e.g. a device running an OS which it has not been seen running before). Secondly, performance can be improved even further by only processing the graphs that are required for the requested result (if only the hardware device is required, why bother determining which browser is being used?).

# Detection process
A series of nodes arranged in a directed acyclic graph are evaluated from an entry point to leaf. There are separate graphs and entry points for each @component and for different use cases. The Device Detection API software will automatically determine the graphs and entry points to use based on the configuration provided at startup, the way the evidence is provided, and the properties required.

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

An entry point for a graph used to determine the OS @component could contain hash values for substrings of 10 characters at character position 23. One such substring could be `Android 4.`. By matching this substring using a hash value, the possible OSs that can be returned are immediately reduced considerably to a subset of Android 4 devices. As the hash value is only 4 bytes in length, the space needed to store the substring is significantly smaller than using the full 10 characters. The evaluation of the operation is also quicker when using hashes than the characters. Hash collisions can be avoided by identifying them during the production of the data set at 51Degrees by choosing substrings that do not result in collisions within the training data.

Continuing the above example, the node that follows the matched node may then focus on identifying the exact Android version by choosing substrings starting at character position 32. At this point in the graph, it has already been determined that this character position is immediately preceded by `Android 4.`, so the possibilities are limited. The node here may contain all the possible Android versions with the major version 4 (e.g. 4.2.2 or 4.4.4). In the above example, the hash for the substring `0.4` would be matched and a leaf node reached, thus completing the graph search for the OS @component.

A separate graph is used to detect the hardware device. After matching a few nodes from the hardware entry point to narrow down the set of devices, the node may then focus on the device model by choosing substrings starting at character position 44. 

Many Android User-Agents will consistently place the substrings associated with the device at this position. A long list of hash values, perhaps tens of thousands, could then be evaluated to either identify the device or narrow down the options. Perhaps just the first 5 characters `SPH-D` will be used to reduce the possible devices. This is very efficient as it considerably narrows the possible devices with a single hash value calculation and lookup. This process of hashing the most relevant substrings will continue until a complete device including hardware, operating system, and browser has been identified using the graphs for each.

# Header length limit {#DeviceDetection_Hash_HeaderLengthLimit}

Detection reads each header up to a limit of 500 bytes. The limit applies to every header, such as User-Agent, and to every [pseudo-header](@ref UACH_Http_Headers_Pseudoheaders) built from User-Agent Client Hints, where it counts one separator between each value. It counts bytes, not characters, so a header holding characters outside ASCII reaches it sooner.

The limit stays at 500 bytes because no data file reads past the first 500 bytes of a header. The working memory for each set of results is sized from the limit when the results are created, so a larger limit would use more memory in every set of results and change no result.

A header longer than the limit is ignored, with no error, and detection carries on with the rest of the @evidence. To have a longer User-Agent used, cut it to its first 500 bytes before passing it in. That gives the same result as reading the whole header would, because nothing after the first 500 bytes is read.

## How to tell a header was ignored

With the default settings, a result whose only @evidence was ignored has the DeviceId `0-0-0-0`, because each @component that matched nothing gives `0` when unmatched results are not allowed, which is the default. Two cases differ.

1. With unmatched results allowed (see @ref DeviceDetection_Features_FalsePositiveControl), each @component gives its default @profile, so the DeviceId shows those @profile ids rather than zeros.
2. When other @evidence still matches, for example client hint headers under 500 bytes, the DeviceId is not all zeros, although the long header was still ignored.

## The setting in each language

The limit is a setting of the device detection configuration. There is nothing to gain from a larger value, for the reason above.

| Language | Setting |
|----------|---------|
| C | `config.b.maxMatchedUserAgentLength` on the `fiftyoneDegreesConfigHash` used to create the data set |
| C++ | `setMaxMatchedUserAgentLength` on the `ConfigHash` used to create the engine |
| Node.js | the `maxMatchedUserAgentLength` option of the on-premise engine and of the pipeline builder |
| Python | the `max_matched_useragent_length` parameter of the on-premise engine and of the pipeline builder |
| PHP | `FiftyOneDegreesHashEngine.max_matched_useragent_length` in the PHP configuration |
| .NET, Java, Go and Rust | not offered, so the limit is always 500 bytes |
| NGINX and Varnish | not offered, so the limit is always 500 bytes |

# Data set production {#DeviceDetection_Hash_DataSetProduction}

Producing the optimized data set is computationally intensive because it requires evaluating training data. However the resulting data set is small and fast for 51Degrees users. As only the relevant characters are evaluated and some tolerance for substrings drifting within the User-Agent can be allowed for, the predictive features of **Hash** are better than character based trie solutions.

With optional @usagesharing, we use real-world data to improve the graphs and their ability to match data not seen during training.

Graphs are constructed using a series of decision trees to determine the best structure for finding a result as fast as possible. The exact structure of the graphs contained in the **Hash** data set is determined using decision trees in a few different ways.


## Performance graphs {#DeviceDetection_Hash_DataSetProduction_Performance}
**⚠️ Deprecated:** Performance graphs are deprecated since v4.5 and are now just an alias of the predictive graph.

Performance optimized graphs were constructed using decision trees which gave the fastest detection for a given evidence string. Generally, their nodes looked for a long hash in a narrow range. For example, if the substring `Android 4.0.4` was known to exist at character positions 18-25 within the training data, looking for it at exactly character 20 reduced the possible devices very quickly, and evaluating an exact position is quicker than evaluating a range. This worked very well with the training data, but not with evidence which had not been seen before. Consider a User-Agent containing the substring `iPhone 8` which is in the training data, then along comes one containing the substring `iPhone 8s`. All substrings to the right of this are shifted by one character. If the next node is looking for `Version` starting at character 120, it now needs to be found at character 121, and because of the very narrow range used in a performance graph, the string would not be matched. Predictive graphs solve this problem.

## Predictive graphs {#DeviceDetection_Hash_DataSetProduction_Predictive}

We use decision trees to construct predictive graphs that match evidence not in the training data. Generally, this results in nodes where a short hash is looked for in a large range. For example, the substring `Android` is usually found around the same area of the User-Agent. So, when constructing a graph for the OS @component, instead of looking for an exact position, why not look for it in the general area it is expected to be? This narrows down the result to Android, then it can be narrowed down further. In contrast to the performance graphs, the above example will probably not be found by matching `4.0.4` next. It's more likely that it will be narrowed down in stages. For example, `4.0.` then `4 `. Constructing a graph in this way ensures that things which do not have an exact match in the training data are still matched to a sufficient degree of accuracy in practice. Consider a new Android version 4.0.5 which is not yet in the training data. Using the predictive graph, `4.0.` would be matched, and the best known match would be correct. If we had looked for `4.0.4`, nothing would have been found after `Android` and the result would have been an unknown Android version.

# Predictive power {#DeviceDetection_Hash_PredictivePower}

When constructing graphs, we risk fitting them too closely or too loosely to the training data. The graphs contained in the **Hash** data set are produced to fit "just right" to the training data seen from optional @usagesharing, and data which has not yet been seen. This is a delicate balance, which we have perfected for most use cases. For cases where some tweaking is required, the algorithm can be configured to be more accommodating (or less) to unknown data.

The **Hash** algorithm has two configurable tolerances, drift and difference, that control how it matches evidence not seen in training. Ignoring irrelevant substrings already helps the algorithm match unknown User-Agents. You can adjust the tolerances to make matching more or less permissive.

## Drift
The drift tolerance allows for a substring to be matched in a wider range of character positions. As an example, the User-Agent may be altered by inserting a space near the start of the string. If we require the characters to be in the exact expected positions then this could match as something other than we might expect.

To allow for drift in substrings within a User-Agent, the drift tolerance can be set. In the case of the above example, setting the drift to one would mean that even though the whole User-Agent was shifted by one character position, it would be matched as the original User-Agent.

This feature can also be useful in predicting new devices which have not yet been seen in the wild. For example, if a User-Agent containing the substring `iPhone 8` was known, then along came one containing the substring `iPhone 8s`, all substrings to the right of this would be shifted by one character. Setting the drift allows the Browser and OS to be correctly identified even though the substrings used to identify them are not in the position they are expected to be in.

## Difference
The difference tolerance allows for User-Agents where some characters differ slightly from what is expected. For example, if a new Android version is released that is not contained in the data set, it can be identified.

Take the example User-Agent for a known browser version which contains the substring `Android 4.0.4`, and an unknown version containing the substring `Android 4.0.5`. Due to the nature of the chosen **hash** algorithm, the hashes of the two substrings vary proportionally to the difference in ASCII value of the last character. This means that if the difference is set to one, the unknown substring will be allowed as a match for the known Android version.

# The algorithm in action {#Device_Detection_Hash_InAction}

Try our [User-Agent Tester](https://51degrees.com/developers/user-agent-tester) to see detection results, or run the [Getting Started](@ref DeviceDetection_Examples_GettingStarted_Console_OnPremise) examples.

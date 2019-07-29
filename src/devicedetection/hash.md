@page DeviceDetection_Hash Hash

# Introduction
During extensive analysis of hundreds of billions of web interactions over several years, 51Degrees discovered that a smart method of identifying and hashing sub strings within User-Agents could be used to produce an optimum data set that displays the following characteristics:

- Speed : extremely fast performance with over 1 million detections per second per CPU core possible.
- Low Memory : memory overhead is reduced due to the use of hash values rather than the characters of the sub strings.
- Prediction : reasonable predictive capabilities when compared to a classic character based trie.

The 51Degrees Hash (patent pending) embodies these features.

# Data Structure
The exact structure of the data is optimized at the time of the data file's production. By aiming for the lowest possible number of operations needed to get a match, the data file is not only small, it is very fast. Pre-processing steps ensure that the ordering of nodes, and the sub strings used, are carefully calibrated to result in device matches being achieved in as few CPU cycles as possible.

As a result of using hashes and selecting only the important sub strings, the data structure is not only fast, it is small. For all but the shortest sub strings, a hash code will take up far less space than the string itself. In addition, by omitting irrelevant parts of a User-Agent, such as strings which identify the user or location, the size can be reduced, and operations which yield no benefit are removed.

# Detection Process
A series of nodes arranged in a tree (or Trie) are evaluated from root to leaf. Each root or branch node can contain one or more hash values that occur between a given range of character positions. The characters in the target User-Agent are evaluated against the node to either match one of the hash values or not. If a hash value is matched then the corresponding next match node is evaluated. If none of the hash values match then an unmatched node is evaluated. This process continues until a leaf node is reached and the device identified. Consider the following User-Agent.


```
      0                   1                   2                   3                   4                   5
Col   0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9
Row                                                                                                                          
0     M o z i l l a / 5 . 0   ( L i n u x ;   U ;   A n d r o i d 4 . 0 . 4 ;   e n - u s ;   S P H - D 7 1 0   B u i l d / I
1     M M 7 6 I )   A p p l e W e b K i t / 5 3 4 . 3 0   ( K H T M L ,   l i k e   G e c k o )   V e r s i o n / 4 . 0   M o
2     b i l e   S a f a r i / 5 3 4 . 3 0
```

*Example User-Agent for analysis with Hash*

The root node of the Hash could contain hash values for the top 50 User-Agents prefixes. One such prefix could be `Mozilla/5.0 (Linux; U; Android 4.0.4;` between character positions 0 and 35. By matching this substring using a hash value the possible devices that can be returned are immediately reduced considerably in one operation. As the hash value is only 4 bytes in length the space needed to store the substring is considerably smaller than using the full 36 characters. The evaluation of the operation is also faster using hashes than the characters. Hash collisions can be avoided by identifying them during the production of the data set at 51Degrees and choosing substrings that do not result in collisions.

Continuing the above example the branch node that follows the matched prefix may then focus on identifying the hardware device by choosing substrings starting at character position 44. Many Android User-Agents will consistently place the substrings associated with the device at this position. A long list of hash values, perhaps tens of thousands, could then be evaluated to either identify the device or narrow down the options. Perhaps just the first 5 characters `SPH-D` will be used to reduce the possible devices. This is very efficient as it considerably narrows the possible devices with a single hash value calculation and lookup. This process of hashing the most relevant substrings will continue until a complete device including hardware, operating system and browser has been identified. 

The production of an optimized data set is extremely computationally intensive, requiring multiple servers to work for several hours. However the resulting data set is small and fast for 51Degrees users. As only the relevant characters are evaluated and some tolerance for substrings drifting within the User-Agent can be allowed for, the predictive features of Hash are better than character based trie solutions.

# Predictive Power
The Hash algorithm has two tolerances which can be enabled through the API to enhance the predictive power of the algorithm. Predictive power of a matching algorithm can be measured by how accurately it can match things it has not yet encountered based solely on the information it already has. By ignoring irrelevant sub strings, the Hash algorithm already fairs well when matching unknown User-Agents. But by configuring drift and difference, the predictive power can be fine tuned by the user.

## Drift
The drift tolerance allows for a substring to be matched in a wider range of character positions. As an example, the User-Agent may be altered by inserting a space near the start of the string. If we require the characters to be in the exact expected positions then this could match as something other than we might expect.

To allow for drift in sub strings within a User-Agent, the drift tolerance can be set. In the case of the above example, setting the drift to one would mean that even though the whole User-Agent was shifted by one character position, it would be matched as the original User-Agent.

This feature can also be useful in predicting new devices which have not yet been seen in the wild. For example, if a User-Agent containing the sub string `iPhone 8` was known, then along came one containing the sub string `iPhone 8s`, all sub strings to the right of this would be shifted by one character. Setting the drift allows the Browser and OS to be correctly identified even though the sub strings used to identify them are not in the position they are expected to be in.

## Difference
The difference tolerance allows for User-Agents where some characters differ slightly from what is expected. For example, if a new Android version is released that is not contained in the data set, it can be identified.

Take the example User-Agent for a known browser version which contains the sub string `Android 4.0.4`, and an unknown version containing the sub string `Android 4.0.5`. Due to the nature of the chosen hash algorithm, the hashes of the two sub strings vary proportionally to the difference in ASCII value of the last character. This means that if the difference is set to one, the unknown sub string will be allowed as a match for the known Android version.
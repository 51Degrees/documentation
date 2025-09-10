@page IpIntelligence_Algorithm IP Intelligence Algorithm

# IP Intelligence Algorithm

51Degrees IP Intelligence uses a directed acyclic graph to identify geolocation and network from a IP v4 or v6 address.

## Core Algorithm Design

### Data Structure

Vertexes are variable length bits forming lower and upper limits corresponding to bit positions in the target IP address.

Bits from the target IP address are evaluated against these limits to identify five possible edges.

1. Less than the lower limit
2. Equal to the lower limit
3. Between the lower and upper limit
4. Equal to the upper limit
5. Greater than the upper limit

When an edge is found that corresponds to a location or network profile a result is returned.

The physical data structure is extremely space efficient and performant when compared to previous data structures.

### Implementation

The algorithm is implemented in C code for maximum portability and performance including in edge computing and network appliances. Key characteristics include;

- **In-process** - all the data and compute operation resides in the same process delivering minimum latency and the best possible performance in practice.
- **In-memory** - all data is loaded into memory for maximum performance. Ideal for offline processing or highly parallelized environments.
- **On-disk** - data is retained on disk for fastest start up performance. Ideal for serverless and web environments.
- **Simple** - high level language APIs make deployment simple for developers of all experience levels.
- **Automatic Update** - data can be updated automatically without requiring a process restart.

See the [C code](https://github.com/51Degrees/ip-graph-cxx) to find out more about the implementation.

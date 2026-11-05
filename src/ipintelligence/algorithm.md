@page IpIntelligence_Algorithm IP Intelligence Algorithm

# IP Intelligence Algorithm

51Degrees IP Intelligence uses a directed acyclic graph to identify location and network information from an IPv4 or IPv6 address.

## Core Algorithm Design

### Data Structure

Vertices are variable length bits forming lower and upper limits corresponding to bit positions in the target IP address.

We compare bits from the target IP address with these limits to choose one of five possible edges:

1. Less than the lower limit
2. Equal to the lower limit
3. Between the lower and upper limit
4. Equal to the upper limit
5. Greater than the upper limit

When an edge is found that corresponds to a location or network profile a result is returned.



### Implementation

The algorithm is implemented in C for use in applications including edge computing and network appliances. Its deployment options include:

- **In-process** - Data access and computation run in the same process to reduce latency.
- **In-memory** - all data is loaded into memory for maximum performance. Ideal for offline processing or highly parallelized environments.
- **On-disk** - data is retained on disk for fastest start up performance. Ideal for serverless and web environments. With the default Balanced profile, naming the required properties holds what they read in memory and leaves what they do not read on disk, which makes lookups faster without using more memory.
- **Simple** - high-level language APIs make deployment simple for developers of all experience levels.
- **Automatic Update** - data can be updated automatically without requiring a process restart.

See the [C code](https://github.com/51Degrees/51degrees-cxx/tree/main/src/ipi/graph) to find out more about the implementation.

@page IpIntelligence_Algorithm IP Intelligence algorithm

# IP Intelligence algorithm

51Degrees IP Intelligence uses a directed acyclic graph to identify location and network information from an IPv4 or IPv6 address.

## Core algorithm design

### Data structure

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
- **On-disk** - data is retained on disk for fastest start up performance. Ideal for serverless and web environments. With the `HighPerformance` profile, naming the required properties loads only what they read and leaves the rest on disk, which gives lookups at in-memory speed with much less memory. See [performance options](@ref DeviceDetection_Features_PerformanceOptions) for when to use each profile.
- **Simple** - high-level language APIs make deployment simple for developers of all experience levels.
- **Automatic Update** - data can be updated automatically without requiring a process restart.

`Balanced` is the default profile, except for the engine PHP builds when it starts. That engine is built from the php.ini file and always holds all the data in memory with `MaxPerformance`, because PHP usually serves requests from worker processes copied from the process that built the engine, and with a profile that reads from the data file those workers would corrupt each other's reads. An engine that PHP code builds later, from a settings array, may use any profile and defaults to `Balanced`.

See the [C code](https://github.com/51Degrees/51degrees-cxx/tree/main/src/ipi/graph) to find out more about the implementation.

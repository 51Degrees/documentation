@page ProductSummaries_Benchmarks_Hardware Hardware Benchmarks

These results are for version 4.5.70 of the Device Detection C library and
version 4.5.34 of the IP Intelligence C library. The
[machines](@ref ProductSummaries_Benchmarks_Hardware_Machines) and
[how we tested](@ref ProductSummaries_Benchmarks_Hardware_HowWeTested),
including what InMemory and Balanced mean, follow the results.

# Device Detection

## InMemory, detections per second

| Machine | `IsMobile` | `PlatformName` | `BrowserName` | `IsCrawler` | One per component | Every property |
|---|---:|---:|---:|---:|---:|---:|
| Dell server | 11,171,641 | 15,064,331 | 10,290,677 | 9,151,766 | 2,935,237 | 1,615,576 |
| AWS c7g.2xlarge | 1,362,952 | 1,701,221 | 1,172,524 | 1,174,748 | 306,275 | 166,181 |
| AWS c6i.2xlarge | 1,002,638 | 1,232,228 | 873,894 | 868,417 | 235,993 | 108,482 |
| Mac mini (2020) | 1,244,922 | 1,448,673 | 1,077,340 | 993,003 | 285,818 | 164,508 |
| Mac mini (2018) | 748,856 | 1,039,969 | 724,112 | 635,516 | 181,778 | 93,795 |
| Raspberry Pi 4 Model B | 91,206 | 113,152 | 83,799 | 76,767 | 22,397 | 9,678 |
| Desktop PC from 2008 | 66,240 | 104,594 | 75,791 | 61,373 | 16,148 | 9,278 |

Measured on 31 July 2026.

## Balanced, detections per second

| Machine | `IsMobile` | `PlatformName` | `BrowserName` | `IsCrawler` | One per component | Every property |
|---|---:|---:|---:|---:|---:|---:|
| Dell server | 241,159 | 210,165 | 150,522 | 189,234 | 56,606 | 638 |
| AWS c7g.2xlarge | 350,858 | 350,747 | 184,068 | 327,593 | 60,601 | 3,374 |
| AWS c6i.2xlarge | 236,870 | 233,612 | 143,369 | 223,668 | 46,170 | 2,750 |
| Mac mini (2020) | 347,849 | 332,328 | 203,284 | 208,838 | 64,038 | 2,747 |
| Mac mini (2018) | 145,968 | 134,552 | 84,041 | 140,662 | 27,676 | 1,568 |
| Raspberry Pi 4 Model B | 35,871 | 42,699 | 21,204 | 40,980 | 6,760 | 306 |
| Desktop PC from 2008 | 75,363 | 83,635 | 47,220 | 62,049 | 14,276 | 472 |

Measured on 31 July 2026.

The every-property column for Balanced comes from about 20,000 records rather
than one million. Balanced is very slow when every property is requested, so if
you need many properties, keep the whole data file in memory.
[Performance Options](@ref DeviceDetection_Features_PerformanceOptions) also
recommends keeping the data file in memory when many threads run at once.

On the 2008 desktop, Balanced beat InMemory for `IsMobile` and `IsCrawler`.
Don't read much into that, as Balanced timed only the first one million records
and InMemory all six million.

## Startup and memory

| Machine | InMemory startup (ms) | Balanced startup (ms) | InMemory dataset memory (MB) | Balanced dataset memory (MB) |
|---|---:|---:|---:|---:|
| Dell server | 197 | 130 | 97.0 | 12.0 |
| AWS c7g.2xlarge | 142 | 84 | 95.7 | 7.6 |
| AWS c6i.2xlarge | 148 | 58 | 95.7 | 7.6 |
| Mac mini (2020) | 76 | 30 | n/a | 7.5 |
| Mac mini (2018) | 163 | 63 | 95.6 | 7.5 |
| Raspberry Pi 4 Model B | 1,067 | 743 | 95.8 | 7.4 |
| Desktop PC from 2008 | 2,900 | 376 | n/a | 7.6 |

Measured on 31 July 2026.

# IP Intelligence

## InMemory, lookups per second

| Machine | `RegisteredName` | `AsnName` | `Longitude` | All three | Every property |
|---|---:|---:|---:|---:|---:|
| Dell server | 25,449,915 | 32,571,687 | 10,104,818 | 2,435,107 | 1,974,117 |
| AWS c7g.2xlarge | 4,363,143 | 5,688,929 | 2,077,427 | 1,131,583 | 270,740 |
| AWS c6i.2xlarge | 2,518,674 | 3,053,785 | 1,507,127 | 761,703 | 178,844 |
| Mac mini (2020) | 2,352,278 | 4,806,364 | 884,235 | 559,059 | 209,876 |
| Mac mini (2018) | 1,194,046 | 2,512,458 | 518,619 | 321,427 | 133,013 |

Measured on 31 July 2026.

## Balanced, lookups per second

| Machine | `RegisteredName` | `AsnName` | `Longitude` | All three | Every property |
|---|---:|---:|---:|---:|---:|
| Dell server | 613,047 | 519,802 | 553,565 | 292,703 | 4,763 |
| AWS c7g.2xlarge | 1,511,950 | 1,865,780 | 1,001,305 | 334,432 | 10,887 |
| AWS c6i.2xlarge | 1,230,586 | 1,512,510 | 789,145 | 282,252 | 9,713 |
| Mac mini (2020) | 1,496,085 | 1,508,657 | 522,488 | 268,159 | 15,914 |
| Mac mini (2018) | 890,080 | 1,093,366 | 404,271 | 135,130 | 5,465 |

Measured on 31 July 2026.

As with Device Detection, the Balanced every-property result comes from about
20,000 records.

## Startup and memory

| Machine | InMemory startup (ms) | Balanced startup (ms) | InMemory dataset memory (MB) | Balanced dataset memory (MB) |
|---|---:|---:|---:|---:|
| Dell server | 2,754 | 1,139 | 5,838.0 | 2,667.0 |
| AWS c7g.2xlarge | 1,615 | 743 | 5,838.5 | 2,663.1 |
| AWS c6i.2xlarge | 2,402 | 1,089 | 5,838.5 | 2,663.1 |
| Mac mini (2020) | 2,893 | 726 | n/a | 2,413.1 |
| Mac mini (2018) | 4,706 | 1,594 | n/a | 2,457.2 |

Measured on 31 July 2026.

# Machines {#ProductSummaries_Benchmarks_Hardware_Machines}

| Machine | Processor | Cores (physical/logical) | Memory (GB) | Operating system | Compiler |
|---|---|---|---:|---|---|
| Dell server | Two AMD EPYC 7742, 64 cores each, one thread per core | 128/128 | 1,259 | Ubuntu 24.04, in a Docker container | GCC 13.3 |
| AWS c7g.2xlarge | AWS Graviton3 (Arm Neoverse-V1), 2.6 GHz | 8/8 | 16 | Amazon Linux 2023 | GCC 11.5 |
| AWS c6i.2xlarge | Intel Xeon Platinum 8375C (Ice Lake), 3.5 GHz all-core turbo, two threads per core | 4/8 | 16 | Amazon Linux 2023 | GCC 11.5 |
| Mac mini (2020) | Apple M1, four performance and four efficiency cores | 8/8 | 8 | macOS 14.4 | Apple Clang 15.0 |
| Mac mini (2018) | Intel Core i5-8500B, 3.0 GHz | 6/6 | 8 | macOS 15.7 | Apple Clang 17.0 |
| Raspberry Pi 4 Model B | Arm Cortex-A72 | 4/4 | 3.7 | Debian 12 | GCC 12.2 |
| Desktop PC from 2008 | Intel Core 2 Duo E8400, 3.0 GHz | 2/2 | 3.6 | Ubuntu 24.04 | GCC 13.3 |

Memory is the amount the operating system reported, in GB of 1,073,741,824
bytes, except for the two AWS instances, which show the size of the instance.

# How we tested {#ProductSummaries_Benchmarks_Hardware_HowWeTested}

We ran the Device Detection C library on seven machines, from a 128-core server
down to a desktop PC built in 2008, and the IP Intelligence C library on five
of them. We recorded throughput, startup time, and memory use on each. Every
machine used the same library versions, data files, and evidence, and we ran
each test once.

## Libraries and data

We built the C libraries from the public repositories, at version
[4.5.70](https://github.com/51Degrees/device-detection-cxx/tree/4.5.70) for
Device Detection and
[4.5.34](https://github.com/51Degrees/ip-intelligence-cxx/tree/4.5.34) for IP
Intelligence. Each machine compiled its own Release build with `-O3`. The build
script also adds `-march=native`, dropping it if the compiler rejects it. The
machines table lists each compiler.

The data files were `TAC-HashV41.hash` (99,667,840 bytes) for Device Detection
and `51Degrees-IPIV4EnterpriseIpiV41.ipi` (6,121,965,416 bytes) for IP
Intelligence, both published on 30 July 2026.

## Configurations

Each library ran in two configurations:

- InMemory loads the whole data file into memory. It is the configuration that
  the `MaxPerformance` [profile](@ref DeviceDetection_Features_PerformanceOptions)
  selects. For these runs we also compiled the library with the memory-only
  option (`FIFTYONE_DEGREES_MEMORY_ONLY`), which leaves out the code for
  reading from disk.
- Balanced, the default profile, reads most of the data file through caches
  that keep the most used data in memory and leave the rest on disk. For IP
  Intelligence, Balanced still loads some parts of the data file fully into
  memory, including the text strings and the IP address graphs described in
  [IP Intelligence Algorithm](@ref IpIntelligence_Algorithm). Each Balanced run
  made an untimed warm-up pass over the same records it then timed, so the
  caches had already seen that traffic. We set the expected concurrency to the
  number of threads, as
  [Concurrent Processing](@ref DeviceDetection_Features_ConcurrentProcessing)
  describes. On the Dell server, with 128 threads, that raised every cache
  smaller than 16,384 entries to 16,384.

## Properties

The `IsMobile`, `PlatformName`, `BrowserName`, and `IsCrawler` columns each
request that property alone. In that order, they come from the hardware,
operating system, browser, and crawler components. "One per component"
requests all four properties together, and "Every property" requests all 279.
For IP Intelligence, the `RegisteredName`, `AsnName`, and `Longitude` columns
each request that property alone. "All three" requests them together, and
"Every property" requests all 49.

Requesting fewer properties is faster because each detection has fewer values
to read, and for Device Detection the library evaluates only the components
that the requested properties belong to (see
[Restrict properties](@ref DeviceDetection_Features_PerformanceOptions)).

## Evidence

Device Detection used six million sets of HTTP request headers from real web
traffic. Each set has a User-Agent, plus User-Agent Client Hints where the
browser sent them. Popular devices and browsers appear many times.

IP Intelligence used six million IP addresses from real web traffic, with no
address repeated in the set.

Each machine ran one thread per logical processor, and each thread took its
own share of the records. In the timed pass every record was processed once,
and no results cache was used. The InMemory runs timed all six million records
and the Balanced runs timed the first one million. The one exception is the
Balanced every-property run, which was limited to 20,000 records because
reading every property with Balanced is very slow. Each thread's share of that
limit was rounded up to a whole number of records, which made the totals 20,096
on the Dell server and 20,004 on the 2018 Mac mini.

## Reading the tables

Detections per second is the total number of records that all the threads
processed, divided by the wall-clock time from the first thread starting to the
last one finishing. A detection here means taking one record, finding the
result, and reading every requested property value. The IP Intelligence tables
count lookups per second in the same way, where a lookup finds the properties
for one IP address. Loading the evidence into memory happened before the clock
started and isn't included.

Startup is how long it took to load the data file and be ready to detect, with
every property requested.

Dataset memory is how much the process's resident memory grew when the data
file was loaded, before any detections ran. It doesn't include the evidence,
and for Balanced it doesn't include the caches as they fill up. MB means
1,048,576 bytes. Four of the InMemory results showed no growth at all, which
can't be right when the whole file is loaded, and the tables show n/a for
those. Only the memory reading is in doubt, because checksums of the detection
results from those runs match those from the other machines.

To work out how long one detection takes with every thread busy, divide the
number of threads by the detections per second, because each thread handles
its records one after another. On the Graviton3 instance with InMemory and
`IsMobile`, eight threads at 1,362,952 detections per second works out at about
5.9 microseconds per detection.

## What we didn't measure

- Which machines kept `-march=native`.
- A standard build using `MaxPerformance`, which may be slower than the
  InMemory figures here.
- Memory use once the Balanced caches had filled.
- How much results vary from one run to the next, because each test ran once.
- What effect the intermittent low-voltage warnings we saw during the Raspberry
  Pi run had on its results.
- IP Intelligence on the Raspberry Pi and the 2008 desktop. The IP Intelligence
  InMemory run needs 5,838 MB, which is more memory than either machine has, so
  we left the whole product out on both. That includes the Balanced run, even
  though Balanced needs less memory.
- Why the 128-core server was slower than the eight-core Graviton3 instance in
  every Balanced column.

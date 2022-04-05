@page Info_TestedVersions Tested Versions

51Degrees uses automated testing to continuously validate our API against a number of platforms and language versions.
The tests cover a wide array of scenarios and are available to view in our repositories on GitHub.
In general, we apply the following guidelines when deciding which platforms and versions to test against:
- We use Azure DevOps with Microsoft-hosted build agents, so we test against platforms that Microsoft [has hosted agents for](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/hosted).
- We test against all versions of languages that are currently considered LTS (Long Term Support) versions.

The tabs below show the specific platforms and versions that are currently tested as part of each release.

****

If something is not tested here, and you believe it should be, please raise an issue via our [GitHub](https://github.com/51Degrees) page and we will look into it.

You may also want to review the @dependencies page, as these topics are related.

**NOTE**: Please refer to the bottom of this page for terminology used below.

@startsnippets
@showsnippet{cxx,C/C++}
@showsnippet{dotnet,.NET}
@showsnippet{java,Java}
@showsnippet{php,PHP}
@showsnippet{node,Node.js}
@showsnippet{python,Python}
@showsnippet{go,Go}
@showsnippet{varnish,Varnish}
@showsnippet{nginx,Nginx}
@showsnippet{wordpress,Wordpress}
@showsnippet{sitecore,Sitecore}
@showsnippet{rust,Rust}
@defaultsnippet{Select a language to view the tested versions.}
@startsnippet{cxx}
Language Versions:
- C11

Platforms:
- Windows Server 2019
  - 32-bit & 64-bit
  - x86_64/amd64
- Ubuntu 18.04
  - 32-bit & 64-bit
  - x86_64/amd64
  - GCC 7.5
- MacOS 11
  - 64-bit
  - x86_64/amd64
  - Clang 13

@endsnippet
@startsnippet{dotnet}

Language Versions:
- .NET Core 3.1

Platforms:
- Windows Server 2019
  - 32-bit & 64-bit
  - x86_64/amd64  TODO
  - C/C++ Redistributable 14.2*
- Ubuntu 18.04
  - 64-bit
  - x86_64/amd64  TODO
  - libatomic1

@endsnippet
@startsnippet{java}
Language Versions:
- Java 8, 11 & 17

Platforms:
- Windows Server 2019
  - 64-bit
  - x86_64/amd64
  - C/C++ Redistributable 14.2*
- Ubuntu 18.04
  - 64bit
  - x86_64/amd64
- MacOS 11
  - 64bit
  - x86_64/amd64

To build from source:
  - [Pipeline](https://github.com/51Degrees/pipeline-java)
  - [Device Detection](https://github.com/51Degrees/device-detection-java)
  - [Location](https://github.com/51Degrees/location-java)

@endsnippet
@startsnippet{php}
Language Versions:
- PHP 5.6, 7.2, 7.3, 7.4 and 8.0

Platforms:
- Ubuntu 18.04
  - php-dev
  - 64-bit
  - x86_64/amd64
  - For 'Device Detection - Onpremise'
    - GCC 7.5
    - libatomic1

@endsnippet
@startsnippet{node}
Language Versions:
- Node.js 10, 12, 14, 16

Platforms:
- Windows Server 2019
  - 64-bit
  - x86_64/amd64
  - C/C++ Redistributable 14.2*
- Ubuntu 18.04
  - 64-bit
  - x86_64/amd64
- MacOS 11
  - 64-bit
  - x86_64/amd64
@endsnippet
@startsnippet{python}
Language Versions:
- Python 3.7, 3.8, 3.9

Platforms:
- Windows Server 2019
  - 32-bit & 64-bit
  - x86_64/amd64
  - For 'Device Detection':
    - Cython
    - Platform Toolset Version v142
    - Windows 10 SDK version 10.0.18362.0
- Ubuntu 18.04
  - 64-bit
  - x86_64/amd64
  - For 'Device Detection':
    - Cython
    - GCC 7.5
    - libatomic1
- MacOS 11
  - 64-bit
  - x86_64/amd64
  - For 'Device Detection':
    - Cython
    - Clang 13
    - libatomic1
@endsnippet
@startsnippet{go}
Language Versions:
- Golang 1.17.1

Platforms:
- Windows Server 2019
  - 64-bit
  - x86_64/amd64
  - MinGW-w64
- Ubuntu 18.04
  - 32-bit & 64-bit
  - x86_64/amd64
  - GCC 7.5
  - libatomic1
- MacOS 11
  - 64-bit
  - x86_64/amd64
  - Clang 13
  - libatomic1

@endsnippet
@startsnippet{varnish}
Language Versions:
- Varnish 6.0.8

Platforms:
- Ubuntu 18.04
  - GCC 7.5
  - 64-bit
  - x86_64/amd64
  - libatomic1
- Ubuntu 20.04
  - GCC 9.3
  - 64-bit
  - x86_64/amd64
  - libatomic1

@endsnippet
@startsnippet{nginx}
Language Versions:
- Nginx 1.19.0, 1.19.5, 1.19.10, 1.20.0, 1.21.3

Platforms:
- Ubuntu 18.04
  - GCC 7.5
  - 64-bit
  - x86_64/amd64
  - libatomic1
- Ubuntu 20.04
  - GCC 9.3
  - 64-bit
  - x86_64/amd64
  - libatomic1

@endsnippet
@startsnippet{wordpress}
Language Versions:
- Wordpress 5.9.2

Platforms:
- Ubuntu 18.04
  - PHP 5.6, 7.2, 7.3, 7.4
@endsnippet
@startsnippet{sitecore}

Details to follow.

@endsnippet
@startsnippet{rust}

Not tested by 51Degrees but available to try [here](https://crates.io/crates/fiftyonedegrees).

@endsnippet
@endsnippets

Terminology:
- **32-bit**: 32 bit build
- **64-bit**: 64 bit build
- **x86_64** / **amd64**: x86-64 architecture (Also known as x64/AMD64/Intel 64)
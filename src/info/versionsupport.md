@page Info_VersionSupport Tested Versions

All APIs are written with a minimum tested language version. Any version above this is theoretically tested, but bleeding edge releases may not be covered by our testing. The table below shows the versions which are tested as part of each release. Where 'prebuilt packages' are available, we detail the built and tested environment together with other dependencies needed to use the packages; and only list the links to the instructions for 'build from source' options. Where 'prebuilt packages' are broadly not available, we list the build and tested environment under the 'build from source' option.

Our policy is to use the build agents from Microsoft that they have at the current time. You can see Microsoft's build agent [here](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/hosted?view=azure-devops&tabs=yaml).

We open source all the build scripts in the CI folder.  If you wish to ensure that the system is being tested on an environment or a particular combination of configurations that isn't covered by us, you might want to replicate these build scripts in your build environment rather than relying on the packages that we produce.

Testing exclusively takes place on long-term support releases.

****

If something is not tested here, and you believe it should be, please raise an issue via our [GitHub](https://github.com/51Degrees) page and we will look into it.

**NOTE**: Please refer to the bottom of this page for terminology used in the below table.

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
Tested versions:
- C11

Prebuilt packages:
- No prebuilt packages are available

To build from source:
- Instructions:
  - [Device Detection](https://github.com/51Degrees/device-detection-cxx)
  - [Common Code](https://github.com/51Degrees/common-cxx)
- Tested Platforms:
  - Windows Server 2019
    - 32-bit & 64-bit
    - x86_64/amd64
    - Platform Toolset Version v142
    - Windows 10 SDK version 10.0.18362.0
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
@startsnippet{dotnet}
Tested versions:
- .NET Standard 2.0

Prebuilt packages are built and tested on the following systems:
- Windows Server 2019
  - .NET Standard 2.0
  - 32-bit & 64-bit
  - x86_64/amd64
  - C/C++ Redistributable 14.2*
- Ubuntu 18.04
  - .NET Standard 2.0
  - 64-bit
  - x86_64/amd64
  - libatomic1

To build from source:
- Instructions:
  - [Pipeline](https://github.com/51Degrees/pipeline-dotnet)
  - [Device Detection](https://github.com/51Degrees/device-detection-dotnet)
  - [Location](https://github.com/51Degrees/location-dotnet)

@endsnippet
@startsnippet{java}
Tested versions:
- Java 8, 11, 17

Prebuilt packages are built and tested on the following systems:
- Windows Server 2019
  - Java 8, 11 & 17
  - 64-bit
  - x86_64/amd64
  - C/C++ Redistributable 14.2*
- Ubuntu 18.04
  - Java 8, 11 & 17
  - 64bit
  - x86_64/amd64
  - libatomic1
- MacOS 11
  - Java 8, 11 & 17
  - 64bit
  - x86_64/amd64
  - libatomic1

To build from source:
  - [Pipeline](https://github.com/51Degrees/pipeline-java)
  - [Device Detection](https://github.com/51Degrees/device-detection-java)
  - [Location](https://github.com/51Degrees/location-java)

@endsnippet
@startsnippet{php}
Tested versions:
- PHP 5.6, 7.x, 8.0

Prebuilt packages are built and tested on the following systems:
- Ubuntu 18.04
  - PHP 5.6, 7.2, 7.3, 7.4 and 8.0
  - 64-bit
  - x86_64/amd64
  - For 'Device Detection - Onpremise'
    - No prebuilt packages are available

To build from source:
- Instructions:
  - Pipeline:
    - [Core](https://github.com/51Degrees/pipeline-php-core)
    - [Engines](https://github.com/51Degrees/pipeline-php-engines)
    - [Cloud Request Engine](https://github.com/51Degrees/pipeline-php-cloudrequestengine)
  - Device Detection:
    - [Cloud](https://github.com/51Degrees/device-detection-php)
    - [Onpremise](https://github.com/51Degrees/device-detection-php-onpremise)
  - Location:
    - [Location](https://github.com/51Degrees/location-php)
- Tested platforms:
  - Ubuntu 18.04
    - PHP 5.6, 7.2, 7.3, 7.4 and 8.0
    - php-dev
    - 64-bit
    - x86_64/amd64
    - For 'Device Detection - Onpremise'
      - GCC 7.5
      - libatomic1

**NOTE**: When using our PHP Device Detection solution under a process manager such as Apache MPM, php-fpm or any other process manager, the following restrictions are applied:
-	Only **MaxPerformance** profile can be used.
-	Manual reload cannot be used. A full server restart is required.
If Apache MPM is used:
-	Only **prefork** mode can be used.
These restrictions are due to the design of our API. We have designed our API to allow setting of different performance profiles, offer the user flexibility between performance and memory usage, while also scaling well in highly concurrent environments.


@endsnippet
@startsnippet{node}
Tested versions:
- Node.js 10, 12, 14, 16

Prebuilt packages are built and tested on the following systems:
- Windows Server 2019
  - Node.js LTS versions (10, 12, 14, 16)
  - 64-bit
  - x86_64/amd64
  - C/C++ Redistributable 14.2*
- Ubuntu 18.04
  - Node.js LTS versions (10, 12, 14, 16)
  - 64-bit
  - x86_64/amd64
  - libatomic1
- MacOS 11
  - Node.js LTS versions (10, 12, 14, 16)
  - 64-bit
  - x86_64/amd64
  - libatomic1

To build from source:
- [Pipeline](https://github.com/51Degrees/pipeline-node)
- [Device Detection](https://github.com/51Degrees/device-detection-node)
- [Location](https://github.com/51Degrees/location-node)

@endsnippet
@startsnippet{python}
Tested versions:
- Python 3.7, 3.8, 3.9

Prebuilt packages are built and tested on the following systems:
- Windows Server 2019
  - Python 3.7, 3.8, 3.9
  - 32-bit & 64-bit
  - x86_64/amd64
  - For 'Device Detection':
    - Cython
    - Platform Toolset Version v142
    - Windows 10 SDK version 10.0.18362.0
- Ubuntu 18.04
  - Python 3.7, 3.8, 3.9
  - 64-bit
  - x86_64/amd64
  - For 'Device Detection':
    - Cython
    - GCC 7.5
    - libatomic1
- MacOS 11
  - Python 3.7, 3.8, 3.9
  - 64-bit
  - x86_64/amd64
  - For 'Device Detection':
    - Cython
    - Clang 13
    - libatomic1

To build from source:
- [Pipeline](https://github.com/51Degrees/pipeline-python)
- [Device Detection](https://github.com/51Degrees/device-detection-python)
- [Location](https://github.com/51Degrees/location-python)

**NOTE**: When using Device Detection API for On-premise in a spawned multi processes environment, the Pipeline object should be created for each process. If it is created as a global variable, the spawned process will re-initialize the variable and therefore, each process will have their own version of the pipeline object. In this environment, `create_temp_data_copy` option should to be set to `False` and the `performance_profile` option should be set to `MaxPerformance`. Since a pipeline is created for each process, there will be an associated memory cost.

These restrictions are due to the design of our API. We have designed our API to allow setting of different performance profiles, offer the user flexibility between performance and memory usage, while also scaling well in highly concurrent environments.

@endsnippet
@startsnippet{go}
Tested versions:
- Golang 1.17.1

Prebuilt packages:
- No prebuilt packages are available

To build from source:
- Instructions:
  - [Device Detection](https://github.com/51Degrees/device-detection-go)
- Tested Platforms:
  - Windows Server 2019
    - Golang 1.17.1
    - 64-bit
    - x86_64/amd64
    - MinGW-w64
  - Ubuntu 18.04
    - Golang 1.17.1
    - 32-bit & 64-bit
    - x86_64/amd64
    - GCC 7.5
    - libatomic1
  - MacOS 11
    - Golang 1.17.1
    - 64-bit
    - x86_64/amd64
    - Clang 13
    - libatomic1

@endsnippet
@startsnippet{varnish}
Tested versions:
- Varnish 6.0.8

Prebuilt packages:
- No prebuilt packages are available

To build from source:
- Instructions:
  - [Device Detection](https://github.com/51Degrees/device-detection-varnish)
- Tested Platforms:
  - Ubuntu 18.04
    - Varnish 6.0.8
    - GCC 7.5
    - 64-bit
    - x86_64/amd64
    - libatomic1
  - Ubuntu 20.04
    - Varnish 6.0.8
    - GCC 9.3
    - 64-bit
    - x86_64/amd64
    - libatomic1

@endsnippet
@startsnippet{nginx}
Tested versions:
- Nginx 1.19.0, 1.19.5, 1.19.10, 1.20.0, 1.21.3

Prebuilt packages:
- No prebuilt packages are available

To build from source:
- Instructions:
  - [Device Detection](https://github.com/51Degrees/device-detection-nginx)
- Tested Platforms:
  - Ubuntu 18.04
    - Nginx 1.19.0, 1.19.5, 1.19.10, 1.20.0, 1.21.3
    - GCC 7.5
    - 64-bit
    - x86_64/amd64
    - libatomic1
  - Ubuntu 20.04
    - Nginx 1.19.0, 1.19.5, 1.19.10, 1.20.0, 1.21.3
    - GCC 9.3
    - 64-bit
    - x86_64/amd64
    - libatomic1

@endsnippet
@startsnippet{wordpress}
Tested versions:
- Wordpress 5.9.2

Prebuilt packages are built and tested on the following systems:
- Ubuntu 18.04
  - Wordpress 5.9.2
  - PHP 5.6, 7.2, 7.3, 7.4

To build from source:
- [Pipeline](https://github.com/51Degrees/pipeline-wordpress)

@endsnippet
@startsnippet{sitecore}

Will be available soon.

@endsnippet
@startsnippet{rust}

Not tested but available to try [here](https://crates.io/crates/fiftyonedegrees).

@endsnippet
@endsnippets

*Other environments may work, but are not tested by 51Degrees.

Terminology:
- **32-bit**: 32 bit build
- **64-bit**: 64 bit build
- **x86_64** / **amd64**: x86-64 architecture (Also known as x64/AMD64/Intel 64)
- **armhf (ARM hard float)**:  32-bit ARM architecture (Debian Linux)
- **aarch64** / **arm64**: 64-bit ARM architecture
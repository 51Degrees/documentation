@page Info_Dependencies Dependencies

51Degrees produce packages that can be consumed via the industry standard package managers for
each language. (NuGet for .NET, Maven for Java, etc.)

There is also the option of building directly from the source code, hosted at [GitHub](https://github.com/51Degrees), 
rather than using the pre-built packages. This will require build-time dependencies to be provided.


Your intended deployment environment may also influence the dependencies that are required.
For example, the on-premise implementation of our Device Detection product is written in C for the 
best possible performance. However, this does come with the price of more complex dependencies 
than is typical for higher-level languages. In comparison, the cloud product has no need for these 
more complex dependencies.

51Degrees' dependencies policy is:
- We aim to minimize third-party dependencies.
- We will use >= binding where possible. (i.e. the package should work with the target version and any later version)
- We will target the oldest version that:
  - Has no known vulnerabilities.
  - Is compatible with the most recent stable (i.e. non-beta, rtm, etc.) version
- We use Azure DevOps with Microsoft-hosted build agents, as such, the pre-built packages may include low-level dependencies based on the [software](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/hosted) that is available on these build agents.

If you are having trouble with a particular dependency, check our @faqs for common problems and solutions.

You may also want to review the @testedversions page, as these topics are related.

Click the tabs below to see dependencies for running the pre-built packages as well as additional
dependencies required for on-premise device detection and instructions for building from the source 
code.

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
@showsnippet{rust,Rust}
@defaultsnippet{Select a language to view the tested versions.}
@startsnippet{cxx}
Packages:
- No prebuilt packages are available

Instructions for building from source:
- [Device Detection](https://github.com/51Degrees/device-detection-cxx#readme)
- [Common Code](https://github.com/51Degrees/common-cxx#readme)

@endsnippet
@startsnippet{dotnet}

Packages:  
- .NET Standard 2.0
- See [Nuget](https://www.nuget.org/profiles/51Degrees) for other specific .NET package dependencies
- On-premise device detection
  - Windows
    - C++ redistributable 14.20 or later
  - Linux
    - libatomic1

Instructions for building from source:
- [Pipeline](https://github.com/51Degrees/pipeline-dotnet#readme)
- [Device Detection](https://github.com/51Degrees/device-detection-dotnet#readme)
- [Location](https://github.com/51Degrees/location-dotnet#readme)

@endsnippet
@startsnippet{java}
Packages:
- Java 8 or later
- See [Maven](https://search.maven.org/search?q=g:com.51degrees) for details of package dependencies
- On-premise device detection
  - Windows
    - C++ redistributable 14.20 or later
  - Linux/Mac OS
    - libatomic1

Instructions for building from source:
- [Pipeline](https://github.com/51Degrees/pipeline-java#readme)
- [Device Detection](https://github.com/51Degrees/device-detection-java#readme)
- [Location](https://github.com/51Degrees/location-java#readme)

@endsnippet
@startsnippet{php}
Packages:

- PHP 5.6 or later
- See [Packagist](https://packagist.org/packages/51degrees/) for details of package dependencies
- On-premise device detection
  - Linux
    - libatomic1

Instructions for building from source:
  - Pipeline:
    - [Core](https://github.com/51Degrees/pipeline-php-core#readme)
    - [Engines](https://github.com/51Degrees/pipeline-php-engines#readme)
    - [Cloud Request Engine](https://github.com/51Degrees/pipeline-php-cloudrequestengine#readme)
  - Device Detection:
    - [Cloud](https://github.com/51Degrees/device-detection-php#readme)
    - [On-premise](https://github.com/51Degrees/device-detection-php-onpremise#readme)
  - Location:
    - [Location](https://github.com/51Degrees/location-php#readme)

@endsnippet
@startsnippet{node}

Packages:

- Node.js 10 or later
- See [NPM](https://www.npmjs.com/~51degrees) for details of package dependencies
- On-premise device detection
  - Windows
    - C++ redistributable 14.20 or later
  - Linux/Mac OS
    - libatomic1

Instructions for building from source:
- [Pipeline](https://github.com/51Degrees/pipeline-node#readme)
- [Device Detection](https://github.com/51Degrees/device-detection-node#readme)
- [Location](https://github.com/51Degrees/location-node#readme)

@endsnippet
@startsnippet{python}

Packages:

- Python 3.7 or later
- See [pypi](https://pypi.org/user/51Degrees.mobi/) for details of package dependencies
- On-premise device detection
  - Windows
    - C++ redistributable 14.20 or later
  - Linux/Mac OS
    - libatomic1
  - In addition, the following dependencies are required at package install time in order to build the native binary
    - Cython
    - Platform Toolset Version v142
    - Windows 10 SDK version 10.0.18362.0

Instructions for building from source:
- [Pipeline](https://github.com/51Degrees/pipeline-python#readme)
- [Device Detection](https://github.com/51Degrees/device-detection-python#readme)
- [Location](https://github.com/51Degrees/location-python#readme)

@endsnippet
@startsnippet{go}

Packages:
- No prebuilt packages are available
  
Instructions for building from source:
- Golang 1.17.1 or later
- [Device Detection](https://github.com/51Degrees/device-detection-go#readme)

@endsnippet
@startsnippet{varnish}
Packages:
- No prebuilt packages are available

Instructions for building from source:
- Varnish 6.0.8 or later
- [Device Detection](https://github.com/51Degrees/device-detection-varnish#readme)

@endsnippet
@startsnippet{nginx}
Packages:
- No prebuilt packages are available

Instructions for building from source:
- Nginx 1.19.0 or later
- [Device Detection](https://github.com/51Degrees/device-detection-nginx#readme)

@endsnippet
@startsnippet{wordpress}

Packages:
- Linux
  - Wordpress 5.9.2
  - PHP 5.6 or later

Instructions for building from source:
- The Wordpress integration only supports cloud, not on-premise. As such, there is less need to build from source. If you want to do so, you will need to clone the source code from [GitHub](https://github.com/51Degrees/pipeline-wordpress).

@endsnippet
@startsnippet{rust}

Not tested by 51Degrees but available to try [here](https://crates.io/crates/fiftyonedegrees).

@endsnippet


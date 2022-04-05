@page Info_Dependencies Dependencies

51Degrees produce packages that can be consumed via the industry standard package managers for
each language. (NuGet for .NET, Maven for Java, etc)

As we are an open source company, you also have the option of building directly from the source code, 
rather than using the pre-built packages. This generally requires more in the way of dependencies 
than the pre-built packages described above.

Your intended deployment environment may also influence the dependencies that are required.
For example, the on-premise implementation of our Device Detection product is written in C for the 
best possible performance. However, this does come with the price of more complex dependencies 
than is typical for higher-level languages. In comparison, the cloud product has no need for these 
more complex dependencies.

Click the tabs below to see dependencies for running the pre-built packages as well as any additional
dependencies required for on-premise device detection and/or building from the source code.


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
@endsnippet
@startsnippet{dotnet}
Packages:
- .NET Standard 2.0
- See [Nuget](https://www.nuget.org/profiles/51Degrees) for other specific .NET package dependencies
- On-premise device detection
  - Windows
    - C++ redistributable 14.2 or later
  - Linux
    - libatomic1

Instructions for building from source:
- [Pipeline](https://github.com/51Degrees/pipeline-dotnet)
- [Device Detection](https://github.com/51Degrees/device-detection-dotnet)
- [Location](https://github.com/51Degrees/location-dotnet)

@endsnippet
@startsnippet{java}
@endsnippet
@startsnippet{php}
@endsnippet
@startsnippet{node}
@endsnippet
@startsnippet{python}
@endsnippet
@startsnippet{go}
@endsnippet
@startsnippet{varnish}
@endsnippet
@startsnippet{nginx}
@endsnippet
@startsnippet{wordpress}
@endsnippet
@startsnippet{sitecore}
@endsnippet
@startsnippet{rust}
@endsnippet


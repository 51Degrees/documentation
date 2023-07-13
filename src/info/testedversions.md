@page Info_TestedVersions Tested Versions

Our code base operates on the following CPUs:

- ARM
- M1, M2
- x64
- x86

And the following operating systems:

- Linux
  - Alpine
  - Amazon Linux
  - CentOS
  - Red Hat Enterprise Linux
  - Ubuntu
- Windows
- macOS

These lists are not exhaustive, so please [contact us](https://51degrees.com/contact-us) if you don't see your environment listed.

We automatically test and distribute packages using a limited set of configurations.

# Automation

The tests cover a wide array of scenarios and are available to view in our repositories on [GitHub](https://github.com/51Degrees).
In general, we apply the following guidelines when deciding which platforms and versions to test against:
- We use GitHub Actions with hosted runners, so we test against platforms that GitHub has [hosted runners](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners#supported-runners-and-hardware-resources) for.
- We test against all versions of languages that are currently considered LTS (Long Term Support) versions.

The tabs below show the specific platforms and versions that are currently tested as part of each release.

If something is not tested here, and you believe it should be, please raise an issue via our [GitHub](https://github.com/51Degrees) page. If
you have a configuration that is not covered, [contact us](https://51degrees.com/contact-us) and we will look into it.

You may also want to review the @dependencies page, as these topics are related.
@htmlonly
<script>
  $( document ).ready(function() {
      grabTestedVersions("device-detection-nginx", "nginx-versions", [
          { title: "NGINX Version", getValue: (d) => d.NginxVersion }
      ]);
      grabTestedVersions("device-detection-cxx", "cxx-versions", [
          { title: "Architecture", getValue: (d) => d.Arch }
      ]);
      grabTestedVersions("device-detection-java", "java-versions", [
          { title: "JDK", getValue: d => d.JavaSDKEnvVar.split("_")[2] },
          { title: "Architecture", getValue: d => d.JavaSDKEnvVar.split("_")[3].toLowerCase() }
      ]);
      grabTestedVersions("device-detection-dotnet", "dotnet-versions", [
          { title: "Architecture", getValue: d => d.Arch }
      ]);
      grabTestedVersions("device-detection-python", "python-versions", [
          { title: "Python", getValue: d => d.LanguageVersion }
      ]);
      grabTestedVersions("device-detection-node", "node-versions", [
          { title: "Node", getValue: d => d.LanguageVersion }
      ]);
  });
</script>
@endhtmlonly

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
These are automatically tested on [GitHub](https://github.com/51Degrees?q=cxx&type=all&language=&sort=).
<div id="cxx-versions"></div>
If you have a configuration that is not covered, please [contact us](https://51degrees.com/contact-us).
@endsnippet
@startsnippet{dotnet}
These are automatically tested on [GitHub](https://github.com/51Degrees?q=dotnet&type=all&language=&sort=).
<div id="dotnet-versions"></div>
If you have a configuration that is not covered, please [contact us](https://51degrees.com/contact-us).
@endsnippet
@startsnippet{java}
These are automatically tested on [GitHub](https://github.com/51Degrees?q=java&type=all&language=&sort=).
<div id="java-versions"></div>
If you have a configuration that is not covered, please [contact us](https://51degrees.com/contact-us).
@endsnippet
@startsnippet{php}
Language Versions:
- PHP 5.6, 7.2, 7.3, 7.4 and 8.0

Platforms:
- Ubuntu 18.04
  - 64-bit (x86_64)

@endsnippet
@startsnippet{node}
These are automatically tested on [GitHub](https://github.com/51Degrees?q=node&type=all&language=&sort=).
<div id="node-versions"></div>
If you have a configuration that is not covered, please [contact us](https://51degrees.com/contact-us).
@endsnippet
@startsnippet{python}
These are automatically tested on [GitHub](https://github.com/51Degrees?q=python&type=all&language=&sort=).
<div id="python-versions"></div>
If you have a configuration that is not covered, please [contact us](https://51degrees.com/contact-us).
@endsnippet
@startsnippet{go}
Language Versions:
- Golang 1.17.1

Platforms:
- Windows Server 2019
  - 64-bit (x86_64)
- Ubuntu 18.04
  - 32-bit (x86_64)
  - 64-bit (x86_64)
- MacOS 11
  - 32-bit (x86_64)
  - 64-bit (x86_64)

@endsnippet
@startsnippet{varnish}
Language Versions:
- Varnish 6.0.8

Platforms:
- Ubuntu 18.04
  - 64-bit (x86_64)
- Ubuntu 20.04
  - 64-bit (x86_64)

@endsnippet
@startsnippet{nginx}
<div id="nginx-versions"></div>
@endsnippet
@startsnippet{wordpress}
Language Versions:
- Wordpress 5.9.2

Platforms:
- Ubuntu 18.04
  - PHP 5.6, 7.2, 7.3, 7.4

@endsnippet
@startsnippet{rust}

Not tested by 51Degrees but available to try [here](https://crates.io/crates/fiftyonedegrees).

@endsnippet
@endsnippets

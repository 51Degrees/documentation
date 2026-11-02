@page ProductSummaries_TestedVersions Tested Versions

Our code base has been tested on the following CPU architectures:

- ARM and ARM64 (including AWS Graviton and Apple Silicon)
- x64 (aka x86_64 or AMD64)
- x86

And the following operating systems:

- Linux
  - Alpine
  - Amazon Linux
  - CentOS
  - Oracle Linux
  - Red Hat Enterprise Linux
  - SUSE
  - Ubuntu
- Windows
- macOS

These lists are not exhaustive, so please [contact us](https://51degrees.com/contact-us) if you don't see your environment listed.

Of the operating systems, we target from the latest versions to the older versions that are still maintained by the vendor. For programming languages, we target the LTS (Long Term Support) versions.

## Building from source
We automatically test and distribute binary packages for a limited list of platforms and architectures.  In case the provided binary package does not run on your environment - you have to build the library from source for your specific platform and architecture. All 51Degrees language libraries provide instructions on building the library from source.  F.e. see:

- [Building Device Detection .NET library from source](https://github.com/51Degrees/device-detection-dotnet?tab=readme-ov-file#build-from-source)
- [Building Device Detection Java library from source](https://github.com/51Degrees/51degrees-java/tree/main/device-detection#build-and-install-from-source)

# Automation

The tests cover a wide array of scenarios and are available to view in our repositories on [GitHub](https://github.com/51Degrees).
In general, we apply the following guidelines when deciding which platforms and versions to test against:
- We use GitHub Actions with hosted runners, so we test against platforms that GitHub has [hosted runners](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners#supported-runners-and-hardware-resources) for.
- We test against all versions of languages that are currently considered LTS versions.

The tabs below are built from each repository's CI configuration each time the page loads, so they show what is tested today. Under each table are links to the repository's latest release and to its test runs.

If something is not tested here, and you believe it should be, please raise an issue via our [GitHub](https://github.com/51Degrees) page. If
you have a configuration that is not covered, [contact us](https://51degrees.com/contact-us) and we will look into it.

@htmlonly
<script>
  $( document ).ready(function() {
      grabTestedVersions("51degrees-varnish", "varnish-versions", [
          { title: "Project", getValue: (d) => d.VinylVersion ? "Vinyl Cache" : "Varnish Cache" },
          { title: "Version", getValue: (d) => d.VinylVersion || d.VarnishVersion }
      ], undefined, "publish.yml");
      grabTestedVersions("51degrees-nginx", "nginx-versions", [
          { title: "NGINX Version", getValue: (d) => d.NginxVersion }
      ]);
      grabTestedVersions("51degrees-cxx", "cxx-versions", [
          { title: "Architecture", getValue: (d) => d.Arch }
      ], "dd");
      grabTestedVersions("51degrees-java", "java-versions", [
          { title: "JDK", getValue: d => d.JavaSDKEnvVar.split("_")[2] },
          { title: "Architecture", getValue: d => d.JavaSDKEnvVar.split("_")[3].toLowerCase() }
      ]);
      grabTestedVersions("device-detection-dotnet", "dotnet-versions", [
          { title: "Architecture", getValue: d => d.Arch }
      ]);
      grabTestedVersions("device-detection-python", "python-versions", [
          { title: "Python Version", getValue: d => d.LanguageVersion }
      ]);
      grabTestedVersions("51degrees-node", "node-versions", [
          { title: "Node Version", getValue: d => d.LanguageVersion }
      ]);
      grabTestedVersions("51degrees-node", "ipi-node-versions", [
          { title: "Node Version", getValue: d => d.LanguageVersion }
      ]);
      grabTestedVersions("device-detection-go", "go-versions", [
          { title: "GoLang Version", getValue: d => d.LanguageVersion }
      ]);
      grabTestedVersions("device-detection-php", "php-versions", [
          { title: "PHP Version", getValue: d => d.LanguageVersion }
      ]);
      grabTestedVersions("pipeline-wordpress", "wordpress-versions", [
          { title: "PHP Version", getValue: d => d.LanguageVersion }
      ]);
      grabTestedVersions("51degrees-rust", "rust-versions", []);
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
Windows includes Framework and Core.
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
These are automatically tested on [GitHub](https://github.com/51Degrees?q=php&type=all&language=&sort=).
<div id="php-versions"></div>
If you have a configuration that is not covered, please [contact us](https://51degrees.com/contact-us).
@endsnippet
@startsnippet{node}
These are automatically tested on [GitHub](https://github.com/51Degrees?q=node&type=all&language=&sort=).
Testing targets the current Node.js LTS versions, the tables below are built from the
CI configuration of each repository so they always reflect the versions currently tested.

Device Detection:
<div id="node-versions"></div>
IP Intelligence:
<div id="ipi-node-versions"></div>
If you have a configuration that is not covered, please [contact us](https://51degrees.com/contact-us).
@endsnippet
@startsnippet{python}
These are automatically tested on [GitHub](https://github.com/51Degrees?q=python&type=all&language=&sort=).
<div id="python-versions"></div>
If you have a configuration that is not covered, please [contact us](https://51degrees.com/contact-us).
@endsnippet
@startsnippet{go}
These are automatically tested on [GitHub](https://github.com/51Degrees?q=go&type=all&language=&sort=).
<div id="go-versions"></div>
If you have a configuration that is not covered, please [contact us](https://51degrees.com/contact-us).
@endsnippet
@startsnippet{varnish}
These are automatically tested on [GitHub](https://github.com/51Degrees/51degrees-varnish).
<div id="varnish-versions"></div>
If you have a configuration that is not covered, please [contact us](https://51degrees.com/contact-us).
@endsnippet
@startsnippet{nginx}
These are automatically tested on [GitHub](https://github.com/51Degrees/51degrees-nginx).
<div id="nginx-versions"></div>
If you have a configuration that is not covered, please [contact us](https://51degrees.com/contact-us).
@endsnippet
@startsnippet{wordpress}
These are automatically tested on [GitHub](https://github.com/51Degrees/pipeline-wordpress).
<div id="wordpress-versions"></div>
If you have a configuration that is not covered, please [contact us](https://51degrees.com/contact-us).
@endsnippet
@startsnippet{rust}
These are automatically tested on [GitHub](https://github.com/51Degrees/51degrees-rust).
<div id="rust-versions"></div>

Language Versions:
- Rust stable (current)
- Minimum supported Rust version: 1.94

Targets:
- Native (x86_64 and Apple Silicon arm64)
- wasm32-wasip1 (the cloud and web crates, for edge runtimes such as Fastly Compute)

If you have a configuration that is not covered, please [contact us](https://51degrees.com/contact-us).
@endsnippet
@endsnippets

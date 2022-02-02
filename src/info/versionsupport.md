@page Info_VersionSupport Version Support

All APIs are written with a minimum tested language version. Any version above this is theoretically tested, but bleeding edge releases may not be supported by our testing. To help determine whether a version is supported, the table below shows the versions which are tested as part of each release, in addition to the minimum target version. 

If something is not tested here, and you believe it should be, please raise an issue via our [GitHub](https://github.com/51Degrees) page and we will look into it.

`NOTE`: Please refer to the bottom of this page for terminology used in the below table.
|Language / Framework|Minimum Supported Version|Supported Platform/Architecture|Tested Configurations*|
|---|---|---|---|
|C/C++  |`C11` and above<BR>`GCC 5` and above on Linux<BR>Platform Toolset Version `v142` and above on Windows<BR>Windows 10 SDK Version `10.0.18362.0` and above on Windows|`Windows`- `x86_64`/`amd64`<BR>`Linux`- `x86_64`/`amd64`<BR>`Linux` - `armhf`/`aarch64` - (Not Tested)<BR>`MacOS`- `x86_64`/`amd64`<BR>`MacOS` - `arm64` - (Not Tested)|`Windows Server 2019` - `VS2019` - `32-bit` & `64-bit` - `x86_64`/`amd64` - Platform Toolset Version `v142` - Windows 10 SDK Version `10.0.18362.0`<BR>`Mac OS 11` - `Clang 13` - `64-bit` - `x86_64`/`amd64`<BR>`Ubuntu 18.04` - `GCC 7.5` - `32-bit` & `64-bit` - `x86_64`/`amd64`|
|.NET   |`Standard 2.0` and above        |`Windows` - `x86_64`/`amd64`<BR>`Linux` - `x86_64`/`amd64`|`Windows Server 2019` - `.NET Core 3.1` - `32-bit` & `64-bit` - `x86_64`/`amd64`<BR>`Ubuntu 18.04` - `.NET Core 3.1` - `64-bit` - `x86_64`/`amd64`|
|Java   |`JDK8` and all `LTS` versions above|`Windows` - `x86_64`/`amd64`<BR>`Linux` - `x86_64`/`amd64`<BR>`Linux` - `armhf`/`aarch64`- (Not Tested)<BR>`MacOS` - `x86_64`/`amd64`<BR>`MacOS` - `arm64`- (Not Tested)|`Windows Server 2019` - `OpenJDK 8`, `11` & `17` - `64-bit` - `x86_64`/`amd64`<BR>`Mac OS 11` - `OpenJDK 8`, `11` & `17` - `64-bit` - `x86_64`/`amd64`<BR>`Ubuntu 18.04` - `OpenJDK 8`, `11` & `17` - `64bit` - `x86_64`/`amd64`| 
|Node.js|`Node.js 10`, `12`, `14` and `16`          |`Windows`- `x86_64`/`amd64`<BR>`Linux`- `x86_64`/`amd64`<BR>`MacOS`- `x86_64`/`amd64`|`Ubuntu 18.04` - `Node.js LTS` versions (`10`, `12`, `14`, `16`) - `64-bit` - `x86_64`/`amd64`<BR>`Windows Server 2019` - `Node.js LTS` versions - `64-bit` - `x86_64`/`amd64`<BR>`MacOS 11` - `Node.js LTS` versions - `64-bit` - `x86_64`/`amd64`|
|Varnish|`Varnish 6.0.6`<BR>`C11` and above|`Linux`- `x86_64`/`amd64`|`Ubuntu 18.04` - `GCC 7.5` - `64-bit` - `x86_64`/`amd64`<BR>`Ubuntu 20.04` - `GCC 9.3` - `64-bit` - `x86_64`/`amd64`|
|Nginx  |`Nginx 1.19.0`, `1.19.5`, `1.19.10`, `1.20.0`, `1.21.3`<BR>`C11` and above|`Linux`- `x86_64`/`amd64`|`Ubuntu 18.04` - `GCC 7.5` - `64-bit` - `x86_64`/`amd64`<BR>`Ubuntu 20.04` - `GCC 9.3` - `64-bit` - `x86_64`/`amd64`|
|PHP    |`PHP 5.6`, `7.x` and `8.0`        |`Linux`- `x86_64`/`amd64`|`Ubuntu 18.04` - `PHP 5.6`, `7.2`, `7.3`, `7.4` and `8.0` - `64-bit` - `x86_64`/`amd64`|
|Python |`Python 3.5+`                   |`Linux`- `x86_64`/`amd64`|`Ubuntu 18.04` - `Python 3.7`, `3.8`, `3.9` - `64-bit` - `x86_64`/`amd64`<BR>`Mac OS 11` - `Python 3.7`, `3.8`, `3.9` - `64-bit` - `x86_64`/`amd64`<BR>`Windows Server 2019` - `Python 3.7`, `3.8`, `3.9` - `32-bit` & `64-bit` - `x86_64`/`amd64`|
|Go     |`Golang 1.17.1`                   |`Windows`- `x86_64`/`amd64`<BR>`Linux`- `x86_64`/`amd64`<BR>`MacOS`- `x86_64`/`amd64`|`Ubuntu 18.04` - `Golang 1.17.1` - `32-bit` & `64-bit` - `x86_64`/`amd64`<BR>`Mac OS 11` - `Golang 1.17.1` - `64-bit` - `x86_64`/`amd64`<BR>`Windows Server 2019` - `Golang 1.17.1` - `64-bit` - `x86_64`/`amd64`|

*Other environments may work, but are not tested by 51Degrees.

Terminology:
- `32-bit`: 32 bit build
- `64-bit`: 64 bit build
- `x86_64`/`amd64`: x86-64 architecture (Also known as x64/AMD64/Intel 64)
- `armhf (ARM hard float)`:  32-bit ARM architecture (Debian Linux)
- `aarch64`/`arm64`: 64-bit ARM architecture
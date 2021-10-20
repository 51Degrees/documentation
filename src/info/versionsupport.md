@page Info_VersionSupport Version Support

All APIs are written with a minimum supported language version. Any version above this is theoretically supported, but bleeding edge releases may not be supported. To help determine whether a version is supported, the table below shows the versions which are tested as part of each release, in addition to the minimum target version.

If something is not supported here, and you believe it should be, [contact us](mailto:support@51degrees.com).

|Language / Framework|Minimum Supported Version|Tested Configurations (if it is not routinely tested, that does not mean it's not supported)|
|---|---|---|
|C/C++  |`C11` and above<BR>`GCC 5` and above on Linux<BR>`x86` and `x86_64`/`amd64` (`armhf` and `aarch64` implemented on Linux)|`Windows 10` - `VS2017` - `x86` & `x86_64`/`amd64`<BR>`Mac OS 10.14` - `Clang 11` - `x86_64`/`amd64`<BR>`Ubuntu 18.04` - `GCC 7.5` - `x86` & `x86_64`/`amd64`|
|.NET   |`Standard 2.0` and above        |`Windows Server 2019` - `.NET Core 3.1` and `.NET Framework 4.6.2`<BR>`Ubuntu 18.04` - `.NET Core 3.1`|
|Java   |`JDK8` and all `LTS` versions above|`Windows Server 2019` - `OpenJDK 8` & `11`<BR>`Mac OS 10.15` - `OpenJDK 8` & `11`<BR>`Ubuntu 20.04` - `OpenJDK 8` & `11`| 
|Node.js|`Node.js 10`, `12`, `14` and `16`          |`Ubuntu 18.04` - `Node.js LTS` versions (`10`, `12`, `14`, `16`)|
|Varnish|`Varnish 6.0.6`<BR>`C11` and above|`Ubuntu 18.04` - `GCC 7.5` - `64-bit`<BR>`Ubuntu 20.04` - `GCC 9.3` - `64-bit`|
|Nginx  |`Nginx 1.19.0`,`1.19.5`,`1.19.10`,`1.20.0`<BR>`C11` and above|`Ubuntu 18.04` - `GCC 7.5` - `64-bit`<BR>`Ubuntu 20.04` - `GCC 9.3` - `64-bit`|
|PHP    |`PHP 5.6`, `7.x` and `8.0`        |`Ubuntu 18.04` - `PHP 5.6`, `7.2`, `7.3`, `7.4` and `8.0`|
|Python |`Python 3.5+`                   |`Ubuntu 20.04` - `Python 3.6`<BR>`Mac OS 10.15` - `Python 3.9`<BR>`Windows Server 2019` - `Python 3.6`|
|Go     |`Golang 1.17.1`                   |`Ubuntu 18.04` - `Golang 1.17.1`<BR>`Ubuntu 20.04` - `Golang 1.17.1`<BR>`Mac OS 10.14` - `Golang 1.17.1`<BR>`Mac OS 10.15` - `Golang 1.17.1`|
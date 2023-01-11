@page Info_FAQs Frequently Asked Questions

@anchor Dotn_TempFiles
[#](@ref Dotn_TempFiles) 
#### Why are my temp files not being cleared when using the .NET Pipeline API?

In .NET core, the finalizer is not called when a program exits as described on [this page](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/destructors). Some engines maintain files in a temporary directory while they are in operation and these can remain if a .NET core application using one of these engines is closed.

To workaround this problem, you can either:
- Use the `SetAutoDisposeElements` setting to ensure elements are disposed when the Pipeline is disposed.
- Explicitly call dispose on all engines before exiting the program.

@anchor Node_TempFiles
[#](@ref Node_TempFiles) 
#### Why are my temp files not being cleared when using the Node.js Pipeline API?  

In Node.js, the finalizer is not called when a program exits. Some engines maintain files in a temporary directory while they are in operation and these can remain if a Node.js application using one of these engines is closed.

To workaround this problem, you can either:
- Set the `createTempDataCopy` to false to use the original file directly. Note that automatic updates cannot be enabled without either using a 
temporary file, or the `MaxPerformance` configuration option where the data file is copied into memory completely.
- Set the `tempDataDir` to a directory which will be periodically cleaned up by another process e.g. `os.tmpdir()`.

These is the options in the device detection on-premise engine, other third party engines may use different option naming.

@anchor Dependencies_Glibc_Libatomic
[#](@ref Dependencies_Glibc_Libatomic)
#### Why am I getting <code>version 'GLIBC_2.27' not found</code> or <code>libatomic.so.1: cannot open shared object file: No such file or directory</code> error when using 51Degrees Device Detection API package for On-premise?

Most of 51Degrees Device Detection API packages for on-premise come with a set of prebuilt libraries. These libraries are built and linked in our build environment and require certain libraries with a minimum version to be available at the runtime. Please check out the @dependencies page to find out what dependencies are required to use our prebuilt packages. If you cannot modify your environment in order to provide the necessary dependencies, we suggest building your own packages from source in your target environment. The @dependencies page also includes links to the `README` files which detail how this can be done.

In the case of missing the `libatomic.so.1` library, make sure the `libatomic1` package is installed in your runtime environment.

If the issue is with version `GLIBC_2.27` not found, we recommend to build the package from source as `GLIBC` is the C standard library which is a core library to the Linux system and reinstalling it would potentially break your environment.

@anchor PHP_ProcessManager
[#](@ref PHP_ProcessManager)
#### Can I use PHP on-premise device detection with a process manager such as Apache MPM or php-fpm? 

When using our PHP Device Detection solution under a process manager such as Apache MPM, php-fpm, or any other process manager, the following restrictions are applied:
-	Only **MaxPerformance** profile can be used.
-	Manual reload cannot be used. A full server restart is required.

If Apache MPM is used:
-	Only **prefork** mode can be used.
These restrictions are due to the interaction between the native libraries used by our on-premise API and the way that OS handles and memory are handled by these process managers.

@anchor Python_MultiProcess
[#](@ref Python_MultiProcess)
#### Can I use Python on-premise device detection in a multi-process environment?

When using Device Detection API for on-premise in a spawned multi processes environment, the Pipeline object should be created for each process. If it is created as a global variable, the spawned process will re-initialize the variable and therefore, each process will have their own version of the pipeline object. In this environment the following settings should be used:
- `create_temp_data_copy` set to `False`
- `performance_profile` set to `MaxPerformance`
Since a pipeline is created for each process, the memory cost of running the API will be multiplied by the number of processes.

These restrictions are due to the interaction between the native libraries used by our on-premise API and the way that OS handles and memory are handled in a multi-process environment.

@anchor UACH_DualEvidence
[#](@ref UACH_DualEvidence)
#### Can I use User Agent Client Hints (UA-CH) at the same time as the User-Agent? 

Yes. In fact, this is recommended. The device detection algorithm will use the UA-CH data where possible. 
However, if a match cannot be found for the supplied UA-CH values, then the User-Agent will be used as a fall back.

If you are using a @webintegration then the UA-CH and User-Agent will both be passed to the Pipeline 
automatically. Otherwise, you need to supply the available header values manually. See the [getting started](@ref Examples_DeviceDetection_GettingStarted_Console_Index) examples for a demonstration of how to supply 
UA-CH evidence in parallel with the User-Agent.

@anchor UserAgent_ContainsBetterData
[#](@ref UserAgent_ContainsBetterData)
#### I've supplied the User-Agent in addition to UA-CH. The result returns unknown values for things that are clearly present in the User-Agent.

UA-CH evidence always takes precedence over the User-Agent. In some scenarios, this means that additional detail that is available in the User-Agent will be ignored. For example:

- `Sec-CH-UA-Platform` = `"Windows"`
- `User-Agent` = `Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:105.0) Gecko/20100101 Firefox/105.0`

The result from the API will return Windows, but the version number will be unknown; this is because the Sec-CH-UA-Platform-Version header has not been supplied.

Since UA-CH take precedence over the User-Agent (in this case, when Sec-CH-UA-Platform is used in preference to User-Agent), despite the User-Agent containing version information, the result from the API will not return any version information. To combat this, we recommend supplying all the Sec-CH-UA headers you need.

We take this approach because the version provided by the User-Agent is incorrect in some scenarios. For example, Windows 11 will always appear as Windows 10 in the User-Agent. 

In addition, as Google press ahead with [deprecating the data](https://www.chromium.org/updates/ua-reduction/) in parts of the User-Agent, the values presented will become less reliable. For example, all Android versions sending a User-Agent with 'Android 10' in it.

Therefore, we believe that returning 'Windows unknown version' or 'Android unknown version' is better than returning 'Windows 10' or 'Android 10' when the user may not actually be using those versions.

Be aware that Sec-CH-UA-Platform-Version, unlike Sec-CH-UA-Platform, will rarely be available in the first request. There is nothing we can do about this, as it is an intentional part of Google's design for UA-CH. For more details, see our [UA-CH feature page](@ref DeviceDetection_Features_UserAgentClientHints).

Finally, some of our users prefer to receive a platform version that is potentially incorrect, rather than an unknown platform version. If you would prefer this behavior, you can modify your system to only supply Sec-CH-UA-Platform to our API when you also have Sec-CH-UA-Platform-Version. This will cause it to fallback to using the platform version from the User-Agent when the complete data from UA-CH is not available.

@anchor Error_OnPremise_DataFile
[#](@ref Error_OnPremise_DataFile) 
#### Why am I getting the following error message when updating the on-premise data file? <code>FiftyOne.Pipeline.Engines.Exceptions.DataUpdateException: 'Too many requests to 'https://distributor.51degrees.com/api/v2/download?LicenseKeys=<our_lic_key_here>&Download=True&Type=HashV41' for engine 'DeviceDetectionHashEngine''</code>

There is a limit to the number of requests that you can make – only one request every 30 minutes can be made for each IP address.

The best solution is to only download the data file when you need to (ideally, once per day), or set up @ref Features_AutomaticDatafileUpdates for the latest data.

Alternatively, you can wait until after the 30-minute window to try again. However, you may encounter the error again.

If you have a production environment with a large number of nodes in a cluster, you need to take special care when designing your system to support data updates in a way that impact on our server and external bandwidth usage from your own systems. The [automatic updates feature page](@ref Features_AutomaticDatafileUpdates) has a section at the bottom with some recommendations.

@anchor Error_NetFramework_NetStandard
[#](@ref Error_NetFramework_NetStandard) 
#### When using the 51Degrees API with ASP.NET (.NET Framework), how do I resolve the error <code>CS0012: The type 'System.Object' is defined in an assembly that is not referenced. You must add a reference to assembly 'netstandard, Version=2.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'</code>

This happens because our API targets .NET Standard 2.0. You'll need to modify the 'compilation' element in your web.config file to add a reference to the netstandard assembly as shown below:

```
<compilation debug="true" targetFramework="4.7.2">
  <assemblies>
    <add assembly="netstandard, Version=2.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51"/>
  </assemblies>
</compilation>
```

@anchor Error_NetFramework_NewerPackage
[#](@ref Error_NetFramework_NewerPackage) 
#### When using the 51Degrees API with .NET Framework, how do I resolve errors like <code>Could not load file or assembly 'Newtonsoft.Json, Version=11.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed' or one of its dependencies. The located assembly's manifest definition does not match the assembly reference. (Exception from HRESULT: 0x80131040)</code>

These errors can be seen when a package you are referencing has a dependency on another package and you have a direct reference in your project to a different version of the same package.
For example, if our package references Newtonsoft.Json version 11 and your project references Newtonsoft.Json version 13.

Sometimes, you'll need to reference the same version as the one required by your dependency. In many cases, this is not necessary though. Instead, you can tell the .NET Framework to handle calls to the version 11 dll by sending them to the version 13 dll.

You do this by configuring a binding redirect in the web.config file:

```
<runtime>
  <assemblyBinding xmlns="urn:schemas-microsoft-com:asm.v1">
    <dependentAssembly>
      <assemblyIdentity name="Newtonsoft.Json" publicKeyToken="30ad4fe6b2a6aeed" />
      <bindingRedirect oldVersion="0.0.0.0-13.0.0.0" newVersion="13.0.0.0" />
   </dependentAssembly>
  </assemblyBinding>
</runtime>
```

@anchor Error_NetFramework_NativeDll
[#](@ref Error_NetFramework_NativeDll) 
#### When using the 51Degrees API with .NET Framework, I get an error loading the native dll <code>Unable to load DLL 'FiftyOne.DeviceDetection.Hash.Engine.OnPremise.Native.dll': The specified module could not be found. (Exception from HRESULT: 0x8007007E)</code>

This error message makes it pretty clear what is happening, but resolving it can be tricky.

Firstly, there are multiple versions of the native dll and we include 3 different flavours in the NuGet package:
- Win86
- Win64
- Linux64

Unlike .NET/.NET Core, the .NET Framework is currently unable to resolve the correct binary at runtime. As a workaround, you'll need to copy the correct dll from the 'runtimes' folder to the root of the 'bin' folder.
This can be done by adding the following snippet as a post build step for your project:

```
copy /Y "$(TargetDir)\runtimes\win-$(Platform)\native\FiftyOne.DeviceDetection.Hash.Engine.OnPremise.Native.dll" "$(TargetDir)\FiftyOne.DeviceDetection.Hash.Engine.OnPremise.Native.dll"
```

You need to make sure that the type of the native dll matches the type of the process that will be executing it. 
For example, if your production IIS instance is running in 32 bit mode, you'll need to make sure that you target the x86 platform for your production build. This will mean that the x86 binary is copied to the root of the bin folder and used at runtime.

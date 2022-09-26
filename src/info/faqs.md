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
#### Can I use User Agent Client Hints (UA-CH) at the same time as the User Agent? 

Yes. In fact, this is recommended. The device detection algorithm will use the UA-CH data where possible. 
However, if a match cannot be found for the supplied UA-CH values, then the User Agent will be used as a fall back.

If you are using a @webintegration then the UA-CH and User Agent will both be passed to the Pipeline 
automatically. Otherwise, you need to supply the available header values manually. See the [getting started](@ref Examples_DeviceDetection_GettingStarted_Console_Index) examples for a demonstration of how to supply 
UA-CH evidence in parallel with the User Agent.

@anchor UserAgent_ContainsBetterData
[#](@ref UserAgent_ContainsBetterData)
#### I've supplied the User Agent in addition to UA-CH. The result returns unknown values for things that are clearly present in the User Agent.

UA-CH evidence always takes precedence over the User Agent. In some scenarios, this means that additional detail that is available in the User Agent will be ignored. For example:

`Sec-CH-UA-Platform` = `"Windows"`
`User-Agent` = `Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:105.0) Gecko/20100101 Firefox/105.0`

The result from the API will return Windows, but the version number will be unknown; this is because the Sec-CH-UA-Platform-Version header has not been supplied.

Since UA-CH take precedence over the User Agent (in this case, when Sec-CH-UA-Platform is used in preference to User Agent), despite the User Agent containing version information, the result from the API will not return any version information. To combat this, we recommend supplying all the Sec-CH-UA headers you need.

We take this approach because the version provided by User Agent is incorrect in some scenarios. For example, Windows 11 will always appear as Windows 10 in the User Agent. 

In addition, as Google press ahead with [deprecating the data](https://www.chromium.org/updates/ua-reduction/) in parts of the User Agent, the values presented will become less reliable. Therefore, we believe that returning 'Windows unknown version' is better than returning 'Windows 10' when the user may not actually be using Windows 10.

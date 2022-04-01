@page Info_FAQs Frequently Asked Questions

#### Why are my temp files not being cleared when using the .NET Pipeline API?

In .NET core, the finalizer is not called when a program exits as described on [this page](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/destructors). Some engines maintain files in a temporary directory while they are in operation and these can remain if a .NET core application using one of these engines is closed.

To workaround this problem, you can either:
- Use the `SetAutoDisposeElements` setting to ensure elements are disposed when the Pipeline is disposed.
- Explicitly call dispose on all engines before exiting the program.

#### Why are my temp files not being cleared when using the Node.js Pipeline API?

In Node.js, the finalizer is not called when a program exits. Some engines maintain files in a temporary directory while they are in operation and these can remain if a Node.js application using one of these engines is closed.

To workaround this problem, you can either:
- Set the `createTempDataCopy` to false to use the original file directly. Note that automatic updates cannot be enabled without either using a 
temporary file, or the `MaxPerformance` configuration option where the data file is copied into memory completely.
- Set the `tempDataDir` to a directory which will be periodically cleaned up by another process e.g. `os.tmpdir()`.

These is the options in the device detection on-premise engine, other third party engines may use different option naming.

#### Why am I getting <code>version 'GLIBC_2.27' not found</code> or <code>libatomic.so.1: cannot open shared object file: No such file or directory</code> error when using 51Degrees Device Detection API package for On-premise?

Most of 51Degrees Device Detection API packages for On-premise come with a set of prebuilt libraries. These libraries are built and linked in our build environment and require certain libraries with a minimum version to be available at the runtime. Please check out [tested version page](http://51degrees.com/documentation/_info__version_support.html) to find out about what configurations we have tested with and what dependencies are required to use our prebuilt packages. If your target environment does not match our tested environment, there are chances that the prebuilt package will still work. If it does not, we suggest building your own packages from source in your target environment. The [tested version page](http://51degrees.com/documentation/_info__version_support.html) also includes links to the `README` files which details how it can be done.

In the case of missing the `libatomic.so.1` library, just make sure the `libatomic1` package is installed in your runtime environment.

If the issue is with version `GLIBC_2.27` not found, we recommend to build the package from source as `GLIBC` is the C standard library which is a core library to the Linux system and reinstalling it would potentially break your environment.
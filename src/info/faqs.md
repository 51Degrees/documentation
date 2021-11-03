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
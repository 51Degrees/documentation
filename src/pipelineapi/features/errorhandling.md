@page PipelineApi_Features_ErrorHandling Error handling

# Introduction

A @Pipeline can contain any number or combination of @flowelements, including custom elements. Errors from these elements are handled consistently.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/features/exception-handling.md#)
for more technical details.

# Approach

Almost all languages have `try/catch` constructs, so these are used by the @pipeline code when calling functions on flow elements.

If the flow element code raises an error, it will be handled by the catch statement.

Any error that occurs will be logged in the `Errors` section of the current @flowdata. The pipeline then proceeds to execution of the next @flowelement. 

After all @flowelements have completed, there are two possible scenarios, depending on @pipeline configuration:

1. If the @flowdata contains any errors then an error will be raised using the standard language features.
2. Execution will return to the caller of the `Process` function. Any errors will effectively be hidden/suppressed unless @logging is configured or the `Errors` section of the @flowdata is checked by the caller.

# Configuration

Error handling is configured using the 'SuppressProcessExceptions' setting.
If set to `true`, errors are hidden/suppressed. If `false`, an error will be raised at the end of @pipeline execution.

The default value is `false`. This is recommended for development/testing to highlight issues.

When running the @Pipeline in production, we recommend setting this to `true` in order to prevent unexpected errors from crashing the application.

As with all configuration settings, this can be set in code or via a @Pipeline configuration file (see [.NET example](https://github.com/51Degrees/51degrees-dotnet/blob/main/examples/device-detection/Cloud/Framework-Web/App_Data/51Degrees.json#L41)).

The setting name follows each language's conventions: `SuppressProcessExceptions` in .NET, `setSuppressProcessException` / `<SuppressProcessException>` (singular) in Java, `suppressProcessExceptions` in Node.js, and `suppress_process_exceptions` in Python. In Node.js and Python it is read from the pipeline-level `PipelineOptions.BuildParameters` section of a configuration file. See [Pipeline Builder](@ref PipelineApi_Concepts_Configuration_Builders_PipelineBuilder_SuppressProcessExceptions) for per-language code and configuration examples.


# Testing failure scenarios

In each integration there are dependencies that can fail, such as network connectivity, DNS, load balancers, web servers etc.  
This is especially true for scenarios relying on 51Degrees Cloud Service. There are several steps you need to take to ensure your integration is safe against such failures and won't crash in production. 

## Simulating the failure

For a cloud integration, there are two ways to simulate a 51Degrees Cloud Service dependency failure:

1. Specify a non-existent `EndPoint` in the `CloudRequestEngine` configuration in the configuration file. For example, set it to "http://nonexistent.domain/".
2. Specify `127.0.0.1	cloud.51degrees.com` in the `/etc/hosts` file (`C:\Windows\System32\drivers\etc\hosts` on Windows).

Under any of these conditions your server app won't be able to talk to `cloud.51degrees.com`.  

## Testing
1. Simulate the failure using one of the methods above. 
2. First test with `SuppressProcessExceptions` set to its default, `false`. Verify that the 51Degrees `Pipeline` raises an exception stating that `cloud.51degrees.com` cannot be reached.
3. Set `SuppressProcessExceptions` to `true` in the configuration and rerun the service. Verify that the 51Degrees `Pipeline` returns a `FlowData` object with `Errors` instead of raising an exception. If an exception still occurs, follow the next step.
4. Make sure you properly wrap getting the device data in your code from FlowData (`FlowData.Get<IDeviceData>()` in .NET) as this call may throw an exception (see [.NET example](https://github.com/51Degrees/51degrees-dotnet/blob/main/examples/device-detection/Cloud/Framework-Web/Default.aspx#L97)). Also make sure that you wrap retrieving properties from device data, such as using a function that try-catch-wraps and null-checks the device data and its properties (see [.NET example](https://github.com/51Degrees/51degrees-dotnet/blob/main/examples/device-detection/Cloud/Framework-Web/Default.aspx#L111)). 
5. Finally, undo the failure simulation (either remove the non-existent endpoint from the configuration or comment out the record in the `hosts` file), and observe the happy path scenario. All should work as expected.

Leave the `SuppressProcessExceptions` configuration set to `true` for the production setup, as it will protect the users from interruptions in case any of the dependencies fail.

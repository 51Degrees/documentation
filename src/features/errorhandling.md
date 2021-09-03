@page Features_ErrorHandling Error Handling

# Introduction

The @Pipeline can contain and number or configuration of @flowelements, including custom 3rd party ones. As such, it must have a robust and consistent error handling solution.

# Approach

Almost all languages have `try/catch` constructs, so these are used by the @pipeline code when calling functions on flow elements.

If the flow element code raises an error, it will be handled by the catch statement.

Any error that occurs will be logged in the `Errors` section of the current @flowdata. The pipeline then proceeds to execution of the next @flowelement. 

After all @flowelements have completed, there are two possible scenarios, depending on pipeline configuration.

1. If the @flowdata contains any errors then an error will be raised using the standard language features.
2. Execution will return to the caller of the `Process` function. Any errors will effectively be hidden/suppressed unless @logging is configured or the `Errors` section of the @flowdata is checked by the caller.

# Configuration

Error handling is configured using the 'Suppress Process Exceptions' setting.
If set to `true`, errors are hidden/suppressed. If `false`, an error will be raised at the end of @pipeline execution.

The default value is `false`. This is recommended for development/testing to highlight issues.

When running the Pipeline in production, we recommend setting this to `true` in order to prevent unexpected errors from crashing the application.

As with all configuration settings, this can be set in code or via a Pipeline configuration file.

# Language Specific Guidance

At time of writing, there is inconsistency in error handling between languages.

Java and .NET will operate as described above.

Python, PHP and Node do not have the 'SuppressProcessException' setting, but will function as if it has been set to `true`. I.e. errors will be suppressed.

The intention is to address this in a future release. There are issues on GitHub to track the status of this change for each language:

- [Python](https://github.com/51Degrees/pipeline-python/issues/3)
- [PHP](https://github.com/51Degrees/pipeline-php-core/issues/1)
- [Node](https://github.com/51Degrees/pipeline-node/issues/8)
@page Features_ErrorHandling Error Handling

# Introduction

The @Pipeline can contain and number or configuration of @flowelements, including custom third-party ones. As such, it must have a robust and consistent error handling solution.

# Approach

Almost all languages have `try/catch` constructs, so these are used by the @pipeline code when calling functions on flow elements.

If the flow element code raises an error, it will be handled by the catch statement.

Any error that occurs will be logged in the `Errors` section of the current @flowdata. The pipeline then proceeds to execution of the next @flowelement. 

After all @flowelements have completed, there are two possible scenarios, depending on pipeline configuration:

1. If the @flowdata contains any errors then an error will be raised using the standard language features.
2. Execution will return to the caller of the `Process` function. Any errors will effectively be hidden/suppressed unless @logging is configured or the `Errors` section of the @flowdata is checked by the caller.

# Configuration

Error handling is configured using the 'Suppress Process Exceptions' setting.
If set to `true`, errors are hidden/suppressed. If `false`, an error will be raised at the end of @pipeline execution.

The default value is `false`. This is recommended for development/testing to highlight issues.

When running the Pipeline in production, we recommend setting this to `true` in order to prevent unexpected errors from crashing the application.

As with all configuration settings, this can be set in code or via a @Pipeline configuration file.
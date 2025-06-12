@page PipelineApi_Features_Logging Logging

# Introduction

**Logging** is available in all parts of the @pipeline, including @flowdata and @flowelements.
How **logging** is implemented will differ depending on language, with each having
its own idiomatic way of performing the function. Any **logging** method which matches the
language's logging interface can be used. Where possible, dependency injection
is used to introduce a **logger** / **logger factory** to the @pipeline.

See the
[Specification](https://github.com/51Degrees/specifications/blob/main/pipeline-specification/features/logging.md#)
for more technical details.

# Configuration

Idiomatic set up of logging varies greatly between languages, but the basic principals apply
to all. Both an @elementbuilder, and a @pipelinebuilder, are provided with a **logger factory**
so that every new object that is created has **logging** functionality specific to its instance.
Standard log levels are adhered to, so the information logged can be limited to 'warn' for example.

@startsnippets
@showsnippet{dotnet,C#}
@showsnippet{java,Java}
@showsnippet{node,Node.js}
@showsnippet{php,PHP}
@showsnippet{python,Python}
@defaultsnippet{Select a tab to view language specific information on configuring **logging**}
@startsnippet{dotnet}
In C#, the `ILogger` interface from Microsoft.Extensions.Logging.Abstractions is used for **logging**.
This means that @pipelinebuilders and @elementbuilders should be supplied with an implementation 
of `ILoggerFactory` which will create **logger** instances for each @pipeline and @flowelement
they create. **Loggers** will also be created for all @flowdata and @elementdata that are created.

The simplest way is to create the default Microsoft implementation available in Microsoft.Extensions.Logging:
```{cs}
ILoggerFactory loggerFactory = new LoggerFactory();
```

In an ASP.NET Core environment, a **logger** can be introduced via dependency injection when starting up the
service. This will then be injected into the @pipelinebuilder.
@endsnippet
@startsnippet{java}
In Java, the `Logger` interface from org.slf4j.slf4j-api is used for **logging**. This means that
@pipelinebuilders and @elementbuilders should be supplied with an implementation of `ILoggerFactory` which
will create **logger** instances for each @pipeline and @flowelement that are created.

The easiest way is to include a dependency on an implementation of slf4j-api such as org.slf4j.slf4j-simple:
```{xml}
<project>
  ...
  <dependencies>
    <dependency>
      <groupId>org.slf4j</groupId>
      <artifactId>slf4j-simple</artifactId>
      <version>${slf4j-simple.version}</version>
    </dependency>
    ...
  </dependencies>
  ...
</project>

```

This will then be injected automatically when creating @builders using their default constructors.

Alternatively, an implementation can be passed explicitly in a @builder's constructor:
```{java}
PipelineBuilder builder = new PipelineBuilder(new MyLoggerFactory());
```
@endsnippet
@startsnippet{node}

In node.js a Pipeline has an instance of an eventEmitter inside it which can be used to listen to events, logs and errors.

```{js}

  // Build the pipeline using an instance of the PipelineBuilder class

  // Then, to monitor the pipeline we can put in listeners for various log events.
  // Valid types are info, debug, warn, error
  pipeline.on('error', console.error);

```

@endsnippet
@startsnippet{php}

The PHP pipeline implementation includes a Logger class that can be used to record events that take place in the pipeline.

Here is an example of a basic logger that stores its logs in an array.

The log object passed to the overriden logInternal function is an associative array that contains:

* time - Y-m-d H:i:s format timestamp
* level - one of "trace", "debug", "information", "warning", "error", "critical"
* message - the message

```{php}

use fiftyone\pipeline\core\Logger;

class MemoryLogger extends Logger
{
    public $log = [];

    public function logInternal($log)
    {

            $this->log[] = $log;
    }
}

```

After making a logging class, you would then use this in a Pipeline as follows:

```{php}

use fiftyone\pipeline\core\PipelineBuilder;

$logger = new MemoryLogger("info"); // Pass in the minimum log level to the constructor

$pipelineBuilder = new PipelineBuilder();

$pipelineBuilder->addLogger($this->logger);

// Then add elements and build the Pipeline as usual

```

@endsnippet
@startsnippet{python}

The python pipeline implementation includes a Logger class that can be used to record events that take place in the pipeline.

Here is an example of a basic logger that stores its logs in a list.

The log object passed to the overriden log_internal function is a dictionary that contains:

* time - Y-m-d H:i:s format timestamp
* level - one of "trace", "debug", "information", "warning", "error", "critical"
* message - the message

```{python}

from fiftyone_pipeline_core.logger import Logger

class MemoryLogger(Logger):

    def __init__(self, min_level="error", settings = {}):

        super(MemoryLogger, self).__init__(min_level, settings)

        self.memory_log = []

    def log_internal(self, level, log):

        self.memory_log.append(log)


```

After making a logging class, you would then use this in a Pipeline by using it in the PipelineBuilder when making your pipeline:

```{python}

from fiftyone_pipeline_core.pipelinebuilder import PipelineBuilder

logger = MemoryLogger('info') // Pass in the minimum log level to the constructor

pipeline = (PipelineBuilder())\
            .add_logger(logger)\
            .build()

```

@endsnippet
@endsnippets

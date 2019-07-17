@page Concepts_Configuration_Builders_ElementBuilder Element Builder

# Introduction

@Flowelements are constructed using a **builder** which follows the
[fluent builder pattern](https://en.wikipedia.org/wiki/Fluent_interface).
This gives a consistent structure to building any @flowelement, allowing
automatic building via configuration files.

By convention, a @flowelement's configuration is immutable once it has been
constructed, so all of its configuration should be done in the **builder**.


# Configuration

Following the convention of fluent builder, configuration options are set using 'set' naming. For example,
to set a configuration option with the name 'setting', a **builder** would have a 'SetSetting' method which
takes the value of the option as an argument and returns the **builder**.


# Building

Once all configuration are set in a **builder**, a 'build' method is used to build a @flowelement
using the configuration options provided. This can optionally take extra options, usually these are options
which are compulsory.

# Usage

@startsnippets{usage}
@showsnippet{usage,dotnet,C#}
@showsnippet{usage,java,Java}
@showsnippet{usage,php,PHP}
@showsnippet{usage,node,Node.js}
@startsnippet{none,block}
Select a language to view language specific usage example.
@endsnippet
@startsnippet{dotnet}
@snippet snippets.cs Using a builder
@endsnippet
@startsnippet{java}
@snippet snippets.java Using a builder
@endsnippet
@startsnippet{php}
**todo**
@endsnippet
@startsnippet{node}
**todo**
@endsnippet


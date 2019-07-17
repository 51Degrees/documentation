@page Concepts_Configuration_Builders_BuildFromConfiguration Building From Configuration

# Introduction

Rather than setting all build options and @flowelements explicitly in code form, it is often
preferable to make the @pipeline configurable without recompiling. A @pipelinebuilder allows
this via its 'BuildFromConfiguration' method. A @pipeline's configuration can be built up within
code, however the most flexible method is to store the configuration in a file.

# Usage

** todo explain parsing files and automatic parsing in web.**

# Example Configuration

@startsnippets
@showsnippet{XML}
@showsnippet{JSON}
@emptysnippet
@startsnippet{XML}
Configure a @pipeline with a @flowelement named 'MyElement' with a build parameter, and
set the @pipeline to suppress process exceptions.
@snippet snippets.xml Pipeline configuration
@endsnippet
@startsnippet{JSON}
Configure a @pipeline with a @flowelement named 'MyElement' with a build parameter, and
set the @pipeline to suppress process exceptions.
@snippet snippets.json Pipeline configuration
@endsnippet
@endsnippets


# Internals
** todo explain internal workings (i.e. dependency injection and reflection)**
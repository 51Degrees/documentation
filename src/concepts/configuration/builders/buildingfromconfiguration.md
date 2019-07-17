@page Concepts_Configuration_Builders_BuildFromConfiguration Building From Configuration

# Introduction

Rather than setting all build options and @flowelements explicitly in code form, it is often
preferable to make the @pipeline configurable without recompiling. A @pipelinebuilder allows
this via its 'BuildFromConfiguration' method. A @pipeline's configuration can be built up within
code, however the most flexible method is to store the configuration in a file.


@

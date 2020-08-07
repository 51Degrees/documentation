![51Degrees](https://51degrees.com/DesktopModules/FiftyOne/Distributor/Logo.ashx?utm_source=github&utm_medium=repository&utm_content=readme_main "Data rewards the curious") **Pipeline API Documentation**

# Summary

This repository contains documentation for the 51Degrees Pipeline API.

In addition, it contains information of how to document the API consistently:

- [Documenting](Documenting.md) - Guidance on writing the documentation in this repository.
- [Documenting Code](Documenting%20Code.md) - Guidance on documenting code in other repositories in order to automatically generate pages in the same style as the documentation in this repository.

Documentation is written and maintained in [Markdown](https://en.wikipedia.org/wiki/Markdown) format. A customized build of [Doxygen](http://www.doxygen.nl/) is then used to generate HTML pages from the Markdown source files. Finally, some custom CSS is used to apply 51Degrees branding and styling.

# Structure

## Documentation structure

The final generated documentation can be broken down into three major groups:

 - The 'written' pages contain entirely hand-written content. They live in this repository.
 - The 'generated' pages contain reference documentation that has been generated automatically from the source code and associated comments. These are built from the sub modules referenced in this repository by the continuous build pipeline when master is updated.
 - Example pages contain a combination of hand-written and generated content. The content for the page file itself is maintained in this repository. However, the example code for each language is pulled in from the generated pages. In order to know the name of the example code file, you will need to generate the HTML documentation from the relevant sub-module.

## Repository Directory Structure

| Source  | Description |
| ------- | ----------- |
| `src/`  | All documentation source lives in the src directory in markdown form with the addition of DoxyGen syntax. |
| `docs/` | HTML documentation generated from `src/` ends up here. This is what is displayed on the documentation pages. |
| `Doxyfile` | Configuration for generating the documentation using DoxyGen. |
| `DoxygenLayout.xml` | Defines how the navigation is layed out in the generated documentation. |
| `examplegrabber.js` | Included in the generated documentation to pull in language specific examples. |
| `pattern-library` | PatternLab submodule which generates the custom CSS used in the generated documentation. |


# Building HTML Documents

This is only intended to be performed by 51Degrees employees.
For complete instructions, see [Documenting](Documenting.md).

First, make sure you have the latest custom build of Doxygen.
Next, run Doxygen to generate the HTML. There are two ways of doing this:

## Windows UI

Simply run the DoxyWizard program and open the Doxyfile in the root of this repository. 

## Command Line

Open a command line, navigate to the repository root and execute the command: `Doxygen`.



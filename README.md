Documentation
=============

This contains general documentation about the v4 API.

In addition, this contains information of how to document the API consistently:

[Documenting](Documenting.md) - Guidance on writing general documentation for this repository.

[Documenting Code](Documenting Code.md) - Guidance on documenting code in other repositories.

# Directory Structure

| Source  | Description |
| ------- | ----------- |
| `src/`  | All documentation source lives in the src directory in markdown form with the addition of DoxyGen syntax. |
| `docs/` | HTML documentation generated from `src/` ends up here. This is what is displayed on the documentation pages. |
| `Doxyfile` | Configuration for generating the documentation using DoxyGen. |
| `DoxygenLayout.xml` | Defines how the navigation is layed out in the generated documentation. |
| `examplegrabber.js` | Included in the generated documentation to pull in language specific examples. |
| `patternlab` | PatternLab submodule which generates the custom CSS used in the generated documentation. |
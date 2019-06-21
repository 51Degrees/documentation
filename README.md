Documentation
=============

This contains general documentation about the v4 API.

# Structure

| | |
| ----- | ----- |
| src/  | All documentation source lives in the src directory in markdown form with the addition of DoxyGen syntax. |
| docs/ | HTML documentation generated from `src/` ends up here. This is what is displayed on the documentation pages. |
| Doxyfile | Configuration for generating the documentation using DoxyGen. |
| DoxygenLayout.xml | Defines how the navigation is layed out in the generated documentation. |

# Markdown Files
Markdown files in the src directory use standard markdown syntax to document each concept. Each concept should live in its own file.
For example, **Pipeline** and **FlowData** have their own files.

## DoxyGen Tags
Each markdown file must have certain definitions inside for them to be handled correctly by DoxyGen.

### @page
Each page must be declared with a **@page** tag giving it a unique identifier, and a page name which need not be unique. For example, the **Pipeline** page is defined with

```
@page Concepts-Core-Pipeline Pipeline
```

where the unique id is its location inside the documentation structure (this is just convention and does not affect the output), and the name of the page is a more friendly name.

### @subpage
Each subpage must be declared in its parent page using the **@subpage** tag and the unique identifier of the subpage. For example, the **Pipeline** page lives under the **Core** page, so the **Core** page contains

```
@subpage Concepts-Core-Pipeline
```

This sets up the subpage, and adds a link to the parent page. The text used for the link can be given as a second argument to the **@subpage** tag, but by default it is the friendly name of the subpage.

### @mainpage
The main page (main.md) is defined using the **@mainpage** tag. This is the same as the **@page** tag, but ensures this is the main page, and is always at the top of the navigation.

### @ref
Links to pages (or anything else which DoxyGen can link to e.g. classes) can be added using the **@ref** tag inside a markdown link. For example, to link to the **Pipeline** page use

```
[some link text](@ref Pipeline)
```

and the **ref** tag will be replaced with the correct URL.

### @htmlonly and @endhtmlonly
Pure HTML can be added to a markdown file by surrounding it with the **@htmlonly** and **@endhtmlonly** tags.

# Example Grabber
The **examplegrabber.js** file is used to load language specific examples onto a general example page. The file must be included in a script tag, then buttons and a div must be set up correctly.

On an example page, the JavaScript is included with (inside a **@htmlonly**)

```
<script type="text/javascript" src="examplegrabber.js"></script>
```

Then a button can be added to view the example in Java:

```
<button class="b-btn b-btn--secondary examplebtn" onclick="grabExample(this, 'pipeline-java','hash_2_getting_started_8java')">Java Code</button>
```

There are a few things to note here:
* the class must be "b-btn b-btn--secondary examplebtn". "b-btn" makes it a button, "b-btn--secondary" makes it unselected, and "examplebtn" is used to identify it to the `grabExample` method;
* the `onclick` event is what sets up the button to load the example using the `grabExample` method defined in `examplegrabber.js`. The arguments are:
	* `this` enables that button to appear selected by removing the "b-btn--secondary" class;
	* `'pipeline-java'` is the name of the repository which the example lives in (this must have the same prefix as this repository);
	* `'hash_2_getting_started_8java'` is the name of the example to load. The actual name of the page will end in '-example.html', but this will be added by the method.

Then a div with the id "grabbed-example" can be added which the **examplegrabber** will load the example into:

```
<div id="grabbed-example"></div>
```

The HTML loaded will come from the **g-docs__primary** div on the target page which will have the id "primary".

Any links on the page (e.g. to classes which are documented in the target repository) are fixed so they point to the correct URL.

# Tag Files
To enable linking to documented members (e.g. classes, structs etc) from other repositories, tag files must be included in the **Doxyfile** using the **TAGFILES** property.

**TODO: explain more**

# DoxygenLayout.xml
This contains the structure of the navigation. First there is the main page (defined by the **@mainpage** tag), then pages (defined with **@page** and **@subpage** tags), then the static links to the language specific documentation (these are hardcoded with the repository names).

# Generating
## Dependencies
### DoxyGen
DoxyGen must be downloaded from **TODO: link**

### GraphVis
In order for DoxyGen to generate nice diagrams, [GraphVis 2.38](https://graphviz.gitlab.io/_pages/Download/windows/graphviz-2.38.msi) must be installed.

### Pattern Lab
**TODO: add style info
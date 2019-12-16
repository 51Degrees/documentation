Documenting Code
================

Code documentation should follow the language syntax, plus a few DoxyGen specific additions.

Before reading this, the reader should be familiar with the [Documenting](Documenting.md) file.

# General

All public code comments should only live in header files if the language is structured that way (e.g. C or C++). Code which is not publicly exposed should still be commented in the code file, however this will not be included in the public generated documentation.

Code comments can be formatted in a few ways, for example, the C way, or the C# way. When using the C/Java way (i.e. asterisks rather than slashes) the comment must begin with two asterisks for DoxyGen to include it:

``` C
/**
 * This is correct.
 */
```

``` C
/*
 * This is wrong.
 */
```

**NOTE:** the asterisks should be horizontally aligned with a space for neatness.

Alternatively in C#:

``` C#
///
/// This is also correct.
///
```

These comment blocks should be above the item which is being documented.

Members, constants etc. can also be commented to the right by beginning the comment with ``/**<``. This can be useful for structures:

``` C
/**
 * Comment for aStruct.
 */
typedef struct a_struct_t {
	const char *aString; /**< Comment for aString. */
	const int anInteger; /**< Comment for anInteger. */
} aStruct;
```

[More on code comments](http://www.doxygen.nl/manual/docblocks.html)

# Method Comments

For XML comment structures like C#, the standard syntax is fine:

``` C#
/// <summary>
/// Comment on the method.
/// </summary>
/// <param="param1">Comment on param1.</param>
/// <returns>Comment on the return value.</returns>
```

[More on XML comments](http://www.doxygen.nl/manual/xmlcmds.html)

With other languages (C, Java etc.) JavaDoc syntax should be used:

``` C
/**
 * Comment on the method.
 * @param param1 comment on param1
 * @return comment on the return value
 */
```

The most useful keywords are:

|   Keyword   | Arguments | Description |
| ----------- | --------- | ----------- |
| ``@param``  | 1         | Describes a parameter of the method. First argument is the param name. |
| ``@return`` | 0         | Describes the value returned by the method. ``@returns`` is also acceptable, but should be consistent across all documentation for that language. |
| ``@tparam`` | 1         | Describes a template parameter. First argument is the param name. For example, a method ``someMethod<T>()`` would use ``@tparam`` to document ``T``. |
| ``@throws`` | 1         | Describes in which situations an exception will be thrown by the method. First argument is the exception type. |
| ``@see``    | 1         | Adds a link to a related item. Mainly useful in Java. |
| ``@copydoc``| 1         | Copies the full comment from another item. This is helpful for inheritance. Also useful are ``@copybrief`` and ``@copydetails``. |

[More on keywords](http://www.doxygen.nl/manual/commands.html)

# Groups

Groups are mainly useful in C where there is no concept of namespaces or subclasses. Each `.h` file should belong to a group. A group is defined using ``@defgroup``, and the contents of a header file can be added to a group using ``@ingroup`` and surrounding with ``@{`` and ``@}``. For example, `arrays.h` is part of the common library, so the header file starts with:

``` C
/**
 * @ingroup FiftyOneDegreesCommon
 * @defgroup FiftyOneDegreesArray Arrays
 *
 * A description of the arrays group...
 *
 * @{
 */
```

and ends with:

``` C
/**
 * @}
 */
```

The ``FiftyOneDegreesCommon`` group is also defined in the same way in another file.

[More on grouping](http://www.doxygen.nl/manual/grouping.html)

# Markdown

All comment blocks can be formatted using markdown. This is the preferred method as it is more readable in the code file than HTML.

[Markdown "cheatsheet"](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)

[More on DoxyGen markdown](http://www.doxygen.nl/manual/markdown.html)

# Links

Links to other documented items are usually generated automatically, however it is preferable to explicitly link using a ``#`` to indicate a link:

``` C
/**
 * Here is a link to the #someFunction function.
 */
```

If the thing being linked is a member of something else, and will be linked with a ``::``, this an indicator like ``#`` so only one is needed. For example, the above example could also be written as:

``` C
/**
 * Here is a link to the ContainingClass::someFunction function.
 */
```

With overloaded functions it is necessary to include the argument types to differentiate, e.g.

``` C++
/**
 * A link to AClass::someOverloadedMethod(int,string)
 */
```

rather than

``` C++
/**
 * A link to AClass::someOverloadedMethod
 */
```

URLs will be automatically linked, but can also be done using markdown syntax:

```
[link text](http:://link.com)
```

[More on linking](http://www.doxygen.nl/manual/autolink.html)

# Classes / Namespaces

Classes and namespaces should be commented in the same way as functions, above their declaration. For example:

``` C++
/**
 * A descriptions of the class SomeClass
 */
class SomeClass {
...
```

or:

``` C#
///
/// A description of the class SomeClass
///
class SomeClass {
...
```

depending on the language.

This can also include ``@tparam`` if the class has one or more type parameter.

Classes and namespaces are automatically structured by DoxyGen so there is no need to use grouping on them. However, methods should be grouped either by using the ``#region`` marker in C#, or like:

``` C++
/**
 * @name Constructors and Destructors
 * @{
 */

...

/**
 * @}
 */
```

in other languages. This makes class documentation pages a bit more structured.

# Examples

## Snippets

The description of classes and groups should contain a brief example of how it is used, with the heading "Usage Example". This should be a brief code block with comments on each step. The code need not be complete, but should show how the class is used, for example:

``` C++
using namespace FiftyoneDegrees::Common;
EngineBase *engine;

// Construct a new evidence instance
EvidenceBase *evidence = new EvidenceBase();

// Add an item of evidence
evidence->operator[]("evidence key") = "evidence value";

// Give the evidence to an engine for processing
ResultsBase *results = engine->processBase(evidence);

// Do something with the results (and delete them once finished)
// ...

// Delete the evidence
delete evidence;
```

It is also important to include any namespaces in the snippet to ensure that classes and methods are linked properly in the generated documentation. In the above example, the reader should be able to click on ``EngineBase`` or any other method and be taken to the documentation for it.

## Full Examples

Source files for examples should be documented with ``@example`` which takes an argument of the file name. This may also include some of the path if the name is ambiguous.

A new example should be added to the project's `Doxyfile` in the `INPUT` field if the source is not already included (this is the case in C and C++ where only `.h` and `.hpp` files are included).

Directories containing examples should be added to the `EXAMPLE_PATH` field in the `Doxyfile` of the project.

The steps carried out in the example should then be detailed along with code snippets to show the step. For example:

```` C++
/**
@example Hash/GettingStarted.cpp
Brief description...

The example shows how to:

1. Do the first step.
```
using namespace ANamepspace;

string value = "avalue";

ANamepspace::AClass *instance = new ANamepspace::AClass(avalue);
```

2. Do the second step.
```
using namespace ANamepspace;

ANamepspace::AnotherClass = instance->someMethod();
```

And some more clarification here if needed.
*/
````

Note that it is fine to omit the aligned asterisks at the start of each line in this case in order to make the text a bit more readable.
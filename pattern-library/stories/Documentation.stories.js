// Pages for the documentation surface (the 51Degrees docs site). Same approach
// as Examples/Pages: one story per page, rendered from source/_patterns.
import { renderPattern } from './render-twig.js';

export default { title: "Documentation/Pages" };

export const DocsIndex = () => renderPattern("layouts-docs-index");
DocsIndex.storyName = "docs index";
export const Doxygen = () => renderPattern("pages-doxygen");
Doxygen.storyName = "doxygen";

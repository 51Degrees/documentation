// Documentation body typography. The heading / link / code styles are scoped
// under .l-docs-index .g-docs__primary, so the wrapper is required.
export default {
  title: 'Base/Typography',
};

const wrap = (inner) => `
  <div class="l-docs-index">
    <div class="g-main">
      <div class="g-docs__content">
        <div class="g-docs__primary" style="padding:24px">${inner}</div>
      </div>
    </div>
  </div>`;

export const Headings = () =>
  wrap(`
    <h1>Heading level 1</h1>
    <h2>Heading level 2</h2>
    <h3>Heading level 3</h3>
    <p>Body paragraph with a <a href="#">documentation link</a> and some
    <code>inline code</code>. Lists and paragraphs use the standard spacing.</p>
    <ul><li>First item</li><li>Second item</li></ul>`);
Headings.storyName = 'Headings & text';

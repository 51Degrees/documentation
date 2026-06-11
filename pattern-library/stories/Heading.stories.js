// Documentation headings: the page title (g-docs__page-title), section
// headings (doxsection) with their hover permalink, and the c-label badge.
export default {
  title: 'Base/Headings',
};

const wrap = (inner) => `
  <div class="l-docs-index">
    <div class="g-main">
      <div class="g-docs__content">
        <div class="g-docs__header">
          <h1 class="g-docs__page-title">Apple Model Detection <span class="c-label">feature</span></h1>
        </div>
        <div class="g-docs__inner">
          <div class="g-docs__primary" style="padding:0 24px">${inner}</div>
        </div>
      </div>
    </div>
  </div>`;

export const PageAndSections = () =>
  wrap(`
    <h2 class="doxsection" id="overview">Overview<a class="headerlink" href="#overview" aria-label="Permalink to this section">🔗</a></h2>
    <p>Section headings use the doxsection style (lime marker) with a permalink
    that appears on hover.</p>
    <h2 class="doxsection" id="how-it-works">How it works<a class="headerlink" href="#how-it-works" aria-label="Permalink to this section">🔗</a></h2>
    <p>The page title above uses g-docs__page-title, with an optional c-label badge.</p>`);
PageAndSections.storyName = 'Page title & section headings';

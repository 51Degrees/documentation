// The full documentation page layout: masthead, left menu (sidenav), content
// column (breadcrumb, page title, body), section nav, and footer CTA. Mirrors
// the layout in source/_patterns/04-layouts/01-docs.
export default {
  title: 'Layouts/Page',
};

export const DocumentationPage = () => `
  <div class="l-docs-index">
    <div class="l-index__content">
      <header class="g-header">
        <a id="projectlogo" href="https://51degrees.com/" class="c-brand__link">
          <img class="c-brand__image" alt="51Degrees" src="https://51degrees.com/img/logo.png" width="172" height="32" />
        </a>
      </header>
      <main class="g-main">
        <div class="g-docs__sidenav">
          <nav class="c-sidenav">
            <h4 class="c-sidenav__heading">Documentation</h4>
            <ul class="c-sidenav__list">
              <li class="c-sidenav__item"><a class="c-sidenav__link" href="#">Getting started</a></li>
              <li class="c-sidenav__item">
                <a class="c-sidenav__link c-sidenav__link--children c-sidenav__link--is-open" href="#">IP Intelligence</a>
                <ul class="c-sidenav__list">
                  <li class="c-sidenav__item"><a class="c-sidenav__link c-sidenav__link--is-active" href="#">Diversity (active)</a></li>
                  <li class="c-sidenav__item"><a class="c-sidenav__link" href="#">Randomization</a></li>
                </ul>
              </li>
            </ul>
          </nav>
        </div>
        <div class="g-docs__content">
          <div class="g-docs__header">
            <ul class="c-breadcrumb">
              <li class="c-breadcrumb__item"><a class="c-breadcrumb__link" href="#">IP Intelligence</a></li>
              <li class="c-breadcrumb__item"><a class="c-breadcrumb__link" href="#">Features</a></li>
              <li class="c-breadcrumb__item">Diversity</li>
            </ul>
            <h1 class="g-docs__page-title">Diversity</h1>
          </div>
          <div class="g-docs__inner">
            <div class="g-docs__primary">
              <h2 class="doxsection" id="overview">Overview<a class="headerlink" href="#overview" aria-label="Permalink to this section">🔗</a></h2>
              <p>The diversity metric describes how varied the candidate set is for an IP address. It is one of the IP Intelligence quality signals.</p>
              <h2 class="doxsection" id="age-weight">Age weight<a class="headerlink" href="#age-weight" aria-label="Permalink to this section">🔗</a></h2>
              <p>Records are weighted by age so that more recent observations contribute more to the result.</p>
            </div>
            <div class="g-docs__sidebar">
              <div class="c-section-nav">
                <h5 class="c-section-nav__heading">In this section</h5>
                <ul class="c-section-nav__list">
                  <li class="c-section-nav__item"><a class="c-section-nav__link" href="#overview">Overview</a></li>
                  <li class="c-section-nav__item"><a class="c-section-nav__link" href="#age-weight">Age weight</a></li>
                </ul>
              </div>
            </div>
          </div>
          <section id="nav-path" class="g-footer g-footer--docs">
            <p class="g-footer__message">Have a data or code question? <a href="https://51degrees.com/contact-us">Get in touch</a> and explore <a href="https://51degrees.com/pricing">subscription options</a>.</p>
          </section>
        </div>
      </main>
    </div>
  </div>`;
DocumentationPage.storyName = 'Documentation page';

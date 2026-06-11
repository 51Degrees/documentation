// The left navigation menu (c-sidenav) with nested, expandable items.
export default {
  title: 'Components/Menu',
};

export const SideNav = () => `
  <div class="l-docs-index">
    <div class="g-docs__sidenav" style="padding:24px;max-width:340px">
      <nav class="c-sidenav">
        <h4 class="c-sidenav__heading">Documentation</h4>
        <ul class="c-sidenav__list">
          <li class="c-sidenav__item"><a class="c-sidenav__link" href="#">Getting started</a></li>
          <li class="c-sidenav__item"><a class="c-sidenav__link c-sidenav__link--children" href="#">Device Detection</a></li>
          <li class="c-sidenav__item">
            <a class="c-sidenav__link c-sidenav__link--children c-sidenav__link--is-open" href="#">IP Intelligence</a>
            <ul class="c-sidenav__list">
              <li class="c-sidenav__item"><a class="c-sidenav__link" href="#">Overview</a></li>
              <li class="c-sidenav__item">
                <a class="c-sidenav__link c-sidenav__link--children c-sidenav__link--is-open" href="#">Features</a>
                <ul class="c-sidenav__list">
                  <li class="c-sidenav__item"><a class="c-sidenav__link c-sidenav__link--is-active" href="#">Diversity (active)</a></li>
                  <li class="c-sidenav__item"><a class="c-sidenav__link" href="#">Randomization</a></li>
                </ul>
              </li>
            </ul>
          </li>
          <li class="c-sidenav__item"><a class="c-sidenav__link c-sidenav__link--children" href="#">Pipeline</a></li>
        </ul>
      </nav>
    </div>
  </div>`;
SideNav.storyName = 'Side navigation';

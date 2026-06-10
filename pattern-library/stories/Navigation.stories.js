// Breadcrumb navigation (c-breadcrumb), as shown at the top of doc pages.
export default {
  title: 'Components/Navigation',
};

export const Breadcrumb = () => `
  <div class="l-docs-index">
    <div class="g-docs__header" style="padding:24px">
      <ul class="c-breadcrumb">
        <li class="c-breadcrumb__item"><a class="c-breadcrumb__link" href="#">IP Intelligence</a></li>
        <li class="c-breadcrumb__item"><a class="c-breadcrumb__link" href="#">Features</a></li>
        <li class="c-breadcrumb__item">Diversity</li>
      </ul>
    </div>
  </div>`;
Breadcrumb.storyName = 'Breadcrumb';

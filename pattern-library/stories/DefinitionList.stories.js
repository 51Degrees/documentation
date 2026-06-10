// Definition list (c-list-definition), used for doxygen \param / \return docs.
export default {
  title: 'Components/Definition list',
};

export const Default = () => `
  <div class="l-docs-index">
    <div class="g-docs__primary" style="padding:24px">
      <dl class="c-list-definition">
        <dt class="c-list-definition__title">resource</dt>
        <dd class="c-list-definition__desc">The Resource Key for the request.</dd>
        <dt class="c-list-definition__title">Returns</dt>
        <dd class="c-list-definition__desc">A signed 51Did envelope.</dd>
      </dl>
    </div>
  </div>`;
Default.storyName = 'Definition list';

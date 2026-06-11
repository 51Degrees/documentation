// Landing story for the design system. It replaced the Pattern Lab / Twig
// preview; Storybook's Vite compiles the SCSS live.
export default {
  title: 'Introduction',
};

export const Welcome = () => `
  <div class="l-docs-index" style="padding:32px">
    <div class="g-docs__primary">
      <h1>51Degrees documentation design system</h1>
      <p>These stories render the documentation pattern library against the real
      design-system styles. They replaced the Pattern Lab / Twig preview.</p>
      <h2>How it is built</h2>
      <p>The SCSS in <code>source/sass</code> is compiled by Vite (Storybook's
      bundler, with <code>vite-plugin-sass-glob-import</code> for the glob
      <code>@import</code>s); the same setup produces <code>docs-main.css</code>
      via <code>npm run build:css</code>. The pattern stories render every
      template in <code>source/_patterns</code> through twig.js.</p>
      <h2>Adding a story</h2>
      <p>Create <code>stories/&lt;Name&gt;.stories.js</code> exporting HTML that
      uses the component's classes. Wrap docs content in
      <code>.l-docs-index .g-docs__primary</code> to pick up the documentation
      layout styles.</p>
    </div>
  </div>`;
Welcome.storyName = 'Welcome';

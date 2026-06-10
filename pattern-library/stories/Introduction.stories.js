// Landing story for the design system. Plain HTML stories exercise the
// compiled docs-main.css, so there is no component-framework lock-in.
export default {
  title: 'Introduction',
};

export const Welcome = () => `
  <div class="l-docs-index" style="padding:32px">
    <div class="g-docs__primary">
      <h1>51Degrees documentation design system</h1>
      <p>These stories render the documentation pattern library against the
      real compiled stylesheet (<code>docs-main.css</code>). They replaced the
      Pattern Lab / Twig preview.</p>
      <h2>How it is built</h2>
      <p>The SCSS in <code>source/sass</code> is compiled to
      <code>docs-main.css</code> by <code>gulp sass</code> (it uses glob
      <code>@import</code>s that gulp-sass-glob resolves). Storybook imports
      that CSS, so a story is just example markup using the design-system
      classes.</p>
      <h2>Adding a story</h2>
      <p>Create <code>stories/&lt;Name&gt;.stories.js</code> exporting HTML that
      uses the component's classes. Wrap docs content in
      <code>.l-docs-index .g-docs__primary</code> to pick up the documentation
      layout styles.</p>
    </div>
  </div>`;
Welcome.storyName = 'Welcome';

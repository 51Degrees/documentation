/**
 * Storybook configuration for the 51Degrees documentation pattern library.
 *
 * Framework: @storybook/html-vite. Stories are plain HTML that exercise the
 * design-system CSS classes, so there is no component-framework lock-in.
 *
 * The SCSS is compiled to CSS by gulp (it relies on glob @imports that only
 * gulp-sass-glob resolves); Storybook imports the compiled docs-main.css in
 * preview.js. The `storybook`/`build-storybook` npm scripts run `gulp sass`
 * first so the CSS is fresh.
 *
 * @type { import('@storybook/html-vite').StorybookConfig }
 */
const config = {
  stories: ['../stories/**/*.stories.js'],
  addons: ['@storybook/addon-a11y'],
  framework: {
    name: '@storybook/html-vite',
    options: {},
  },
};

export default config;

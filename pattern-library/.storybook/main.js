/**
 * Storybook configuration for the 51Degrees documentation pattern library.
 *
 * Framework: @storybook/html-vite. Stories are plain HTML that exercise the
 * design-system CSS classes, so there is no component-framework lock-in.
 *
 * Storybook's own Vite compiles the SCSS live (preview.js imports
 * source/sass/docs-main.scss). vite-plugin-sass-glob-import resolves the glob
 * @imports the entry relies on. The same Vite setup (vite.config.js) builds
 * the docs CSS via `npm run build:css`.
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
  async viteFinal(viteConfig) {
    const { default: sassGlobImports } = await import('vite-plugin-sass-glob-import');
    viteConfig.plugins = viteConfig.plugins || [];
    viteConfig.plugins.push(sassGlobImports());
    viteConfig.css = viteConfig.css || {};
    viteConfig.css.preprocessorOptions = viteConfig.css.preprocessorOptions || {};
    viteConfig.css.preprocessorOptions.scss = {
      loadPaths: ['source/sass', 'node_modules/normalize.css'],
    };
    return viteConfig;
  },
};

export default config;

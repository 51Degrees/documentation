// The design system, compiled live by Storybook's Vite (with the glob-import
// plugin). Both entries are imported so every pattern is styled: docs-main
// covers the documentation surface (base, components, docs groups/layouts,
// footers) and conf-main covers the configurator components/panels.
import '../source/sass/docs-main.scss';
import '../source/sass/conf-main.scss';
import '../source/sass/examples-main.scss';

/** @type { import('@storybook/html').Preview } */
const preview = {
  parameters: {
    layout: 'fullscreen',
    options: {
      storySort: {
        order: ['Introduction', 'Base', 'Components', 'Groups', ['Examples', ['Pages', 'Components']], 'Documentation', 'Configurator'],
      },
    },
    a11y: {
      // The design system targets WCAG; surface violations in the panel.
      test: 'todo',
    },
  },
};

export default preview;

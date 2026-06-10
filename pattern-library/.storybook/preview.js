// The design system, compiled live by Storybook's Vite (with the glob-import
// plugin). Importing the SCSS entry means every story renders with the real
// 51Degrees documentation styles and hot-reloads on SCSS edits.
import '../source/sass/docs-main.scss';

/** @type { import('@storybook/html').Preview } */
const preview = {
  parameters: {
    layout: 'fullscreen',
    options: {
      storySort: {
        order: ['Introduction', 'Base', 'Components', 'Groups', 'Layouts'],
      },
    },
    a11y: {
      // The design system targets WCAG; surface violations in the panel.
      test: 'todo',
    },
  },
};

export default preview;

// The compiled design-system stylesheet (built by `gulp sass`). Importing it
// here makes every story render with the real 51Degrees documentation styles.
import '../source/css/docs-main.css';

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

import { defineConfig } from 'vite';
import sassGlobImports from 'vite-plugin-sass-glob-import';
import { resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('.', import.meta.url));

// Compiles the SCSS design system to CSS, replacing the old gulp pipeline.
// vite-plugin-sass-glob-import expands the glob @imports (e.g.
// '01-base/**/*.scss') that the entry files rely on. Storybook reuses the
// glob plugin + loadPaths via .storybook/main.js.
export default defineConfig({
  plugins: [
    sassGlobImports(),
    // CSS-only build: drop the empty JS chunks rollup emits per SCSS entry.
    {
      name: 'css-only-output',
      generateBundle(_options, bundle) {
        for (const file of Object.keys(bundle)) {
          if (file.endsWith('.js')) delete bundle[file];
        }
      },
    },
  ],
  css: {
    preprocessorOptions: {
      scss: {
        loadPaths: ['source/sass', 'node_modules/normalize.css'],
      },
    },
  },
  build: {
    outDir: 'source/css',
    emptyOutDir: false,
    cssMinify: false,
    rollupOptions: {
      input: {
        'docs-main': resolve(root, 'source/sass/docs-main.scss'),
        'main': resolve(root, 'source/sass/main.scss'),
        'conf-main': resolve(root, 'source/sass/conf-main.scss'),
        'examples-main': resolve(root, 'source/sass/examples-main.scss'),
      },
      output: {
        assetFileNames: '[name][extname]',
      },
    },
  },
});

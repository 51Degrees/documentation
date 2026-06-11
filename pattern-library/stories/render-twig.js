// Renders the Pattern Lab Twig templates so every pattern in source/_patterns
// appears in Storybook. Vite loads each .twig (raw) and .json (data) at build
// time; twig.js renders them. Includes/extends use Pattern Lab shorthand
// (<category>-<basename>, e.g. "components-sidenav") which we register here.
import Twig from 'twig';

const templates = import.meta.glob('../source/_patterns/**/*.twig', {
  query: '?raw',
  import: 'default',
  eager: true,
});
const dataModules = import.meta.glob('../source/_patterns/**/*.json', {
  import: 'default',
  eager: true,
});

const strip = (s) => s.replace(/^\d+-/, '');
const relOf = (p) => p.split('/_patterns/')[1];
const shorthand = (p) => {
  const r = relOf(p).replace(/\.(twig|json)$/, '');
  const s = r.split('/');
  return strip(s[0]) + '-' + strip(s[s.length - 1]);
};
const pathId = (p) => relOf(p).replace(/\.twig$/, '');

const dataById = {};
for (const [p, d] of Object.entries(dataModules)) {
  dataById[shorthand(p)] = d && d.default ? d.default : d;
}

// Register every template under its shorthand id and its full path id so
// includes/extends resolve from the inline registry.
const objects = {};
for (const [p, content] of Object.entries(templates)) {
  for (const id of [shorthand(p), pathId(p)]) {
    if (objects[id]) continue;
    try {
      objects[id] = Twig.twig({ id, data: content, allowInlineIncludes: true });
    } catch (_) {
      /* keep going; failures surface at render time */
    }
  }
}

export function renderPattern(id, extra = {}) {
  const data = { ...(dataById[id] || {}), ...extra };
  let html;
  try {
    const tpl = objects[id] || Twig.twig({ ref: id });
    html = tpl.render(data);
  } catch (e) {
    return (
      '<div style="padding:16px;border:1px dashed #c33;color:#900;font:13px/1.5 sans-serif">' +
      'Pattern <b>' + id + '</b> could not be previewed: ' + (e && e.message) +
      '<br><small>The source template uses Twig features (e.g. {% extends %}) that need updating for the renderer.</small></div>'
    );
  }
  // Wrap in the documentation layout class so design-system styles apply.
  return '<div class="l-docs-index">' + html + '</div>';
}

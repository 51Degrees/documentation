// Renders the Pattern Lab Twig templates so every pattern in source/_patterns
// appears in Storybook. Vite loads each .twig (raw) and .json (data) at build
// time; twig.js renders them. Includes/extends use Pattern Lab shorthand
// (<category>-<basename>, e.g. "components-sidenav").
//
// twig.js cannot `extends` an inline (in-memory) template, so we flatten
// inheritance ourselves: resolve the parent and substitute the child's blocks
// before handing a single, extends-free template to twig.js.
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
  // strip a trailing dash too: "00-panel-.twig" -> "panel" so includes/extends
  // that reference "groups-panel" resolve.
  return strip(s[0]) + '-' + strip(s[s.length - 1]).replace(/-+$/, '');
};
const pathId = (p) => relOf(p).replace(/\.twig$/, '');

// Raw template content by both ids (for flattening parents).
const rawById = {};
for (const [p, content] of Object.entries(templates)) {
  rawById[shorthand(p)] = content;
  rawById[pathId(p)] = content;
}
const dataById = {};
for (const [p, d] of Object.entries(dataModules)) {
  dataById[shorthand(p)] = d && d.default ? d.default : d;
}

const EXTENDS = /\{%\s*extends\s+["']([^"']+)["']\s*%\}/;
const BLOCK = /\{%\s*block\s+(\w+)\s*%\}([\s\S]*?)\{%\s*endblock(?:\s+\w+)?\s*%\}/g;

// Resolve {% extends %} by inlining the child's block overrides into the
// parent. Handles multi-level inheritance; no {{ parent() }} (unused here).
function flatten(content, depth = 0) {
  if (depth > 6) return content;
  const ext = content.match(EXTENDS);
  if (!ext) return content;
  const parentRaw = rawById[ext[1]];
  if (!parentRaw) return content;
  const parent = flatten(parentRaw, depth + 1);
  const childBody = content.replace(EXTENDS, '');
  const childBlocks = {};
  let m;
  BLOCK.lastIndex = 0;
  while ((m = BLOCK.exec(childBody))) childBlocks[m[1]] = m[2];
  return parent.replace(BLOCK, (full, name, inner) =>
    name in childBlocks ? childBlocks[name] : inner
  );
}

// Register every (extends-free) template so includes resolve from the registry.
for (const [, content] of Object.entries(templates)) {
  // nothing to do here; templates are compiled on demand below
}
let registered = false;
function registerAll() {
  if (registered) return;
  registered = true;
  for (const [p, content] of Object.entries(templates)) {
    const flat = flatten(content);
    for (const id of [shorthand(p), pathId(p)]) {
      try { Twig.twig({ id, data: flat, allowInlineIncludes: true }); } catch (_) {}
    }
  }
}

export function renderPattern(rawId, extra = {}) {
  registerAll();
  // Normalise a trailing dash so ids generated before the fix still resolve.
  const id = rawById[rawId] ? rawId : rawId.replace(/-+$/, '');
  // Permissive defaults so patterns that reference data with no .json file
  // (option.*, category.*, loops) render empty instead of throwing.
  const baseline = {
    option: {}, category: {}, subCategory: {},
    categories: [], options: [], properties: [],
    vendor: '', vendors: [{ name: '' }],
  };
  const data = { ...baseline, ...(dataById[id] || {}), ...extra };
  try {
    const flat = flatten(rawById[id] || '');
    const html = Twig.twig({ data: flat, allowInlineIncludes: true }).render(data);
    return '<div class="l-docs-index">' + html + '</div>';
  } catch (e) {
    return (
      '<div style="padding:16px;border:1px dashed #c33;color:#900;font:13px/1.5 sans-serif">' +
      'Pattern <b>' + id + '</b> could not be previewed: ' + (e && e.message) + '</div>'
    );
  }
}

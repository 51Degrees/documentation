// Base buttons (b-btn) and modifiers.
export default {
  title: 'Base/Buttons',
};

const wrap = (inner) => `<div class="l-docs-index" style="padding:24px;display:flex;gap:12px;flex-wrap:wrap;align-items:center">${inner}</div>`;

export const Variants = () =>
  wrap(`
    <button class="b-btn">Default</button>
    <button class="b-btn b-btn--secondary">Secondary</button>
    <button class="b-btn b-btn--large">Large</button>
    <button class="b-btn" disabled>Disabled</button>
    <a href="#" class="b-btn">Anchor button</a>`);
Variants.storyName = 'Variants';

export const Block = () =>
  `<div class="l-docs-index" style="padding:24px;max-width:420px">
     <button class="b-btn b-btn--block">Block button</button>
   </div>`;
Block.storyName = 'Block';

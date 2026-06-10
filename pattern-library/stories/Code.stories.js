// Code block (c-code) with syntax-highlight spans, as emitted for doxygen
// code listings.
export default {
  title: 'Components/Code',
};

export const Block = () => `
  <div class="l-docs-index">
    <div class="g-docs__primary" style="padding:24px">
      <div class="c-code">
        <header class="c-code__header">
          <h2 class="c-code__heading">Example</h2>
        </header>
        <code class="c-code__block">
          <div class="c-code__line"><span class="c-code__keyword">namespace </span>TestNamespace {</div>
          <div class="c-code__line">  <span class="c-code__keyword">class </span>Example {</div>
          <div class="c-code__line">    <span class="c-code__keywordtype">const char</span> *s = <span class="c-code__stringliteral">"a string"</span>;</div>
          <div class="c-code__line">    <span class="c-code__comment">// a comment</span></div>
          <div class="c-code__line">  }</div>
          <div class="c-code__line">}</div>
        </code>
      </div>
    </div>
  </div>`;
Block.storyName = 'Code block';

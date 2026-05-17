# HTML Document Shapes — paste-ready templates

This is the technical reference SKILL.md sends you to in Step 5. Each shape entry is a self-contained recipe: when to use it, what DOM you need, which styles are shape-specific (on top of the design tokens in SKILL.md), and which interactive behaviours are mandatory.

**Read only the shape(s) you actually need.** Don't read the whole file end-to-end on every invocation.

Conventions used below:
- `<!-- comments like this -->` are direction for you, the agent, not for the file.
- Style snippets are *additive* — paste them after the design-token block from SKILL.md.
- `…` inside markup means "fill in real content here."

---

## Shape 1 — Explainer

**Use when** the content teaches one thing: how a system works, what a concept means, how a feature behaves. Concept explainer, feature deep-dive, "explain X to me like I'm new."

**Mandatory elements**: TL;DR box at the top, scannable subheadings (h2 per section), at least one diagram OR one collapsible "show the details" block, optional sticky table-of-contents aside on desktop, optional glossary aside that hover-links terms in the body.

### Skeleton

```html
<main class="explainer">
  <header>
    <p class="eyebrow">Concept · 5 min read</p>
    <h1>Consistent hashing</h1>
    <p class="lead">One paragraph: why this exists and what problem it solves.</p>
  </header>

  <aside class="tldr">
    <p class="tldr-label">TL;DR</p>
    <p>Three sentences max. The whole point compressed.</p>
  </aside>

  <section>
    <h2>How it works</h2>
    <p>…</p>
    <!-- inline SVG diagram if it helps -->
  </section>

  <section>
    <h2>When to reach for it</h2>
    <ul class="checklist">
      <li>Scenario one</li>
      <li>Scenario two</li>
    </ul>
  </section>

  <details class="deep-dive">
    <summary>Show me the math</summary>
    <p>Hidden by default, expandable for the readers who want it.</p>
  </details>

  <aside class="glossary">
    <h3>Glossary</h3>
    <dl>
      <dt>Node</dt><dd>A server in the hash ring.</dd>
    </dl>
  </aside>
</main>
```

### Shape-specific styles

```css
.explainer { max-width: 1100px; margin: 0 auto; display: grid;
  grid-template-columns: minmax(0, 1fr) 240px; gap: 48px; }
@media (max-width: 960px) {
  .explainer { grid-template-columns: 1fr; }
  .explainer > aside { order: 2; position: static; max-height: none; }
}
.tldr { background: var(--g100); border-left: 3px solid var(--clay);
  padding: 16px 20px; border-radius: 6px; margin: 24px 0 40px; }
.tldr-label { font-family: var(--mono); font-size: 11px; text-transform: uppercase;
  letter-spacing: 0.08em; color: var(--clay); margin-bottom: 6px; }
.term { border-bottom: 1.5px dotted var(--clay); cursor: help; }
details.deep-dive { border: 1.5px solid var(--g300); border-radius: 10px;
  padding: 16px 20px; margin: 24px 0; }
details.deep-dive summary { font-family: var(--mono); font-size: 12px;
  text-transform: uppercase; letter-spacing: 0.06em; cursor: pointer; }

/* Sticky glossary / sidebar — MUST contain its own scroll, or
   content past the viewport is unreachable. */
.explainer > aside.glossary {
  position: sticky;
  top: 32px;
  align-self: start;
  max-height: calc(100vh - 64px);
  overflow-y: auto;
  overscroll-behavior: contain;
  padding: 18px;
  background: var(--g100);
  border: 1.5px solid var(--g200);
  border-radius: 12px;
}
.explainer > aside.glossary::-webkit-scrollbar { width: 6px; }
.explainer > aside.glossary::-webkit-scrollbar-thumb {
  background: var(--g300); border-radius: 999px;
}
```

### Interactive behaviour (optional but recommended)

If the explainer has terms repeated across sections, mark them with `<span class="term" data-glossary="node">node</span>` and add a click handler that scrolls the glossary `dt` into view.

---

## Shape 2 — Comparison

**Use when** the content puts 2–4 options next to each other: code approaches, design directions, library trade-offs, before/after.

**Mandatory elements**: equal-width side-by-side columns at desktop, stacked at mobile, identical sub-structure across columns (pros / cons / one footer metric), one column marked "Recommended" if there's a default.

### Skeleton (3-up)

```html
<main class="comparison">
  <header>
    <p class="eyebrow">Decision · pick one</p>
    <h1>Debounced search — three approaches</h1>
    <p class="lead">Same feature, three ways to build it. Trade-offs called out inline.</p>
  </header>

  <div class="compare-grid">
    <article class="option">
      <header class="option-head">
        <h2>Inline useEffect</h2>
        <p class="meta">Bundle: +0 kb · Reuse: low</p>
      </header>
      <pre><code>…</code></pre>
      <div class="pros-cons">
        <ul class="pros"><li>Pro one</li></ul>
        <ul class="cons"><li>Con one</li></ul>
      </div>
    </article>

    <article class="option recommended">
      <header class="option-head">
        <h2>Custom hook <span class="pill">recommended</span></h2>
        <p class="meta">Bundle: +0.2 kb · Reuse: high</p>
      </header>
      <pre><code>…</code></pre>
      <div class="pros-cons">
        <ul class="pros"><li>…</li></ul>
        <ul class="cons"><li>…</li></ul>
      </div>
    </article>

    <article class="option">…</article>
  </div>
</main>
```

### Shape-specific styles

```css
.comparison { max-width: 1280px; margin: 0 auto; }
.compare-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; }
@media (max-width: 960px) { .compare-grid { grid-template-columns: 1fr; } }
.option { border: 1.5px solid var(--g300); border-radius: 12px; background: var(--paper); padding: 20px; }
.option.recommended { border-color: var(--clay); box-shadow: 0 8px 24px rgba(217,119,87,0.08); }
.option-head h2 { font-size: 22px; }
.pill { display: inline-block; font-family: var(--mono); font-size: 10px;
  text-transform: uppercase; letter-spacing: 0.08em; color: var(--clay);
  border: 1px solid var(--clay); border-radius: 999px; padding: 2px 8px; }
.meta { font-family: var(--mono); font-size: 11px; color: var(--g500); margin: 4px 0 12px; }
pre { background: var(--g100); border-radius: 8px; padding: 12px; overflow-x: auto;
  font-size: 12px; line-height: 1.55; }
.pros-cons { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-top: 12px; }
.pros li::marker { color: var(--olive); }
.cons li::marker { color: var(--rust); }
.pros, .cons { padding-left: 20px; font-size: 13px; }
```

---

## Shape 3 — Report

**Use when** the content is recurring institutional reading: weekly status, monthly recap, project update, post-mortem.

**Mandatory elements**: header with date range + "auto-generated" pill, a "What shipped" / "What slipped" / "Next week" three-block layout, at least one small chart or counter, a print stylesheet so it survives being PDF'd.

### Skeleton

```html
<main class="report">
  <header>
    <div class="header-top">
      <h1>Platform Eng — Week 11</h1>
      <span class="auto-pill">Auto · Mar 10 – Mar 14</span>
    </div>
    <p class="date-range">5 days · 18 PRs merged · 2 incidents</p>
  </header>

  <section class="counters">
    <div class="counter">
      <p class="counter-label">Shipped</p>
      <p class="counter-num shipped">7</p>
    </div>
    <div class="counter">
      <p class="counter-label">In flight</p>
      <p class="counter-num">4</p>
    </div>
    <div class="counter">
      <p class="counter-label">Slipped</p>
      <p class="counter-num slipped">2</p>
    </div>
  </section>

  <section>
    <h2>What shipped</h2>
    <ul class="entry-list">
      <li><span class="status shipped"></span><strong>Deploy speed</strong> — Cut p95 deploy time from 8m to 3m. <a>PR 1241</a></li>
    </ul>
  </section>

  <section>
    <h2>What slipped</h2>
    <ul class="entry-list">…</ul>
  </section>

  <section>
    <h2>Next week</h2>
    <ol class="entry-list">…</ol>
  </section>
</main>
```

### Shape-specific styles

```css
.report { max-width: 860px; margin: 0 auto; }
.header-top { display: flex; align-items: baseline; justify-content: space-between; gap: 12px; }
.auto-pill { font-family: var(--mono); font-size: 11px; text-transform: uppercase;
  letter-spacing: 0.06em; color: var(--g500); background: var(--g100);
  border: 1.5px solid var(--g300); border-radius: 999px; padding: 5px 11px; }
.counters { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin: 32px 0 40px; }
.counter { border: 1.5px solid var(--g300); border-radius: 12px; padding: 20px;
  background: var(--paper); }
.counter-label { font-family: var(--mono); font-size: 11px; text-transform: uppercase;
  letter-spacing: 0.08em; color: var(--g500); margin-bottom: 8px; }
.counter-num { font-family: var(--serif); font-size: 44px; font-weight: 500;
  letter-spacing: -0.02em; }
.counter-num.shipped { color: var(--olive); }
.counter-num.slipped { color: var(--rust); }
.entry-list { list-style: none; padding: 0; }
.entry-list li { display: flex; align-items: baseline; gap: 12px; padding: 10px 0;
  border-bottom: 1px solid var(--g200); }
.status { width: 8px; height: 8px; border-radius: 50%; flex-shrink: 0; margin-top: 8px; }
.status.shipped { background: var(--olive); }
.status.slipped { background: var(--rust); }

@media print {
  body { background: white; padding: 0; }
  .auto-pill { background: transparent; }
  section { page-break-inside: avoid; }
}
```

### Incident-report variant

Add a chronological timeline section (`<ol class="timeline">`) with timestamps in the left column and event descriptions on the right, plus a "Follow-up checklist" of action items at the bottom. Each timeline row gets `border-left: 2px solid var(--g300)` and a dot at the start.

---

## Shape 4 — Slide deck

**Use when** the user said "deck", "slides", or "present" and wants something they can arrow-key through in a meeting.

**Mandatory elements**: `scroll-snap-type: y mandatory` on the body, full-viewport `.slide` sections, arrow-key + space navigation, page counter in the corner, an optional `.invert` slide for section breaks.

### Skeleton

```html
<body>
  <section class="slide cover">
    <div class="slide-inner">
      <p class="eyebrow">Q2 Planning · 14 Mar 2026</p>
      <h1>Where we go next</h1>
      <p class="subtitle">A short read for the leadership team.</p>
    </div>
  </section>

  <section class="slide">
    <div class="slide-inner">
      <h2>Three bets for the quarter</h2>
      <ul class="big">
        <li>One</li><li>Two</li><li>Three</li>
      </ul>
    </div>
  </section>

  <section class="slide invert">
    <div class="slide-inner">
      <p class="eyebrow">Bet 01</p>
      <h2>Detail page</h2>
    </div>
  </section>

  <nav class="pager"><span id="cur">1</span> / <span id="tot">3</span></nav>
</body>
```

### Shape-specific styles

```css
html { scroll-behavior: smooth; }
body { scroll-snap-type: y mandatory; overflow-x: hidden; padding: 0; }
.slide { width: 100vw; height: 100vh; scroll-snap-align: start; scroll-snap-stop: always;
  display: flex; align-items: center; justify-content: center; padding: 8vh 6vw; }
.slide-inner { width: 100%; max-width: 780px; }
.slide.invert { background: var(--slate); color: var(--ivory); }
.slide.invert .eyebrow { color: var(--g300); }
.slide h1 { font-size: clamp(40px, 6vw, 64px); line-height: 1.08; }
.slide h2 { font-size: clamp(30px, 4vw, 42px); }
.subtitle { font-size: 17px; line-height: 1.6; color: var(--g700); max-width: 520px; }
.invert .subtitle { color: var(--g300); }
.pager { position: fixed; bottom: 18px; right: 22px; font-family: var(--mono);
  font-size: 12px; color: var(--g500); }
```

### Mandatory JS

```html
<script>
  const slides = document.querySelectorAll('.slide');
  const cur = document.getElementById('cur');
  const tot = document.getElementById('tot');
  tot.textContent = slides.length;
  let i = 0;
  const go = (delta) => {
    i = Math.max(0, Math.min(slides.length - 1, i + delta));
    slides[i].scrollIntoView({ behavior: 'smooth' });
    cur.textContent = i + 1;
  };
  addEventListener('keydown', (e) => {
    if (e.key === 'ArrowDown' || e.key === 'ArrowRight' || e.key === ' ' || e.key === 'PageDown') { e.preventDefault(); go(1); }
    if (e.key === 'ArrowUp'   || e.key === 'ArrowLeft'  || e.key === 'PageUp')                   { e.preventDefault(); go(-1); }
    if (e.key === 'f' || e.key === 'F') document.documentElement.requestFullscreen?.();
  });
  // Keep counter in sync if user scrolls with the wheel/trackpad.
  new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        i = [...slides].indexOf(entry.target);
        cur.textContent = i + 1;
      }
    });
  }, { threshold: 0.6 }).observe(slides[0]);
</script>
```

---

## Shape 5 — Design reference

**Use when** the content is a design system: tokens, palette swatches, type scale, component contact sheets.

**Mandatory elements**: swatch grids with hex values shown, a type-scale ladder with real specimens, a spacing scale, sectioned by category (color → typography → spacing → components), copy-to-clipboard on hover for any token.

### Skeleton

```html
<main class="dsr">
  <header>
    <h1>Acme Design Reference</h1>
    <p class="sub">Auto-generated from <code>tokens.json</code> · v3.2</p>
  </header>

  <section>
    <h2>Color</h2><hr class="rule">
    <div class="swatch-group">
      <p class="swatch-group-label">Brand</p>
      <div class="swatch-grid">
        <button class="swatch" data-copy="#D97757">
          <span class="chip" style="background:#D97757"></span>
          <span class="swatch-name">Clay</span>
          <span class="swatch-hex">#D97757</span>
        </button>
        <!-- … repeat per token -->
      </div>
    </div>
  </section>

  <section>
    <h2>Type scale</h2><hr class="rule">
    <ol class="type-ladder">
      <li><span class="rung" style="font-size:64px">Display 64</span></li>
      <li><span class="rung" style="font-size:40px">H1 40</span></li>
      <li><span class="rung" style="font-size:24px">H2 24</span></li>
      <li><span class="rung" style="font-size:16px">Body 16</span></li>
    </ol>
  </section>
</main>
```

### Shape-specific styles

```css
.dsr { max-width: 980px; margin: 0 auto; }
.rule { border: none; border-top: 1px solid var(--g300); margin: 0 0 28px; }
.swatch-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(96px, 1fr)); gap: 16px; }
.swatch { all: unset; cursor: pointer; display: flex; flex-direction: column; gap: 6px; }
.chip { display: block; height: 64px; border-radius: 8px; border: 1.5px solid rgba(0,0,0,0.06); }
.swatch-name { font-size: 12px; }
.swatch-hex  { font-family: var(--mono); font-size: 11px; color: var(--g500); }
.type-ladder { list-style: none; padding: 0; display: flex; flex-direction: column; gap: 8px; }
```

### Mandatory JS — copy-on-click

```html
<script>
  document.querySelectorAll('[data-copy]').forEach((el) => {
    el.addEventListener('click', async () => {
      await navigator.clipboard.writeText(el.dataset.copy);
      el.classList.add('copied');
      setTimeout(() => el.classList.remove('copied'), 900);
    });
  });
</script>
```

---

## Shape 6 — Diagram sheet

**Use when** the content is shape-of-the-system: a flowchart, a module map, a sequence of arrows, a set of figures for a blog post.

**Mandatory elements**: every diagram is **inline SVG** (no Mermaid runtime, no raster images), each node is a real `<g>` with class names you can target from CSS, the hot path or critical step is highlighted with `--clay`, captions sit below each figure not floating beside it.

**Sizing rule for boxed text** — a `<rect>` has no auto-padding for the text positioned over it; they're independent shapes. Size each box so:

- `width ≥ longest_text_pixels + 32` (16 px of optical padding on each side)
- `height ≥ total_text_height + 24` for a two-line stack (title + subtitle)

Rough char widths to estimate from: **mono 11 px ≈ 6.5 px/char**, **sans 14 px ≈ 7 px/char**, **serif 16 px ≈ 9 px/char**. Example: a subtitle "palette · type · grid" in mono 11 px is ~150 px wide, so the rect must be at least 182 px wide. When in doubt, widen the box rather than shrink the text.

### Skeleton — single flowchart

```html
<main class="diagrams">
  <header>
    <h1>Deploy pipeline</h1>
    <p class="lead">From <code>git push</code> to live traffic in roughly seven minutes.</p>
  </header>

  <figure class="diagram">
    <svg viewBox="0 0 720 240" role="img" aria-labelledby="dp-title">
      <title id="dp-title">Deploy pipeline flowchart</title>
      <!-- Stage box -->
      <g class="stage" data-stage="lint" transform="translate(20,80)">
        <rect width="120" height="80" rx="10" fill="var(--paper)" stroke="var(--g300)" stroke-width="1.5"/>
        <text x="60" y="44" text-anchor="middle" font-family="var(--sans)" font-size="14">Lint</text>
      </g>
      <!-- Arrow -->
      <line x1="140" y1="120" x2="180" y2="120" stroke="var(--g500)" stroke-width="1.5" marker-end="url(#arrow)"/>
      <!-- Highlighted hot path stage -->
      <g class="stage hot" data-stage="deploy" transform="translate(500,80)">
        <rect width="120" height="80" rx="10" fill="var(--clay)" stroke="var(--clay-d)"/>
        <text x="60" y="44" text-anchor="middle" fill="var(--ivory)" font-size="14">Deploy</text>
      </g>
      <defs>
        <marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="8" markerHeight="8" orient="auto">
          <path d="M0,0 L10,5 L0,10 z" fill="var(--g500)"/>
        </marker>
      </defs>
    </svg>
    <figcaption>Stages run sequentially. The <span class="hot-text">deploy</span> stage is the only one that touches prod.</figcaption>
  </figure>
</main>
```

### Shape-specific styles

```css
.diagrams { max-width: 980px; margin: 0 auto; }
.diagram { margin: 32px 0; }
.diagram svg { width: 100%; height: auto; }
figcaption { font-size: 14px; color: var(--g500); margin-top: 12px; max-width: 640px; }
.hot-text { color: var(--clay); font-weight: 500; }
.stage rect { transition: stroke-width 120ms; }
.stage:hover rect { stroke-width: 2.5; }
```

### Multi-figure sheet variant

Wrap each figure in `<figure>` and stack them; one diagram per logical chunk. Add a small left rail with anchor links (`#fig-1`, `#fig-2`) so the reader can jump.

---

## Shape 7 — Writeup

**Use when** the content is a PR description, an RFC, an implementation plan, or any "for reviewers" doc.

**Mandatory elements**: a "What and why" header, a "Before / After" pair (text, screenshot, or both), a per-file tour of the change, a risks table, a "Where to focus the review" callout box.

### Skeleton

```html
<main class="writeup">
  <header>
    <p class="eyebrow">PR #1248 · 3 files · +124 / -56</p>
    <h1>Replace cron-based reindexer with stream consumer</h1>
    <p class="lead">Drops indexer p99 latency from 9 minutes to 12 seconds and removes the nightly Pagerduty page.</p>
  </header>

  <section class="ba">
    <div class="ba-pane">
      <h3>Before</h3>
      <ul>
        <li>Cron job triggers once an hour</li>
        <li>Full table scan, ~9m</li>
        <li>Stale data for up to 60m</li>
      </ul>
    </div>
    <div class="ba-pane after">
      <h3>After</h3>
      <ul>
        <li>Stream consumer reads CDC events</li>
        <li>~12s end-to-end</li>
        <li>Stale data ≤ 30s</li>
      </ul>
    </div>
  </section>

  <section>
    <h2>File-by-file tour</h2>
    <details open><summary><code>indexer/consumer.ts</code> — new entry point</summary><p>…</p></details>
    <details><summary><code>indexer/cron.ts</code> — deleted</summary><p>…</p></details>
  </section>

  <section>
    <h2>Risks</h2>
    <table class="risks">
      <thead><tr><th>Risk</th><th>Likelihood</th><th>Mitigation</th></tr></thead>
      <tbody>
        <tr><td>Backfill misses events</td><td>Low</td><td>Replay tool tested in staging</td></tr>
      </tbody>
    </table>
  </section>

  <aside class="focus">
    <p class="focus-label">Reviewer focus</p>
    <p><code>consumer.ts</code> error handling and offset commit ordering. Everything else is mechanical.</p>
  </aside>
</main>
```

### Shape-specific styles

```css
.writeup { max-width: 860px; margin: 0 auto; }
.ba { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin: 32px 0; }
@media (max-width: 720px) { .ba { grid-template-columns: 1fr; } }
.ba-pane { border: 1.5px solid var(--g300); border-radius: 12px; padding: 20px; background: var(--paper); }
.ba-pane.after { border-color: var(--olive); }
.ba-pane h3 { font-family: var(--mono); font-size: 11px; text-transform: uppercase;
  letter-spacing: 0.08em; color: var(--g500); margin-bottom: 8px; }
.ba-pane.after h3 { color: var(--olive); }
details { border-bottom: 1px solid var(--g200); padding: 12px 0; }
details summary { cursor: pointer; font-family: var(--mono); font-size: 13px; }
.risks { width: 100%; border-collapse: collapse; }
.risks th, .risks td { text-align: left; padding: 10px 8px; border-bottom: 1px solid var(--g200); font-size: 14px; }
.risks th { font-family: var(--mono); font-size: 11px; text-transform: uppercase; color: var(--g500); }
.focus { background: var(--g100); border-left: 3px solid var(--clay); padding: 16px 20px; border-radius: 6px; margin-top: 32px; }
.focus-label { font-family: var(--mono); font-size: 11px; text-transform: uppercase;
  letter-spacing: 0.08em; color: var(--clay); margin-bottom: 6px; }
```

### Implementation-plan variant

Replace the Before/After block with a milestones timeline: an ordered list of milestones with target dates, each as a card with a status pill. Add an inline data-flow diagram (Shape 6 styling) and the risks table.

---

## Shape 8 — Interactive editor

**Use when** the user wants to manipulate something and walk away with the result: triage board, feature-flag toggler, prompt template editor, ranking sheet.

**Mandatory elements**: a sticky top toolbar with a clearly-labelled **Export** / **Copy** button, the actual editor surface in the middle, a "live preview" or "what you'll copy" pane on the side (or below on mobile), keyboard hints in the mono font.

**The export button is non-negotiable.** Every editor must close the loop: take whatever the user did in the UI and produce a string they can paste back into chat, into a doc, or into source.

### Skeleton — drag-to-rank triage board

```html
<header>
  <p class="eyebrow">Editor · drag to rank, then export</p>
  <h1>Triage · 12 tickets</h1>
  <p class="sub">Drag items between columns. Tab + Space also works.</p>
</header>

<nav class="toolbar">
  <span class="hint">⌘+C exports current ordering as markdown</span>
  <span class="spacer"></span>
  <button class="btn-ghost" id="reset">Reset</button>
  <button class="btn-primary" id="export">Copy as markdown</button>
</nav>

<main class="board">
  <section class="col" data-bucket="now">
    <h3>Now</h3>
    <ul class="dropzone" data-bucket="now">
      <li class="card" draggable="true" data-id="t-101">Fix flaky CI</li>
    </ul>
  </section>
  <section class="col" data-bucket="next"><h3>Next</h3><ul class="dropzone" data-bucket="next"></ul></section>
  <section class="col" data-bucket="later"><h3>Later</h3><ul class="dropzone" data-bucket="later"></ul></section>
  <section class="col" data-bucket="cut"><h3>Cut</h3><ul class="dropzone" data-bucket="cut"></ul></section>
</main>
```

### Shape-specific styles

```css
body { padding: 0; }
header { padding: 48px 32px 16px; max-width: 1180px; margin: 0 auto; }
.toolbar { position: sticky; top: 0; z-index: 10; display: flex; align-items: center;
  gap: 10px; background: var(--ivory); padding: 10px 32px 14px;
  border-bottom: 1px solid var(--g200); }
.toolbar .spacer { flex: 1; }
.hint { font-family: var(--mono); font-size: 11px; color: var(--g500); }
.btn-primary { background: var(--slate); color: var(--ivory); border: 1.5px solid var(--slate);
  border-radius: 999px; padding: 9px 16px; font-family: var(--mono); font-size: 12px; cursor: pointer; }
.btn-primary.copied { background: var(--olive); border-color: var(--olive); }
.btn-ghost { background: transparent; color: var(--g700); border: 1.5px solid var(--g300);
  border-radius: 999px; padding: 9px 16px; font-family: var(--mono); font-size: 12px; cursor: pointer; }
.board { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; padding: 24px 32px; max-width: 1180px; margin: 0 auto; }
@media (max-width: 880px) { .board { grid-template-columns: 1fr 1fr; } }
.col h3 { font-family: var(--mono); font-size: 11px; text-transform: uppercase;
  letter-spacing: 0.08em; color: var(--g500); margin-bottom: 10px; }
.dropzone { list-style: none; padding: 8px; min-height: 200px;
  border: 1.5px dashed var(--g300); border-radius: 12px; background: var(--paper); }
.dropzone.over { border-color: var(--sky); background: #fafcff; }
.card { border: 1.5px solid var(--g300); border-radius: 8px; padding: 10px 12px;
  margin-bottom: 8px; background: var(--paper); cursor: grab; font-size: 14px; }
.card:active { cursor: grabbing; }
.card.dragging { opacity: 0.4; }
```

### Mandatory JS — drag, drop, export

```html
<script>
  // Drag-and-drop on each card; the drop-zone wraps its bucket.
  let dragged = null;
  document.querySelectorAll('.card').forEach((card) => {
    card.addEventListener('dragstart', () => { dragged = card; card.classList.add('dragging'); });
    card.addEventListener('dragend',   () => { card.classList.remove('dragging'); dragged = null; });
  });
  document.querySelectorAll('.dropzone').forEach((zone) => {
    zone.addEventListener('dragover',  (e) => { e.preventDefault(); zone.classList.add('over'); });
    zone.addEventListener('dragleave', ()  =>  zone.classList.remove('over'));
    zone.addEventListener('drop',      (e) => {
      e.preventDefault();
      zone.classList.remove('over');
      if (dragged) zone.appendChild(dragged);
    });
  });

  // Export — turn the live DOM into a markdown checklist the user can paste anywhere.
  document.getElementById('export').addEventListener('click', async () => {
    const lines = [];
    document.querySelectorAll('.col').forEach((col) => {
      lines.push(`## ${col.querySelector('h3').textContent.trim()}`);
      col.querySelectorAll('.card').forEach((c) => lines.push(`- ${c.textContent.trim()}`));
      lines.push('');
    });
    await navigator.clipboard.writeText(lines.join('\n'));
    const btn = document.getElementById('export');
    btn.classList.add('copied');
    btn.textContent = 'Copied';
    setTimeout(() => { btn.classList.remove('copied'); btn.textContent = 'Copy as markdown'; }, 1200);
  });
</script>
```

### Other editor variants

- **Feature-flag editor** — checkboxes grouped by area; track changed keys vs original; "Copy diff" button outputs `{ key: value }` JSON for only the changed flags.
- **Prompt tuner** — left pane has `<textarea>` with variable slots highlighted; right pane re-renders preview on every `input` event; copy button outputs the filled template.

---

## Shape 9 — Code review

**Use when** the content is an annotated diff: somebody (the agent or a reviewer) walking through code changes line by line.

**Mandatory elements**: a unified or split diff view, line numbers in a gutter, margin notes attached to specific lines (anchored, scrollable), severity tags (`nit` / `suggestion` / `must-fix`), a jump-to-comment index at the top.

### Skeleton (unified diff)

```html
<main class="review">
  <header>
    <p class="eyebrow">Review · 3 comments</p>
    <h1>auth/middleware.ts</h1>
    <nav class="jumps">
      <a href="#c1">L24 · must-fix</a>
      <a href="#c2">L37 · suggestion</a>
      <a href="#c3">L51 · nit</a>
    </nav>
  </header>

  <section class="diff">
    <ol class="lines">
      <li class="ctx"><span class="ln">22</span><code>  if (!token) return null;</code></li>
      <li class="add"><span class="ln">23</span><code>+  const decoded = verify(token);</code></li>
      <li class="add hot" id="c1"><span class="ln">24</span><code>+  return decoded.user;</code>
        <aside class="note must-fix">
          <p class="sev">must-fix</p>
          <p><code>verify()</code> can throw — wrap in try/catch and return <code>null</code> on failure.</p>
        </aside>
      </li>
    </ol>
  </section>
</main>
```

### Shape-specific styles

```css
.review { max-width: 1080px; margin: 0 auto; }
.jumps { display: flex; gap: 16px; margin-top: 12px; }
.jumps a { font-family: var(--mono); font-size: 12px; color: var(--clay); text-decoration: none; }
.diff { background: var(--paper); border: 1.5px solid var(--g300); border-radius: 12px; overflow: hidden; }
.lines { list-style: none; padding: 0; margin: 0; font-family: var(--mono); font-size: 13px; }
.lines li { display: grid; grid-template-columns: 48px 1fr; align-items: start; }
.ln { color: var(--g500); padding: 4px 12px; text-align: right; background: var(--g100); }
.lines code { padding: 4px 16px; white-space: pre; }
.lines li.add { background: #f1f7ee; }
.lines li.del { background: #fbeeec; }
.lines li.hot { background: #fff3ed; }
.note { grid-column: 2; margin: 8px 16px 12px; padding: 10px 14px;
  border-radius: 8px; border: 1.5px solid var(--g300); background: var(--paper); }
.sev { font-family: var(--mono); font-size: 11px; text-transform: uppercase;
  letter-spacing: 0.08em; margin-bottom: 6px; }
.note.must-fix { border-color: var(--rust); }
.note.must-fix .sev { color: var(--rust); }
.note.suggestion .sev { color: var(--clay); }
.note.nit .sev { color: var(--g500); }
```

---

## Shape 10 — Dashboard

**Use when** the content is at-a-glance health: KPIs, status pills, small sparklines, alert counts.

**Mandatory elements**: 3–8 stat cards above the fold, one inline-SVG sparkline per metric, a clearly-coloured status pill per row, a "last refreshed at" timestamp.

### Skeleton

```html
<main class="dash">
  <header>
    <h1>Order pipeline · live</h1>
    <p class="sub">Updated <time>2 minutes ago</time></p>
  </header>

  <section class="kpis">
    <article class="kpi">
      <p class="kpi-label">Orders / min</p>
      <p class="kpi-num">142</p>
      <svg class="spark" viewBox="0 0 120 28">
        <polyline points="0,20 20,18 40,12 60,16 80,8 100,11 120,4"
          fill="none" stroke="var(--olive)" stroke-width="1.5"/>
      </svg>
    </article>
    <article class="kpi">…</article>
    <article class="kpi">…</article>
  </section>

  <section class="alerts">
    <h2>Active alerts</h2>
    <ul class="alert-list">
      <li><span class="pill rust">page</span> Stripe webhooks 5xx · 12m ago</li>
      <li><span class="pill clay">warn</span> Index lag &gt; 30s · 4m ago</li>
    </ul>
  </section>
</main>
```

### Shape-specific styles

```css
.dash { max-width: 1180px; margin: 0 auto; }
.kpis { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin: 32px 0; }
.kpi { border: 1.5px solid var(--g300); border-radius: 12px; padding: 20px; background: var(--paper); }
.kpi-label { font-family: var(--mono); font-size: 11px; text-transform: uppercase;
  letter-spacing: 0.08em; color: var(--g500); margin-bottom: 8px; }
.kpi-num { font-family: var(--serif); font-size: 40px; font-weight: 500; letter-spacing: -0.02em; }
.spark { width: 100%; height: 28px; margin-top: 8px; }
.alert-list { list-style: none; padding: 0; }
.alert-list li { display: flex; align-items: center; gap: 12px; padding: 10px 0;
  border-bottom: 1px solid var(--g200); }
.pill { font-family: var(--mono); font-size: 10px; text-transform: uppercase;
  letter-spacing: 0.08em; padding: 3px 8px; border-radius: 999px; color: var(--paper); }
.pill.rust { background: var(--rust); }
.pill.clay { background: var(--clay); }
.pill.olive { background: var(--olive); }
```

---

## When in doubt

- The shape isn't obvious → default to **explainer**. Most content rendered as HTML is fundamentally "let me show you a thing."
- The user said "make me a doc" with no shape hint → ask one clarifying question: "Is this for reading, presenting, or doing?" Their answer maps to explainer / slide deck / interactive editor.
- The content fights two shapes → embed the secondary inside the primary. A weekly report (Shape 3) can contain an incident sub-section that uses Shape 6 inline SVG. Don't split into two files.

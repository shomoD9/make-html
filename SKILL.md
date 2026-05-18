---
name: make-html
description: Generate a single-file, aesthetically excellent HTML document from any source content (a URL, a markdown doc, a chat thread, a code file, a spec, a Notion page, a tweet, a JSON blob). Analyses the content, picks an appropriate document shape from the gallery (explainer, comparison, report, slide deck, design system, flowchart, interactive editor, PR writeup, status report, concept explainer), and writes a self-contained `.html` file with consistent editorial design. ONLY use when the user explicitly invokes via `/make-html`, names this skill, or asks "make an HTML for…", "render this as HTML", "turn this into an HTML doc". Never auto-trigger.
disable-model-invocation: true
---

# Make HTML

This skill turns any content the user points at into a **single self-contained `.html` file** that renders the information in the way it actually wants to be read — boxes and arrows for a system, side-by-side panels for a comparison, scroll-snapped pages for a deck, a draggable editor when the user needs to manipulate something. Markdown flattens spatial information; this skill un-flattens it.

It is invoked **only** when the user explicitly says so. Slash-command (`/make-html`), by name, or via a clear "make an HTML for …" request. Do not auto-trigger on ambient content.

The aesthetic target is the **editorial / Reading Room** look popularised by Anthropic's docs and the html-effectiveness gallery: serif headlines, mono eyebrows, an ivory page, a single clay accent. Every output should be visually coherent with that family even when the *shape* of the document changes.

## Hard rules

These are non-negotiable. If the output violates any of them, it is broken.

- **One file out.** A single `.html` file. No external CSS or JS files, no build step, no framework runtime. Inline everything in `<style>` and `<script>`.
- **Works offline.** No CDN React / Vue / Tailwind / jQuery. No analytics, no tracking, no external API calls. Optional `<link>` to Google Fonts is the only allowed network request, and only when the design genuinely needs a custom display face.
- **System-font default.** Prefer `ui-serif`, `system-ui`, and `ui-monospace` — they render instantly, look native, and never trigger FOUT. Only reach for Google Fonts when the brief explicitly asks for a specific typeface.
- **Vanilla JS only.** Native DOM APIs. No `import` statements, no bundler-specific syntax. Code must run as-is when the file is double-clicked from Finder.
- **Mobile-responsive.** Layout must remain usable at 375 px wide. Use `clamp()`, CSS grid `auto-fit`, and `@media` queries — not fixed pixel widths on the body.
- **Semantic HTML.** Real `<header>`, `<main>`, `<section>`, `<article>`, `<aside>`, `<nav>`, `<footer>`. Tables for tabular data; lists for lists. Tooling and screen readers depend on this; so does your own future self when you re-read the source.
- **Filename is kebab-case + topic.** `q3-roadmap.html`, `consistent-hashing-explainer.html`, `auth-pr-writeup.html`. Default location is the current working directory unless the user names one. Never write to the user's home or to `/tmp` unless asked.
- **Dark-mode toggle ships by default.** Every output includes a small toggle button (top-right of viewport), a complete dark palette mirroring the light tokens, and a pre-FOUC `<head>` script that respects the user's `prefers-color-scheme` on first visit and persists their choice via `localStorage`. The toggle is non-optional — even a one-page report gets it. See Step 4 for the palette + toggle component, Step 6 for placement.

## Workflow

### Step 1 — Get the source

**Default behaviour — bare invocation = render the last assistant message.** When the user invokes `/make-html` (or just types it as a standalone message) with no further content, no link, and no instruction, the source is **the assistant's most recent message in the conversation**. Do not ask "what content?" — assume the user wants the answer they just received turned into an HTML doc. This is the single most common invocation pattern: the user reads (or skims, or skips) a long reply, decides they'd rather look at it than read it, and types `/make-html`. Honour that default silently.

The same rule applies when the user adds a short directive without source ("/make-html — explain it to me", "render this as a deck") — the directive shapes the *style* (it might hint at the shape or the tone) but the source is still the prior message unless they point elsewhere.

Other ways a source can arrive:

- **A URL** → fetch it (WebFetch tool) and read the rendered content.
- **A file path / @-mention** → read it (markdown, code, JSON, anything text).
- **A pasted chat thread, doc, or block of text** → use it verbatim.
- **A vague topic with no source AND no prior context** ("make an HTML about Kafka consumer groups" in a brand-new chat) → only then ask the user what specific source to pull from. Do **not** hallucinate facts into the document. The skill renders information; it does not invent it.

If the source is large (a long doc, a sprawling repo, a 4000-word reply), summarise it in your own working memory first. The HTML is the artifact, not a verbatim reprint.

### Step 2 — Pick a document shape

The shape is the single biggest decision. It determines layout, navigation, and which interactive elements you need.

| Shape | Use when the content is… | Signal phrases from the user |
| --- | --- | --- |
| **explainer** | A concept, system, or feature that needs to be taught | "explain", "how does … work", "teach", "deep dive" |
| **comparison** | Two or more options (libraries, designs, approaches) | "compare", "vs", "trade-offs", "which should I pick" |
| **report** | A weekly status, incident post-mortem, or recap | "status", "weekly", "post-mortem", "summarise the week" |
| **slide deck** | Content to present, one idea per page | "slides", "deck", "present", "walk through" |
| **design reference** | Tokens, components, swatches, contact sheets | "design system", "tokens", "swatches", "components" |
| **diagram sheet** | Boxes-and-arrows, flowcharts, SVG figures | "flowchart", "diagram", "pipeline", "draw" |
| **writeup** | A PR description, implementation plan, RFC | "writeup", "plan", "RFC", "for reviewers" |
| **interactive editor** | The user needs to do something and export the result | "let me drag", "let me tweak", "give me an editor", "I'll re-order" |
| **code review** | An annotated diff with margin notes | "review this diff", "annotate this PR" |
| **dashboard** | At-a-glance KPIs, small charts, status pills | "dashboard", "KPIs", "at a glance" |
| **rich-explainer** | A concept deep-dive whose content has multiple shapes inside it (process + comparison + timeline + decisions + code + design) and would lose information if forced into prose-only explainer. Embeds mini-versions of other shapes as section patterns. | "rich explainer", "visual explainer", "fully visual", "make this visual", "show me don't just tell me" |

Full templates and rules for each live in [shapes.md](shapes.md). **Read shapes.md before writing the file** — it has paste-ready scaffolding for every shape above.

If the content fits two shapes (e.g. an incident report with a flowchart inside it), pick the dominant shape and embed the other as a section. Don't try to be every shape at once.

### Step 3 — Pick a viewing context

The shape implies a default, but the user may override:

- **Long-scroll** (default for: explainer, report, writeup, code review, dashboard) — one page, vertical reading.
- **Slide-snapped** (default for: slide deck) — `scroll-snap-type: y mandatory`, full-viewport pages, arrow-key navigation.
- **Print-ready** (default for: incident report, status report when it's going to a PDF) — add `@media print` rules, control `page-break-inside`.
- **App-like** (default for: interactive editor) — sticky toolbar, fixed sidebar, the body doesn't scroll.

Pick one and commit. Don't bolt scroll-snap onto a report or print rules onto a draggable editor.

### Step 4 — Apply the design system

Every shape uses the same tokens. This is what makes the family coherent.

#### Palette (CSS variables — copy verbatim)

```css
:root {
  --ivory:  #FAF9F5;
  --paper:  #FFFFFF;
  --slate:  #141413;
  --clay:   #D97757;
  --clay-d: #B85C3E;
  --oat:    #E3DACC;
  --olive:  #788C5D;
  --rust:   #B04A3F;
  --sky:    #6A8CAF;
  --g100:   #F0EEE6;
  --g200:   #E6E3DA;
  --g300:   #D1CFC5;
  --g500:   #87867F;
  --g700:   #3D3D3A;
}
```

Roles: `--ivory` is the page background. `--slate` is primary text. `--clay` is the one accent — eyebrows, links, key numbers, the underline under the active tab. `--olive` for positive status (shipped, passed, healthy). `--rust` for negative (broke, failed, regressed). `--sky` for "interactive / clickable / draggable" affordances in editors. The grays are scale, lightest to darkest. Use `--oat` for soft chips / tags / inert backgrounds.

#### Dark palette (every token, mirrored)

The dark variants live under `[data-theme="dark"]` on `:root`. The rest of the stylesheet references `var(--*)` and switches automatically. **Do not write `@media (prefers-color-scheme: dark)` rules** — the data-theme attribute is what the toggle flips, and a media query would fight it. The pre-FOUC script in Step 6 honours `prefers-color-scheme` once, on first visit, then hands control to the toggle.

```css
:root[data-theme="dark"] {
  --ivory:  #1A1815;   /* warm dark page bg — NOT pure black */
  --paper:  #242220;   /* lifted card surface */
  --slate:  #F4EFE6;   /* warm cream body text */
  --clay:   #E58B6F;   /* brightened terracotta, same hue family */
  --clay-d: #C6705A;
  --oat:    #3A332A;   /* inert beige in dark */
  --olive:  #9DB082;   /* brightened positive status */
  --rust:   #D26C5F;   /* brightened negative status */
  --sky:    #95B4D1;   /* brightened interactive blue */
  --g100:   #26241F;
  --g200:   #2F2C27;
  --g300:   #3D3A33;   /* borders, dimmer in dark */
  --g500:   #908E85;
  --g700:   #C7C4BA;   /* body-text gray in dark */
}
```

Two things that matter aesthetically:

- **Warm dark, not pure black.** `#1A1815` mirrors the warm `#FAF9F5` ivory of the light palette — it reads as "evening reading lamp", not "void". Pure `#000` against warm editorial type looks like a bug.
- **Shadows don't translate.** Skip `box-shadow` in dark mode — a shadow can't be darker than the background it sits on. If a hero element needs lift in dark mode, use a slightly brighter border (`var(--g500)` instead of `var(--g300)`) instead.

#### Theme toggle (paste verbatim)

A fixed pill in the top-right of the viewport. Moon icon visible in light mode (suggests "go dark"), sun icon visible in dark mode (suggests "go light"). The button uses `currentColor` so the icon inherits the theme's text color automatically.

HTML — directly after the opening `<body>` tag, so it stays above all content:

```html
<button class="theme-toggle" type="button" aria-label="Toggle dark mode" title="Toggle dark mode">
  <svg class="i-moon" width="16" height="16" viewBox="0 0 16 16" fill="none" aria-hidden="true">
    <path d="M14 8.5A6 6 0 1 1 7.5 2a4.5 4.5 0 0 0 6.5 6.5z" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round"/>
  </svg>
  <svg class="i-sun" width="16" height="16" viewBox="0 0 16 16" fill="none" aria-hidden="true">
    <circle cx="8" cy="8" r="3" stroke="currentColor" stroke-width="1.5"/>
    <path d="M8 1.5v2M8 12.5v2M1.5 8h2M12.5 8h2M3.4 3.4l1.4 1.4M11.2 11.2l1.4 1.4M3.4 12.6l1.4-1.4M11.2 4.8l1.4-1.4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
  </svg>
</button>
```

CSS — in the components section of your `<style>`:

```css
.theme-toggle {
  position: fixed;
  top: 20px;
  right: 20px;
  z-index: 100;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--paper);
  color: var(--g700);
  border: 1.5px solid var(--g300);
  border-radius: 999px;
  cursor: pointer;
  transition: background 140ms ease, color 140ms ease, border-color 140ms ease;
}
.theme-toggle:hover { color: var(--clay); border-color: var(--clay); }
.theme-toggle .i-sun  { display: none; }
.theme-toggle .i-moon { display: inline-block; }
:root[data-theme="dark"] .theme-toggle .i-moon { display: none; }
:root[data-theme="dark"] .theme-toggle .i-sun  { display: inline-block; }
```

The handler script and the FOUC-prevention script both live in Step 6 (placement matters).

#### Type stacks (copy verbatim)

```css
:root {
  --serif: ui-serif, Georgia, "Times New Roman", Times, serif;
  --sans:  system-ui, -apple-system, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
  --mono:  ui-monospace, "SF Mono", Menlo, Monaco, Consolas, monospace;
}
```

#### Type scale and weight

- **Headlines**: `var(--serif)`, weight **500** (not 700, not 800 — the lightness is the whole point of the look), tight letter-spacing `-0.01em` to `-0.018em`. Sizes: hero `clamp(38px, 5.4vw, 62px)`, h2 `clamp(28px, 3.8vw, 38px)`, h3 22–26 px.
- **Body**: `var(--sans)`, 14–17 px, line-height **1.55–1.65**, color `var(--g700)` for long-form, `var(--slate)` for tight blocks.
- **Eyebrows / labels / pills**: `var(--mono)`, 11–12 px, `text-transform: uppercase`, `letter-spacing: 0.08em–0.12em`, color `var(--g500)`.
- **Code**: `var(--mono)`, 13 px, optional 1 × 5 px padding + `var(--g100)` background for inline; full panels get a 12 px radius and a 1.5 px `var(--g300)` border.

#### Layout

- **Container max-width**: 720 px (narrow explainer / single-column reading), 860–980 px (most reports / writeups), 1100–1180 px (anything with a sidebar or grid).
- **Page padding**: `56px 24px 96px` on the body (top, sides, bottom). Generous bottom keeps the last block from kissing the viewport edge.
- **Radius**: panels 10–14 px, rows / chips 6–8 px, buttons that should feel like actions 999 px (pill).
- **Border**: `1.5px solid var(--g300)`. The half-pixel-but-not-quite gives the editorial feel; pure 1 px reads as web-ui, pure 2 px reads as kindergarten.
- **Box-shadow** is rare. Use it once, on the hero element, to lift it off the page (e.g. `0 12px 32px rgba(20,20,19,.10)`). Everywhere else, rely on borders.

#### Aesthetic commitment

Pick **one** and hold it across the whole document. Don't mix.

- **Editorial** (default) — serif headlines, generous whitespace, one accent, paper feel. The Reading Room.
- **Documentation** — sans throughout, denser, sticky TOC, code panels everywhere. Think Stripe docs.
- **Brutalist** — mono everywhere, hard rules, no radius, single accent at full saturation. For internal tools and dashboards.
- **Soft / pastel** — `--oat` and `--olive` become primary, `--clay` muted, serif italics, more rounded. For warm/personal content.

When in doubt, **default to editorial**. It is the canonical look of the gallery the user pointed at.

### Step 5 — Apply shape-specific structure

Open [shapes.md](shapes.md), find the section that matches the shape from Step 2, and follow its skeleton. Each shape entry includes:
- The DOM skeleton it expects.
- Shape-specific layout rules (e.g. slide decks need full-viewport pages; editors need a sticky toolbar with an export button).
- Interactive behaviours that are mandatory (e.g. every editor must have a copy-to-clipboard export).

Do not skip this read. The shape rules are why two HTML files from this skill *feel* like they came from the same place even though one is a flowchart and the other is a prompt-tuner.

### Step 6 — Write the HTML

Structure of every file:

```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><Page title — same as the H1></title>

  <!-- FOUC-prevention: set data-theme BEFORE the stylesheet parses,
       so dark-mode users don't see a flash of light theme on first paint.
       Must live in <head> before <style>, must be synchronous. -->
  <script>
    (function () {
      var saved = localStorage.getItem('theme');
      var prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      if (saved === 'dark' || (!saved && prefersDark)) {
        document.documentElement.setAttribute('data-theme', 'dark');
      }
    })();
  </script>

  <style>
    /* 1. Tokens (light :root + dark :root[data-theme="dark"] from Step 4) */
    /* 2. Reset + base body styles */
    /* 3. Theme toggle component (from Step 4) */
    /* 4. Shape-specific styles (from shapes.md) */
    /* 5. Print rules (if shape is a report) */
  </style>
</head>
<body>
  <!-- Theme toggle — fixed top-right, present on every page (from Step 4). -->
  <button class="theme-toggle" type="button" aria-label="Toggle dark mode">...</button>

  <!-- Semantic structure for this shape (from shapes.md) -->

  <script>
    /* Theme toggle handler — flip data-theme and persist the choice. */
    document.querySelector('.theme-toggle').addEventListener('click', function () {
      var html = document.documentElement;
      var next = html.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
      html.setAttribute('data-theme', next);
      localStorage.setItem('theme', next);
    });

    /* Plus any other JS the shape strictly needs. No utility libs. */
  </script>
</body>
</html>
```

**Inline `<style>` ordering matters.** Tokens → reset → typography → layout → components → state (e.g. `.active`, `:hover`). Future edits land in the right section.

**Comment generously in the source.** Block-comment each section (`/* ── Header ─── */`) so the user can read the file and learn from it. This is a teaching artifact as much as a rendered artifact.

### Step 7 — Self-review checklist

Before declaring done, run through:

- [ ] File opens in a browser by double-click. No console errors. No 404s on assets.
- [ ] Renders correctly at 375 px (mobile), 768 px (tablet), 1280 px (desktop).
- [ ] The page title (`<title>`) matches the H1.
- [ ] One coherent palette throughout. Only one accent colour is doing accent work.
- [ ] One aesthetic commitment. No mixing brutalist with soft pastel.
- [ ] Eyebrows / labels are mono uppercase; headlines are serif weight 500.
- [ ] Container has a max-width. Body doesn't scroll horizontally.
- [ ] Every interactive editor has a visible **Export** / **Copy** button that surfaces the user's edits as text.
- [ ] Every diagram is **inline SVG** (no raster screenshots, no Mermaid runtime).
- [ ] Slide decks: arrow keys navigate; Esc / `F` toggles fullscreen if play mode is wanted.
- [ ] Reports going to print: `@media print` removes nav, sets `body { background: white }`, controls `page-break-inside: avoid` on cards.
- [ ] The source HTML is readable — section comments, semantic tags, no minified blobs.
- [ ] No external dependencies other than (optionally) one Google Fonts request.
- [ ] Dark mode toggle is visible in top-right; clicking switches the palette; reloading the page preserves the choice; `prefers-color-scheme: dark` is honoured on first visit; no flash of light theme before the toggle's correct state appears.
- [ ] No hardcoded hex colors in content — every fill/stroke/color references a `var(--*)` token so it switches with theme. Inline SVG included: use `style="fill: var(--paper); stroke: var(--g300);"` or `currentColor`, not raw `<rect fill="#FFFFFF">`.

### Step 8 — Hand off

Tell the user:
- The full path of the file you wrote.
- The shape you picked and why (one sentence).
- One concrete invitation for them to act: "open it in a browser", "drag it into Cursor", "copy the URL into a slack message". Don't open the browser yourself unless asked.

## Anti-patterns

These show up constantly in agent-generated HTML and ruin the artifact. Avoid them.

- **Tailwind / Bootstrap class soup.** This skill does not ship CDN frameworks. Style with the tokens above. If you find yourself writing `class="flex items-center gap-2 px-4 py-2 rounded-full bg-slate-900 text-white"` — stop. Write semantic class names (`class="toolbar"`) and put the rules in `<style>`.
- **React in a `<script type="module">` tag from a CDN.** Forbidden. The output must run with no network.
- **A wall of `<div>`s with `class="card"`.** Use `<article>`, `<section>`, `<aside>` for blocks of meaning. Tooling and assistive tech depend on it.
- **Inventing facts to fill a section.** If the source doesn't say it, don't write it. An honest blank panel ("No data — provide a value to populate") beats a fictional one.
- **Skipping the export button on an editor.** A draggable triage board with no "copy as markdown" output is a closed loop the user can't get back out of. Every editor ends with `navigator.clipboard.writeText(serialised)`.
- **A slide deck that scrolls instead of snaps.** If the shape is "deck", commit: `scroll-snap-type: y mandatory` + `.slide { height: 100vh; scroll-snap-align: start; }` + arrow-key handlers. Otherwise call it an explainer.
- **Mermaid / D3 / charting libraries.** Inline SVG with a `<g>` per element. The agent can write SVG; the runtime cost of a charting lib isn't worth it for a one-off artifact.
- **Three accent colours.** One. The eye should land on `--clay` and nowhere else.
- **Headline weight 700 / 800 / 900.** Weight 500 serif is the look. Heavier weights read as marketing landing page.
- **Body line-height under 1.5.** Long-form text needs air. 1.55–1.65 is the band.
- **Padding below 24 px on the body sides.** Content kissing the viewport edge reads as "the agent didn't try".
- **Emojis sprinkled for decoration.** Status pills can carry colour + label. Don't reach for emoji as visual noise.
- **Opening the browser, deploying to a server, or starting a dev server.** This skill writes a file. The user takes it from there.
- **Sticky / fixed panels that don't contain their own scroll.** When an aside has `position: sticky` (or `position: fixed`) and its content can exceed viewport height, the user loses access to the overflow — the page scrolls but the panel doesn't. Always pair sticky positioning with `max-height: calc(100vh - <top-and-bottom-breathing-room>)`, `overflow-y: auto`, and `overscroll-behavior: contain` (so when the panel reaches its scroll end, the page doesn't suddenly take over the scroll wheel). The principle: any bounded surface that holds overflowing content must scroll itself. Anything else is unreachable content.
- **SVG diagram nodes with text that hugs the rect edge.** A `<rect>` is a shape, not a container — it has no auto-padding for the `<text>` next to it. Size each box so `rect width ≥ longest_label_px + 32` (16 px of optical padding on each side). Rough character widths to estimate from: mono 11 px ≈ 6.5 px/char, serif 16 px ≈ 9 px/char, sans 14 px ≈ 7 px/char. When in doubt, widen the box rather than shrink the text. The same rule on the vertical axis: `rect height ≥ total_text_height + 24` for a two-line stack.
- **Pure black `#000` in dark mode.** Pure black against warm editorial type reads as a styling bug. Use a warm dark like `#1A1815` for the page background — it mirrors the warm ivory of the light palette and is the "evening reading lamp" companion to it.
- **Inverting colors with `filter: invert()`** or duplicating every rule under `@media (prefers-color-scheme: dark)`. Dark mode is a deliberate palette under `[data-theme="dark"]`, not a math operation and not a parallel stylesheet. Semantic tokens get their own dark values that preserve meaning — `--olive` is still "positive status" in both modes, just brightened for the new surface.
- **Hardcoded hex colors inside the doc body.** Every color must reference a `var(--*)` token, or the toggle won't move it. This includes inline SVG: CSS rules override SVG presentation attributes, so prefer `svg rect { fill: var(--paper); stroke: var(--g300); }` (or inline `style="fill: var(--paper);"`) over raw `<rect fill="#FFFFFF" stroke="#D1CFC5">`. The agent's tell that they forgot this: the diagram stays light when the rest of the page goes dark.

## Extending the skill

If the user asks for something the gallery doesn't cover (a new shape, a brand-specific theme, a different aesthetic), add the new pattern as a section in [shapes.md](shapes.md) with a paste-ready skeleton — the same way the existing shapes are documented. Do not invent new design tokens; reuse the palette above. A skill that drifts becomes a skill nobody trusts.

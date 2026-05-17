# make-html

`make-html` is an explicit-invocation agent skill for turning source material into a polished, self-contained HTML document.

It is designed for moments where markdown is too flat: explainers, reports, side-by-side comparisons, diagrams, slide-like documents, dashboards, code reviews, and small interactive editors.

## What It Does

- Reads a source: URL, markdown, chat answer, spec, docs, code, tweet thread, JSON, or pasted text.
- Chooses the right document shape instead of forcing everything into a single template.
- Writes one standalone `.html` file with inline CSS and vanilla JavaScript.
- Uses a warm editorial design system by default.
- Includes a dark-mode toggle on every generated page.
- Avoids external dependencies, CDNs, analytics, frameworks, and build steps.

## Repository Layout

```text
.
├── SKILL.md                  # Canonical skill instructions
├── shapes.md                 # Shape-specific templates and rules
├── install.sh                # Installs/syncs the skill across local agents
└── wrappers/
    ├── claude/SKILL.md       # Claude Code wrapper
    └── codex/
        ├── SKILL.md          # Codex skill wrapper
        └── make-html.md      # Codex slash-command prompt
```

The root `SKILL.md` and `shapes.md` are the source of truth. The wrappers exist only so other agents can discover and route to the same skill.

## Install Locally

From this repository:

```sh
./install.sh
```

That installs the skill system-wide for:

- Cursor: `~/.cursor/skills/make-html`
- Claude Code: `~/.claude/skills/make-html`
- Codex: `~/.agents/skills/make-html` and `~/.codex/prompts/make-html.md`

## Invocation

Use it explicitly:

```text
/make-html <source or direction>
```

If invoked with no source, the default behaviour is intentional: render the assistant's most recent message as an HTML document.

## Design Commitments

Every generated HTML page should:

- Be a single file.
- Work offline.
- Use semantic HTML.
- Use vanilla JavaScript only.
- Be mobile responsive.
- Include a dark-mode toggle.
- Keep colors tokenized so light/dark mode works consistently.
- Use inline SVG for diagrams rather than Mermaid, D3, or screenshots.

## Updating

Pull the latest version and rerun:

```sh
git pull
./install.sh
```

That is the intended propagation path: update this repo once, then sync the same skill to every local agent.

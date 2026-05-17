---
name: make-html
description: Generate a single-file, aesthetically excellent HTML document from any source content (URL, markdown, chat thread, code, spec, docs, or pasted text). This is a wrapper skill: the canonical instructions live at ~/.cursor/skills/make-html/SKILL.md. Use only when explicitly invoked or requested; never auto-trigger.
---

# Make HTML

This is the Codex user-scope wrapper for the shared `make-html` skill.

## Canonical source

Before doing any work, read the canonical skill files:

- `~/.cursor/skills/make-html/SKILL.md`
- `~/.cursor/skills/make-html/shapes.md` only when the canonical `SKILL.md` tells you to read shape-specific instructions

Then follow those canonical instructions exactly.

## Invocation rule

If the user invokes this skill with no arguments or no additional content, follow the canonical default: render the assistant's most recent message in the current conversation as a single self-contained HTML document.

## Output rule

Do not answer from this wrapper alone. The wrapper exists only so Codex can discover the skill globally while Cursor remains the editable source of truth.

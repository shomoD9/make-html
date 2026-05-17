---
description: Use the make-html skill to render content as a polished single-file HTML document.
argument-hint: [SOURCE_OR_DIRECTION]
---

Use the user skill named `make-html` from `~/.agents/skills/make-html/SKILL.md`.

Arguments, if provided:

```text
$ARGUMENTS
```

If no arguments are provided, follow the skill's default rule: render the assistant's most recent message in this conversation as an HTML document. Do not ask what content to use unless there is no usable prior assistant message and no source in the prompt.

If arguments are provided, treat them as the user's source, direction, or shape hint, then follow the skill exactly.

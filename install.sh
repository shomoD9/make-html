#!/usr/bin/env bash
set -euo pipefail

# Install make-html into the user-level skill directories for the agents
# this repo supports. The repository root remains the canonical source; this
# script copies the current checked-out version into each agent's discovery path.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CURSOR_SKILL_DIR="${HOME}/.cursor/skills/make-html"
CLAUDE_SKILL_DIR="${HOME}/.claude/skills/make-html"
CODEX_SKILL_DIR="${HOME}/.agents/skills/make-html"
CODEX_PROMPT_DIR="${HOME}/.codex/prompts"

mkdir -p "${CURSOR_SKILL_DIR}" "${CLAUDE_SKILL_DIR}" "${CODEX_SKILL_DIR}" "${CODEX_PROMPT_DIR}"

# Cursor gets the full canonical skill. This is the local source other wrapper
# skills point at, so keeping it complete matters.
cp "${ROOT_DIR}/SKILL.md" "${CURSOR_SKILL_DIR}/SKILL.md"
cp "${ROOT_DIR}/shapes.md" "${CURSOR_SKILL_DIR}/shapes.md"

# Claude and Codex receive lightweight wrappers. The wrappers tell those agents
# to read Cursor's canonical copy, so future local edits only need to happen once.
cp "${ROOT_DIR}/wrappers/claude/SKILL.md" "${CLAUDE_SKILL_DIR}/SKILL.md"
cp "${ROOT_DIR}/wrappers/codex/SKILL.md" "${CODEX_SKILL_DIR}/SKILL.md"
cp "${ROOT_DIR}/wrappers/codex/make-html.md" "${CODEX_PROMPT_DIR}/make-html.md"

printf 'Installed make-html for Cursor, Claude Code, and Codex.\n'
printf 'Canonical local skill: %s\n' "${CURSOR_SKILL_DIR}"

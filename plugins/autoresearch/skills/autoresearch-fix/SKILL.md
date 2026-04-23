---
name: autoresearch-fix
description: Autonomous repair workflow for tests, types, lint, and build failures. Use when the user explicitly asks to fix failures with autoresearch or invokes /autoresearch:fix.
---

# Autoresearch Fix

- Load `references/fix-workflow.md`.
- Auto-detect current failures before asking questions.
- If target or scope is incomplete, ask the user directly for only the missing fields.
- Repair one issue per iteration, verify immediately, and revert regressions.

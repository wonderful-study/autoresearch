---
description: Run the autonomous repair loop for tests, types, lint, or build failures.
argument-hint: "[Target: <cmd>] [Guard: <cmd>] [Scope: <glob>] [--category <type>] [--skip-lint] [--from-debug] [Iterations: N]"
---

# /autoresearch:fix

The user invoked this command with: `$ARGUMENTS`

## Instructions

1. Read `skills/autoresearch-fix/SKILL.md`.
2. Read `references/fix-workflow.md`.
3. Parse Target, Guard, Scope, category, `--skip-lint`, `--from-debug`, and Iterations from `$ARGUMENTS`.
4. If the fix target or scope is incomplete, inspect current failures first, then ask the user directly for only what is missing.
5. Run the fix workflow and stop when errors reach zero or the bounded iteration limit is reached.

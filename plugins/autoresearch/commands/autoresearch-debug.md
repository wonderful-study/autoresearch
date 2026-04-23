---
description: Run the autonomous bug-hunting workflow.
argument-hint: "[--fix] [Scope: <glob>] [Symptom: <text>] [--severity <level>] [--technique <name>] [Iterations: N]"
---

# /autoresearch:debug

The user invoked this command with: `$ARGUMENTS`

## Instructions

1. Read `skills/autoresearch-debug/SKILL.md`.
2. Read `references/debug-workflow.md`.
3. Parse `--fix`, Scope, Symptom, severity, technique, and Iterations from `$ARGUMENTS`.
4. If Scope or Symptom is missing, inspect the repo first, then ask the user directly for only the missing information.
5. Run the debug workflow. If `--fix` is present, hand off to the fix workflow after findings are collected.

---
description: Run the autonomous documentation and codebase learning workflow.
argument-hint: "[Goal: <text>] [Mode: <init|update|check|summarize>] [Scope: <glob>] [--depth <level>] [--file <name>] [--scan] [--topics <list>] [--no-fix] [--format <fmt>] [Iterations: N]"
---

# /autoresearch:learn

The user invoked this command with: `$ARGUMENTS`

## Instructions

1. Read `skills/autoresearch-learn/SKILL.md`.
2. Read `references/learn-workflow.md`.
3. Parse Mode, Goal, Scope, depth, file target, scan mode, topics, no-fix, format, and Iterations from `$ARGUMENTS`.
4. If mode or scope is missing, inspect the repo first, then ask the user directly for only the missing configuration.
5. Run the learn workflow and stop after the bounded iteration limit when provided.

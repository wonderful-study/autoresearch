---
description: Run the autonomous improve-verify-keep/discard loop against a mechanical metric.
argument-hint: "[Goal: <text>] [Scope: <glob>] [Metric: <text>] [Verify: <cmd>] [Guard: <cmd>] [Iterations: N]"
---

# /autoresearch

The user invoked this command with: `$ARGUMENTS`

## Instructions

1. Read `skills/autoresearch/SKILL.md`.
2. Read `references/core-principles.md`, `references/autonomous-loop-protocol.md`, and `references/results-logging.md`.
3. Parse Goal, Scope, Metric, Verify, Guard, and Iterations from `$ARGUMENTS`.
4. If Goal, Scope, Metric, or Verify is missing:
   - inspect the repo first for likely defaults and candidate commands
   - ask the user directly for only the missing fields in one concise message
   - never rely on legacy batched-question helpers from another platform
5. Execute the autonomous loop.
6. If `Iterations: N` is set, run exactly `N` iterations and stop with a summary.

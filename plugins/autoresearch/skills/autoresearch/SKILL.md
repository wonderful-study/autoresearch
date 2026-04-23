---
name: autoresearch
description: Autonomous goal-directed iteration for any measurable objective. Use when the user explicitly asks to run autoresearch, improve a repository against a metric, or invoke /autoresearch.
metadata:
  priority: 10
  retrieval:
    aliases:
      - autoresearch
      - improvement loop
      - metric optimization
---

# Autoresearch

Use this workflow only when the user explicitly requests it through `/autoresearch`, `@autoresearch`, `$autoresearch`, or an unambiguous request to run the autoresearch loop.

## Required Inputs

- Goal
- Scope
- Metric and direction
- Verify command
- Optional Guard
- Optional Iterations

## Execution Rules

- Inspect the repository before asking questions.
- If a critical field is missing, ask the user directly for only the missing fields in one concise message.
- Never depend on legacy batched-question helpers or hidden workspace-state paths.
- Load `references/core-principles.md`, `references/autonomous-loop-protocol.md`, and `references/results-logging.md`.
- Follow the git preconditions, one-change-per-iteration rule, verify/guard/rollback logic, and TSV logging format exactly.

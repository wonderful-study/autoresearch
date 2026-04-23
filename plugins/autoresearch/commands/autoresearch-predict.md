---
description: Run the multi-persona prediction workflow before debugging, fixing, or shipping.
argument-hint: "[Goal: <text>] [Scope: <glob>] [--chain <targets>] [--depth <level>] [--personas N] [--rounds N] [--adversarial] [--budget <N>] [--fail-on <severity>] [Iterations: N]"
---

# /autoresearch:predict

The user invoked this command with: `$ARGUMENTS`

## Instructions

1. Read `skills/autoresearch-predict/SKILL.md`.
2. Read `references/predict-workflow.md`.
3. Parse Goal, Scope, chain targets, depth, personas, rounds, adversarial mode, budget, fail-on, and Iterations from `$ARGUMENTS`.
4. If Scope or Goal is missing, inspect the repo first, then ask the user directly for the missing inputs.
5. Run the prediction workflow and hand off to chained workflows when requested.

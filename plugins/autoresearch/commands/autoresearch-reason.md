---
description: Run adversarial refinement with isolated generation, critique, synthesis, and judging rounds.
argument-hint: "[Task: <text>] [Domain: <domain>] [--mode <mode>] [--judges N] [--iterations N] [--convergence N] [--chain <targets>]"
---

# /autoresearch:reason

The user invoked this command with: `$ARGUMENTS`

## Instructions

1. Read `skills/autoresearch-reason/SKILL.md`.
2. Read `references/reason-workflow.md`.
3. Parse Task, Domain, mode, judges, iterations, convergence, and chain targets from `$ARGUMENTS`.
4. If the task or domain is missing, ask the user directly for the missing information before starting.
5. Run the adversarial reasoning workflow and hand off to chained workflows when requested.

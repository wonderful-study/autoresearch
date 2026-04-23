---
description: Generate and expand scenarios, edge cases, and derivative situations from a seed scenario.
argument-hint: "[Scenario: <text>] [--domain <type>] [--depth <level>] [--scope <glob>] [--format <type>] [--focus <area>] [Iterations: N]"
---

# /autoresearch:scenario

The user invoked this command with: `$ARGUMENTS`

## Instructions

1. Read `skills/autoresearch-scenario/SKILL.md`.
2. Read `references/scenario-workflow.md`.
3. Parse Scenario, domain, depth, scope, format, focus, and Iterations from `$ARGUMENTS`.
4. If the seed scenario or domain is missing, ask the user directly for only the missing context.
5. Run the scenario workflow and stop after the bounded iteration limit when one is provided.

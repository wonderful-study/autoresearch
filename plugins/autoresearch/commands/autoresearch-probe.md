---
description: Probe fuzzy goals for hidden requirements, assumptions, constraints, and ready-to-run autoresearch config.
argument-hint: "[Topic: <text>] [--adversarial] [--depth <depth>] [--mode <interactive|autonomous>] [--chain <targets>]"
---

# /autoresearch:probe

The user invoked this command with: `$ARGUMENTS`

## Instructions

1. Read `skills/autoresearch-probe/SKILL.md`.
2. Read `references/probe-workflow.md`.
3. Parse Topic, adversarial mode, depth, mode, and chain targets from `$ARGUMENTS`.
4. If the topic is missing, ask the user directly for the missing context before starting.
5. Run the requirement/assumption probe and hand off to chained workflows when requested.

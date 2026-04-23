---
description: Build a runnable autoresearch configuration from a plain-language goal.
argument-hint: "[Goal: <text>]"
---

# /autoresearch:plan

The user invoked this command with: `$ARGUMENTS`

## Instructions

1. Read `skills/autoresearch-plan/SKILL.md`.
2. Read `references/plan-workflow.md`.
3. Treat the full argument string as goal context unless a `Goal:` field is present.
4. If no goal is provided, ask the user directly for the goal in one concise question.
5. Walk through the planning workflow and produce a complete config the user can run immediately.

---
description: Run the universal shipping workflow for code and non-code deliverables.
argument-hint: "[--dry-run] [--auto] [--force] [--rollback] [--monitor N] [--type <type>] [Target: <path>] [--checklist-only] [Iterations: N]"
---

# /autoresearch:ship

The user invoked this command with: `$ARGUMENTS`

## Instructions

1. Read `skills/autoresearch-ship/SKILL.md`.
2. Read `references/ship-workflow.md`.
3. Parse the ship target, type, mode flags, monitor interval, and Iterations from `$ARGUMENTS`.
4. If the target or type is unclear, inspect the repo state first, then ask the user directly for only the missing information.
5. Run the shipping workflow, including dry-run, verify, rollback, or monitoring phases when requested.

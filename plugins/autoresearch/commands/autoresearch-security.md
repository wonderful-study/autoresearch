---
description: Run the autonomous STRIDE and OWASP security audit workflow.
argument-hint: "[--diff] [--fix] [--fail-on <severity>] [Scope: <glob>] [Focus: <text>] [Iterations: N]"
---

# /autoresearch:security

The user invoked this command with: `$ARGUMENTS`

## Instructions

1. Read `skills/autoresearch-security/SKILL.md`.
2. Read `references/security-workflow.md`.
3. Parse `--diff`, `--fix`, `--fail-on`, Scope, Focus, and Iterations from `$ARGUMENTS`.
4. If the audit scope is missing, inspect the codebase first, then ask the user directly for the missing scope or focus.
5. Execute the security workflow and honor any bounded iteration limit.

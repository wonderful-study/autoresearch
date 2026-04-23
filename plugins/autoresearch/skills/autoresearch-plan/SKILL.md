---
name: autoresearch-plan
description: Build a runnable autoresearch configuration from a plain-language goal. Use when the user explicitly asks to plan an autoresearch run or invokes /autoresearch:plan.
---

# Autoresearch Plan

- Use this workflow only for explicit planning requests.
- Load `references/plan-workflow.md`.
- If the goal is missing, ask the user directly for it.
- Turn the goal into a decision-complete config: scope, metric, direction, verify command, optional guard, and iteration recommendation.
- Validate candidate verify commands against the repo before recommending them.

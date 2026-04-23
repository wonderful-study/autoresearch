---
name: autoresearch-scenario
description: Scenario exploration workflow for edge cases, failures, and derivative situations. Use when the user explicitly asks for scenario generation with autoresearch or invokes /autoresearch:scenario.
---

# Autoresearch Scenario

- Load `references/scenario-workflow.md`.
- If the scenario seed or domain is missing, ask the user directly for only the missing information.
- Generate concrete, testable situations rather than vague bullets.
- Respect bounded iteration limits when provided.

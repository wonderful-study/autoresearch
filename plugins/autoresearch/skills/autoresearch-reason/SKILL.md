---
name: autoresearch-reason
description: Adversarial refinement workflow for subjective decisions. Use when the user explicitly asks for structured debate or invokes /autoresearch:reason.
---

# Autoresearch Reason

- Load `references/reason-workflow.md`.
- If task or domain is missing, ask the user directly for only the missing information.
- Keep the rounds explicit: generate, critique, synthesize, judge, and optional chaining.
- Respect convergence and bounded iteration controls.

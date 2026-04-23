# Autoresearch for Codex

Codex-native plugin bundle for autonomous goal-directed iteration.

## Includes

- 10 explicit skills under `skills/`
- 10 slash commands under `commands/`
- Shared workflow references under `references/`

## Commands

- `/autoresearch`
- `/autoresearch:plan`
- `/autoresearch:debug`
- `/autoresearch:fix`
- `/autoresearch:security`
- `/autoresearch:ship`
- `/autoresearch:scenario`
- `/autoresearch:predict`
- `/autoresearch:learn`
- `/autoresearch:reason`

## Local repo install

Open Codex in this repository and use `/plugins` to install the repo-local `autoresearch` plugin from `.agents/plugins/marketplace.json`.

## Explicit invocation

- `@autoresearch` to load the plugin
- `$autoresearch` or a specific `$autoresearch-*` skill to load one workflow directly
- slash commands for the command-shaped entry points above

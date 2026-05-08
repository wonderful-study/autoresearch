# Autoresearch for Codex

Codex-native plugin bundle for autonomous goal-directed iteration.

## Includes

- 11 explicit workflow skills under `skills/`
- 11 slash-style command definitions under `commands/`
- Wrapper CLI under `scripts/`
- Canonical command spec under `resources/`
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
- `/autoresearch:probe`

## Local repo install

Open Codex in this repository and use `/plugins` to install the repo-local `autoresearch` plugin from `.agents/plugins/marketplace.json`.

## Explicit invocation

- `@autoresearch` to load the plugin
- `$autoresearch` to load the router skill, then use a subcommand such as `$autoresearch probe`
- slash commands for the command-shaped entry points above

#!/usr/bin/env bash
# Sync the repo-local Codex plugin skill into .agents/skills/autoresearch/.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SRC="$REPO_ROOT/plugins/autoresearch/skills/autoresearch"
DST="$REPO_ROOT/.agents/skills/autoresearch"

if [[ ! -d "$SRC" ]]; then
  printf 'Error: source directory not found: %s\n' "$SRC" >&2
  exit 1
fi

rm -rf "$DST"
mkdir -p "$(dirname "$DST")"
cp -R "$SRC" "$DST"

mkdir -p "$DST/resources" "$DST/scripts"
cp "$REPO_ROOT/plugins/autoresearch/resources/autoresearch-command-spec.json" "$DST/resources/autoresearch-command-spec.json"
cp "$REPO_ROOT/plugins/autoresearch/scripts/autoresearch_cli.py" "$DST/scripts/autoresearch_cli.py"

total=$(find "$DST" -type f | wc -l | tr -d ' ')
printf 'Sync complete: %s files updated in %s\n' "$total" "$DST"

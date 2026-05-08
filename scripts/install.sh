#!/usr/bin/env bash
# Autoresearch installer for the Codex-native fork.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

LOCATION=""
CONFIG_DIR=""
FORCE=0

cancelled() { printf "\nInstallation cancelled\n"; exit 0; }
trap cancelled INT

usage() {
  cat <<'EOF'
Usage: ./scripts/install.sh [options]

Options:
  --codex             Install for OpenAI Codex
  -g, --global        Install globally
  -l, --local         Install in the current project
  -c, --config-dir    Override the global Codex config directory
  --force             Replace existing files without prompting
  -h, --help          Show this help message

Examples:
  ./scripts/install.sh
  ./scripts/install.sh --codex --global
  ./scripts/install.sh --codex --local
EOF
}

expand_path() {
  local raw="$1"
  if [[ "$raw" == ~* ]]; then
    printf '%s\n' "${raw/#\~/$HOME}"
  else
    printf '%s\n' "$raw"
  fi
}

is_interactive() { [[ -t 0 && -t 1 ]]; }
die() { printf 'Error: %s\n' "$1" >&2; exit 1; }

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --codex)
        ;;
      -g|--global)
        if [[ -n "$LOCATION" && "$LOCATION" != "global" ]]; then die "choose --global or --local"; fi
        LOCATION="global" ;;
      -l|--local)
        if [[ -n "$LOCATION" && "$LOCATION" != "local" ]]; then die "choose --global or --local"; fi
        LOCATION="local" ;;
      -c|--config-dir)
        shift
        if [[ $# -eq 0 ]]; then die "--config-dir requires a path"; fi
        CONFIG_DIR="$(expand_path "$1")" ;;
      --config-dir=*)
        CONFIG_DIR="$(expand_path "${1#*=}")"
        if [[ -z "$CONFIG_DIR" ]]; then die "--config-dir requires a path"; fi ;;
      --force) FORCE=1 ;;
      -h|--help) usage; exit 0 ;;
      *) die "unknown argument: $1" ;;
    esac
    shift
  done
  if [[ -n "$CONFIG_DIR" && "$LOCATION" == "local" ]]; then
    die "--config-dir can only be used with --global"
  fi
}

get_global_dir() {
  if [[ -n "$CONFIG_DIR" ]]; then
    printf '%s\n' "$CONFIG_DIR"
  elif [[ -n "${CODEX_HOME:-}" ]]; then
    expand_path "$CODEX_HOME"
  else
    printf '%s\n' "$HOME/.codex"
  fi
}

get_target_dir() {
  if [[ "${LOCATION:-}" == "local" ]]; then
    printf '%s\n' "$PWD/.codex"
  else
    get_global_dir
  fi
}

prompt_location() {
  local global_dir answer
  global_dir="$(get_global_dir)"
  printf 'Install location:\n  1) Global (%s)\n  2) Local  (%s)\nChoice [1]: ' "$global_dir" "$PWD/.codex"
  read -r answer || cancelled
  case "${answer:-1}" in
    1) LOCATION="global" ;;
    2) LOCATION="local" ;;
    *) die "invalid selection: $answer" ;;
  esac
}

ensure_context() {
  if [[ -z "$LOCATION" ]]; then
    if is_interactive; then prompt_location; else LOCATION="global"; fi
  fi
}

sync_dir() {
  [[ -n "$2" && "$2" =~ ^/.{3,}/.{1,}/.{1,} ]] || die "sync_dir: refusing unsafe destination path: ${2:-<empty>}"
  rm -rf "$2"
  mkdir -p "$(dirname "$2")"
  cp -R "$1" "$2"
}

sync_file() {
  mkdir -p "$(dirname "$2")"
  cp "$1" "$2"
}

confirm_overwrite() {
  local target_root="$1"
  if [[ $FORCE -eq 1 ]]; then return 0; fi
  if [[ ! -d "$target_root/skills/autoresearch" ]]; then return 0; fi
  if ! is_interactive; then return 0; fi
  local answer
  printf 'Existing autoresearch files found in %s. Replace? [Y/n]: ' "$target_root"
  read -r answer || cancelled
  case "${answer:-Y}" in
    [yY]|[yY][eE][sS]|'') ;;
    *) printf 'Skipped.\n'; exit 0 ;;
  esac
}

install_codex() {
  local target_root="$1"
  mkdir -p "$target_root/skills"
  sync_dir "$REPO_ROOT/.agents/skills/autoresearch" "$target_root/skills/autoresearch"
  sync_file "$REPO_ROOT/plugins/autoresearch/resources/autoresearch-command-spec.json" "$target_root/skills/autoresearch/resources/autoresearch-command-spec.json"
  sync_file "$REPO_ROOT/plugins/autoresearch/scripts/autoresearch_cli.py" "$target_root/skills/autoresearch/scripts/autoresearch_cli.py"
}

main() {
  parse_args "$@"
  ensure_context

  local target_root
  target_root="$(get_target_dir)"
  confirm_overwrite "$target_root"

  printf 'Installing Autoresearch for OpenAI Codex (%s)\nTarget: %s\n' "$LOCATION" "$target_root"
  install_codex "$target_root"
  printf 'Done. Use $autoresearch in Codex to start.\n'
}

main "$@"

#!/usr/bin/env bash
# Sync current Irvue wallpaper through pywal and run optional hooks.
set -euo pipefail

WAL_BIN="${WAL_BIN:-wal}"
WAL_OPTS="${WAL_OPTS:-}"
HOOK_DIR="${WAL_HOOK_DIR:-$HOME/.config/wal/hooks.d}"

err() { printf "%s\n" "$*" >&2; }

get_wallpaper() {
  osascript -e 'tell application "Irvue" to get current wallpaper path' 2>/dev/null || true
}

main() {
  local wallpaper colors_json

  if ! command -v "$WAL_BIN" >/dev/null 2>&1; then
    err "wal not found. Install pywal (e.g., pipx install pywal)."
    exit 1
  fi

  if [ $# -gt 0 ]; then
    wallpaper="$1"
  else
    wallpaper="$(get_wallpaper)"
  fi

  if [ -z "$wallpaper" ]; then
    err "No wallpaper path provided and could not get one from Irvue. Pass a path or start Irvue."
    exit 1
  fi
  if [ ! -f "$wallpaper" ]; then
    err "Wallpaper path does not exist: $wallpaper"
    exit 1
  fi

  "$WAL_BIN" -i "$wallpaper" $WAL_OPTS
  colors_json="$HOME/.cache/wal/colors.json"

  if [ -d "$HOOK_DIR" ]; then
    for hook in "$HOOK_DIR"/*; do
      [ -x "$hook" ] || continue
      "$hook" "$colors_json" "$wallpaper" || err "Hook failed: $hook"
    done
  fi
}

main "$@"

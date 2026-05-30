#!/usr/bin/env bash
# Sync current Irvue wallpaper through pywal and run optional hooks.
set -euo pipefail

export PATH="$HOME/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

WAL_BIN="${WAL_BIN:-wal}"
WAL_OPTS="${WAL_OPTS:--n}"
HOOK_DIR="${WAL_HOOK_DIR:-$HOME/.config/wal/hooks.d}"
STATE_FILE="${WAL_STATE_FILE:-$HOME/.cache/wal/current-wallpaper.state}"
FORCE=0

err() { printf "%s\n" "$*" >&2; }

get_wallpaper() {
  osascript -e 'tell application "Irvue" to get current wallpaper path' 2>/dev/null || true
}

get_newest_irvue_wallpaper() {
  local dir="$HOME/Library/Containers/com.leonspok.osx.Irvue/Data/Library/Application Support/Irvue"
  [ -d "$dir" ] || return 0
  find "$dir" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.heic' \) -print0 2>/dev/null |
    xargs -0 stat -f '%m %N' 2>/dev/null |
    sort -nr |
    awk 'NR == 1 { sub(/^[0-9]+ /, ""); print }' || true
}

get_macos_wallpaper_from_store() {
  local plist="$HOME/Library/Application Support/com.apple.wallpaper/Store/Index.plist"
  [ -f "$plist" ] || return 0
  python3 - "$plist" <<'PY'
import re
import subprocess
import sys
from pathlib import Path
from urllib.parse import unquote, urlparse

plist = sys.argv[1]
try:
    out = subprocess.check_output(["strings", plist], text=True, stderr=subprocess.DEVNULL)
except Exception:
    sys.exit(0)

paths = []
for url in re.findall(r"file://[^\s\"']+\.(?:jpg|jpeg|png|heic)", out, re.I):
    path = Path(unquote(urlparse(url).path))
    if path.is_file():
        paths.append(path)

if paths:
    print(max(paths, key=lambda p: p.stat().st_mtime))
PY
}

wallpaper_signature() {
  local path="$1"
  printf "%s|%s\n" "$path" "$(stat -f '%m' "$path" 2>/dev/null || printf unknown)"
}

main() {
  local wallpaper colors_json signature

  if ! command -v "$WAL_BIN" >/dev/null 2>&1; then
    err "wal not found. Install pywal (e.g., pipx install pywal)."
    exit 1
  fi

  while [ $# -gt 0 ]; do
    case "$1" in
      --force|-f)
        FORCE=1
        shift
        ;;
      *)
        wallpaper="$1"
        shift
        ;;
    esac
  done

  wallpaper="${wallpaper:-$(get_wallpaper)}"
  wallpaper="${wallpaper:-$(get_newest_irvue_wallpaper)}"
  wallpaper="${wallpaper:-$(get_macos_wallpaper_from_store)}"

  if [ -z "$wallpaper" ]; then
    err "No wallpaper path provided and could not detect one from Irvue/macOS. Pass an image path."
    exit 1
  fi
  if [ ! -f "$wallpaper" ]; then
    err "Wallpaper path does not exist: $wallpaper"
    exit 1
  fi

  signature="$(wallpaper_signature "$wallpaper")"
  if [ "$FORCE" -eq 0 ] && [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "$signature" ]; then
    exit 0
  fi

  "$WAL_BIN" -i "$wallpaper" $WAL_OPTS
  colors_json="$HOME/.cache/wal/colors.json"
  mkdir -p "$(dirname "$STATE_FILE")"
  printf "%s" "$signature" > "$STATE_FILE"

  if [ -d "$HOOK_DIR" ]; then
    for hook in "$HOOK_DIR"/*; do
      [ -x "$hook" ] || continue
      "$hook" "$colors_json" "$wallpaper" || err "Hook failed: $hook"
    done
  fi
}

main "$@"

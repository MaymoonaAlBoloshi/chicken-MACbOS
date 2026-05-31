#!/usr/bin/env bash
# Ask Irvue to switch wallpaper, then sync pywal colors from the new image.
set -euo pipefail

export PATH="$HOME/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

osascript <<'OSA'
tell application "Irvue" to activate
delay 0.2
tell application "System Events"
  key code 45 using {command down, option down}
end tell
OSA

# Give Irvue a moment to download/apply the new wallpaper before reading its cache.
sleep "${IRVUE_WAL_DELAY:-5}"

exec "$HOME/bin/irvue-wal-sync.sh" --force

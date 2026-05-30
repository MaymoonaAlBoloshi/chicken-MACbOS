#!/usr/bin/env bash
set -euo pipefail
. "$HOME/.config/sketchybar/colors.sh"

focused_json="$(yabai -m query --windows --window 2>/dev/null || echo "")"

title=""
if [ -n "$focused_json" ]; then
  title="$(printf '%s' "$focused_json" | /usr/bin/python3 - <<'PY'
import json,sys
try:
    data=json.load(sys.stdin)
    print(data.get("title","") or "")
except Exception:
    print("")
PY
)"
fi

# Fallback when yabai socket isn't reachable or no title found.
if [ -z "$title" ]; then
  title="$(osascript <<'OSA' 2>/dev/null || true
tell application "System Events"
  set _app to first application process whose frontmost is true
  if exists window 1 of _app then
    return name of window 1 of _app
  end if
end tell
return ""
OSA
)"
fi

now_playing() {
  local np
  np="$(osascript <<'OSA' 2>/dev/null || true
tell application "Music"
  if it is running and player state is playing then
    return "􀑪 " & artist of current track & " — " & name of current track
  end if
end tell
tell application "Spotify"
  if it is running and player state is playing then
    return "􀑪 " & artist of current track & " — " & name of current track
  end if
end tell
return ""
OSA
)"
  printf '%s' "$np"
}

label="$(now_playing)"
if [ -z "$label" ]; then
  [ -z "$title" ] && title="Desktop"
  label="􀎫 $title"
fi

sketchybar --set "$NAME" \
  label="$label" \
  label.color="$FG_COLOR" \
  icon.drawing=off \
  background.color="$BAR_COLOR" \
  background.border_color="$BAR_BORDER" \
  background.border_width=1

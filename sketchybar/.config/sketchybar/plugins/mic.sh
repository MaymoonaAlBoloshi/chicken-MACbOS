#!/usr/bin/env bash
set -euo pipefail
. "$HOME/.config/sketchybar/colors.sh"

toggle_mic() {
  current="$(osascript -e 'input volume of (get volume settings)' 2>/dev/null || echo 0)"
  if [ "${current:-0}" -eq 0 ]; then
    osascript -e 'set volume input volume 70' >/dev/null 2>&1 || true
  else
    osascript -e 'set volume input volume 0' >/dev/null 2>&1 || true
  fi
}

if [ "${SENDER:-}" = "mouse.clicked" ]; then
  toggle_mic
fi

level="$(osascript -e 'input volume of (get volume settings)' 2>/dev/null || echo 0)"
muted_icon="􀝚"
hot_icon="􀊱"
icon="$hot_icon"
label="mic ${level}%"
[ "${level:-0}" -eq 0 ] && icon="$muted_icon" && label="mic muted"

sketchybar --set "$NAME" \
  icon="$icon" \
  label="$label" \
  label.color="$FG_COLOR" \
  icon.color="$ACCENT_COLOR" \
  click_script="$HOME/.config/sketchybar/plugins/mic.sh" \
  background.color="$BAR_COLOR"

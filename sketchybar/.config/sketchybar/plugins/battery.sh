#!/usr/bin/env bash
set -euo pipefail
. "$HOME/.config/sketchybar/colors.sh"

raw="$(pmset -g batt | grep -Eo '[0-9]+%')"
pct="${raw%%%}"

plugged="$(pmset -g batt | grep -o 'AC Power' || true)"
icon=""
[ "$pct" -lt 40 ] && icon=""
[ "$pct" -lt 20 ] && icon=""
[ -n "$plugged" ] && icon=""

sketchybar --set "$NAME" \
  icon="$icon" \
  label="${pct}%" \
  label.color="$FG_COLOR" \
  icon.color="$ACCENT_COLOR" \
  background.color="$BAR_COLOR"

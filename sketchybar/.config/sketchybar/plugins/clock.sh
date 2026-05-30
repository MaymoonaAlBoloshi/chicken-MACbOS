#!/usr/bin/env bash
set -euo pipefail
. "$HOME/.config/sketchybar/colors.sh"

sketchybar --set "$NAME" \
  icon="" \
  label="$(date '+%a %b %d %H:%M')" \
  label.color="$FG_COLOR" \
  icon.color="$ACCENT_COLOR" \
  background.color="$BAR_COLOR"

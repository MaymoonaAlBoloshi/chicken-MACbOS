#!/usr/bin/env bash
set -euo pipefail
. "$HOME/.config/sketchybar/colors.sh"

app_name="$(/usr/bin/osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null || echo "Desktop")"

sketchybar --set "$NAME" \
  icon="" \
  label="$app_name" \
  label.color="$FG_COLOR" \
  icon.color="$ACCENT_COLOR" \
  background.color="$BAR_COLOR"

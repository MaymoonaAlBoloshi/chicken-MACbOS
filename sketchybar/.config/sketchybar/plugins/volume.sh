#!/usr/bin/env bash
set -euo pipefail
. "$HOME/.config/sketchybar/colors.sh"

step=5
vol="$(osascript -e 'output volume of (get volume settings)' 2>/dev/null || echo 0)"

adjust_volume() {
  local delta="$1"
  local new=$((vol + delta))
  [ "$new" -lt 0 ] && new=0
  [ "$new" -gt 100 ] && new=100
  osascript -e "set volume output volume $new" >/dev/null 2>&1 || true
  vol="$new"
}

case "${SENDER:-}" in
  mouse.clicked)
    adjust_volume 0
    ;;
  mouse.scrolled.up)
    adjust_volume "$step"
    ;;
  mouse.scrolled.down)
    adjust_volume "-$step"
    ;;
esac

icon="􀊣"
[ "${vol:-0}" -lt 60 ] && icon="􀊠"
[ "${vol:-0}" -lt 25 ] && icon="􀊡"
[ "${vol:-0}" -eq 0 ] && icon="􀊢"

sketchybar --set "$NAME" \
  icon="$icon" \
  label="vol ${vol}%" \
  label.color="$FG_COLOR" \
  icon.color="$ACCENT_COLOR" \
  click_script="$HOME/.config/sketchybar/plugins/volume.sh" \
  background.color="$BAR_COLOR"

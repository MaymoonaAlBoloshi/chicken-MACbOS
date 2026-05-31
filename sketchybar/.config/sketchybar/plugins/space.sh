#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
. "$CONFIG_DIR/colors.sh"

if [ "$SELECTED" = "true" ]; then
  sketchybar --animate tanh 12 --set "$NAME" \
    icon.highlight=on \
    icon.color="$BAR_COLOR" \
    background.color="$ACCENT_COLOR" \
    background.border_color="$FG_COLOR" \
    background.border_width=1
else
  sketchybar --animate tanh 12 --set "$NAME" \
    icon.highlight=off \
    icon.color="$ACCENT_COLOR" \
    background.color=0x00000000 \
    background.border_color="$ACCENT_MUTED" \
    background.border_width=1
fi

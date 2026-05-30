#!/usr/bin/env bash
set -euo pipefail
. "$HOME/.config/sketchybar/colors.sh"

airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
ssid="Off"
strength="􀙈"

if [ -x "$airport" ]; then
  info="$("$airport" -I 2>/dev/null || true)"
  ssid_line="$(printf '%s\n' "$info" | awk -F': ' '/ SSID/ {print $2; exit}')"
  rssi="$(printf '%s\n' "$info" | awk -F': ' '/agrCtlRSSI/ {print $2; exit}')"
  [ -n "$ssid_line" ] && ssid="$ssid_line"
  if [ -n "$rssi" ]; then
    if [ "$rssi" -gt -55 ]; then
      strength="􀙇"
    elif [ "$rssi" -gt -67 ]; then
      strength="􀙅"
    else
      strength="􀙆"
    fi
  fi
fi

sketchybar --set "$NAME" \
  icon="$strength" \
  label="$ssid" \
  label.color="$FG_COLOR" \
  icon.color="$ACCENT_COLOR" \
  background.color="$BAR_COLOR"

#!/usr/bin/env bash
set -euo pipefail
. "$HOME/.config/sketchybar/colors.sh"

cpu_line="$(top -l 1 -n 0 | awk '/CPU usage/ {print $3, $5}' | head -n1)"
cpu_used="0"
if [ -n "$cpu_line" ]; then
  cpu_used="$(printf '%s\n' "$cpu_line" | /usr/bin/python3 - <<'PY'
import sys
parts=sys.stdin.read().strip().replace('%','').split()
try:
  user=float(parts[0])
  syscpu=float(parts[1])
  print(int(user+syscpu))
except Exception:
  print(0)
PY
)"
fi

mem_free="$(memory_pressure 2>/dev/null | awk -F'= ' '/System-wide memory free percentage/ {gsub("%","",$2); print $2; exit}')"
[ -z "$mem_free" ] && mem_free="0"
mem_used=$(( 100 - ${mem_free%.*} ))
[ "$mem_used" -lt 0 ] && mem_used=0

sketchybar --set "$NAME" \
  icon="􀊴" \
  label="cpu ${cpu_used}% · mem ${mem_used}%" \
  label.color="$FG_COLOR" \
  icon.color="$ACCENT_COLOR" \
  background.color="$BAR_COLOR"

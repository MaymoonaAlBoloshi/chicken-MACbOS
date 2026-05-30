#!/usr/bin/env bash
set -euo pipefail
. "$HOME/.config/sketchybar/colors.sh"

focused_pid=""
focused_json="$(yabai -m query --windows --window 2>/dev/null || echo "")"
focused_pid="$(printf '%s' "$focused_json" | /usr/bin/python3 - <<'PY'
import json,sys
try:
    data=json.load(sys.stdin)
    pid=data.get("pid","")
    print(pid)
except Exception:
    print("")
PY
)"

repo_dir=""
if [ -n "$focused_pid" ]; then
  repo_dir="$(lsof -a -p "$focused_pid" -d cwd -Fn 2>/dev/null | sed -n 's/^n//p' | head -n1)"
fi
[ -z "$repo_dir" ] && repo_dir="$PWD"

label=""
if git -C "$repo_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch="$(git -C "$repo_dir" symbolic-ref --quiet --short HEAD 2>/dev/null || git -C "$repo_dir" rev-parse --short HEAD 2>/dev/null || true)"
  [ -n "$branch" ] && label="$branch"
fi

if [ -z "$label" ]; then
  sketchybar --set "$NAME" label.drawing=off icon.drawing=off
  exit 0
fi

sketchybar --set "$NAME" \
  icon="" \
  label="$label" \
  label.drawing=on \
  icon.drawing=on \
  label.color="$FG_COLOR" \
  icon.color="$ACCENT_COLOR" \
  background.color="$BAR_COLOR"

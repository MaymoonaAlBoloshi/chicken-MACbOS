#!/usr/bin/env bash
# Hide sketchybar space items that don't exist in yabai so we only show real spaces.

SPACES_JSON="$(yabai -m query --spaces 2>/dev/null || true)"
[ -n "$SPACES_JSON" ] || exit 0

if command -v jq >/dev/null 2>&1; then
  SPACE_IDS="$(printf '%s\n' "$SPACES_JSON" | jq -r '.[].index' 2>/dev/null)"
else
  # Fallback: best-effort parse without jq.
  SPACE_IDS="$(printf '%s\n' "$SPACES_JSON" | sed -n 's/.*"index"[[:space:]]*:[[:space:]]*\\([0-9]*\\).*/\\1/p')"
fi

[ -n "$SPACE_IDS" ] || exit 0

for sid in {1..9}; do
  if printf '%s\n' "$SPACE_IDS" | grep -qx "$sid"; then
    sketchybar --set "space.$sid" drawing=on
  else
    sketchybar --set "space.$sid" drawing=off
  fi
done

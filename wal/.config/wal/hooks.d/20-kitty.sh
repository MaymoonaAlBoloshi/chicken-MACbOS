#!/usr/bin/env bash
# Live-apply wal-generated kitty colors if kitty is running.
set -euo pipefail

kitty_conf_src="$HOME/.cache/wal/colors-kitty.conf"

[ -f "$kitty_conf_src" ] || exit 0

if command -v kitty >/dev/null 2>&1; then
  kitty @ set-colors --all --configured "$kitty_conf_src" >/dev/null 2>&1 || true
fi

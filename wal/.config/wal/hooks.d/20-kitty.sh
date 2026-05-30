#!/usr/bin/env bash
# Copy wal-generated kitty colors and live-apply if kitty is running.
set -euo pipefail

kitty_conf_src="$HOME/.cache/wal/colors-kitty.conf"
kitty_conf_dst="$HOME/.config/kitty/wal.conf"

[ -f "$kitty_conf_src" ] || exit 0
mkdir -p "$(dirname "$kitty_conf_dst")"
cp "$kitty_conf_src" "$kitty_conf_dst"

if command -v kitty >/dev/null 2>&1; then
  kitty @ set-colors --all --configured "$kitty_conf_dst" >/dev/null 2>&1 || true
fi

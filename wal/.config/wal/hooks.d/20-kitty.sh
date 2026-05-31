#!/usr/bin/env bash
# Live-apply wal-generated kitty colors and custom tab-bar colors if kitty is running.
set -euo pipefail

colors_json="${1:-$HOME/.cache/wal/colors.json}"
kitty_conf_src="$HOME/.cache/wal/colors-kitty.conf"
tabbar_src="$HOME/.config/kitty/tab_bar.toml"
tabbar_dst="$HOME/.cache/wal/kitty-tab-bar.toml"

[ -f "$kitty_conf_src" ] || exit 0

if [ -f "$colors_json" ] && [ -f "$tabbar_src" ]; then
  python3 - "$colors_json" "$tabbar_src" "$tabbar_dst" <<'PY'
import json
import re
import sys
from pathlib import Path

colors_path = Path(sys.argv[1])
src = Path(sys.argv[2])
dst = Path(sys.argv[3])

data = json.loads(colors_path.read_text())
special = data.get("special", {})
colors = data.get("colors", {})

active_bg = colors.get("color4") or special.get("background") or "#1d2f8f"
inactive_bg = special.get("background") or colors.get("color0") or "#071039"
active_fg = special.get("foreground") or colors.get("color15") or "#f3f5ff"
inactive_fg = colors.get("color8") or colors.get("color7") or active_fg

text = src.read_text()

replacements = {
    r'active_color="[^"]*"(    # e\.g\. "#1a1a2e".*)': f'active_color="{active_bg}"\\1',
    r'inactive_color="[^"]*"(  # e\.g\. "#0a0a0a".*)': f'inactive_color="{inactive_bg}"\\1',
    r'active_color="[^"]*"(    # e\.g\. "#ffffff".*)': f'active_color="{active_fg}"\\1',
    r'inactive_color="[^"]*"(  # e\.g\. "#888888".*)': f'inactive_color="{inactive_fg}"\\1',
}

for pattern, replacement in replacements.items():
    text = re.sub(pattern, replacement, text, count=1)

dst.parent.mkdir(parents=True, exist_ok=True)
dst.write_text(text)
PY
fi

if command -v kitty >/dev/null 2>&1; then
  kitty @ set-colors --all --configured "$kitty_conf_src" >/dev/null 2>&1 || true
  kitty @ load-config --all >/dev/null 2>&1 || true
fi

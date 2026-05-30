#!/usr/bin/env bash
# Generate wal-colors.css inside each Firefox profile so userChrome/userContent can import locally.
set -euo pipefail

colors_src="$HOME/.cache/wal/colors.css"
profiles_ini="$HOME/Library/Application Support/Firefox/profiles.ini"
[ -f "$colors_src" ] || exit 0
[ -f "$profiles_ini" ] || exit 0

python3 - "$colors_src" "$profiles_ini" <<'PY'
import configparser, sys
from pathlib import Path

colors_src = Path(sys.argv[1])
profiles_ini = Path(sys.argv[2])
cfg = configparser.RawConfigParser()
cfg.read(profiles_ini)

for section in cfg.sections():
    if not section.startswith("Profile"):
        continue
    path = cfg.get(section, "Path", fallback="")
    if not path:
        continue
    is_relative = cfg.getboolean(section, "IsRelative", fallback=True)
    profile_dir = profiles_ini.parent / path if is_relative else Path(path)
    chrome_dir = profile_dir / "chrome"
    chrome_dir.mkdir(parents=True, exist_ok=True)
    dest = chrome_dir / "wal-colors.css"
    dest.write_text(colors_src.read_text())
PY

#!/usr/bin/env bash
# Reload sketchybar if present.
set -euo pipefail

command -v sketchybar >/dev/null 2>&1 || exit 0
sketchybar --reload >/dev/null 2>&1 || true

#!/usr/bin/env bash
# Color helpers for sketchybar, using wal if available with a sane fallback.

if [ -f "$HOME/.cache/wal/colors.sh" ]; then
  # Ensure wal's FZF_DEFAULT_OPTS reference doesn't trip set -u in plugins.
  FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS-}"
  LS_COLORS="${LS_COLORS-}"
  # shellcheck disable=SC1090
  . "$HOME/.cache/wal/colors.sh"
else
  foreground="#cddcf3"
  background="#30466f"
  color0="$background"
  color1="#76A8E6"
  color2="#8098BE"
  color3="#91AFE2"
  color4="#8DB5F1"
  color5="#ACC1DE"
  color6="#9BC2FC"
  color7="$foreground"
  color8="#8f9aaa"
  color9="$color1"
  color10="$color2"
  color11="$color3"
  color12="$color4"
  color13="$color5"
  color14="$color6"
  color15="$foreground"
fi

with_alpha() {
  local hex="${1#\#}"
  local alpha="${2:-ff}"
  printf "0x%s%s" "$alpha" "$hex"
}

BAR_COLOR=$(with_alpha "${color0:-30466f}" "f0")
BAR_BORDER=$(with_alpha "${color8:-8f9aaa}" "80")
FG_COLOR=$(with_alpha "${foreground:-cddcf3}")
ACCENT_COLOR=$(with_alpha "${color4:-8DB5F1}")
ACCENT_MUTED=$(with_alpha "${color5:-ACC1DE}" "cc")
WARN_COLOR=$(with_alpha "${color1:-76A8E6}")

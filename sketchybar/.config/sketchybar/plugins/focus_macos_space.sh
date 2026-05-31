#!/usr/bin/env bash

sid="$1"

case "$sid" in
  1) key_code=18 ;;
  2) key_code=19 ;;
  3) key_code=20 ;;
  4) key_code=21 ;;
  5) key_code=23 ;;
  6) key_code=22 ;;
  7) key_code=26 ;;
  8) key_code=28 ;;
  9) key_code=25 ;;
  *) exit 0 ;;
esac

osascript -e "tell application \"System Events\" to key code $key_code using control down"

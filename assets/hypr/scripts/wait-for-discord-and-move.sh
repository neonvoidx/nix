#!/usr/bin/env bash

set -euo pipefail

TARGET_W="${1:-1418}"
TARGET_H="${2:-681}"

while true; do
  # Original Spotify logic (commented out)
  # if hyprctl -j clients | jq -e 'any(.class == "discord")' >/dev/null 2>&1 && \
  #    hyprctl -j clients | jq -e 'any(.class == "spotify")' >/dev/null 2>&1; then
  #  break
  # fi

  # Wait for both Discord and Pear
  if hyprctl -j clients | jq -e 'any(.class == "discord")' >/dev/null 2>&1 && \
     hyprctl -j clients | jq -e 'any(.class == "com.github.th-ch.youtube-music" and .title == "Pear")' >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

sleep 2

# Arrange Discord (large portion)
# hyprctl dispatch 'hl.dsp.window.move({ direction = "u", window = "class:discord" })' || true
# hyprctl dispatch "hl.dsp.window.resize({ x = $TARGET_W, y = $TARGET_H, relative = false, window = \"class:discord\" })" || true
hyprctl dispatch 'hl.dsp.window.move({ direction = "u", window = "class:discord" })' || true
hyprctl dispatch "hl.dsp.window.resize({ x = 1418, y = 1841, relative = false, window = \"class:discord\" })" || true

# Arrange Pear (small portion)
hyprctl dispatch 'hl.dsp.window.move({ direction = "d", window = "class:com.github.th-ch.youtube-music" })' || true
hyprctl dispatch "hl.dsp.window.resize({ x = $TARGET_W, y = $TARGET_H, relative = false, window = \"class:com.github.th-ch.youtube-music\" })" || true

#!/usr/bin/env bash

set -euo pipefail

while true; do
  if hyprctl -j clients | jq -e 'any(.class == "vesktop")' >/dev/null 2>&1 && \
     hyprctl -j clients | jq -e 'any(.class == "Spotify")' >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

hyprctl dispatch 'hl.dsp.window.move({ direction = "u", window = "class:vesktop" })' || true

TARGET_W=1440
TARGET_H=$((2440 * 70 / 100))

hyprctl dispatch "hl.dsp.window.resize({ x = $TARGET_W, y = $TARGET_H, relative = false, window = \"class:vesktop\" })" || true

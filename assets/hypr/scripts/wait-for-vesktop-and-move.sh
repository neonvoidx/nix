#!/usr/bin/env bash

set -euo pipefail

TARGET_W="${1:-1440}"
TARGET_H="${2:-1830}"

while true; do
  if hyprctl -j clients | jq -e 'any(.class == "vesktop")' >/dev/null 2>&1 && \
     hyprctl -j clients | jq -e 'any(.class == "spotify")' >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

sleep 2

hyprctl dispatch 'hl.dsp.window.move({ direction = "u", window = "class:vesktop" })' || true

hyprctl dispatch "hl.dsp.window.resize({ x = $TARGET_W, y = $TARGET_H, relative = false, window = \"class:vesktop\" })" || true

#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
WORKSPACE_FILE="$STATE_DIR/active-workspace"
WINDOW_FILE="$STATE_DIR/active-window"

# If Hyprland isn't running, do nothing
if ! hyprctl -j monitors >/dev/null 2>&1; then
  exit 0
fi

# Focus the saved workspace
workspace=""
if [ -f "$WORKSPACE_FILE" ]; then
  workspace=$(tr -d '\n' < "$WORKSPACE_FILE")
fi

if [ -n "$workspace" ]; then
  hyprctl dispatch "hl.dsp.focus({ workspace = \"$workspace\" })" >/dev/null 2>&1 || true
  sleep 0.1
fi

# Focus the saved window address (if it still exists)
window_selector=""
if [ -f "$WINDOW_FILE" ]; then
  window_selector=$(tr -d '\n' < "$WINDOW_FILE")
fi

if [ -n "$window_selector" ]; then
  # Strip address: prefix for raw address comparison with hyprctl
  window_addr="${window_selector#address:}"
  if hyprctl -j clients 2>/dev/null | jq -e --arg addr "$window_addr" 'any(.address == $addr)' >/dev/null 2>&1; then
    hyprctl dispatch "hl.dsp.focus({ window = \"$window_selector\" })" >/dev/null 2>&1 || true
  fi
fi

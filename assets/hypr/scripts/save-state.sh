#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
WORKSPACE_FILE="$STATE_DIR/active-workspace"
WINDOW_FILE="$STATE_DIR/active-window"

mkdir -p "$STATE_DIR"

# Persist active workspace
hyprctl -j activeworkspace 2>/dev/null | jq -r '.id | tostring' > "$WORKSPACE_FILE" 2>/dev/null || true

# Persist active window address (empty if none/desktop)
window_addr=$(hyprctl -j activewindow 2>/dev/null | jq -r '.address // empty' 2>/dev/null || true)
if [ -n "$window_addr" ]; then
  printf 'address:%s' "$window_addr" > "$WINDOW_FILE"
else
  rm -f "$WINDOW_FILE"
fi

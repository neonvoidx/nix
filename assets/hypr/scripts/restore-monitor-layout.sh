#!/usr/bin/env bash

set -euo pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
LAYOUT_FILE="$STATE_DIR/monitor-layout"

APPLY_SCRIPT="$HOME/.config/hypr/scripts/apply-monitor-layout.sh"

mkdir -p "$STATE_DIR"

# If Hyprland isn't running, don't error.
if ! hyprctl -j monitors >/dev/null 2>&1; then
  exit 0
fi

layout="default"
if [ -f "$LAYOUT_FILE" ]; then
  layout=$(cat "$LAYOUT_FILE" | tr -d '\n')
fi

case "$layout" in
  default|notouch|work|work-notouch) ;;
  *) layout="default" ;;
esac

if [ -x "$APPLY_SCRIPT" ]; then
  "$APPLY_SCRIPT" "$layout" || true
  # Let monitors settle before dispatching workspace
  sleep 0.5
fi

"$HOME/.config/hypr/scripts/restore-xrandr-primary.sh"

# Restore focused workspace
WORKSPACE_FILE="$STATE_DIR/active-workspace"
if [ -f "$WORKSPACE_FILE" ]; then
  workspace=$(tr -d '\n' < "$WORKSPACE_FILE")
  if [ -n "$workspace" ]; then
    hyprctl dispatch "hl.dsp.focus({ workspace = \"$workspace\" })" >/dev/null
  fi
fi

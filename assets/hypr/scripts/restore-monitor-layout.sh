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

# ── Enforce workspace-to-monitor bindings ──────────────────────────────────
# In work layouts DP-2 is disabled, so all workspaces go to DP-3.
# In default layouts DP-2 is the primary, DP-3 is secondary.
# Without this, workspaces drift to HDMI-A-1 when moves to DP-2 fail silently.

if [[ "$layout" == work* ]]; then
  hyprctl eval "
    move_workspace_to_monitor(\"1\", \"DP-3\")
    move_workspace_to_monitor(\"2\", \"DP-3\")
    move_workspace_to_monitor(\"3\", \"HDMI-A-1\")
    move_workspace_to_monitor(\"4\", \"DP-3\")
    move_workspace_to_monitor(\"5\", \"DP-3\")
    move_workspace_to_monitor(\"6\", \"DP-3\")
    move_workspace_to_monitor(\"7\", \"DP-3\")
    move_workspace_to_monitor(\"8\", \"DP-3\")
    move_workspace_to_monitor(\"9\", \"DP-3\")
    move_workspace_to_monitor(\"10\", \"DP-3\")
    move_workspace_to_monitor(\"11\", \"DP-3\")
  " >/dev/null 2>&1 || true
else
  hyprctl eval "
    move_workspace_to_monitor(\"1\", \"DP-2\")
    move_workspace_to_monitor(\"2\", \"DP-3\")
    move_workspace_to_monitor(\"3\", \"HDMI-A-1\")
    move_workspace_to_monitor(\"4\", \"DP-3\")
    move_workspace_to_monitor(\"5\", \"DP-2\")
    move_workspace_to_monitor(\"6\", \"DP-2\")
    move_workspace_to_monitor(\"7\", \"DP-2\")
    move_workspace_to_monitor(\"8\", \"DP-2\")
    move_workspace_to_monitor(\"9\", \"DP-2\")
    move_workspace_to_monitor(\"10\", \"DP-2\")
    move_workspace_to_monitor(\"11\", \"DP-2\")
  " >/dev/null 2>&1 || true
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

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
# After apply_monitor_layout() reconfigures monitors (and may disable DP-2
# when restoring the "work"/"work-notouch" layout), workspaces can be
# reassigned to wrong monitors (e.g. workspace 5 landing on HDMI-A-1).
# Re-bind each workspace to its designated monitor so the portrait monitor
# (HDMI-A-1) always gets workspace 3 and never 5.

hyprctl eval "
move_workspace_to_monitor(\"1\", \"DP-2\")
move_workspace_to_monitor(\"2\", \"DP-3\")
move_workspace_to_monitor(\"3\", \"HDMI-A-1\")
move_workspace_to_monitor(\"4\", \"DP-3\")
move_workspace_to_monitor(\"5\", \"DP-2\")
move_workspace_to_monitor(\"6\", \"DP-2\")
move_workspace_to_monitor(\"10\", \"DP-2\")
move_workspace_to_monitor(\"11\", \"DP-2\")
" >/dev/null 2>&1 || true

"$HOME/.config/hypr/scripts/restore-xrandr-primary.sh"

# Restore focused workspace
WORKSPACE_FILE="$STATE_DIR/active-workspace"
if [ -f "$WORKSPACE_FILE" ]; then
  workspace=$(tr -d '\n' < "$WORKSPACE_FILE")
  if [ -n "$workspace" ]; then
    hyprctl dispatch "hl.dsp.focus({ workspace = \"$workspace\" })" >/dev/null
  fi
fi

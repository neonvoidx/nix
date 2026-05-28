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
# Use direct hyprctl dispatch (not hyprctl eval) to avoid Lua IPC issues.

dispatch_move_workspace() {
  hyprctl dispatch "hl.dsp.workspace.move({ workspace = \"$1\", monitor = \"$2\" })" >/dev/null 2>&1 || true
}

dispatch_focus_monitor() {
  hyprctl dispatch "hl.dsp.focus({ monitor = \"$1\" })" >/dev/null 2>&1 || true
}

if [[ "$layout" == work* ]]; then
  PRIMARY_MON="DP-3"
  SECONDARY_MON=""
  dispatch_move_workspace 1  "$PRIMARY_MON"
  dispatch_move_workspace 2  "$PRIMARY_MON"
  dispatch_move_workspace 3  "HDMI-A-1"
  dispatch_move_workspace 4  "$PRIMARY_MON"
  dispatch_move_workspace 5  "$PRIMARY_MON"
  dispatch_move_workspace 6  "$PRIMARY_MON"
  dispatch_move_workspace 7  "$PRIMARY_MON"
  dispatch_move_workspace 8  "$PRIMARY_MON"
  dispatch_move_workspace 9  "$PRIMARY_MON"
  dispatch_move_workspace 10 "$PRIMARY_MON"
  dispatch_move_workspace 11 "$PRIMARY_MON"
else
  PRIMARY_MON="DP-2"
  SECONDARY_MON="DP-3"
  dispatch_move_workspace 1  "$PRIMARY_MON"
  dispatch_move_workspace 2  "$SECONDARY_MON"
  dispatch_move_workspace 3  "HDMI-A-1"
  dispatch_move_workspace 4  "$SECONDARY_MON"
  dispatch_move_workspace 5  "$PRIMARY_MON"
  dispatch_move_workspace 6  "$PRIMARY_MON"
  dispatch_move_workspace 7  "$PRIMARY_MON"
  dispatch_move_workspace 8  "$PRIMARY_MON"
  dispatch_move_workspace 9  "$PRIMARY_MON"
  dispatch_move_workspace 10 "$PRIMARY_MON"
  dispatch_move_workspace 11 "$PRIMARY_MON"
fi

"$HOME/.config/hypr/scripts/restore-xrandr-primary.sh"

# Cursor default must follow the active primary monitor, never HDMI.
hyprctl keyword cursor:default_monitor "$PRIMARY_MON" >/dev/null 2>&1 || true

# Focus the primary monitor so workspace 1 lands in the right place
dispatch_focus_monitor "$PRIMARY_MON"

# Restore focused workspace
WORKSPACE_FILE="$STATE_DIR/active-workspace"
if [ -f "$WORKSPACE_FILE" ]; then
  workspace=$(tr -d '\n' < "$WORKSPACE_FILE")
  if [ -n "$workspace" ]; then
    hyprctl dispatch "hl.dsp.focus({ workspace = \"$workspace\" })" >/dev/null 2>&1 || true
  fi
fi

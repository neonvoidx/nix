#!/usr/bin/env bash

set -euo pipefail

PRIMARY_MON="${1:-DP-2}"
SECONDARY_MON="${2:-DP-3}"
PORTRAIT_MON="${3:-HDMI-A-1}"

LOCK_FILE="/tmp/hypr-restore-monitor-layout.lock"

# Prevent concurrent restores (e.g. daemon + rebuild triggering at the same time).
exec 9>"$LOCK_FILE"
if ! flock -n 9; then
  exit 0
fi

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
LAYOUT_FILE="$STATE_DIR/monitor-layout"

APPLY_SCRIPT="$HOME/.config/hypr/scripts/apply-monitor-layout.sh"

mkdir -p "$STATE_DIR"

# If Hyprland isn't running, don't error.
if ! hyprctl -j monitors >/dev/null 2>&1; then
  exit 0
fi

# Snapshot current workspace + window before moving anything, so the
# restore at the end reflects the user's pre-reload state, not whatever
# Hyprland shuffles during layout application.
SAVE_STATE="$HOME/.config/hypr/scripts/save-state.sh"
if [ -x "$SAVE_STATE" ]; then
  "$SAVE_STATE"
fi

# Capture workspace ID immediately after save, in case save-workspace.sh
# daemon (running concurrently) overwrites the state file during our
# workspace creation loop below.
restore_ws=$(hyprctl -j activeworkspace 2>/dev/null | jq -r '.id' 2>/dev/null || echo "")

layout="default"
if [ -f "$LAYOUT_FILE" ]; then
  layout=$(cat "$LAYOUT_FILE" | tr -d '\n')
fi

case "$layout" in
  default|work) ;;
  *) layout="default" ;;
esac

# Determine which monitor is active based on layout.
if [[ "$layout" == work* ]]; then
  ACTIVE_MON="$SECONDARY_MON"
else
  ACTIVE_MON="$PRIMARY_MON"
fi

# ── Helper dispatchers ─────────────────────────────────────────────────────

dispatch_move_workspace() {
  hyprctl dispatch "hl.dsp.workspace.move({ workspace = \"$1\", monitor = \"$2\", follow = false })" >/dev/null 2>&1 || true
}

dispatch_focus_monitor() {
  hyprctl dispatch "hl.dsp.focus({ monitor = \"$1\" })" >/dev/null 2>&1 || true
}

# ── Monitor layout ─────────────────────────────────────────────────────────

if [ -x "$APPLY_SCRIPT" ] && [[ "$layout" != "default" ]]; then
  "$APPLY_SCRIPT" "$layout" || true
  sleep 0.5
fi

# ── Enforce workspace-to-monitor bindings ──────────────────────────────────

if [[ "$layout" == work* ]]; then
  dispatch_move_workspace 1  "$ACTIVE_MON"
  dispatch_move_workspace 2  "$ACTIVE_MON"
  dispatch_move_workspace 3  "$ACTIVE_MON"
  dispatch_move_workspace 4  "$ACTIVE_MON"
  dispatch_move_workspace 5  "$ACTIVE_MON"
  dispatch_move_workspace 6  "$ACTIVE_MON"
  dispatch_move_workspace 7  "$ACTIVE_MON"
  dispatch_move_workspace 8  "$ACTIVE_MON"
  dispatch_move_workspace 9  "$ACTIVE_MON"
  dispatch_move_workspace 10 "$ACTIVE_MON"
  dispatch_move_workspace 11 "$ACTIVE_MON"
  dispatch_move_workspace 12 "$ACTIVE_MON"
  dispatch_move_workspace 13  "$PORTRAIT_MON"
else
  dispatch_move_workspace 1  "$PRIMARY_MON"
  dispatch_move_workspace 2  "$SECONDARY_MON"
  dispatch_move_workspace 3  "$PRIMARY_MON"
  dispatch_move_workspace 4  "$PRIMARY_MON"
  dispatch_move_workspace 5  "$PRIMARY_MON"
  dispatch_move_workspace 6  "$PRIMARY_MON"
  dispatch_move_workspace 7  "$PRIMARY_MON"
  dispatch_move_workspace 8  "$PRIMARY_MON"
  dispatch_move_workspace 9  "$PRIMARY_MON"
  dispatch_move_workspace 10 "$PRIMARY_MON"
  dispatch_move_workspace 11 "$PRIMARY_MON"
  dispatch_move_workspace 12 "$SECONDARY_MON"
  dispatch_move_workspace 13  "$PORTRAIT_MON"
fi

"$HOME/.config/hypr/scripts/restore-xrandr-primary.sh" "$PRIMARY_MON" "$SECONDARY_MON"

# Cursor default must follow the active primary monitor, never portrait.
hyprctl keyword cursor:default_monitor "$PRIMARY_MON" >/dev/null 2>&1 || true

# Focus the primary monitor so workspace 1 lands in the right place
dispatch_focus_monitor "$PRIMARY_MON"

# Restore focused workspace
if [ -n "$restore_ws" ]; then
  hyprctl dispatch "hl.dsp.focus({ workspace = \"$restore_ws\" })" >/dev/null 2>&1 || true
  sleep 0.1
fi

# Restore focused window address
WINDOW_FILE="$STATE_DIR/active-window"
if [ -f "$WINDOW_FILE" ]; then
  window_selector=$(tr -d '\n' < "$WINDOW_FILE")
  if [ -n "$window_selector" ]; then
    window_addr="${window_selector#address:}"
    if hyprctl -j clients 2>/dev/null | jq -e --arg addr "$window_addr" 'any(.address == $addr)' >/dev/null 2>&1; then
      hyprctl dispatch "hl.dsp.focus({ window = \"$window_selector\" })" >/dev/null 2>&1 || true
    fi
  fi
fi

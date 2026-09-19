#!/usr/bin/env bash

MODE="${1:-}"
PRIMARY_MONITOR="${2:-DP-2}"
SECONDARY_MONITOR="${3:-DP-3}"
PORTRAIT_MONITOR="${4:-HDMI-A-1}"
WORKSPACES_TO_MOVE=(1 2 4 5 6 7 8 9 10 11) # everything but discord/spotify workspace
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
GAMESCREEN_STATE_FILE="$STATE_DIR/gamescreen"
SCREEN_STATE_FILE="$STATE_DIR/screen"
LAYOUT_FILE="$STATE_DIR/monitor-layout"
APPLY_SCRIPT="$HOME/.config/hypr/scripts/apply-monitor-layout.sh"

mkdir -p "$STATE_DIR"

current_layout="default"
if [ -f "$LAYOUT_FILE" ]; then
  current_layout=$(tr -d '\n' < "$LAYOUT_FILE")
fi

set_cursor_default_monitor() {
  hyprctl keyword cursor:default_monitor "$1" >/dev/null 2>&1 || true
}

dispatch_move_workspace() {
  hyprctl dispatch "hl.dsp.workspace.move({ workspace = \"$1\", monitor = \"$2\", follow = false })" >/dev/null 2>&1 || true
}

dispatch_focus_monitor() {
  hyprctl dispatch "hl.dsp.focus({ monitor = \"$1\" })" >/dev/null 2>&1 || true
}

SAVE_STATE_SCRIPT="$HOME/.config/hypr/scripts/save-state.sh"
RESTORE_STATE_SCRIPT="$HOME/.config/hypr/scripts/restore-state.sh"

if [ "$MODE" = "1" ]; then
  "$SAVE_STATE_SCRIPT"
  echo "both" > "$SCREEN_STATE_FILE"
  xrandr --output "$PRIMARY_MONITOR" --primary
  # Enable both monitors
  case "$current_layout" in
    work) next_layout="default" ;;
    *) next_layout="$current_layout" ;;
  esac
  "$APPLY_SCRIPT" "$next_layout"

  # Let monitors settle before moving workspaces (primary may be re-enabling)
  sleep 0.5

  # Enforce workspace-to-monitor bindings after layout transition.
  dispatch_move_workspace 1  "$PRIMARY_MONITOR"
  dispatch_move_workspace 2  "$SECONDARY_MONITOR"
  dispatch_move_workspace 3  "$PRIMARY_MONITOR"
  dispatch_move_workspace 4  "$PRIMARY_MONITOR"
  dispatch_move_workspace 5  "$PRIMARY_MONITOR"
  dispatch_move_workspace 6  "$PRIMARY_MONITOR"
  dispatch_move_workspace 7  "$PRIMARY_MONITOR"
  dispatch_move_workspace 8  "$PRIMARY_MONITOR"
  dispatch_move_workspace 9  "$PRIMARY_MONITOR"
  dispatch_move_workspace 10 "$PRIMARY_MONITOR"
  dispatch_move_workspace 11 "$PRIMARY_MONITOR"
  dispatch_move_workspace 12 "$SECONDARY_MONITOR"
  dispatch_move_workspace 13  "$PORTRAIT_MONITOR"

  # Cursor default must follow the active primary monitor, never portrait.
  set_cursor_default_monitor "$PRIMARY_MONITOR"
  dispatch_focus_monitor "$PRIMARY_MONITOR"

  # Restore xrandr primary based on screen state
  "$HOME/.config/hypr/scripts/restore-xrandr-primary.sh" "$PRIMARY_MONITOR" "$SECONDARY_MONITOR"

  # Persist chosen layout in a single file so it can be restored after nix rebuild.
  echo "$next_layout" > "$LAYOUT_FILE"
  "$RESTORE_STATE_SCRIPT"
  exit
else
  "$SAVE_STATE_SCRIPT"
  echo "external" > "$SCREEN_STATE_FILE"
  xrandr --output "$SECONDARY_MONITOR" --primary
  # Disable the primary monitor and keep the secondary active
  case "$current_layout" in
    default) next_layout="work" ;;
    *) next_layout="$current_layout" ;;
  esac
  "$APPLY_SCRIPT" "$next_layout"
  sleep 0.5

  # Move every workspace to the secondary monitor.
  for ws in 1 2 3 4 5 6 7 8 9 10 11 12; do
    dispatch_move_workspace "$ws" "$SECONDARY_MONITOR"
  done

  # Cursor default must follow the active primary monitor, never portrait.
  set_cursor_default_monitor "$SECONDARY_MONITOR"
  dispatch_focus_monitor "$SECONDARY_MONITOR"

  # Restore xrandr primary based on screen state
  "$HOME/.config/hypr/scripts/restore-xrandr-primary.sh" "$PRIMARY_MONITOR" "$SECONDARY_MONITOR"

  echo "$next_layout" > "$LAYOUT_FILE"
  "$RESTORE_STATE_SCRIPT"
  exit
fi

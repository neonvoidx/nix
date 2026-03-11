#!/usr/bin/env bash
INTERNAL_MONITOR="DP-2"
EXTERNAL_MONITOR="DP-3"
WORKSPACES_TO_MOVE=(1 2 4 5 6 7 8 9 10 11) # everything but discord/spotify workspace
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
GAMESCREEN_STATE_FILE="$STATE_DIR/gamescreen"
SCREEN_STATE_FILE="$STATE_DIR/screen"
HDR_STATE_FILE="$STATE_DIR/hdr"
LAYOUT_FILE="$STATE_DIR/monitor-layout"

mkdir -p "$STATE_DIR"

move_all_workspaces_to_monitor() {
  # Get the list of existing workspace IDs
  existing_workspaces=$(hyprctl workspaces -j | jq '.[].id')

  for workspace in "${WORKSPACES_TO_MOVE[@]}"; do
    if echo "$existing_workspaces" | grep -q -w "$workspace"; then
      hyprctl dispatch moveworkspacetomonitor "$workspace" "$1"
    fi
  done
}

if [ "$1" = "1" ]; then
  xrandr --output "$INTERNAL_MONITOR" --primary
  # Enable internal monitor
  if [ -f "$GAMESCREEN_STATE_FILE" ]; then
    hyprctl keyword source "$HOME/.config/hypr/hyprland/monitors/monitors-notouch.conf"
    # hyprctl keyword source "$HOME/.config/hypr/hyprland/monitors/monitors-notouch-nohdr.conf"
  else
    hyprctl keyword source "$HOME/.config/hypr/hyprland/monitors/monitors.conf"
    # hyprctl keyword source "$HOME/.config/hypr/hyprland/monitors/monitors-nohdr.conf"
  fi
  move_all_workspaces_to_monitor "$INTERNAL_MONITOR"
  hyprctl dispatch moveworkspacetomonitor 2 "$EXTERNAL_MONITOR"
  hyprctl dispatch moveworkspacetomonitor 4 "$EXTERNAL_MONITOR"
  hyprctl dispatch moveworkspacetomonitor 5 "$INTERNAL_MONITOR"
  echo "both" > "$SCREEN_STATE_FILE"

  # Persist chosen layout in a single file so it can be restored after nix rebuild.
  if [ -f "$HDR_STATE_FILE" ]; then
    if [ -f "$GAMESCREEN_STATE_FILE" ]; then
      echo "notouch-nohdr" > "$LAYOUT_FILE"
    else
      echo "default-nohdr" > "$LAYOUT_FILE"
    fi
  else
    if [ -f "$GAMESCREEN_STATE_FILE" ]; then
      echo "notouch" > "$LAYOUT_FILE"
    else
      echo "default" > "$LAYOUT_FILE"
    fi
  fi
  exit
else
  xrandr --output "$EXTERNAL_MONITOR" --primary
  # Disable internal monitor
  if [ -f "$GAMESCREEN_STATE_FILE" ]; then
    hyprctl keyword source "$HOME/.config/hypr/hyprland/monitors/monitors-work-notouch.conf"
    # hyprctl keyword source "$HOME/.config/hypr/hyprland/monitors/monitors-work-notouch-nohdr.conf"
  else
    hyprctl keyword source "$HOME/.config/hypr/hyprland/monitors/monitors-work.conf"
    # hyprctl keyword source "$HOME/.config/hypr/hyprland/monitors/monitors-work-nohdr.conf"
  fi
  move_all_workspaces_to_monitor "$EXTERNAL_MONITOR"
  echo "external" > "$SCREEN_STATE_FILE"

  if [ -f "$HDR_STATE_FILE" ]; then
    if [ -f "$GAMESCREEN_STATE_FILE" ]; then
      echo "work-notouch-nohdr" > "$LAYOUT_FILE"
    else
      echo "work-nohdr" > "$LAYOUT_FILE"
    fi
  else
    if [ -f "$GAMESCREEN_STATE_FILE" ]; then
      echo "work-notouch" > "$LAYOUT_FILE"
    else
      echo "work" > "$LAYOUT_FILE"
    fi
  fi
  exit
fi

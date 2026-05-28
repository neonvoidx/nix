#!/usr/bin/env bash
PRIMARY_MONITOR="DP-2"
SECONDARY_MONITOR="DP-3"
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

move_all_workspaces_to_monitor() {
  # Get the list of existing workspace IDs
  existing_workspaces=$(hyprctl workspaces -j | jq '.[].id')

  for workspace in "${WORKSPACES_TO_MOVE[@]}"; do
    if echo "$existing_workspaces" | grep -q -w "$workspace"; then
      hyprctl eval "move_workspace_to_monitor($(printf '%s' "$workspace" | jq -Rr @json), $(printf '%s' "$1" | jq -Rr @json))" >/dev/null 2>&1 || true
    fi
  done
}

if [ "$1" = "1" ]; then
  echo "both" > "$SCREEN_STATE_FILE"
  xrandr --output "$PRIMARY_MONITOR" --primary
  # Enable both monitors
  case "$current_layout" in
    work-notouch) next_layout="notouch" ;;
    work) next_layout="default" ;;
    *) next_layout="$current_layout" ;;
  esac
  "$APPLY_SCRIPT" "$next_layout"

  # Let monitors settle before moving workspaces (DP-2 may be re-enabling)
  sleep 0.5

  # Enforce workspace-to-monitor bindings after layout transition.
  # The layout re-config may momentarily shuffle workspaces; explicitly
  # place every workspace back on its designated monitor.
  hyprctl eval "
    move_workspace_to_monitor(\"1\", $(printf '%s' "$PRIMARY_MONITOR" | jq -Rr @json))
    move_workspace_to_monitor(\"2\", $(printf '%s' "$SECONDARY_MONITOR" | jq -Rr @json))
    move_workspace_to_monitor(\"3\", \"HDMI-A-1\")
    move_workspace_to_monitor(\"4\", $(printf '%s' "$SECONDARY_MONITOR" | jq -Rr @json))
    move_workspace_to_monitor(\"5\", $(printf '%s' "$PRIMARY_MONITOR" | jq -Rr @json))
    move_workspace_to_monitor(\"6\", $(printf '%s' "$PRIMARY_MONITOR" | jq -Rr @json))
    move_workspace_to_monitor(\"7\", $(printf '%s' "$PRIMARY_MONITOR" | jq -Rr @json))
    move_workspace_to_monitor(\"8\", $(printf '%s' "$PRIMARY_MONITOR" | jq -Rr @json))
    move_workspace_to_monitor(\"9\", $(printf '%s' "$PRIMARY_MONITOR" | jq -Rr @json))
    move_workspace_to_monitor(\"10\", $(printf '%s' "$PRIMARY_MONITOR" | jq -Rr @json))
    move_workspace_to_monitor(\"11\", $(printf '%s' "$PRIMARY_MONITOR" | jq -Rr @json))
  " >/dev/null 2>&1 || true
  # Persist chosen layout in a single file so it can be restored after nix rebuild.
  echo "$next_layout" > "$LAYOUT_FILE"
  exit
else
  echo "external" > "$SCREEN_STATE_FILE"
  xrandr --output "$SECONDARY_MONITOR" --primary
  # Disable the primary monitor and keep the secondary active
  case "$current_layout" in
    notouch) next_layout="work-notouch" ;;
    default) next_layout="work" ;;
    *) next_layout="$current_layout" ;;
  esac
  "$APPLY_SCRIPT" "$next_layout"
  # Let monitors settle (DP-2 being disabled may shuffle workspaces)
  sleep 0.5
  move_all_workspaces_to_monitor "$SECONDARY_MONITOR"
  echo "$next_layout" > "$LAYOUT_FILE"
  exit
fi

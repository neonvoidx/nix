#!/usr/bin/env bash

set -euo pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
LAYOUT_FILE="$STATE_DIR/monitor-layout"

MON_DIR="$HOME/.config/hypr/hyprland/monitors"

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
  default) file="$MON_DIR/monitors.conf" ;;
  notouch) file="$MON_DIR/monitors-notouch.conf" ;;
  work) file="$MON_DIR/monitors-work.conf" ;;
  work-notouch) file="$MON_DIR/monitors-work-notouch.conf" ;;
  default-nohdr) file="$MON_DIR/monitors-nohdr.conf" ;;
  notouch-nohdr) file="$MON_DIR/monitors-notouch-nohdr.conf" ;;
  work-nohdr) file="$MON_DIR/monitors-work-nohdr.conf" ;;
  work-notouch-nohdr) file="$MON_DIR/monitors-work-notouch-nohdr.conf" ;;
  *) file="$MON_DIR/monitors.conf" ;;
esac

if [ -f "$file" ]; then
  # Use || true so set -e doesn't abort if hyprctl exits non-zero
  hyprctl keyword source "$file" >/dev/null || true
  # Let monitors settle before dispatching workspace
  sleep 0.5
fi

"$HOME/.config/hypr/scripts/restore-xrandr-primary.sh"

# Restore focused workspace
WORKSPACE_FILE="$STATE_DIR/active-workspace"
if [ -f "$WORKSPACE_FILE" ]; then
  workspace=$(tr -d '\n' < "$WORKSPACE_FILE")
  if [ -n "$workspace" ]; then
    hyprctl dispatch workspace "$workspace" >/dev/null
  fi
fi

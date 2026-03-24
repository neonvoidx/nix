#!/usr/bin/env bash
# Daemon: listens to Hyprland's event socket and persists the active workspace
# so restore-monitor-layout.sh can re-focus it after a config reload/rebuild.
# Run via exec-once (single instance, survives config reloads).

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
WORKSPACE_FILE="$STATE_DIR/active-workspace"

mkdir -p "$STATE_DIR"

SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

socat -u UNIX-CONNECT:"$SOCK" - | while IFS= read -r line; do
  case "$line" in
    workspace>>*)
      printf '%s' "${line#workspace>>}" > "$WORKSPACE_FILE"
      ;;
  esac
done

#!/usr/bin/env bash
# Daemon: listens to Hyprland's event socket and:
# - persists the active workspace on workspace change events
# - re-applies saved monitor layout + workspace after config reloads
# Run via exec-once (single instance, survives config reloads).

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
WORKSPACE_FILE="$STATE_DIR/active-workspace"

mkdir -p "$STATE_DIR"

SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

# Reconnect loop: socat exits if the pipe breaks; restart it automatically.
while true; do
  # Wait for socket to exist (handles brief unavailability at startup)
  while [ ! -S "$SOCK" ]; do
    sleep 0.5
  done

  socat -u UNIX-CONNECT:"$SOCK" - 2>/dev/null | while IFS= read -r line; do
    case "$line" in
      workspace>>*)
        printf '%s' "${line#workspace>>}" > "$WORKSPACE_FILE"
        ;;
      configreloaded>>*)
        # Give Hyprland time to finish applying the new config before restoring state.
        sleep 0.5
        "$HOME/.config/hypr/scripts/restore-monitor-layout.sh" &
        ;;
    esac
  done

  sleep 1
done

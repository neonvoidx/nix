#!/usr/bin/env bash
# Daemon: listens to Hyprland's event socket and:
# - persists the active workspace on workspace change events
# - re-applies saved monitor layout + workspace after config reloads
# Run via exec-once (single instance, survives config reloads).

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
WORKSPACE_FILE="$STATE_DIR/active-workspace"
WINDOW_FILE="$STATE_DIR/active-window"

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
      "workspace>>"*)
        printf '%s' "${line#workspace>>}" > "$WORKSPACE_FILE"
        ;;
      "activewindow>>"*)
        window_info="${line#activewindow>>}"
        window_addr="${window_info%%,*}"
        if [ -n "$window_addr" ]; then
          printf 'address:%s' "$window_addr" > "$WINDOW_FILE"
        fi
        ;;
      "configreloaded>>"*)
        # Snapshot the current workspace + window NOW, before Hyprland's own
        # post-reload workspace shuffling overwrites the state file.
        SAVE_STATE="$HOME/.config/hypr/scripts/save-state.sh"
        if [ -x "$SAVE_STATE" ]; then
          "$SAVE_STATE"
        fi
        # Give Hyprland time to finish applying the new config before restoring state.
        sleep 0.5
        "$HOME/.config/hypr/scripts/restore-monitor-layout.sh" &
        ;;
    esac
  done

  sleep 1
done

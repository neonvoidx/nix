#!/usr/bin/env bash

PRIMARY_MON="${1:-DP-2}"
SECONDARY_MON="${2:-DP-3}"

STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/hypr/screen"

if [ "$(cat "$STATE_FILE" 2>/dev/null | tr -d '\n')" = "external" ]; then
  xrandr --output "$SECONDARY_MON" --primary
else
  xrandr --output "$PRIMARY_MON" --primary
fi

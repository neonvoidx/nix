#!/usr/bin/env bash

STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/hypr/screen"

if [ "$(cat "$STATE_FILE" 2>/dev/null | tr -d '\n')" = "external" ]; then
  xrandr --output DP-3 --primary
else
  xrandr --output DP-2 --primary
fi

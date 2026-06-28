#!/usr/bin/env bash

STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/hypr/screen"

if [ "$(cat "$STATE_FILE" 2>/dev/null | tr -d '\n')" = "external" ]; then
  xrandr --output DP-3 --primary
  notify-send "xrandr primary set to DP-3" -t 2000
else
  xrandr --output DP-2 --primary
  notify-send "xrandr primary set to DP-2" -t 2000
fi

#!/usr/bin/env bash
# Toggle HDR on/off

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
HDR_STATE_FILE="$STATE_DIR/hdr"
GAMESCREEN_STATE_FILE="$STATE_DIR/gamescreen"
SCREEN_STATE_FILE="$STATE_DIR/screen"
LAYOUT_FILE="$STATE_DIR/monitor-layout"

mkdir -p "$STATE_DIR"

# Determine current screen state
SCREEN_STATE="both"
if [ -f "$SCREEN_STATE_FILE" ]; then
    SCREEN_STATE=$(cat "$SCREEN_STATE_FILE")
fi

# Determine gaming mode state
GAMING_MODE=false
if [ -f "$GAMESCREEN_STATE_FILE" ]; then
    GAMING_MODE=true
fi

# Check current HDR state (default is ON = with HDR)
if [ -f "$HDR_STATE_FILE" ]; then
    # Currently HDR is OFF, switch back to HDR enabled
    if [ "$SCREEN_STATE" = "both" ]; then
        if [ "$GAMING_MODE" = true ]; then
            hyprctl keyword source "$HOME/.config/hypr/hyprland/monitors/monitors-notouch.conf"
        else
            hyprctl keyword source "$HOME/.config/hypr/hyprland/monitors/monitors.conf"
        fi
    else
        # external monitor only
        if [ "$GAMING_MODE" = true ]; then
            hyprctl keyword source "$HOME/.config/hypr/hyprland/monitors/monitors-work-notouch.conf"
        else
            hyprctl keyword source "$HOME/.config/hypr/hyprland/monitors/monitors-work.conf"
        fi
    fi
    rm -f "$HDR_STATE_FILE"
    # keep overall layout selection in sync (best-effort)
    if [ "$SCREEN_STATE" = "both" ]; then
      if [ "$GAMING_MODE" = true ]; then
        echo "notouch" > "$LAYOUT_FILE"
      else
        echo "default" > "$LAYOUT_FILE"
      fi
    else
      if [ "$GAMING_MODE" = true ]; then
        echo "work-notouch" > "$LAYOUT_FILE"
      else
        echo "work" > "$LAYOUT_FILE"
      fi
    fi
    notify-send "HDR" "Enabled" -t 2000
else
    # Currently HDR is ON, switch to HDR disabled
    if [ "$SCREEN_STATE" = "both" ]; then
        if [ "$GAMING_MODE" = true ]; then
            hyprctl keyword source "$HOME/.config/hypr/hyprland/monitors/monitors-notouch-nohdr.conf"
        else
            hyprctl keyword source "$HOME/.config/hypr/hyprland/monitors/monitors-nohdr.conf"
        fi
    else
        # external monitor only
        if [ "$GAMING_MODE" = true ]; then
            hyprctl keyword source "$HOME/.config/hypr/hyprland/monitors/monitors-work-notouch-nohdr.conf"
        else
            hyprctl keyword source "$HOME/.config/hypr/hyprland/monitors/monitors-work-nohdr.conf"
        fi
    fi
    : > "$HDR_STATE_FILE"
    if [ "$SCREEN_STATE" = "both" ]; then
      if [ "$GAMING_MODE" = true ]; then
        echo "notouch-nohdr" > "$LAYOUT_FILE"
      else
        echo "default-nohdr" > "$LAYOUT_FILE"
      fi
    else
      if [ "$GAMING_MODE" = true ]; then
        echo "work-notouch-nohdr" > "$LAYOUT_FILE"
      else
        echo "work-nohdr" > "$LAYOUT_FILE"
      fi
    fi
    notify-send "HDR" "Disabled" -t 2000
fi

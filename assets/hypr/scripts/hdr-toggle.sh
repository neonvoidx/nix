#!/usr/bin/env bash
# Toggle HDR on/off

HDR_STATE_FILE="/tmp/hypr-hdr-state"
GAMESCREEN_STATE_FILE="/tmp/hypr-gamescreen-state"
SCREEN_STATE_FILE="/tmp/hypr-screen-state"

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
    rm "$HDR_STATE_FILE"
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
    touch "$HDR_STATE_FILE"
    notify-send "HDR" "Disabled" -t 2000
fi

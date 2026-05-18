#!/usr/bin/env bash
# Toggle monitors not touching for gaming

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
STATE_FILE="$STATE_DIR/gamescreen"
LAYOUT_FILE="$STATE_DIR/monitor-layout"
APPLY_SCRIPT="$HOME/.config/hypr/scripts/apply-monitor-layout.sh"

mkdir -p "$(dirname "$STATE_FILE")"

current_layout="default"
if [ -f "$LAYOUT_FILE" ]; then
    current_layout=$(tr -d '\n' < "$LAYOUT_FILE")
fi

apply_layout() {
    local layout="$1"
    echo "$layout" > "$LAYOUT_FILE"
    "$APPLY_SCRIPT" "$layout"
}

# Check current state (default is OFF = using the default layout)
if [ -f "$STATE_FILE" ]; then
    case "$current_layout" in
        notouch) apply_layout default ;;
        work-notouch) apply_layout work ;;
        *) apply_layout "$current_layout" ;;
    esac
    rm -f "$STATE_FILE"
    notify-send "Monitor Layout" "Switched to default (touching)" -t 2000
else
    case "$current_layout" in
        default) apply_layout notouch ;;
        work) apply_layout work-notouch ;;
        *) apply_layout "$current_layout" ;;
    esac
    : > "$STATE_FILE"
    notify-send "Monitor Layout" "Switched to gaming (not touching)" -t 2000
fi

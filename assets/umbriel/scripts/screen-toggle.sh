#!/usr/bin/env bash

MODE="${1:-}"
PRIMARY_OUTPUT="${UMBRIEL_PRIMARY_OUT:-}"
SECONDARY_OUTPUT="${UMBRIEL_SECONDARY_OUT:-}"

if [[ "$MODE" != "0" && "$MODE" != "1" ]]; then
  echo "Usage: $0 [1|0]"
  exit 1
fi

if [[ -z "$PRIMARY_OUTPUT" ]]; then
  echo "Umbriel primary output is not configured"
  exit 1
fi

move_steam() {
  local output="$1"
  local active_window
  local steam_window

  active_window=$(umbriel windows --json | jq -r '.[] | select(.active) | .id')
  while IFS= read -r steam_window; do
    [[ -z "$steam_window" ]] && continue
    umbriel msg "window-focus:${steam_window}"
    umbriel msg "window-move-to-workspace-silent:2/${output}"
  done < <(umbriel windows --json | jq -r '.[] | select(.app_id == "steam") | .id')

  [[ -z "$active_window" ]] || umbriel msg "window-focus:${active_window}"
}

if [[ "$MODE" == "1" ]]; then
  notify-send "Enabling ${PRIMARY_OUTPUT} (Umbriel)"
  umbriel msg "output-enable:${PRIMARY_OUTPUT}"
  move_steam "$PRIMARY_OUTPUT"
  exit
fi

notify-send "Disabling ${PRIMARY_OUTPUT} (Umbriel)"
if [[ -n "$SECONDARY_OUTPUT" ]]; then
  move_steam "$SECONDARY_OUTPUT"
fi
umbriel msg "output-disable:${PRIMARY_OUTPUT}"

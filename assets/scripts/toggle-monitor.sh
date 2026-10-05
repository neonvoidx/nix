#!/usr/bin/env bash

DM="${XDG_CURRENT_DESKTOP}"

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 [1|0]"
  exit 1
fi

ARG="$1"

if [[ "$DM" == "Umbriel" ]] || \
       [[ -n "${UMBRIEL_SOCKET:-}" ]] || \
       [[ -S "${XDG_RUNTIME_DIR:-}/umbriel-${WAYLAND_DISPLAY:-}.sock" ]]; then
  echo "Umbriel detected"
  bash ~/.config/umbriel/scripts/screen-toggle.sh "$ARG"
else
  echo "Unknown display manager/compositor"
  exit 1
fi

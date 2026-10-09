#!/usr/bin/env bash
# Toggle the primary output.

MODE="${1:-}"
PRIMARY_OUTPUT="${UMBRIEL_PRIMARY_OUT:-}"

if [[ "$MODE" != "0" && "$MODE" != "1" ]]; then
  echo "Usage: $0 [1|0]"
  exit 1
fi

if [[ -z "$PRIMARY_OUTPUT" ]]; then
  echo "Umbriel primary output is not configured"
  exit 1
fi

if [[ "$MODE" == "1" ]]; then
  notify-send "Enabling ${PRIMARY_OUTPUT} (Umbriel)"
  umbriel msg "output-enable:${PRIMARY_OUTPUT}"
  exit
fi

notify-send "Disabling ${PRIMARY_OUTPUT} (Umbriel)"
umbriel msg "output-disable:${PRIMARY_OUTPUT}"

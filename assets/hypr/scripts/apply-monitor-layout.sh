#!/usr/bin/env bash

set -euo pipefail

hypr_eval() {
  hyprctl eval "$1" >/dev/null || true
}

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <layout>" >&2
  exit 1
fi

layout="$1"
layout_key="${layout//-/_}"

if ! hyprctl -j monitors >/dev/null 2>&1; then
  exit 0
fi

hypr_eval "apply_monitor_layout($(printf '%s' "$layout_key" | jq -Rr @json))"

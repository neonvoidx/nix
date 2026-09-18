#!/usr/bin/env bash
# Jump back to the last focused workspace tracked by workspace-history.sh.
set -euo pipefail

state_file="${XDG_STATE_HOME:-$HOME/.local/state}/umbriel/workspace-history.json"
[[ -f "$state_file" ]] || exit 0

previous_name="$(jq -r '.previous.name // empty' "$state_file")"
previous_output="$(jq -r '.previous.output // empty' "$state_file")"

if [[ -z "$previous_name" || -z "$previous_output" ]]; then
  exit 0
fi

umbriel_bin="${UMBRIEL_BIN:-umbriel}"
"$umbriel_bin" msg "workspace-switch:${previous_name}/${previous_output}" >/dev/null 2>&1

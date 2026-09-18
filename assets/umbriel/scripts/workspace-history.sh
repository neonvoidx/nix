#!/usr/bin/env bash
# Track every focused workspace so a helper can jump back to the global last workspace.
set -euo pipefail

umbriel_bin="${UMBRIEL_BIN:-umbriel}"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/umbriel"
state_file="$state_dir/workspace-history.json"
mkdir -p "$state_dir"

previous="null"
current="null"

write_state() {
  tmp="$(mktemp "$state_dir/workspace-history.XXXXXX")"
  printf '{"previous":%s,"current":%s}\n' "$previous" "$current" >"$tmp"
  mv "$tmp" "$state_file"
}

write_state

"$umbriel_bin" subscribe workspaces | while IFS= read -r line; do
  entry="$(jq -c '.data[] | select(.focused) | {name,output,index,layout}' <<<"$line")" || continue
  [[ -n "$entry" ]] || continue

  if [[ "$current" != "null" ]]; then
    previous="$current"
  fi
  current="$entry"
  write_state
done

#!/usr/bin/env bash
# Keep Discord and Spotify in separate portrait scrolling lanes: Discord first
# at 75% of the strip and Spotify second at 25%. Both use dynamic workspace 1.
set -euo pipefail

umbriel_bin="${UMBRIEL_BIN:-umbriel}"
portrait_output="${UMBRIEL_PORTRAIT_OUT:-}"
[[ -n "$portrait_output" ]] || exit 0
last_pair=""

socket="${UMBRIEL_SOCKET:-}"
if [[ -z "$socket" ]]; then
  runtime_dir="${XDG_RUNTIME_DIR:-/run/user/$UID}"
  display="${WAYLAND_DISPLAY:-wayland-0}"
  socket="$runtime_dir/umbriel-${display}.sock"
fi
[[ -S "$socket" ]] || exit 0
export UMBRIEL_SOCKET="$socket"

layout_pair() {
  local workspaces windows ws_id pair discord_id spotify_id discord_y spotify_y restore_id
  workspaces="$("$umbriel_bin" workspaces --json)" || return 1
  ws_id="$(jq -r --arg out "$portrait_output" '
    .[] | select(.output == $out and .index == 1) | .id
  ' <<<"$workspaces")"
  [[ -n "$ws_id" ]] || return 0

  windows="$("$umbriel_bin" windows --json)" || return 1
  pair="$(jq -r --arg ws "$ws_id" '
    def main_window($app):
      [.[] | select(.workspace == $ws and .app_id == $app
        and (.floating // false | not) and (.scratchpad // "") == ""
        and (.title // "") != "Discord Popout")]
      | max_by(.w * .h) | .id // empty;
    [main_window("discord"), main_window("spotify")] | @tsv
  ' <<<"$windows")"
  IFS=$'\t' read -r discord_id spotify_id <<<"$pair"
  [[ -n "$discord_id" && -n "$spotify_id" ]] || return 0

  # `windows` also fires for focus and geometry changes. Only arrange a new
  # pair, otherwise these IPC actions would continuously trigger themselves.
  [[ "$pair" != "$last_pair" ]] || return 0
  last_pair="$pair"

  discord_y="$(jq -r --arg id "$discord_id" '.[] | select(.id == $id) | .y' <<<"$windows")"
  spotify_y="$(jq -r --arg id "$spotify_id" '.[] | select(.id == $id) | .y' <<<"$windows")"

  # The portrait output has a horizontal workspace axis, so its scrolling strip
  # is vertical. Only take focus when Discord must be moved to the first lane;
  # the opening rules assign both lane extents without IPC focus changes.
  if (( ${discord_y%.*} > ${spotify_y%.*} )); then
    restore_id="$(jq -r '.[] | select(.active) | .id' <<<"$windows")"
    "$umbriel_bin" msg "window-focus:$discord_id" >/dev/null
    "$umbriel_bin" msg window-move-up >/dev/null
    [[ -z "$restore_id" ]] || "$umbriel_bin" msg "window-focus:$restore_id" >/dev/null || true
  fi
}

# Apply on startup and after either main window is replaced, without reacting
# to ordinary focus, geometry, or title events.
while IFS= read -r _; do
  layout_pair || break
done < <("$umbriel_bin" subscribe windows)

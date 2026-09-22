#!/usr/bin/env bash
# Keep Discord and Spotify in separate portrait scrolling lanes: Discord first
# at 75% of the strip and Spotify second at 25%. Both use dynamic workspace 1.
set -euo pipefail

umbriel_bin="${UMBRIEL_BIN:-umbriel}"
portrait_output="${UMBRIEL_PORTRAIT_OUT:-}"
[[ -n "$portrait_output" ]] || exit 0

socket="${UMBRIEL_SOCKET:-}"
if [[ -z "$socket" ]]; then
  runtime_dir="${XDG_RUNTIME_DIR:-/run/user/$UID}"
  display="${WAYLAND_DISPLAY:-wayland-0}"
  socket="$runtime_dir/umbriel-${display}.sock"
fi
[[ -S "$socket" ]] || exit 0
export UMBRIEL_SOCKET="$socket"

layout_pair() {
  local workspaces windows ws_id pair discord_id spotify_id discord_y spotify_y discord_h spotify_h restore_id
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

  # Actions work on the focused window, so restore the user's focus afterward.
  restore_id="$(jq -r '.[] | select(.active) | .id' <<<"$windows")"
  discord_y="$(jq -r --arg id "$discord_id" '.[] | select(.id == $id) | .y' <<<"$windows")"
  spotify_y="$(jq -r --arg id "$spotify_id" '.[] | select(.id == $id) | .y' <<<"$windows")"
  discord_h="$(jq -r --arg id "$discord_id" '.[] | select(.id == $id) | .h' <<<"$windows")"
  spotify_h="$(jq -r --arg id "$spotify_id" '.[] | select(.id == $id) | .h' <<<"$windows")"

  # Ignore the window events emitted by the actions below once the pair is
  # already ordered and within a small rounding tolerance of 75/25.
  if (( ${discord_y%.*} < ${spotify_y%.*} )); then
    local total_height=$(( ${discord_h%.*} + ${spotify_h%.*} ))
    if (( total_height > 0 && ${discord_h%.*} * 100 >= total_height * 70 && ${discord_h%.*} * 100 <= total_height * 80 )); then
      return 0
    fi
  fi

  "$umbriel_bin" msg "window-focus:$discord_id" >/dev/null
  # The portrait output has a horizontal workspace axis, so its scrolling strip
  # is vertical. Moving up puts Discord in the first lane.
  if (( ${discord_y%.*} > ${spotify_y%.*} )); then
    "$umbriel_bin" msg window-move-up >/dev/null
  fi
  "$umbriel_bin" msg window-set-primary-extent:0.75 >/dev/null
  "$umbriel_bin" msg "window-focus:$spotify_id" >/dev/null
  "$umbriel_bin" msg window-set-primary-extent:0.25 >/dev/null

  [[ -z "$restore_id" ]] || "$umbriel_bin" msg "window-focus:$restore_id" >/dev/null || true
}

# Reapply after replacements, restores, and remaps without defining persistent
# workspaces.
while IFS= read -r _; do
  layout_pair || break
done < <("$umbriel_bin" subscribe windows)

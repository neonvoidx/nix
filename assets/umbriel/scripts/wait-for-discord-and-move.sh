#!/usr/bin/env bash
# Keep Discord above Spotify when either main window opens on the portrait.
# We do this in the master layout by promoting the stack window into master,
# then sizing the two rows 75/25.
set -euo pipefail

umbriel_bin="${UMBRIEL_BIN:-umbriel}"
socket="${UMBRIEL_SOCKET:-}"
if [[ -z "$socket" ]]; then
  runtime_dir="${XDG_RUNTIME_DIR:-/run/user/$UID}"
  display="${WAYLAND_DISPLAY:-wayland-0}"
  candidate="$runtime_dir/umbriel-${display}.sock"
  if [[ -S "$candidate" ]]; then
    socket="$candidate"
    export UMBRIEL_SOCKET="$socket"
  fi
fi
if [[ -z "$socket" || ! -S "$socket" ]]; then
  echo "Umbriel socket not found; skip Discord layout helper." >&2
  exit 0
fi
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/umbriel"
[[ -f "$config_dir/layout.env" ]] || exit 0
# shellcheck source=/dev/null
source "$config_dir/layout.env"
[[ -n "${UMBRIEL_PORTRAIT_OUT:-}" ]] || exit 0

last_pair=""
"$umbriel_bin" subscribe windows | while IFS= read -r _event; do
  # Query fresh state: our own actions can queue older subscription snapshots.
  workspaces="$("$umbriel_bin" workspaces --json)" || break
  ws_id="$(jq -r --arg out "$UMBRIEL_PORTRAIT_OUT" '
    .[] | select(.name == "13" and .output == $out) | .id
  ' <<<"$workspaces")"
  [[ -n "$ws_id" ]] || continue
  windows="$("$umbriel_bin" windows --json)" || break
  pair="$(jq -r --arg ws "$ws_id" '
    [.[] | select(.workspace == $ws and (.floating // false) == false
      and (.scratchpad // "") == "" and .w > 0 and .h > 0
      and (.title // "") != "Discord Popout")] as $windows |
    ([$windows[] | select(.app_id == "discord")] | max_by(.w * .h)) as $d |
    ([$windows[] | select(.app_id == "spotify")] | max_by(.w * .h)) as $s |
    if $d != null and $s != null then [$d.id, $s.id] | @tsv else empty end
  ' <<<"$windows")"
  [[ -n "$pair" && "$pair" != "$last_pair" ]] || continue
  IFS=$'\t' read -r discord_id spotify_id <<<"$pair"

  # active is seat-global; focused remembers one window on every workspace.
  restore_id="$(jq -r '.[] | select(.active) | .id' <<<"$windows")"
  restore_workspace="$(jq -r '.[] | select(.focused) |
    if .named then "workspace-switch:\(.name | tojson)/\(.output)"
    else "workspace-switch:\(.index)/\(.output)" end
  ' <<<"$workspaces")"

  # Mark before acting so an action failure cannot loop on our own focus events.
  last_pair="$pair"
  # Arrange the pair into master rows: Discord on top (75%), Spotify on bottom (25%).
  if "$umbriel_bin" msg "window-focus:$discord_id" &&
     "$umbriel_bin" msg layout-master-count-increase >/dev/null &&
     "$umbriel_bin" msg window-move-up >/dev/null &&
     "$umbriel_bin" msg "window-set-secondary-extent:0.75" >/dev/null &&
     "$umbriel_bin" msg "window-focus:$spotify_id" &&
     "$umbriel_bin" msg window-move-down >/dev/null &&
     "$umbriel_bin" msg "window-set-secondary-extent:0.25" >/dev/null; then
    :
  else
    echo "Could not arrange Discord/Spotify; retry on their next launch." >&2
  fi
  if [[ -n "$restore_id" ]]; then
    "$umbriel_bin" msg "window-focus:$restore_id" >/dev/null || true
  elif [[ -n "$restore_workspace" ]]; then
    "$umbriel_bin" msg "$restore_workspace" >/dev/null || true
  fi
done

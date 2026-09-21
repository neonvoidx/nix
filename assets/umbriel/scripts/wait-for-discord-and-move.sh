#!/usr/bin/env bash
# Keep Discord above Spotify when either main window opens on the portrait.
# We don't rely on scrolling layout. Instead we force both windows into the
# same master-layout area so they stack vertically, then size their rows 75/25.
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
while IFS= read -r _event; do
  # Query fresh state: our own actions can queue older subscription snapshots.
  workspaces="$("$umbriel_bin" workspaces --json)" || break
  ws_id="$(jq -r --arg out "$UMBRIEL_PORTRAIT_OUT" --arg ws "$UMBRIEL_PORTRAIT_WORKSPACE" '
    .[] | select(.name == $ws and .output == $out) | .id
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
  [[ -n "$pair" ]] || continue
  IFS=$'\t' read -r discord_id spotify_id <<<"$pair"

  # The same windows may be rearranged when Umbriel restores the session after
  # sleep or unlock. Skip ordinary updates, but repair a pair that became
  # side-by-side again.
  if [[ "$pair" == "$last_pair" ]]; then
    x_d_current="$(jq -r --arg id "$discord_id" '.[] | select(.id == $id) | .x // empty' <<<"$windows")"
    x_s_current="$(jq -r --arg id "$spotify_id" '.[] | select(.id == $id) | .x // empty' <<<"$windows")"
    if [[ -n "$x_d_current" && -n "$x_s_current" ]] && (( ${x_d_current%.*} - ${x_s_current%.*} < 80 && ${x_s_current%.*} - ${x_d_current%.*} < 80 )); then
      continue
    fi
  fi

  # active is seat-global; focused remembers one window on every workspace.
  restore_id="$(jq -r '.[] | select(.active) | .id' <<<"$windows")"
  restore_workspace="$(jq -r '.[] | select(.focused) |
    if .named then "workspace-switch:\(.name | tojson)/\(.output)"
    else "workspace-switch:\(.index)/\(.output)" end
  ' <<<"$workspaces")"

  # Mark before acting so an action failure cannot loop on our own focus events.
  last_pair="$pair"

  # Ensure actions run against the portrait chat workspace.
  # (Focusing a window by id may not always switch workspaces depending on focus policies.)
  "$umbriel_bin" msg "workspace-switch:\"$UMBRIEL_PORTRAIT_WORKSPACE\"/$UMBRIEL_PORTRAIT_OUT" >/dev/null || true
  # If they're side-by-side (master+stack), move the leftmost window into the stack so the stack becomes full-width
  # and both windows become vertical rows.
  left_id=""

  # Compute positions fresh (the subscription can be stale vs our actions).
  windows_now="$("$umbriel_bin" windows --json)" || break
  x_d="$(jq -r --arg id "$discord_id" '.[] | select(.id == $id) | .x // empty' <<<"$windows_now")"
  x_s="$(jq -r --arg id "$spotify_id" '.[] | select(.id == $id) | .x // empty' <<<"$windows_now")"
  y_d="$(jq -r --arg id "$discord_id" '.[] | select(.id == $id) | .y // empty' <<<"$windows_now")"
  y_s="$(jq -r --arg id "$spotify_id" '.[] | select(.id == $id) | .y // empty' <<<"$windows_now")"

  # If x differs a lot, they're arranged left/right (master+stack). Move the master window into the stack
  # so the stack becomes full-width and the two windows become vertical rows.
  if [[ -n "$x_d" && -n "$x_s" ]] && (( ${x_d%.*} - ${x_s%.*} > 80 || ${x_s%.*} - ${x_d%.*} > 80 )); then
    w_d="$(jq -r --arg id "$discord_id" '.[] | select(.id == $id) | .w // empty' <<<"$windows_now")"
    w_s="$(jq -r --arg id "$spotify_id" '.[] | select(.id == $id) | .w // empty' <<<"$windows_now")"

    if [[ -n "$w_d" && -n "$w_s" ]] && (( ${w_d%.*} < ${w_s%.*} )); then
      # Right window is wider: treat it as master and move it into stack.
      right_id="$discord_id"
      if (( ${x_s%.*} > ${x_d%.*} )); then
        right_id="$spotify_id"
      fi
      "$umbriel_bin" msg "window-focus:$right_id" >/dev/null || true
      "$umbriel_bin" msg window-consume-left >/dev/null || true
    else
      # Default: left window is master (master.position = "left").
      if (( ${x_d%.*} < ${x_s%.*} )); then
        left_id="$discord_id"
      else
        left_id="$spotify_id"
      fi
      "$umbriel_bin" msg "window-focus:$left_id" >/dev/null || true
      "$umbriel_bin" msg window-consume-right >/dev/null || true
    fi

    sleep 0.15
  fi

  # Re-query after a potential consume.
  windows_now="$("$umbriel_bin" windows --json)" || break
  x_d="$(jq -r --arg id "$discord_id" '.[] | select(.id == $id) | .x // empty' <<<"$windows_now")"
  x_s="$(jq -r --arg id "$spotify_id" '.[] | select(.id == $id) | .x // empty' <<<"$windows_now")"
  y_d="$(jq -r --arg id "$discord_id" '.[] | select(.id == $id) | .y // empty' <<<"$windows_now")"
  y_s="$(jq -r --arg id "$spotify_id" '.[] | select(.id == $id) | .y // empty' <<<"$windows_now")"

  # Order and size the rows when they're stacked (roughly same x).
  if [[ -n "$x_d" && -n "$x_s" ]] && (( ${x_d%.*} - ${x_s%.*} < 80 && ${x_s%.*} - ${x_d%.*} < 80 )); then
    # Ensure Discord is above Spotify.
    if [[ -n "$y_d" && -n "$y_s" ]] && (( ${y_d%.*} > ${y_s%.*} )); then
      "$umbriel_bin" msg "window-focus:$discord_id" >/dev/null || true
      "$umbriel_bin" msg window-move-up >/dev/null || true
    fi

    "$umbriel_bin" msg "window-focus:$discord_id" >/dev/null || true
    "$umbriel_bin" msg "window-set-secondary-extent:0.75" >/dev/null || true
    "$umbriel_bin" msg "window-focus:$spotify_id" >/dev/null || true
    "$umbriel_bin" msg "window-set-secondary-extent:0.25" >/dev/null || true

  else
    echo "Discord/Spotify did not end up stacked; leaving as-is." >&2
  fi
  if [[ -n "$restore_id" ]]; then
    "$umbriel_bin" msg "window-focus:$restore_id" >/dev/null || true
  elif [[ -n "$restore_workspace" ]]; then
    "$umbriel_bin" msg "$restore_workspace" >/dev/null || true
  fi

done < <("$umbriel_bin" subscribe windows)

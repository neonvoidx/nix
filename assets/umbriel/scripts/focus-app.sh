#!/usr/bin/env bash
# Focus the first open window matching an application, using Umbriel's IPC.
# usage: umbriel-focus-app.sh app <app_id> [<excluded_title_regex>]
#        umbriel-focus-app.sh game
set -euo pipefail

umbriel_bin="${UMBRIEL_BIN:-umbriel}"
mode="${1:?usage: umbriel-focus-app.sh app <app_id> [excluded_title] | umbriel-focus-app.sh game}"

socket="${UMBRIEL_SOCKET:-}"
if [[ -z "$socket" ]]; then
  runtime_dir="${XDG_RUNTIME_DIR:-/run/user/$UID}"
  display="${WAYLAND_DISPLAY:-wayland-0}"
  socket="$runtime_dir/umbriel-${display}.sock"
fi
[[ -S "$socket" ]] || exit 0
export UMBRIEL_SOCKET="$socket"

if [[ "$mode" == "game" ]]; then
  app=""
else
  app="${2:?usage: umbriel-focus-app.sh app <app_id> [excluded_title]}"
fi
excluded_title="${3:-}"

windows="$("$umbriel_bin" windows --json)" || exit 1

id="$(
  jq -r --arg mode "$mode" --arg app "$app" --arg excl "$excluded_title" '
    def is_game:
      (.app_id | test("^(steam_app_.*|gamescope|wow[.]exe)$"))
      or ((.title // "") | test("^(World of Warcraft|FINAL FANTASY XIV|Hytale)"));
    def wanted:
      if $mode == "game" then
        is_game and ((.title // "") != "SplashScreen")
      else
        .app_id == $app and ($excl == "" or (((.title // "") | test($excl)) | not))
      end;
    [.[] | select(wanted and ((.scratchpad // "") == "") and ((.app_id // "") != ""))]
      | if $mode == "game" then sort_by(-(.w * .h)) else . end
      | .[0].id // empty
  ' <<<"$windows"
)" || exit 1

[[ -n "$id" ]] || exit 0
"$umbriel_bin" msg "window-focus:$id" >/dev/null
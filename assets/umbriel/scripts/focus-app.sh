#!/usr/bin/env bash
# Focus an existing Steam, game, or Thunderbird window without assuming its workspace.
set -euo pipefail

case "${1:-}" in
steam | game | thunderbird | discord) target="$1" ;;
*)
  echo "usage: $0 steam|game|thunderbird" >&2
  exit 2
  ;;
esac

umbriel_bin="${UMBRIEL_BIN:-umbriel}"
window_id="$("$umbriel_bin" windows --json | jq -r --arg target "$target" '
  [.[] | select(.w > 0 and .h > 0 and (.scratchpad // "") == "") |
    (.app_id // "") as $app | (.title // "") as $title |
    select(
      if $target == "steam" then
        $app == "steam" and ($title | test("^notificationtoasts"; "i") | not)
        elif $target == "thunderbird" then
          $app == "thunderbird" and ($title | test("Reminder"; "i") | not)
        elif $target == "discord" then
          $app == "discord" and ($title | test("Discord Popout"; "i") | not)
      else
        (($app | test("^(steam_app_.*|gamescope|wow[.]exe)$"))
          or ($title | test("FINAL FANTASY XIV|World of Warcraft|Hytale|[(]DEBUG[)]")))
        and ($title | test("SplashScreen|^Gifts$|^Battle[.]net|^notificationtoasts"; "i") | not)
      end
    )]
  | sort_by([
      (if $target == "steam" and .title == "Steam" then 1 else 0 end),
      (if .active then 1 else 0 end),
      (.w * .h)
    ])
  | last | .id // empty
')"

if [[ -z "$window_id" ]]; then
  echo "No open $target window found." >&2
  exit 0
fi
"$umbriel_bin" msg "window-focus:$window_id"

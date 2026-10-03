#!/usr/bin/env bash
# Toggle the primary output. Games are routed explicitly so they land on
# workspace 2 of the primary output (enabled) or the secondary output
# (disabled) and never on the portrait output.

MODE="${1:-}"
PRIMARY_OUTPUT="${UMBRIEL_PRIMARY_OUT:-}"
SECONDARY_OUTPUT="${UMBRIEL_SECONDARY_OUT:-}"
GAME_WORKSPACE=2

if [[ "$MODE" != "0" && "$MODE" != "1" ]]; then
  echo "Usage: $0 [1|0]"
  exit 1
fi

if [[ -z "$PRIMARY_OUTPUT" ]]; then
  echo "Umbriel primary output is not configured"
  exit 1
fi

# Games to migrate: same identity test as focus-app.sh. Steam's own windows
# are excluded because they live in the global 'steam' scratchpad, and
# SplashScreen is part of the Steam client rather than a game.
game_windows() {
  umbriel windows --json | jq -r --arg from "$1" '
    def is_game:
      (.app_id // "" | test("^(steam_app_.*|gamescope|wow[.]exe)$"))
      or ((.title // "") | test("^(World of Warcraft|FINAL FANTASY XIV|Hytale)"))
      or (.content_type == "game")
      or (.xdg_tag == "proton-game");
    def not_client:
      ((.title // "") != "SplashScreen") and ((.scratchpad // "") == "");
    [.[] | select(is_game and not_client) | select(.workspace != $from) | .id][]
  '
}

move_games() {
  local output="$1"
  local active_window
  local game_window

  # Nothing to route to when there is no secondary output to fall back on.
  [[ -n "$output" ]] || return 0

  active_window=$(umbriel windows --json | jq -r '.[] | select(.active) | .id')
  while IFS= read -r game_window; do
    [[ -z "$game_window" ]] && continue
    umbriel msg "window-focus:${game_window}"
    umbriel msg "window-move-to-workspace-silent:${GAME_WORKSPACE}/${output}"
  done < <(game_windows "${output}:${GAME_WORKSPACE}")

  [[ -z "$active_window" ]] || umbriel msg "window-focus:${active_window}"
}

if [[ "$MODE" == "1" ]]; then
  notify-send "Enabling ${PRIMARY_OUTPUT} (Umbriel)"
  umbriel msg "output-enable:${PRIMARY_OUTPUT}"
  move_games "$PRIMARY_OUTPUT"
  exit
fi

notify-send "Disabling ${PRIMARY_OUTPUT} (Umbriel)"
move_games "$SECONDARY_OUTPUT"
umbriel msg "output-disable:${PRIMARY_OUTPUT}"
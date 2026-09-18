# Umbriel - Things I want/need

## Window rule to constrain cursor

- Hyprland has a way to confine cursor to certain windows. Example flow in Hyprland window rules:

```
# Set all steam launched games to have content type "game"
                              hl.window_rule({ name = "steamgames", match = { class = "^steam_app_.*$" }, workspace = "11", fullscreen = true, content="game"})

# Set confine_pointer = true for all windows with content set to "game"
                              hl.window_rule({ match = { content = "game", fullscreen = true }, confine_pointer = true })

```

- Explanation of above:
  - If matches specific rules, i.e class = `steam_app*`, I set the content type to game
  - I then have a window rule for any content type game matches, which sets confine_pointer
  - All games no longer allow cursor to leave window naturally without hitting a bind to focus another window or workspace
- Workarounds (but not ideal):
  - Have a "gaming mode" toggle script where you move monitors 1px apart from each other in multi monitor setups, so cursor cant leave naturally, but this requires a manual toggling and detoggling when gaming or leaving gaming
  - Use gamescope which comes with a bunch of other quirks I don't want

## Mouse dragging windows

- Maybe a config error on my part, but when I try to Mod + left mouse button drag windows in a horizontal axis layout, it only lets me drag the window above or below existing windows and not to the left or right?

## Workspace Overview

- Option to hide empty workspaces?

# TODOs

- animations & shaders, need shaders for rest, tweaking time etc
- check out other noctalia/umbriel actions we can bind/use

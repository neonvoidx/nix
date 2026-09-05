{ den, ... }:
{
  den.aspects.ghostty.homeManager =
    { config, ... }:
    {
      programs.ghostty = {
        enable = true;
        enableZshIntegration = true;

        settings = {
          # Font — same as kitty
          font-family = "NeonMono";
          font-size = 16;

          # Cursor
          cursor-style = "block";
          cursor-style-blink = true;
          # cursor trail via custom shader (kitty had cursor_trail)
          custom-shader = "~/.config/ghostty/cursor_warp.glsl";

          # Background/Window
          background-opacity = 0.97;
          background-blur-radius = 20;
          window-decoration = false;
          window-padding-x = 12;
          window-padding-y = 12;
          window-vsync = true;
          window-inherit-working-directory = true;
          window-theme = "ghostty";
          window-save-state = "always";
          confirm-close-surface = false;
          class = "ghostty";

          # Scrollback
          scrollback-limit = 10000;

          # Shell integration
          shell-integration = "detect";
          shell-integration-features = "cursor,sudo,title,ssh-env,ssh-terminfo";

          # Clipboard
          clipboard-write = "allow";
          clipboard-read = "allow";
          clipboard-trim-trailing-spaces = true;
          clipboard-paste-protection = false;
          clipboard-paste-bracketed-safe = true;
          copy-on-select = "clipboard";

          # Misc
          link-previews = true;
          underline-hyperlinks = "always";
          image-storage-limit = 4000000000;

          keybind = [
            # Copy/Paste
            "ctrl+shift+c=copy_to_clipboard"
            "ctrl+shift+v=paste_from_clipboard"

            # Font management
            "ctrl+shift+plus=increase_font_size:1"
            "ctrl+shift+minus=decrease_font_size:1"

            # Reload config
            "ctrl+shift+r=reload_config"

            # Scrolling
            "ctrl+shift+up=scroll_page_up"
            "ctrl+shift+down=scroll_page_down"

            # Fullscreen
            "f11=toggle_fullscreen"
          ];
        };
      };

      home.file.".config/ghostty/cursor_warp.glsl".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/ghostty/cursor_warp.glsl";
    };
}
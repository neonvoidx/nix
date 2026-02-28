{ ... }:
{
  flake.modules.homeManager.ghostty =
    { config, ... }:
    {
      programs.ghostty = {
        enable = false;
        settings = {
          theme = "eldritch";
          background-opacity = 0.99;
          cursor-style = "bar";
          class = "ghostty";
          window-padding-x = "0,0";
          window-padding-y = "0,0";
          window-vsync = true;
          window-inherit-working-directory = true;
          window-decoration = false;
          window-theme = "ghostty";
          shell-integration = "detect";
          gtk-tabs-location = "bottom";
          gtk-wide-tabs = false;
          window-show-tab-bar = "always";
          shell-integration-features = "cursor,sudo,title,ssh-env,ssh-terminfo";
          window-save-state = "always";
          clipboard-write = "allow";
          clipboard-read = "allow";
          clipboard-trim-trailing-spaces = true;
          clipboard-paste-protection = false;
          clipboard-paste-bracketed-safe = true;
          image-storage-limit = 4000000000;
          copy-on-select = "clipboard";
          confirm-close-surface = false;
          link-previews = true;
          custom-shader = "shaders/cursor_warp.glsl";
          gtk-custom-css = "~/.config/ghostty/gtk.css";
          keybind = [
            "ctrl+shift+c=copy_to_clipboard"
            "ctrl+shift+v=paste_from_clipboard"
            "ctrl+shift+plus=increase_font_size:1"
            "ctrl+shift+minus=decrease_font_size:1"
            "ctrl+shift+r=reload_config"
            "ctrl+t>c=new_tab"
            "ctrl+t>n=next_tab"
            "ctrl+t>p=previous_tab"
            "ctrl+t>x=close_surface"
            "ctrl+t>b=new_split:down"
            "ctrl+t>v=new_split:right"
            "ctrl+t>1=goto_tab:1"
            "ctrl+t>2=goto_tab:2"
            "ctrl+t>3=goto_tab:3"
            "ctrl+t>4=goto_tab:4"
            "ctrl+t>5=goto_tab:5"
            "ctrl+t>6=goto_tab:6"
            "ctrl+t>7=goto_tab:7"
            "ctrl+t>8=goto_tab:8"
            "ctrl+t>9=goto_tab:9"
            "ctrl+t>h=goto_split:left"
            "ctrl+t>j=goto_split:bottom"
            "ctrl+t>k=goto_split:top"
            "ctrl+t>l=goto_split:right"
            "ctrl+t>shift+h=resize_split:left,100"
            "ctrl+t>shift+j=resize_split:down,100"
            "ctrl+t>shift+k=resize_split:up,100"
            "ctrl+t>shift+l=resize_split:right,100"
            "ctrl+t>enter=toggle_split_zoom"
          ];
        };
        themes = {
          eldritch = {
            background = "#212337";
            foreground = "#ebfafa";
            cursor-color = "#f8f8f2";
            cursor-text = "#37f499";
            selection-background = "#bf4f8e";
            selection-foreground = "#ebfafa";
            palette = [
              "0=#21222c"
              "1=#f9515d "
              "2=#37f499 "
              "3=#e9f941 "
              "4=#9071f4 "
              "5=#f265b5 "
              "6=#04d1f9 "
              "7=#ebfafa "
              "8=#7081d0 "
              "9=#f16c75 "
              "10=#69F8B3"
              "11=#f1fc79"
              "12=#a48cf2"
              "13=#FD92CE"
              "14=#66e4fd"
              "15=#ffffff"
            ];
          };
        };
      };
      home.file.".config/ghostty/gtk.css".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/ghostty/gtk.css";
      home.file.".config/ghostty/cursor_warp.glsl".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/ghostty/cursor_warp.glsl";
    };
}

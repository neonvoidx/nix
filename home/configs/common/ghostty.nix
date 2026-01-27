{ ... }:
{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "eldritch";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 16;
      background-opacity = 0.99;
      cursor-style = "bar";
      class = "ghostty";
      window-padding-x = "0,0";
      window-padding-y = "0,0";
      window-vsync = true;
      window-inherit-working-directory = true;
      window-decoration = false;
      macos-titlebar-style = "hidden";
      window-theme = "ghostty";
      shell-integration = "detect";
      gtk-tabs-location = "bottom";
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
  home.file.".config/ghostty/gtk.css" = {
    text = ''
      /*
      debug: env GTK_DEBUG=interactive ghostty
      https://docs.gtk.org/gtk4/css-overview.html
      https://docs.gtk.org/gtk4/css-properties.html
      */
      headerbar {
        margin: 0;
        padding: 0;
        min-height: 20px;
      }

      tabbar tabbox {
        margin: 0;
        padding: 0;
        min-height: 10px;
        background-color: #1a1a1a;
        font-family: JetBrainsMono Nerd Font;
      }

      tabbar tabbox tab {
        margin: 0;
        padding: 0;
        color: #9ca3af;
        border-right: 1px solid #374151;
      }

      tabbar tabbox tab:selected {
        background-color: #2d2d2d;
        color: #ffffff;
      }

      tabbar tabbox tab label {
        font-size: 14px;
        font-weight: bold;
      }
    '';
  };
}

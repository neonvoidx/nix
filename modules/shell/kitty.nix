{ den, ... }:
{
  den.aspects.kitty.homeManager =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      programs.kitty = {
        enable = true;

        themeFile = "Eldritch";

        actionAliases = {
          "kitty_scrollback_nvim" = "kitten ${config.xdg.configHome}/kitty/kitty_scrollback_nvim.py";
        };

        font = {
          name = "NeonMono";
          size = 16;
        };

        settings = {
          clipboard_control = "write-clipboard write-primary read-clipboard read-primary";

          copy_on_select = "clipboard";

          auto_reload_config = -1;

          # Font settings
          bold_font = "auto";
          italic_font = "auto";
          disable_ligatures = "never";

          # Cursor
          cursor_trail = 3;

          # Shaders
          custom_shaders = "cursor-trail-blaze";

          # Symbol map for Nerd Fonts
          symbol_map = "U+e000-U+e00a,U+ea60-U+ebeb,U+e0a0-U+e0c8,U+e0ca,U+e0cc-U+e0d4,U+e200-U+e2a9,U+e300-U+e3e3,U+e5fa-U+e6b1,U+e700-U+e7c5,U+f000-U+f2e0,U+f300-U+f372,U+f400-U+f532,U+f0001-U+f1af0 Symbols Nerd Font Mono";

          # Kitty modifier key
          kitty_mod = "ctrl+shift";

          # Cursor
          cursor_shape = "block";
          cursor_blink_interval = 1;

          # Scrollback
          scrollback_lines = 10000;
          scrollback_pager = "less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER";
          scrollback_pager_history_size = 4096;

          # Mouse
          url_style = "dotted";
          open_url_with = "default";
          url_prefixes = "file ftp ftps gemini git gopher http https irc ircs kitty mailto news sftp ssh";
          detect_urls = true;
          underline_hyperlinks = "always";
          paste_actions = "quote-urls-at-prompt";
          focus_follows_mouse = false;

          # Performance Tuning
          repaint_delay = 1;
          input_delay = 1;
          sync_to_monitor = true;

          # Terminal bell
          enable_audio_bell = false;
          visual_bell_duration = 0;
          bell_on_tab = "  ";

          # Window layout
          enabled_layouts = "splits,stack";
          remember_window_size = true;
          draw_minimal_borders = true;
          window_border_width = "0.5pt";
          window_padding_width = 1;
          window_margin_width = 0;
          single_window_margin_width = 1;
          inactive_text_alpha = "1.0";
          single_window_padding_width = 0;
          background_opacity = "0.97";
          hide_window_decorations = "titlebar-only";
          confirm_os_window_close = 0;
          background_blur = 20;

          # Tab bar
          tab_bar_margin_width = 9;
          tab_bar_margin_height = "5 5";
          tab_bar_style = "separator";
          tab_fade = "0";
          tab_bar_min_tabs = 2;

          # Advanced
          editor = ".";
          allow_remote_control = true;
          listen_on = "unix:/tmp/mykitty";
          update_check_interval = 6;
          clipboard_max_size = 512;
          allow_hyperlinks = true;
          shell_integration = "no-title";
          term = "xterm-kitty";

          # OS Specific Tweaks
          linux_display_server = "wayland";

          # Miscellaneous
          undercurl_style = "thick-sparse";
          show_hyperlink_targets = true;
          window_resize_step_lines = 5;
        };

        # tab separator being empty string in nix, causes HM to evaluate and use default kitty instead
        extraConfig = ''
          # tab_separator set via extraConfig to ensure kitty receives `tab_separator ""`
          tab_separator ""

          tab_title_template "{fmt.fg._323449}{fmt.bg.default}{fmt.fg._04d1f9}{fmt.bg.default}{index}{fmt.fg._04d1f9}{fmt.bg._323449} {title} {fmt.fg._323449}{fmt.bg.default} "
          active_tab_title_template "{fmt.fg._37f499}{fmt.bg.default}{fmt.fg._212337}{fmt.bg._37f499}{fmt.fg._212337}{fmt.bg._37f499} {title} {fmt.fg._37f499}{fmt.bg.default} "
        '';

        keybindings = {
          # Disable some defaults
          "cmd+enter" = "no_op";
          "ctrl+tab" = "no_op";
          "cmd+`" = "no_op";

          # Copy/Paste
          "kitty_mod+c" = "copy_to_clipboard";
          "kitty_mod+v" = "paste_from_clipboard";

          # Scrolling
          "kitty_mod+up" = "scroll_page_up";
          "kitty_mod+down" = "scroll_page_down";

          # Shell integration
          "kitty_mod+j" = "scroll_to_prompt 1";
          "kitty_mod+k" = "scroll_to_prompt -1";
          "kitty_mod+o" = "show_last_command_output";

          # Zellij owns C-t and C-h/j/k/l; let its keyboard protocol
          # negotiation preserve modified keys such as Shift+Enter.

          # Scrollback with nvim
          "kitty_mod+h" = "kitty_scrollback_nvim";
          "kitty_mod+g" = "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";

          # Font Management
          "kitty_mod+plus" = "change_font_size all +1.0";
          "kitty_mod+minus" = "change_font_size all -1.0";

          # Miscellaneous
          "f11" = "toggle_fullscreen";
          "f12" = "kitten unicode_input --tab name --emoji-variation graphic";
          "kitty_mod+r" = "load_config_file";
          "kitty_mod+e" = "open_url_with_hints";

          # Marks
          "f1" = "toggle_marker text 1 TEST";
          "f2" = "toggle_marker text 2 ERROR";
          "ctrl+shift+t" = "set_tab_title \" \"";
        };

        mouseBindings = {
          "right click" = "grabbed,ungrabbed paste_from_clipboard";
          "ctrl+shift+right press" =
            "ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output";
        };
      };
      programs.zsh.shellAliases = {
        icat = "kitten icat";
        ssh = "kitten ssh";
        d = "kitten diff";
      };

      # Overrides the shipped cursor-trail-blaze.pipeline (kitty resolves the
      # config-dir one first) to recolor the trail via its static const vars.
      xdg.configFile."kitty/shaders/cursor-trail-blaze.pipeline".text = ''
        # Eldritch colors baked in linear RGB (kitty shaders run in linear space).
        # TRAIL_COLOR = Great Old One Green #37f499 (matches theme cursor)
        # TRAIL_COLOR_ACCENT = Watery Tomb Blue #04d1f9
        startgroup
            var float4 TRAIL_COLOR = float4(0.0382, 0.9047, 0.3185, 1.0)
            var float4 TRAIL_COLOR_ACCENT = float4(0.0012, 0.6376, 0.9473, 1.0)
            animation_start cursor-trail-move
            animation_stop cursor-trail-stop
            shaders cursor-trail-blaze
        endgroup
      '';

      xdg.configFile."kitty/kitty_scrollback_nvim.py".source =
        ../../assets/kitty/kitty_scrollback_nvim.py;
      xdg.configFile."kitty/kitty_scroll_prompt.py".source = ../../assets/kitty/kitty_scroll_prompt.py;
    };
}

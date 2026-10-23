{ den, ... }:
{
  den.aspects.zellij.homeManager =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      c = config.lib.stylix.colors.withHashtag;
      autolock = pkgs.zellijPlugins.autolock;
      zextract = pkgs.fetchurl {
        url = "https://github.com/codingfragments/zellij-zextract/releases/download/v0.4.0/zextract.wasm";
        hash = "sha256-LnneanEAK2IcBo6kIyuzyuPt9nb/mSjL0+AC22eh/BA=";
      };
      whichKey = pkgs.fetchurl {
        url = "https://github.com/johnae/zj-which-key/releases/download/v0.2.0/zj_which_key.wasm";
        hash = "sha256-Hi7cOGIS6gWIE5mo0GcgYDiR/+CnxTq1prMPJvyfyfs=";
      };
      zellij = "${config.programs.zellij.package}/bin/zellij";
    in
    {
      programs.zellij = {
        enable = true;
        enableZshIntegration = false;
        attachExistingSession = true;
        settings = {
          default_layout = "default";
          default_mode = "normal";
          support_kitty_keyboard_protocol = true;
          on_force_close = "detach";
          session_serialization = true;
          pane_viewport_serialization = false;
          show_startup_tips = false;
          show_release_notes = false;
          scroll_buffer_size = 10000;
          copy_on_select = true;
          copy_command = "${pkgs.wl-clipboard}/bin/wl-copy";
        };
        themes.stylix.themes.default = {
          ribbon_unselected = {
            background = lib.mkForce c.base00;
            base = lib.mkForce c.base0C;
          };
          text_unselected = {
            background = lib.mkForce c.base00;
            base = lib.mkForce c.base04;
          };
        };
        layouts.default = ''
          layout {
            default_tab_template {
              children
              pane size=1 borderless=true {
                plugin location="file:${pkgs.zellijPlugins.zjstatus}" {
                  format_left "{mode}#[fg=${c.base0C},bg=${c.base00},bold] {session} "
                  format_center "{tabs}"
                  format_space "#[bg=${c.base00}]"
                  format_hide_on_overlength "true"
                  format_precedence "lrc"

                  mode_normal "#[fg=${c.base00},bg=${c.base0C},bold] NORMAL "
                  mode_locked "#[fg=${c.base00},bg=${c.base0B},bold] APP "
                  mode_pane "#[fg=${c.base00},bg=${c.base0E},bold] PANE "
                  mode_move "#[fg=${c.base00},bg=${c.base0E},bold] MOVE "
                  mode_tab "#[fg=${c.base00},bg=${c.base0E},bold] TAB "
                  mode_resize "#[fg=${c.base00},bg=${c.base0A},bold] RESIZE "
                  mode_rename_tab "#[fg=${c.base00},bg=${c.base0E},bold] RENAME "
                  mode_scroll "#[fg=${c.base00},bg=${c.base0E},bold] SCROLL "
                  mode_enter_search "#[fg=${c.base00},bg=${c.base0E},bold] SEARCH "
                  mode_search "#[fg=${c.base00},bg=${c.base0E},bold] SEARCH "
                  mode_default_to_mode "normal"

                  tab_normal "#[fg=${c.base04},bg=${c.base00}] {index} {name} "
                  tab_active "#[fg=${c.base00},bg=${c.base0B},bold] {index} {name} "
                  tab_separator " "
                  border_enabled "false"
                  hide_frame_for_single_pane "false"
                }
              }
            }
            tab name="home" focus=true { pane cwd=${builtins.toJSON config.home.homeDirectory}; }
            tab name="nix" { pane cwd=${builtins.toJSON config.dotfiles.checkoutPath}; }
          }
        '';
        extraConfig = ''
          plugins {
            autolock location="file:${autolock}"
            zextract location="file:${zextract}"
          }
          // Default autolock rules give every foreground app its keys,
          // unlocking at shell prompts. No Enter interception or polling shell.
          load_plugins {
            autolock
            "file:${whichKey}" {
              auto_show "true"
              delay_secs "0.4"
              position "bottom-right"
              max_height_pct "90"
            }
          }
          keybinds clear-defaults=true {
            normal {
              bind "Ctrl h" { MoveFocus "Left"; }
              bind "Ctrl j" { MoveFocus "Down"; }
              bind "Ctrl k" { MoveFocus "Up"; }
              bind "Ctrl l" { MoveFocus "Right"; }
            }
            shared_except "pane" {
              bind "Ctrl t" { SwitchToMode "Pane"; }
            }
            // Navigation that remains available in every foreground app.
            shared {
              bind "Alt Left" { MoveFocus "Left"; }
              bind "Alt Down" { MoveFocus "Down"; }
              bind "Alt Up" { MoveFocus "Up"; }
              bind "Alt Right" { MoveFocus "Right"; }
            }
            pane {
              bind "Ctrl t" "Esc" "Enter" { SwitchToMode "Normal"; }
              bind "v" { NewPane "Right"; SwitchToMode "Normal"; }
              bind "b" { NewPane "Down"; SwitchToMode "Normal"; }
              bind "x" { CloseFocus; SwitchToMode "Normal"; }
              bind "z" { ToggleFocusFullscreen; SwitchToMode "Normal"; }
              bind "f" { ToggleFloatingPanes; SwitchToMode "Normal"; }
              bind "h" "Left" { MoveFocus "Left"; SwitchToMode "Normal"; }
              bind "j" "Down" { MoveFocus "Down"; SwitchToMode "Normal"; }
              bind "k" "Up" { MoveFocus "Up"; SwitchToMode "Normal"; }
              bind "l" "Right" { MoveFocus "Right"; SwitchToMode "Normal"; }
              bind "c" { NewTab; SwitchToMode "Normal"; }
              bind "n" { GoToNextTab; SwitchToMode "Normal"; }
              bind "p" { GoToPreviousTab; SwitchToMode "Normal"; }
              bind "1" { GoToTab 1; SwitchToMode "Normal"; }
              bind "2" { GoToTab 2; SwitchToMode "Normal"; }
              bind "3" { GoToTab 3; SwitchToMode "Normal"; }
              bind "4" { GoToTab 4; SwitchToMode "Normal"; }
              bind "5" { GoToTab 5; SwitchToMode "Normal"; }
              bind "6" { GoToTab 6; SwitchToMode "Normal"; }
              bind "7" { GoToTab 7; SwitchToMode "Normal"; }
              bind "8" { GoToTab 8; SwitchToMode "Normal"; }
              bind "9" { GoToTab 9; SwitchToMode "Normal"; }
              bind "/" { SwitchToMode "EnterSearch"; SearchInput 0; }
              bind "]" { EditScrollback; SwitchToMode "Normal"; }
              bind "[" { SwitchToMode "Scroll"; }
              bind "m" { SwitchToMode "Move"; }
              bind "t" { SwitchToMode "Tab"; }
              bind "r" { SwitchToMode "Resize"; }
              bind "," { SwitchToMode "RenameTab"; TabNameInput 0; }
              bind "d" { Detach; }
              bind "\\" {
                LaunchOrFocusPlugin "zextract" { floating true; move_to_focused_tab true; }
                SwitchToMode "Normal"
              }
              bind "?" {
                LaunchOrFocusPlugin "file:${whichKey}" {
                  floating true
                  move_to_focused_tab true
                  role "browser"
                }
                SwitchToMode "Normal"
              }
              bind "o" {
                LaunchOrFocusPlugin "zellij:session-manager" { floating true; move_to_focused_tab true; }
                SwitchToMode "Normal"
              }
            }
            scroll {
              bind "j" "Down" { ScrollDown; }
              bind "k" "Up" { ScrollUp; }
              bind "Ctrl f" "PageDown" { PageScrollDown; }
              bind "Ctrl b" "PageUp" { PageScrollUp; }
              bind "Ctrl d" { HalfPageScrollDown; }
              bind "Ctrl u" { HalfPageScrollUp; }
              bind "g" { ScrollToTop; }
              bind "G" { ScrollToBottom; }
              bind "/" { SwitchToMode "EnterSearch"; SearchInput 0; }
              bind "Esc" "q" { ScrollToBottom; SwitchToMode "Normal"; }
            }
            entersearch {
              bind "Enter" { SwitchToMode "Search"; }
              bind "Esc" "Ctrl c" { ScrollToBottom; SwitchToMode "Normal"; }
            }
            search {
              bind "n" { Search "down"; }
              bind "N" "p" { Search "up"; }
              bind "/" { SwitchToMode "EnterSearch"; SearchInput 0; }
              bind "j" "Down" { ScrollDown; }
              bind "k" "Up" { ScrollUp; }
              bind "Ctrl f" "PageDown" { PageScrollDown; }
              bind "Ctrl b" "PageUp" { PageScrollUp; }
              bind "Ctrl d" { HalfPageScrollDown; }
              bind "Ctrl u" { HalfPageScrollUp; }
              bind "c" { SearchToggleOption "CaseSensitivity"; }
              bind "w" { SearchToggleOption "Wrap"; }
              bind "o" { SearchToggleOption "WholeWord"; }
              bind "Esc" "Ctrl c" { ScrollToBottom; SwitchToMode "Normal"; }
            }
            move {
              bind "n" { BreakPaneRight; SwitchToMode "Normal"; }
              bind "p" { BreakPaneLeft; SwitchToMode "Normal"; }
              bind "c" { BreakPane; SwitchToMode "Normal"; }
              bind "h" "Left" { MovePane "Left"; }
              bind "j" "Down" { MovePane "Down"; }
              bind "k" "Up" { MovePane "Up"; }
              bind "l" "Right" { MovePane "Right"; }
              bind "Esc" "Enter" { SwitchToMode "Normal"; }
            }
            tab {
              bind "," { SwitchToMode "RenameTab"; TabNameInput 0; }
              bind "Esc" "Enter" { SwitchToMode "Normal"; }
            }
            resize {
              bind "h" "Left" { Resize "Increase Left"; }
              bind "j" "Down" { Resize "Increase Down"; }
              bind "k" "Up" { Resize "Increase Up"; }
              bind "l" "Right" { Resize "Increase Right"; }
              bind "-" { Resize "Decrease"; }
              bind "+" "=" { Resize "Increase"; }
              bind "Esc" "Enter" { SwitchToMode "Normal"; }
            }
            renametab {
              bind "Esc" { UndoRenameTab; SwitchToMode "Normal"; }
              bind "Enter" { SwitchToMode "Normal"; }
            }
          }
        '';
      };

      # Popup grants otherwise overwrite the controller's larger cached request.
      home.activation.zellij-which-key-permissions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${pkgs.python3}/bin/python3 ${../../assets/zellij/ensure-plugin-permissions.py} \
          ${lib.escapeShellArg "${config.xdg.cacheHome}/zellij/permissions.kdl"} ${whichKey}
      '';

      xdg.configFile."zellij/zextract.kdl".text = ''
        ui { preview "off" }
      '';

      # `s` opens the built-in manager inside Zellij, or attaches outside it.
      programs.zsh.initContent = lib.mkAfter ''
        function zellij() {
          if [[ "''${1:-}" != action ]]; then
            ${pkgs.python3}/bin/python3 ${../../assets/zellij/ensure-plugin-permissions.py} \
              ${lib.escapeShellArg "${config.xdg.cacheHome}/zellij/permissions.kdl"} ${whichKey} || return
          fi
          command ${zellij} "$@"
        }
        function s() {
          if [[ -n "''${ZELLIJ:-}" ]]; then
            zellij action launch-or-focus-plugin zellij:session-manager --floating
          else
            zellij attach --create home
          fi
        }
        if [[ -o interactive && -t 0 && -t 1 && -z "''${ZELLIJ:-}" && -z "''${TMUX:-}" && -z "''${DEVENV_ROOT:-}" && -z "''${SSH_CONNECTION:-}" ]]; then
          zellij attach --create home
        fi
        alias zj="zellij"
      '';
    };
}

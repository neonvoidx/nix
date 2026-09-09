{ den, inputs, ... }:
{
  den.aspects.tmux.homeManager =
    { config, pkgs, ... }:
    let
      c = config.lib.stylix.colors;
      nvim = inputs.nvim-config.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      # Adds a wrapper script for resurrect to use persistence nvim when restoring neovim
      home.file.".local/bin/tmux-resurrect-nvim".source = pkgs.writeShellScript "tmux-resurrect-nvim" ''
        exec ${nvim}/bin/nvim -c 'lua require("persistence").load()'
      '';

      programs = {
        tmux = {
          enable = true;
          prefix = "C-t";
          keyMode = "vi";
          customPaneNavigationAndResize = false;
          mouse = true;
          baseIndex = 1;
          newSession = true;
          escapeTime = 0;
          terminal = "tmux-256color";
          shell = "${pkgs.zsh}/bin/zsh";
          historyLimit = 10000;

          # Declarative plugins (no tpm needed; each is packaged in nixpkgs)
          plugins = [
            { plugin = pkgs.tmuxPlugins.sensible; }
            { plugin = pkgs.tmuxPlugins.yank; }
            { plugin = pkgs.tmuxPlugins.better-mouse-mode; }
            {
              plugin = pkgs.tmuxPlugins.resurrect;
              extraConfig = ''
                # Nix records an absolute nvim command, so use Resurrect's
                # substring matcher and load the cwd-specific persistence.nvim session.
                set -g @resurrect-processes 'ssh "~nvim->~/.local/bin/tmux-resurrect-nvim" "opencode->opencode *"'
                # Pane-content replay races process restoration and can leave
                # a shell displaying stale output instead of the restored app.
                set -g @resurrect-capture-pane-contents 'off'
              '';
            }
            {
              plugin = pkgs.tmuxPlugins.continuum;
              extraConfig = ''
                set -g @continuum-restore 'on'
                set -g @continuum-save-interval '5'
              '';
            }
          ];

          extraConfig = ''
            # Pane indexes must stay tidy because the status plugin runs on renumbering.
            set -g renumber-windows on
            setw -g pane-base-index 1

            # Allows passing of keys like ctrl+enter shift+enter etc
            set -g extend-keys on

            # Pane border
            set -g pane-border-style fg=#${c.base02}
            set -g pane-active-border-style fg=#${c.base0C}

            # Message / command prompt
            set -g message-style bg=#${c.base0C},fg=#${c.base00}
            set -g message-command-style bg=#${c.base0C},fg=#${c.base00}

            # Mode (copy-mode) indicator
            set -g mode-style bg=#${c.base0C},fg=#${c.base00}

            # -------------------------------------------------
            # Keybindings
            # -------------------------------------------------

            # Reload config
            bind R source-file ~/.config/tmux/tmux.conf \; display-message 'tmux.conf reloaded'

            # Splits (open in current pane directory)
            #   v = vertical split (side-by-side), b = horizontal split (stacked)
            bind v split-window -h -c '#{pane_current_path}'
            bind b split-window -v -c '#{pane_current_path}'

            # Terminal windows
            bind c new-window -c '#{pane_current_path}'

            # Kill pane without prompt
            bind x kill-pane

            # Swap panes
            bind '{' swap-pane -U
            bind '}' swap-pane -D

            # Zoom
            bind z resize-pane -Z
            bind m resize-pane -Z

            # Resize bindings (shift+hjkl)
            bind H resize-pane -L 5
            bind J resize-pane -D 5
            bind K resize-pane -U 5
            bind L resize-pane -R 5

            # Smart pane navigation with Neovim-split awareness (smart-splits.nvim).
            # '@pane-is-vim' is a pane-local option set by smart-splits on load; when
            # the pane runs neovim the key is forwarded so nvim can move between its
            # own splits first, otherwise tmux selects the adjacent pane directly.
            bind-key -n C-h if -F "#{@pane-is-vim}" 'send-keys C-h' 'select-pane -L'
            bind-key -n C-j if -F "#{@pane-is-vim}" 'send-keys C-j' 'select-pane -D'
            bind-key -n C-k if -F "#{@pane-is-vim}" 'send-keys C-k' 'select-pane -U'
            bind-key -n C-l if -F "#{@pane-is-vim}" 'send-keys C-l' 'select-pane -R'

            # Smart pane resize with Neovim-split awareness (Ctrl+Shift+hjkl)
            bind-key -n C-S-h if -F "#{@pane-is-vim}" 'send-keys C-S-h' 'resize-pane -L 3'
            bind-key -n C-S-j if -F "#{@pane-is-vim}" 'send-keys C-S-j' 'resize-pane -D 3'
            bind-key -n C-S-k if -F "#{@pane-is-vim}" 'send-keys C-S-k' 'resize-pane -U 3'
            bind-key -n C-S-l if -F "#{@pane-is-vim}" 'send-keys C-S-l' 'resize-pane -R 3'

            # Interactive resize mode: prefix+r, then hjkl / arrows to resize,
            # q / Esc / Enter to exit back to normal mode
            bind r set -g key-table resize
            bind -T resize h resize-pane -L 5
            bind -T resize j resize-pane -D 5
            bind -T resize k resize-pane -U 5
            bind -T resize l resize-pane -R 5
            bind -T resize Left resize-pane -L 5
            bind -T resize Down resize-pane -D 5
            bind -T resize Up resize-pane -U 5
            bind -T resize Right resize-pane -R 5
            bind -T resize q set -g key-table root
            bind -T resize Escape set -g key-table root
            bind -T resize Enter set -g key-table root

            # Incremental resize (repeatable): prefix+- / prefix++
            bind -r '-' resize-pane -L 5
            bind -r '+' resize-pane -R 5

            # Detach
            bind d detach-client

            # Session management
            bind t command-prompt -I '#S' 'rename-session -- "%%"'
            bind '$' command-prompt -I '#S' 'rename-session -- "%%"'
            # Manual rename (prefix+,) also disables auto-renaming so the name sticks.
            bind ',' command-prompt -I '#W' 'rename-window -- "%%" \; set -w automatic-rename off'

            # Window navigation (with prefix)
            bind C-h select-window -t :-
            bind C-j select-window -t :+

            # Move window
            bind '<' swap-window -t -1
            bind '>' swap-window -t +1

            # -------------------------------------------------
            # Component status line
            # -------------------------------------------------
            set -g status-left-length 100
            set -g status-right-length 100
            set -g status-justify left
            set -g status-left ''''''
            set -g status-right '#[fg=#{?#{==:#{client_key_table},prefix},#${c.base0B},#${c.base0C}},bg=#${c.base00}] #S'
            setw -g window-status-separator ' '
            setw -g automatic-rename on
            setw -g automatic-rename-format '#{pane_current_command}'
            setw -g window-status-format '#[fg=#${c.base01},bg=#${c.base00}]#[fg=#${c.base05},bg=#${c.base01}] #I #[fg=#${c.base00},bg=#${c.base03}] #{pane_current_command} #[fg=#${c.base03},bg=#${c.base00}]'
            setw -g window-status-current-format '#[fg=#${c.base01},bg=#${c.base00}]#[fg=#${c.base0B},bg=#${c.base01},bold] #I #[fg=#${c.base00},bg=#${c.base0B},bold] #{pane_current_command} #[fg=#${c.base0B},bg=#${c.base00}]'
            # Empty statusline above for spacing
            set -Fg 'status-format[1]' '#{status-format[0]}'
            set -g 'status-format[0]' ""
            set -g status 2
          '';
        };
        sesh = {
          enable = true;
          enableAlias = true;
          enableTmuxIntegration = true;
          tmuxKey = "o";
          settings = {
          };
        };
      };

      systemd.user.services."tmux-default-sessions" = {
        Unit = {
          Description = "Ensure default tmux sessions exist";
          After = [ "default.target" ];
        };
        Service = {
          Type = "oneshot";
          RemainAfterExit = true;
          Environment = [ "TMUX_TMPDIR=%t" ];
          ExecStart = [
            (pkgs.writeShellScript "tmux-default-sessions" ''
              ${pkgs.tmux}/bin/tmux new-session -d -s home -c "$HOME" 2>/dev/null \
                || ${pkgs.tmux}/bin/tmux has-session -t home
              ${pkgs.tmux}/bin/tmux new-session -d -s nix -c "$HOME/nix" 2>/dev/null \
                || ${pkgs.tmux}/bin/tmux has-session -t nix

              # Some setups/plugins briefly create a default numeric session (usually "0") as a
              # bootstrap during restore. If it's still around and unattached, remove it.
              if ${pkgs.tmux}/bin/tmux has-session -t 0 2>/dev/null; then
                attached="$(${pkgs.tmux}/bin/tmux display-message -p -t 0 '#{session_attached}' 2>/dev/null || echo 0)"
                if [ "$attached" = "0" ]; then
                  ${pkgs.tmux}/bin/tmux kill-session -t 0 2>/dev/null || true
                fi
              fi
            '')
          ];
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };
}

{ den, ... }:
{
  den.aspects.tmux.homeManager =
    { config, pkgs, ... }:
    let
      c = config.lib.stylix.colors;
    in
    {
      programs.tmux = {
        enable = true;
        prefix = "C-Space";
        keyMode = "vi";
        customPaneNavigationAndResize = true;
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
              set -g @resurrect-strategy-nvim 'session'
              set -g @resurrect-processes 'ssh'
              set -g @resurrect-capture-pane-contents 'on'
            '';
          }
          {
            plugin = pkgs.tmuxPlugins.continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
              set -g @continuum-save-interval '15'
            '';
          }
          {
            plugin = pkgs.tmuxPlugins.dotbar;
            extraConfig = ''
              # dotbar theme remapped to the eldritch base16 palette
              set -g @tmux-dotbar-bg '#${c.base00}'
              set -g @tmux-dotbar-fg '#${c.base04}'
              set -g @tmux-dotbar-fg-current '#${c.base05}'
              set -g @tmux-dotbar-fg-session '#${c.base0C}'
              set -g @tmux-dotbar-fg-prefix '#${c.base0B}'
              set -g @tmux-dotbar-position 'bottom'
              set -g @tmux-dotbar-right 'true'
              # Right side shows basename of the active pane's working dir
              set -g @tmux-dotbar-status-right-text '#{b:pane_current_path}'
              set -g @tmux-dotbar-window-status-format ' #I:#W '
              set -g @tmux-dotbar-session-position 'left'
              set -g @tmux-dotbar-rounded 'true'
            '';
          }
        ];

        extraConfig = ''
          # Pane indexes must stay tidy: dotbar runs on renumbering
          set -g renumber-windows on
          setw -g pane-base-index 1

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

          # Pane navigation via vim keys
          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R

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
          bind ',' command-prompt -I '#W' 'rename-window -- "%%"'

          # Window navigation (with prefix)
          bind C-h select-window -t :-
          bind C-j select-window -t :+

          # Move window
          bind '<' swap-window -t -1
          bind '>' swap-window -t +1
        '';
      };
    };
}

{ config, pkgs, ... }:
let
  c = config.colorScheme.palette;
in
{
  programs.yazi = {
    enable = true;
    keymap = {
      mgr.prepend_keymap = [
        {
          on = [ "<C-q>" ];
          run = "quit";
        }
        {
          on = [ "u" ];
          run = "undo";
        }
        {
          on = [
            "c"
            "a"
            "a"
          ];
          run = "plugin compress";
          desc = "Archive selected files";
        }
        {
          on = [
            "c"
            "a"
            "p"
          ];
          run = "plugin compress -p";
          desc = "Archive selected files (password)";
        }
        {
          on = [
            "c"
            "a"
            "h"
          ];
          run = "plugin compress -ph";
          desc = "Archive selected files (password+header)";
        }
        {
          on = [
            "c"
            "a"
            "l"
          ];
          run = "plugin compress -l";
          desc = "Archive selected files (compression level)";
        }
        {
          on = [
            "c"
            "a"
            "u"
          ];
          run = "plugin compress -phl";
          desc = "Archive selected files (password+header+level)";
        }
        {
          on = [
            "R"
            "b"
          ];
          run = "plugin recycle-bin";
          desc = "Open Recycle Bin menu";
        }
        {
          on = [
            "g"
            "i"
          ];
          run = "plugin lazygit";
          desc = "run lazygit";
        }
      ];
    };
    plugins = {
      recycle-bin = pkgs.yaziPlugins.recycle-bin;
      lazygit = pkgs.yaziPlugins.lazygit;
      compress = pkgs.yaziPlugins.compress;
      mediainfo = pkgs.yaziPlugins.mediainfo;
    };
    settings = {
      mgr = {
        ratio = [
          1
          4
          3
        ];
        sort_by = "alphabetical";
        sort_sensitive = false;
        sort_reverse = false;
        linemode = "permissions";
        show_hidden = true;
        show_symlink = true;
        mouse_events = [ "scroll" ];
      };

      preview = {
        wrap = "yes";
        tab_size = 2;
      };

      opener = {
        play = [
          {
            run = ''mpv "$@"'';
            orphan = true;
            for = "unix";
          }
        ];
        edit = [
          {
            run = ''$EDITOR "$@"'';
            block = true;
            for = "unix";
          }
        ];
        open = [
          {
            run = ''xdg-open "$@"'';
            desc = "Open";
          }
        ];
      };

      tasks = {
        image_bound = [
          20000
          20000
        ];
        image_alloc = 1073741824;
      };

      input = {
        cursor_blink = true;
      };

      plugin = {
        prepend_preloaders = [
          {
            mime = "{audio,video,image}/*";
            run = "mediainfo";
          }
          {
            mime = "application/subrip";
            run = "mediainfo";
          }
          {
            mime = "application/postscript";
            run = "mediainfo";
          }
        ];
        prepend_previewers = [
          {
            mime = "{audio,video,image}/*";
            run = "mediainfo";
          }
          {
            mime = "application/subrip";
            run = "mediainfo";
          }
          {
            mime = "application/postscript";
            run = "mediainfo";
          }
        ];
      };
    };
    theme = {
      manager = {
        cwd = { fg = "#${c.base0C}"; };
        hovered = { fg = "#${c.base00}"; bg = "#${c.base0D}"; };
        preview_hovered = { underline = true; };
        find_keyword = { fg = "#${c.base0A}"; bold = true; };
        find_position = { fg = "#${c.base0E}"; bg = "reset"; bold = true; };
        marker_selected = { fg = "#${c.base0B}"; bg = "#${c.base0B}"; };
        marker_copied = { fg = "#${c.base0A}"; bg = "#${c.base0A}"; };
        marker_cut = { fg = "#${c.base08}"; bg = "#${c.base08}"; };
        tab_active = { fg = "#${c.base00}"; bg = "#${c.base0D}"; };
        tab_inactive = { fg = "#${c.base05}"; bg = "#${c.base02}"; };
        border_symbol = "│";
        border_style = { fg = "#${c.base03}"; };
      };
      status = {
        separator_open = "";
        separator_close = "";
        separator_style = { fg = "#${c.base02}"; bg = "#${c.base02}"; };
        mode_normal = { fg = "#${c.base00}"; bg = "#${c.base0D}"; bold = true; };
        mode_select = { fg = "#${c.base00}"; bg = "#${c.base0B}"; bold = true; };
        mode_unset = { fg = "#${c.base00}"; bg = "#${c.base0E}"; bold = true; };
        progress_label = { fg = "#${c.base05}"; bold = true; };
        progress_normal = { fg = "#${c.base0D}"; bg = "#${c.base02}"; };
        progress_error = { fg = "#${c.base08}"; bg = "#${c.base02}"; };
        permissions_t = { fg = "#${c.base0B}"; };
        permissions_r = { fg = "#${c.base0A}"; };
        permissions_w = { fg = "#${c.base08}"; };
        permissions_x = { fg = "#${c.base0C}"; };
        permissions_s = { fg = "#${c.base03}"; };
      };
      input = {
        border = { fg = "#${c.base0D}"; };
        title = { };
        value = { };
        selected = { bg = "#${c.base02}"; };
      };
      select = {
        border = { fg = "#${c.base0D}"; };
        active = { fg = "#${c.base0E}"; };
        inactive = { };
      };
      tasks = {
        border = { fg = "#${c.base0D}"; };
        title = { };
        hovered = { underline = true; };
      };
      which = {
        cols = 3;
        mask = { bg = "#${c.base01}"; };
        cand = { fg = "#${c.base0C}"; };
        rest = { fg = "#${c.base03}"; };
        desc = { fg = "#${c.base0E}"; };
        separator = "  ";
        separator_style = { fg = "#${c.base03}"; };
      };
      help = {
        on = { fg = "#${c.base0E}"; };
        exec = { fg = "#${c.base0C}"; };
        desc = { fg = "#${c.base03}"; };
        hovered = { bg = "#${c.base02}"; bold = true; };
        footer = { fg = "#${c.base02}"; bg = "#${c.base05}"; };
      };
      filetype = {
        rules = [
          { mime = "image/*"; fg = "#${c.base0C}"; }
          { mime = "video/*"; fg = "#${c.base0A}"; }
          { mime = "audio/*"; fg = "#${c.base0E}"; }
          { mime = "application/zip"; fg = "#${c.base08}"; }
          { mime = "application/gzip"; fg = "#${c.base08}"; }
          { mime = "application/x-tar"; fg = "#${c.base08}"; }
          { mime = "application/x-bzip"; fg = "#${c.base08}"; }
          { mime = "application/x-7z-compressed"; fg = "#${c.base08}"; }
          { mime = "application/x-rar"; fg = "#${c.base08}"; }
          { name = "*"; fg = "#${c.base05}"; }
          { name = "*/"; fg = "#${c.base0D}"; }
        ];
      };
    };
  };
}

{ den, ... }:
{
  den.aspects.yazi.homeManager =
    { pkgs, ... }:
    {
      programs.yazi = {
        enable = true;
        shellWrapperName = "y";
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
            syntax = {
              theme = "Eldritch";
              background = "#212337";
            };
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
      };
    };
}

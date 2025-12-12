{ ... }: {
  programs.nixvim = {
    plugins.snacks = {
      enable = true;
      settings = {
        animate.enabled = true;
        bigfile.enabled = true;
        dim.enabled = true;
        scope.enabled = true;
        rename.enabled = true;
        git.enabled = false;
        notifier = {
          enabled = true;
          timeout = 3000;
        };
        image.resolve.__raw = # lua
          ''
            function(path, src)
              local ok, obsidian_api = pcall(require, "obsidian.api")
              if ok then
                if obsidian_api.path_is_note(path) then
                  return obsidian_api.resolve_image_path(src)
                end
              end
            end
          '';
        quickfile.enabled = true;
        scroll.enabled = true;
        statuscolumn = {
          enabled = true;
          left = [ "sign" ];
          right = [ "fold" "git" "mark" ];
          folds = {
            open = false;
            git_hl = true;
          };
        };
        indent = {
          enabled = true;
          hl = [
            "SnacksIndent1"
            "SnacksIndent2"
            "SnacksIndent3"
            "SnacksIndent4"
            "SnacksIndent5"
            "SnacksIndent6"
            "SnacksIndent7"
            "SnacksIndent8"
          ];
        };
        input.enabled = true;
        lazygit.enabled = true;
        picker = {
          layout.layout = {
            backdrop = false;
            width = 0.8;
            min_width = 80;
            height = 0.8;
            min_height = 30;
            box = "vertical";
            border = true;
            title = "{title} {live} {flags}";
            title_pos = "center";
            "__unkeyed-1" = {
              win = "input";
              height = 1;
              border = "bottom";
            };
            "__unkeyed-2" = {
              win = "list";
              border = "none";
              height = 0.4;
              wo = { wrap = true; };
            };
            "__unkeyed-3" = {
              win = "preview";
              title = "{preview}";
              height = 0.6;
              border = "top";
            };
          };
          enabled = true;
          actions.qflist_append.__raw = # lua
            ''
              function(picker)
                picker:close()
                local sel = picker:selected()
                local items = #sel > 0 and sel or picker:items()
                local qf = {}
                for _, item in ipairs(items) do
                  qf[#qf + 1] = {
                    filename = Snacks.picker.util.path(item),
                    bufnr = item.buf,
                    lnum = item.pos and item.pos[1] or 1,
                    col = item.pos and item.pos[2] + 1 or 1,
                    end_lnum = item.end_pos and item.end_pos[1] or nil,
                    end_col = item.end_pos and item.end_pos[2] + 1 or nil,
                    text = item.line or item.comment or item.label or item.name or item.detail or item.text,
                    pattern = item.search,
                    valid = true,
                  }
                end
                vim.fn.setqflist(qf, "a")
                vim.cmd("botright copen")
              end
            '';
          win.input.keys."<c-q>" = {
            __unkeyed-1 = "qflist_append";
            mode = [ "n" "i" ];
          };
        };
        dashboard = {
          enabled = true;
          preset.header = ''
            ░   ░░░  ░░        ░░░      ░░░  ░░░░  ░░        ░░  ░░░░  ░
            ▒    ▒▒  ▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒   ▒▒   ▒
            ▓  ▓  ▓  ▓▓      ▓▓▓▓  ▓▓▓▓  ▓▓▓  ▓▓  ▓▓▓▓▓▓  ▓▓▓▓▓        ▓
            █  ██    ██  ████████  ████  ████    ███████  █████  █  █  █
            █  ███   ██        ███      ██████  █████        ██  ████  █
          '';
          sections = [
            { section = "header"; }
            {
              section = "keys";
              gap = 1;
              padding = 1;
            }
            {
              pane = 2;
              icon = " ";
              title = "Recent Files";
              section = "recent_files";
              indent = 2;
              padding = 1;
              cwd = true;
              limit = 5;
            }
            {
              pane = 2;
              icon = " ";
              title = "Git Status";
              section = "terminal";
              enabled.__raw = # lua
                ''
                  function()
                    return Snacks.git.get_root() ~= nil
                  end
                '';
              cmd = "git status --short --branch --renames";
              height = 5;
              padding = 1;
              ttl = 300;
              indent = 3;
            }
            {
              __raw = # lua
                ''
                  function()
                    local in_git = Snacks.git.get_root() ~= nil
                    local cmds = {
                      {
                        icon = " ",
                        title = "Git Status",
                        cmd = "git --no-pager diff --stat -B -M -C",
                        height = 10,
                      },
                    }
                    return vim.tbl_map(function(cmd)
                      return vim.tbl_extend("force", {
                        pane = 2,
                        section = "terminal",
                        enabled = in_git,
                        padding = 1,
                        ttl = 60,
                        indent = 3,
                      }, cmd)
                    end, cmds)
                  end
                '';
            }
            # {
            #   section = "startup";
            #   pane = 1;
            # }
          ];
        };
      };
    };

    extraConfigLua = # lua
      ''
        vim.api.nvim_set_hl(0, "SnacksDim", { link = "Comment" })

        -- Setup toggles
        vim.api.nvim_create_autocmd("User", {
          pattern = "VeryLazy",
          callback = function()
            _G.dd = function(...)
              Snacks.debug.inspect(...)
            end
            _G.bt = function()
              Snacks.debug.backtrace()
            end
            vim.print = _G.dd

            Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
            Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
            Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
            Snacks.toggle.diagnostics():map("<leader>ud")
            Snacks.toggle.line_number():map("<leader>ul")
            Snacks.toggle
              .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
              :map("<leader>uc")
            Snacks.toggle.treesitter():map("<leader>uT")
            Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
            Snacks.toggle.inlay_hints():map("<leader>uh")
            Snacks.toggle.indent():map("<leader>ug")
            Snacks.toggle.dim():map("<leader>uD")
          end,
        })
      '';

    keymaps = [
      # Top Pickers & Explorer
      {
        key = "<leader><space>";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.smart()
            end
          '';
        options.desc = "Smart Find Files";
      }
      {
        key = "<leader>'";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.buffers()
            end
          '';
        options.desc = "Buffers";
      }
      {
        key = "<leader>/";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.grep()
            end
          '';
        options.desc = "Grep";
      }
      {
        key = "<leader>:";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.command_history()
            end
          '';
        options.desc = "Command History";
      }
      {
        key = "<leader>nd";
        action.__raw = # lua
          ''
            function()
              Snacks.notifier.hide()
            end
          '';
        options.desc = "Notifications hide";
      }
      # Find
      {
        key = "<leader>fb";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.buffers()
            end
          '';
        options.desc = "Buffers";
      }
      {
        key = "<leader>fc";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
            end
          '';
        options.desc = "Find Config File";
      }
      {
        key = "<leader>ff";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.files()
            end
          '';
        options.desc = "Find Files";
      }
      {
        key = "<leader>fg";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.git_files()
            end
          '';
        options.desc = "Find Git Files";
      }
      {
        key = "<leader>fp";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.projects()
            end
          '';
        options.desc = "Projects";
      }
      {
        key = "<leader>fr";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.recent()
            end
          '';
        options.desc = "Recent";
      }
      # Git
      {
        key = "<leader>gb";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.git_branches()
            end
          '';
        options.desc = "Git Branches";
      }
      {
        key = "<leader>gl";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.git_log()
            end
          '';
        options.desc = "Git Log";
      }
      {
        key = "<leader>gL";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.git_log_line()
            end
          '';
        options.desc = "Git Log Line";
      }
      {
        key = "<leader>gs";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.git_status()
            end
          '';
        options.desc = "Git Status";
      }
      {
        key = "<leader>gS";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.git_stash()
            end
          '';
        options.desc = "Git Stash";
      }
      {
        key = "<leader>gd";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.git_diff()
            end
          '';
        options.desc = "Git Diff (Hunks)";
      }
      {
        key = "<leader>gf";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.git_log_file()
            end
          '';
        options.desc = "Git Log File";
      }
      # Grep/Search
      {
        key = "<leader>sb";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lines()
            end
          '';
        options.desc = "Buffer Lines";
      }
      {
        key = "<leader>sB";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.grep_buffers()
            end
          '';
        options.desc = "Grep Open Buffers";
      }
      {
        key = "<leader>sg";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.grep()
            end
          '';
        options.desc = "Grep";
      }
      {
        key = "<leader>sw";
        mode = [ "n" "x" ];
        action.__raw = # lua
          ''
            function()
              Snacks.picker.grep_word()
            end
          '';
        options.desc = "Visual selection or word";
      }
      {
        key = ''<leader>s"'';
        action.__raw = # lua
          ''
            function()
              Snacks.picker.registers()
            end
          '';
        options.desc = "Registers";
      }
      {
        key = "<leader>s/";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.search_history()
            end
          '';
        options.desc = "Search History";
      }
      {
        key = "<leader>sa";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.autocmds()
            end
          '';
        options.desc = "Autocmds";
      }
      {
        key = "<leader>sc";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.command_history()
            end
          '';
        options.desc = "Command History";
      }
      {
        key = "<leader>sC";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.commands()
            end
          '';
        options.desc = "Commands";
      }
      {
        key = "<leader>sh";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.help()
            end
          '';
        options.desc = "Help Pages";
      }
      {
        key = "<leader>sH";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.highlights()
            end
          '';
        options.desc = "Highlights";
      }
      {
        key = "<leader>si";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.icons()
            end
          '';
        options.desc = "Icons";
      }
      {
        key = "<leader>sj";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.jumps()
            end
          '';
        options.desc = "Jumps";
      }
      {
        key = "<leader>sk";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.keymaps()
            end
          '';
        options.desc = "Keymaps";
      }
      {
        key = "<leader>sl";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.loclist()
            end
          '';
        options.desc = "Location List";
      }
      {
        key = "<leader>sm";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.marks()
            end
          '';
        options.desc = "Marks";
      }
      {
        key = "<leader>sM";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.man()
            end
          '';
        options.desc = "Man Pages";
      }

      {
        key = "<leader>sq";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.qflist()
            end
          '';
        options.desc = "Quickfix List";
      }
      {
        key = "<leader>sR";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.resume()
            end
          '';
        options.desc = "Resume";
      }
      {
        key = "<leader>su";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.undo()
            end
          '';
        options.desc = "Undo History";
      }
      {
        key = "<leader>uC";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.colorschemes()
            end
          '';
        options.desc = "Colorschemes";
      }
      # LSP
      {
        key = "gd";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lsp_definitions()
            end
          '';
        options.desc = "Goto Definition";
      }
      {
        key = "gD";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lsp_declarations()
            end
          '';
        options.desc = "Goto Declaration";
      }
      {
        key = "gr";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lsp_references()
            end
          '';
        options = {
          desc = "References";
          nowait = true;
        };
      }
      {
        key = "gI";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lsp_implementations()
            end
          '';
        options.desc = "Goto Implementation";
      }
      {
        key = "gy";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lsp_type_definitions()
            end
          '';
        options.desc = "Goto T[y]pe Definition";
      }
      {
        key = "<leader>ss";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lsp_symbols()
            end
          '';
        options.desc = "LSP Symbols";
      }
      {
        key = "<leader>sS";
        action.__raw = # lua
          ''
            function()
              Snacks.picker.lsp_workspace_symbols()
            end
          '';
        options.desc = "LSP Workspace Symbols";
      }
      # Other
      {
        key = "<leader>z";
        action.__raw = # lua
          ''
            function()
              Snacks.zen()
            end
          '';
        options.desc = "Toggle Zen Mode";
      }
      {
        key = "<leader>Z";
        action.__raw = # lua
          ''
            function()
              Snacks.zen.zoom()
            end
          '';
        options.desc = "Toggle Zoom";
      }
      {
        key = "<leader>..";
        action.__raw = # lua
          ''
            function()
              Snacks.scratch()
            end
          '';
        options.desc = "Toggle Scratch Buffer";
      }
      {
        key = "<leader>.s";
        action.__raw = # lua
          ''
            function()
              Snacks.scratch.select()
            end
          '';
        options.desc = "Select Scratch Buffer";
      }
      {
        key = "<leader>nn";
        action.__raw = # lua
          ''
            function()
              Snacks.notifier.show_history()
            end
          '';
        options.desc = "Notification History";
      }
      {
        key = "<leader>bd";
        action.__raw = # lua
          ''
            function()
              Snacks.bufdelete()
            end
          '';
        options.desc = "Delete Buffer";
      }
      {
        key = "<leader>cR";
        action.__raw = # lua
          ''
            function()
              Snacks.rename.rename_file()
            end
          '';
        options.desc = "Rename File";
      }
      {
        key = "<leader>gB";
        mode = [ "n" "v" ];
        action.__raw = # lua
          ''
            function()
              Snacks.gitbrowse()
            end
          '';
        options.desc = "Git Browse";
      }
      {
        key = "<leader>gg";
        action.__raw = # lua
          ''
            function()
              Snacks.lazygit()
            end
          '';
        options.desc = "Lazygit";
      }
      {
        key = "<leader>un";
        action.__raw = # lua
          ''
            function()
              Snacks.notifier.hide()
            end
          '';
        options.desc = "Dismiss All Notifications";
      }
      {
        key = "<c-/>";
        action.__raw = # lua
          ''
            function()
              Snacks.terminal()
            end
          '';
        options.desc = "Toggle Terminal";
      }
      {
        key = "<c-_>";
        action.__raw = # lua
          ''
            function()
              Snacks.terminal()
            end
          '';
        options.desc = "which_key_ignore";
      }
      {
        key = "]]";
        mode = [ "n" "t" ];
        action.__raw = # lua
          ''
            function()
              Snacks.words.jump(vim.v.count1)
            end
          '';
        options.desc = "Next Reference";
      }
      {
        key = "[[";
        mode = [ "n" "t" ];
        action.__raw = # lua
          ''
            function()
              Snacks.words.jump(-vim.v.count1)
            end
          '';
        options.desc = "Prev Reference";
      }
      {
        key = "<leader>N";
        action.__raw = # lua
          ''
            function()
              Snacks.win({
                file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
                width = 0.6,
                height = 0.6,
                wo = {
                  spell = false,
                  wrap = false,
                  signcolumn = "yes",
                  statuscolumn = " ",
                  conceallevel = 3,
                },
              })
            end
          '';
        options.desc = "Neovim News";
      }
    ];
  };
}

{ pkgs, ... }: {
  programs.nixvim = {
    plugins = {
      # Auto-pair brackets
      mini = {
        enable = true;
        modules = {
          pairs = {
            # Auto-pair configuration
          };
          surround = {
            # Surround operations
          };
        };
      };

      # Enhanced yank/paste
      yanky = {
        enable = true;
        settings = {
          ring = {
            history_length = 100;
            storage = "shada";
          };
          picker = { select = { action = null; }; };
          system_clipboard = { sync_with_ring = true; };
        };
      };

      # Enhanced motion navigation
      flash = {
        enable = true;
        settings = {
          labels = "asdfghjklqwertyuiopzxcvbnm";
          search = {
            multi_window = true;
            forward = true;
            wrap = true;
            mode = "exact";
          };
          jump = {
            jumplist = true;
            pos = "start";
            history = false;
            register = false;
            nohlsearch = false;
            autojump = false;
          };
          label = {
            uppercase = true;
            rainbow = {
              enabled = false;
              shade = 5;
            };
          };
          modes = {
            search = { enabled = true; };
            char = {
              enabled = true;
              keys = [ "f" "F" "t" "T" ";" "," ];
              search = { wrap = false; };
              highlight = { backdrop = true; };
              jump = { register = false; };
            };
            treesitter = {
              labels = "abcdefghijklmnopqrstuvwxyz";
              jump = { pos = "range"; };
              search = { incremental = false; };
              label = { };
              highlight = {
                backdrop = false;
                matches = false;
              };
            };
          };
        };
      };

      # Peek line numbers
      numb = { enable = true; };

      # Incremental LSP rename
      inc-rename = { enable = true; };

      # Guess indent
      guess-indent = { enable = true; };

      # Modern folding
      nvim-ufo = {
        enable = true;
        settings = {
          provider_selector = ''
            function(bufnr, filetype, buftype)
              return {'treesitter', 'indent'}
            end
          '';
        };
      };
    };

    # Additional editing plugins via extraPlugins
    extraPlugins = with pkgs.vimPlugins; [
      # Snippet management
      nvim-scissors
      friendly-snippets
    ];

    # Additional configuration
    extraConfigLua = # lua
      ''
        -- Flash keymaps
        vim.keymap.set({ "n", "x", "o" }, "s", function()
          require("flash").jump()
        end, { desc = "Flash" })

        vim.keymap.set({ "n", "x", "o" }, "S", function()
          require("flash").treesitter()
        end, { desc = "Flash Treesitter" })

        vim.keymap.set("o", "r", function()
          require("flash").remote()
        end, { desc = "Remote Flash" })

        vim.keymap.set({ "o", "x" }, "R", function()
          require("flash").treesitter_search()
        end, { desc = "Treesitter Search" })

        vim.keymap.set({ "c" }, "<c-s>", function()
          require("flash").toggle()
        end, { desc = "Toggle Flash Search" })

        -- Yanky keymaps
        vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
        vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
        vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
        vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")

        vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleForward)")
        vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleBackward)")

        vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
        vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
        vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
        vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")

        vim.keymap.set("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)")
        vim.keymap.set("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
        vim.keymap.set("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
        vim.keymap.set("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")

        vim.keymap.set("n", "=p", "<Plug>(YankyPutAfterFilter)")
        vim.keymap.set("n", "=P", "<Plug>(YankyPutBeforeFilter)")

        -- Inc-rename keymap
        vim.keymap.set("n", "<leader>rn", function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end, { expr = true, desc = "Incremental rename" })

        -- UFO folding keymaps
        vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = "Open all folds" })
        vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = "Close all folds" })
        vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds, { desc = "Open folds except kinds" })
        vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith, { desc = "Close folds with" })
        vim.keymap.set('n', 'zp', function()
          local winid = require('ufo').peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end, { desc = "Peek folded lines" })
      '';
  };
}

{ pkgs, ... }: {
  programs.nixvim = {

    plugins = {
      # Git signs - git decorations
      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add = { text = "│"; };
            change = { text = "│"; };
            delete = { text = "_"; };
            topdelete = { text = "‾"; };
            changedelete = { text = "~"; };
            untracked = { text = "┆"; };
          };
          signcolumn = true;
          numhl = false;
          linehl = false;
          word_diff = false;
          watch_gitdir = { follow_files = true; };
          attach_to_untracked = true;
          current_line_blame = false;
          current_line_blame_opts = {
            virt_text = true;
            virt_text_pos = "eol";
            delay = 1000;
            ignore_whitespace = false;
          };
          sign_priority = 6;
          update_debounce = 100;
          status_formatter = null;
          max_file_length = 40000;
          preview_config = {
            border = "rounded";
            style = "minimal";
            relative = "cursor";
            row = 0;
            col = 1;
          };
        };
      };

      # Diffview - git diff viewer
      diffview = { enable = true; };
    };

    # Additional git plugins via extraPlugins
    extraPlugins = with pkgs.vimPlugins; [
      # Git blame
      git-blame-nvim
      # Merge conflict resolver
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "resolved.nvim";
          src = pkgs.fetchFromGitHub {
            owner = "noamsto";
            repo = "resolved.nvim";
            rev = "main";
            sha256 = ""; # Will need to be filled
          };
        };
      }
      # Git scripts (for vault auto-commit)
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "git-scripts.nvim";
          src = pkgs.fetchFromGitHub {
            owner = "declancm";
            repo = "git-scripts.nvim";
            rev = "main";
            sha256 = ""; # Will need to be filled
          };
        };
      }
    ];

    # Additional git configuration
    extraConfigLua = # lua
      ''
        -- Git blame configuration
        vim.g.gitblame_enabled = true
        vim.g.gitblame_message_template = "<author> • <date> <<sha>>"
        vim.g.gitblame_date_format = "%r"

        -- Resolved.nvim setup
        require("resolved").setup({})

        -- Git-scripts configuration
        local gitscripts = require("git-scripts")
        gitscripts.setup({
          default_keymaps = false,
          commit_on_save = true,
        })

        -- Auto pull on vault enter
        vim.api.nvim_create_autocmd({ "BufEnter", "VimEnter" }, {
          pattern = vim.fn.expand("~") .. "/vault/*.md",
          callback = function()
            gitscripts.async_pull()
          end,
          desc = "Auto pull repo on enter",
        })

        -- Gitsigns keymaps
        local wk = require("which-key")
        wk.add({
          {
            "<leader>g",
            group = "+git",
            icon = { icon = " " },
          },
        })

        -- Gitsigns navigation
        vim.keymap.set("n", "]h", function()
          if vim.wo.diff then
            return "]h"
          end
          vim.schedule(function()
            require("gitsigns").next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Next hunk" })

        vim.keymap.set("n", "[h", function()
          if vim.wo.diff then
            return "[h"
          end
          vim.schedule(function()
            require("gitsigns").prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Previous hunk" })

        -- Gitsigns actions
        vim.keymap.set("n", "<leader>gs", require("gitsigns").stage_hunk, { desc = "Stage hunk" })
        vim.keymap.set("n", "<leader>gr", require("gitsigns").reset_hunk, { desc = "Reset hunk" })
        vim.keymap.set("v", "<leader>gs", function()
          require("gitsigns").stage_hunk({vim.fn.line("."), vim.fn.line("v")})
        end, { desc = "Stage hunk" })
        vim.keymap.set("v", "<leader>gr", function()
          require("gitsigns").reset_hunk({vim.fn.line("."), vim.fn.line("v")})
        end, { desc = "Reset hunk" })
        vim.keymap.set("n", "<leader>gS", require("gitsigns").stage_buffer, { desc = "Stage buffer" })
        vim.keymap.set("n", "<leader>gu", require("gitsigns").undo_stage_hunk, { desc = "Undo stage hunk" })
        vim.keymap.set("n", "<leader>gR", require("gitsigns").reset_buffer, { desc = "Reset buffer" })
        vim.keymap.set("n", "<leader>gp", require("gitsigns").preview_hunk, { desc = "Preview hunk" })
        vim.keymap.set("n", "<leader>gb", function()
          require("gitsigns").blame_line({full=true})
        end, { desc = "Blame line" })
        vim.keymap.set("n", "<leader>gB", require("gitsigns").toggle_current_line_blame, { desc = "Toggle line blame" })
        vim.keymap.set("n", "<leader>gd", require("gitsigns").diffthis, { desc = "Diff this" })
        vim.keymap.set("n", "<leader>gD", function()
          require("gitsigns").diffthis("~")
        end, { desc = "Diff this ~" })

        -- Diffview keymaps
        vim.keymap.set("n", "<leader>gv", "<cmd>DiffviewOpen<cr>", { desc = "Diffview open" })
        vim.keymap.set("n", "<leader>gc", "<cmd>DiffviewClose<cr>", { desc = "Diffview close" })
        vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "Diffview file history" })
      '';
  };
}

{ pkgs, ... }: {
  programs.nixvim = {
    plugins = {
      # Snacks - collection of useful utilities
      # Note: snacks.nvim is not yet in nixvim, will need to be added as extraPlugin

      # Session management
      persistence = { enable = true; };

      # File manager integration
      yazi = {
        enable = true;
        settings = { open_for_directories = false; };
      };
    };

    # Additional utility plugins via extraPlugins
    extraPlugins = with pkgs.vimPlugins; [
      # Promise async library for UFO
      promise-async
      # Overseer - task runner
      overseer-nvim
      # Snacks.nvim
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "snacks.nvim";
          src = pkgs.fetchFromGitHub {
            owner = "folke";
            repo = "snacks.nvim";
            rev = "main";
            sha256 = ""; # Will need to be filled
          };
        };
      }
      # Sidekick - sidebar utilities (for AI CLI)
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "sidekick.nvim";
          src = pkgs.fetchFromGitHub {
            owner = "liubianshi";
            repo = "sidekick.nvim";
            rev = "main";
            sha256 = ""; # Will need to be filled
          };
        };
      }
    ];

    # Additional configuration
    extraConfigLua = # lua
      ''
        -- Snacks.nvim configuration
        require("snacks").setup({
          bigfile = { enabled = true },
          notifier = { enabled = true },
          quickfile = { enabled = true },
          statuscolumn = { enabled = true },
          words = { enabled = true },
          dashboard = { enabled = false },
        })

        -- Overseer configuration
        require("overseer").setup({
          templates = { "builtin" },
          strategy = {
            "toggleterm",
            direction = "horizontal",
            autos_croll = true,
            quit_on_exit = "success"
          },
        })

        -- Yazi keymaps
        vim.keymap.set("n", "<leader>e", function()
          require("yazi").yazi()
        end, { desc = "Open yazi" })

        vim.keymap.set("n", "<leader>E", function()
          require("yazi").yazi(nil, vim.fn.getcwd())
        end, { desc = "Open yazi at cwd" })

        -- Persistence keymaps
        vim.keymap.set("n", "<leader>qs", function()
          require("persistence").load()
        end, { desc = "Restore session" })

        vim.keymap.set("n", "<leader>ql", function()
          require("persistence").load({ last = true })
        end, { desc = "Restore last session" })

        vim.keymap.set("n", "<leader>qd", function()
          require("persistence").stop()
        end, { desc = "Don't save current session" })

        -- Overseer keymaps
        local wk = require("which-key")
        wk.add({
          {
            "<leader>o",
            group = "+overseer",
            icon = { icon = " " },
          },
        })

        vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle<cr>", { desc = "Toggle overseer" })
        vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<cr>", { desc = "Run task" })
        vim.keymap.set("n", "<leader>oa", "<cmd>OverseerTaskAction<cr>", { desc = "Task action" })
        vim.keymap.set("n", "<leader>oi", "<cmd>OverseerInfo<cr>", { desc = "Overseer info" })
        vim.keymap.set("n", "<leader>ob", "<cmd>OverseerBuild<cr>", { desc = "Build task" })
        vim.keymap.set("n", "<leader>oq", "<cmd>OverseerQuickAction<cr>", { desc = "Quick action" })

        -- Snacks keymaps
        wk.add({
          {
            "<leader>n",
            group = "+notifications",
            icon = { icon = " " },
          },
        })

        vim.keymap.set("n", "<leader>nh", function()
          require("snacks").notifier.show_history()
        end, { desc = "Show notification history" })

        vim.keymap.set("n", "<leader>nd", function()
          require("snacks").notifier.hide()
        end, { desc = "Dismiss all notifications" })
      '';
  };
}

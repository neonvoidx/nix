{ pkgs, ... }: {
  programs.nixvim = {
    plugins = {
      # GitHub Copilot
      copilot-lua = {
        enable = true;
        suggestion = {
          enabled = true;
          auto_trigger = true;
          keymap = {
            accept = "<Tab>";
            accept_word = false;
            accept_line = false;
            next = "<M-]>";
            prev = "<M-[>";
            dismiss = "<C-]>";
          };
        };
        panel = {
          enabled = true;
          auto_refresh = false;
          keymap = {
            jump_prev = "[[";
            jump_next = "]]";
            accept = "<CR>";
            refresh = "gr";
            open = "<M-CR>";
          };
        };
        filetypes = {
          markdown = false;
          help = false;
          gitcommit = false;
          gitrebase = false;
          hgcommit = false;
          svn = false;
          cvs = false;
          "." = false;
          sh = ''
            function()
              if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
                return false
              end
              return true
            end
          '';
        };
      };
    };

    # Additional AI plugins via extraPlugins
    extraPlugins = with pkgs.vimPlugins;
      [
        # Copilot LSP
        {
          plugin = pkgs.vimUtils.buildVimPlugin {
            name = "copilot-lsp";
            src = pkgs.fetchFromGitHub {
              owner = "copilotlsp-nvim";
              repo = "copilot-lsp";
              rev = "main";
              sha256 = ""; # Will need to be filled
            };
          };
        }
      ];

    # Sidekick configuration (from utilities.nix but AI-specific keymaps here)
    extraConfigLua = # lua
      ''
        -- Sidekick CLI configuration for AI tools
        require("sidekick").setup({
          nes = { enabled = false },
          mux = { enabled = false },
          cli = {
            tools = {
              aider = { 
                cmd = { "ocaider", "--watch-files", "--model", "oca/gpt5" } 
              },
            },
          },
        })

        -- AI keymaps
        local wk = require("which-key")
        wk.add({
          {
            "<leader>a",
            group = "+ai",
            icon = { icon = "󰧑 " },
          },
        })

        -- Copilot commands
        vim.keymap.set("n", "<leader>ac", "<cmd>Copilot<cr>", { desc = "Copilot panel" })
        vim.keymap.set("n", "<leader>ae", "<cmd>Copilot enable<cr>", { desc = "Enable Copilot" })
        vim.keymap.set("n", "<leader>ad", "<cmd>Copilot disable<cr>", { desc = "Disable Copilot" })

        -- Sidekick AI keymaps (from ai.lua)
        vim.keymap.set("n", "<tab>", function()
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>"
          end
        end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })

        vim.keymap.set("n", "<leader>aa", function()
          require("sidekick.cli").toggle({ name = "copilot" })
        end, { desc = "Sidekick Toggle Copilot" })

        vim.keymap.set("n", "<leader>aA", function()
          require("sidekick.cli").toggle({ name = "aider" })
        end, { desc = "Sidekick Toggle Aider" })

        vim.keymap.set("n", "<leader>as", function()
          require("sidekick.cli").select({ filter = { installed = true } })
        end, { desc = "Select CLI" })

        vim.keymap.set({"n", "x"}, "<leader>at", function()
          require("sidekick.cli").send({ msg = "{this}" })
        end, { desc = "Send This" })

        vim.keymap.set("x", "<leader>av", function()
          require("sidekick.cli").send({ msg = "{selection}" })
        end, { desc = "Send Visual Selection" })

        vim.keymap.set({"n", "x"}, "<leader>ap", function()
          require("sidekick.cli").prompt()
        end, { desc = "Sidekick Select Prompt" })

        vim.keymap.set({"n", "x", "i", "t"}, "<c-.>", function()
          require("sidekick.cli").focus()
        end, { desc = "Sidekick Switch Focus" })
      '';
  };
}

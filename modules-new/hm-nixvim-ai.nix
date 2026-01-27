{ config, ... }:
{
  flake.modules.homeManager.nixvim-ai = { pkgs, lib, config, inputs, ... }: {
    programs.nixvim = {
      plugins.copilot-lua = {
        enable = true;
        filetypes = {
          markdown = false;
          help = false;
          sh.__raw = ''
            function()
              if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
                return false
              end
              return true
            end
          '';
        };
      };

      # plugins.sidekick = {
      #   enable = true;
      #   settings = {
      #     nes = {
      #       enabled = false;
      #     };
      #     mux = {
      #       enabled = false;
      #     };
      #     keys = [
      #       {
      #         __unkeyed-1 = "<tab>";
      #         __unkeyed-2.__raw = ''
      #           function()
      #             -- if there is a next edit, jump to it, otherwise apply it if any
      #             if not require("sidekick").nes_jump_or_apply() then
      #               return "<Tab>" -- fallback to normal tab
      #             end
      #           end
      #         '';
      #         expr = true;
      #         desc = "Goto/Apply Next Edit Suggestion";
      #       }
      #       {
      #         __unkeyed-1 = "<leader>aa";
      #         __unkeyed-2.__raw = ''
      #           function()
      #             require("sidekick.cli").toggle({ name = "copilot" })
      #           end
      #         '';
      #         desc = "Sidekick Toggle Copilot";
      #       }
      #       {
      #         __unkeyed-1 = "<leader>aA";
      #         __unkeyed-2.__raw = ''
      #           function()
      #             require("sidekick.cli").toggle({ name = "aider" })
      #           end
      #         '';
      #         desc = "Sidekick Toggle Aider";
      #       }
      #       {
      #         __unkeyed-1 = "<leader>as";
      #         __unkeyed-2.__raw = ''
      #           function()
      #             require("sidekick.cli").select({ filter = { installed = true } })
      #           end
      #         '';
      #         desc = "Select CLI";
      #       }
      #       {
      #         __unkeyed-1 = "<leader>at";
      #         __unkeyed-2.__raw = ''
      #           function()
      #             require("sidekick.cli").send({ msg = "{this}" })
      #           end
      #         '';
      #         mode = [
      #           "x"
      #           "n"
      #         ];
      #         desc = "Send This";
      #       }
      #       {
      #         __unkeyed-1 = "<leader>av";
      #         __unkeyed-2.__raw = ''
      #           function()
      #             require("sidekick.cli").send({ msg = "{selection}" })
      #           end
      #         '';
      #         mode = [ "x" ];
      #         desc = "Send Visual Selection";
      #       }
      #       {
      #         __unkeyed-1 = "<leader>ap";
      #         __unkeyed-2.__raw = ''
      #           function()
      #             require("sidekick.cli").prompt()
      #           end
      #         '';
      #         mode = [
      #           "n"
      #           "x"
      #         ];
      #         desc = "Sidekick Select Prompt";
      #       }
      #       {
      #         __unkeyed-1 = "<c-.>";
      #         __unkeyed-2.__raw = ''
      #           function()
      #             require("sidekick.cli").focus()
      #           end
      #         '';
      #         mode = [
      #           "n"
      #           "x"
      #           "i"
      #           "t"
      #         ];
      #         desc = "Sidekick Switch Focus";
      #       }
      #     ];
      #   };
      # };
    };
  };
}

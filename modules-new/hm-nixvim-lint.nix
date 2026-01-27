{ config, ... }:
{
  flake.modules.homeManager.nixvim-lint = { pkgs, lib, config, inputs, ... }: {
    programs.nixvim = {
      plugins.lint = {
        enable = true;
        lintersByFt = {
          typescript = [ "eslint_d" ];
          typescriptreact = [ "eslint_d" ];
          javascript = [ "eslint_d" ];
          javascriptreact = [ "eslint_d" ];
          cmake = [ "cmakelint" ];
        };
      };

      autoCmd = [
        {
          event = [ "BufEnter" "BufWritePost" "InsertLeave" ];
          callback.__raw = ''
            function()
              require("lint").try_lint()
            end
          '';
        }
      ];
    };
  };
}

{ pkgs, ... }:
{
  programs.nixvim = {
    
    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "eldritch";
          src = pkgs.fetchFromGitHub {
            owner = "eldritch-theme";
            repo = "eldritch.nvim";
            rev = "c0f80da1c2d8a8b481c95c70c2b01be0e44d7906";
            hash = "sha256-3BYWyPgmKGVBEQNHsv49j0gIRJ7n72UQvIVfCpLiNGA=";
          };
        };
        config = ''
          vim.cmd([[colorscheme eldritch]])
        '';
      }
    ];
  };
}

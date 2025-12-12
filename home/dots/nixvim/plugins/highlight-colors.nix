{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "nvim-highlight-colors";
          src = pkgs.fetchFromGitHub {
            owner = "brenoprata10";
            repo = "nvim-highlight-colors";
            rev = "5c5658f46bccd64aa1e8cec1c3e22e1d10c7cfea";
            hash = "sha256-8rfK0vTf1h1qPKN0O9c0JuH5vfyS+X3XKl8a+9Hpk2M=";
          };
        };
        config = ''
          lua << EOF
          require("nvim-highlight-colors").setup({
            render = "virtual",
          })
          EOF
        '';
      }
    ];
  };
}

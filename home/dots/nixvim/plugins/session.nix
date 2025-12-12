{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "persistence";
          src = pkgs.fetchFromGitHub {
            owner = "folke";
            repo = "persistence.nvim";
            rev = "b2ac41ca376cc1ab074a6fb3d39c5f36aeb69d48";
            hash = "sha256-OKpU57KWKHQYqGlCXXnx7bG0rL44+EKXUg1ZAIQhG94=";
          };
        };
        config = ''
          lua << EOF
          require("persistence").setup({
            need = 1,
            branch = true,
          })
          EOF
        '';
      }
    ];
  };
}

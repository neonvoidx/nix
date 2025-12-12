{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "helpview";
          src = pkgs.fetchFromGitHub {
            owner = "OXY2DEV";
            repo = "helpview.nvim";
            rev = "c6a6601d49fb5b2c5cf21c10faa0ec88ad33a52b";
            hash = "sha256-UGcZGVMkKrVPxLgXb4Lm3dKCzHKSGf7UBBbQ4eqaOy4=";
          };
        };
        config = ''
          lua << EOF
          require("helpview").setup({
            preview = {
              icon_provider = "devicons",
            },
          })
          EOF
        '';
      }
    ];
  };
}

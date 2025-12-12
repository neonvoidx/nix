{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "inc-rename";
          src = pkgs.fetchFromGitHub {
            owner = "smjonas";
            repo = "inc-rename.nvim";
            rev = "f388b05f2b7040b3a95c65a212a1302cfb4a4c36";
            hash = "sha256-FgdEGu3Q0RXVhL7RNRvTjzXUTI/rz/oXcSzRvJuGmGU=";
          };
        };
        config = ''
          lua << EOF
          require("inc_rename").setup()
          EOF
        '';
      }
    ];

    keymaps = [
      {
        key = "<leader>cr";
        action = ":IncRename ";
        options.desc = "Rename symbol";
      }
    ];
  };
}

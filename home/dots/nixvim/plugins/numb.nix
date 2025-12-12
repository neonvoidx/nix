{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "numb";
          src = pkgs.fetchFromGitHub {
            owner = "nacro90";
            repo = "numb.nvim";
            rev = "2c89245d1185e02fec1494c45bc765a38b6b40b3";
            hash = "sha256-NfbtajJ5p6Hy15NQZ8JTQE97E6FWjkSUNA59BxEHI9E=";
          };
        };
        config = ''
          lua << EOF
          require("numb").setup()
          EOF
        '';
      }
    ];
  };
}

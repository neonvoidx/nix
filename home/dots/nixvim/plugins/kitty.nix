{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "vim-kitty-navigator";
          src = pkgs.fetchFromGitHub {
            owner = "knubie";
            repo = "vim-kitty-navigator";
            rev = "1fa7c57c7f235a370d7c34efc9845944e6b0c3aa";
            hash = "sha256-kPJvWpAaFgE8fvxjJaGANs8JFVCRiIKJiWy0JJVg7BY=";
          };
        };
      }
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "kitty-scrollback";
          src = pkgs.fetchFromGitHub {
            owner = "mikesmithgh";
            repo = "kitty-scrollback.nvim";
            rev = "f3ff5c659e7ee4d8b22a41eebf8ae6b78d7d3f6f";
            hash = "sha256-zx2e4VPWWmHDWNS2aJ1qAuX0D6sqeFJxRQFZlhUlZVo=";
          };
        };
        config = ''
          lua << EOF
          require("kitty-scrollback").setup()
          EOF
        '';
      }
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "vim-kitty";
          src = pkgs.fetchFromGitHub {
            owner = "fladson";
            repo = "vim-kitty";
            rev = "d9b9a5f0e24ee338a83b1235ed8af8ed85bc49ba";
            hash = "sha256-U2lc13bIKvw1/qbJ5H4F3vWkkrOMxETHn1i5h6zT4zc=";
          };
        };
      }
    ];
  };
}

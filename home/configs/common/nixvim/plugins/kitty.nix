{ pkgs, lib, ... }:
{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "kitty-scrollback.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "mikesmithgh";
        repo = "kitty-scrollback.nvim";
        rev = "main";
        sha256 = "sha256-UNBQMh7No5tMpgFFzjKPloqJNhy2V58nR4aFFjqOH0E=";
      };
    })
    (pkgs.vimUtils.buildVimPlugin {
      name = "vim-kitty-navigator";
      src = pkgs.fetchFromGitHub {
        owner = "knubie";
        repo = "vim-kitty-navigator";
        rev = "master";
        sha256 = "sha256-8CwXh54zgus2VkfYvPHzqu8cIF2sKOLwVHEtyHCQB44=";
      };
    })
    (pkgs.vimUtils.buildVimPlugin {
      name = "vim-kitty";
      src = pkgs.fetchFromGitHub {
        owner = "fladson";
        repo = "vim-kitty";
        rev = "main";
        sha256 = "sha256-ogHsdYTmfY304HflX7+SmT6LVPGlxHpiodL84XR9oFM=";
      };
    })
  ];

  extraConfigLua = ''
    -- Only configure kitty-scrollback if we're in kitty
    if vim.env.TERM == "xterm-kitty" then
      require('kitty-scrollback').setup()
    end
  '';
}

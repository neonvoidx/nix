{ pkgs, ... }: {
  programs.nixvim = {

    # Kitty plugins via extraPlugins
    extraPlugins = with pkgs.vimPlugins; [
      # Kitty config syntax
      vim-kitty
      # Kitty navigator
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "vim-kitty-navigator";
          src = pkgs.fetchFromGitHub {
            owner = "knubie";
            repo = "vim-kitty-navigator";
            rev = "master";
            sha256 = ""; # Will need to be filled
          };
        };
      }
      # Kitty scrollback
      {
        plugin = pkgs.vimUtils.buildVimPlugin {
          name = "kitty-scrollback.nvim";
          src = pkgs.fetchFromGitHub {
            owner = "mikesmithgh";
            repo = "kitty-scrollback.nvim";
            rev = "main";
            sha256 = ""; # Will need to be filled
          };
        };
      }
    ];

    # Kitty configuration is handled in keymaps.nix for the navigator
    extraConfigLua = # lua
      ''
        -- Kitty scrollback configuration
        require('kitty-scrollback').setup()
      '';
  };
}

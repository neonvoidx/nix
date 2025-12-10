{ ... }: {
  imports = [ ./options.nix ./keymaps.nix ./autocommands.nix ./plugins ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    # Enable experimental features
    enableMan = true;

    # Set leaders
    globals.mapleader = " ";
    globals.maplocalleader = "\\";

    # Color scheme
    colorschemes.eldritch.enable = true;
  };
}

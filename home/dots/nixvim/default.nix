{ inputs, ... }: {
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./opts.nix
    ./autocmds.nix
    ./keymaps.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    enableMan = true;

    viAlias = true;
    vimAlias = true;

    colorschemes.tokyonight.enable = true;
  };
}

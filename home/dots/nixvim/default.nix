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
    # colorscheme

    viAlias = true;
    vimAlias = true;
  };
}

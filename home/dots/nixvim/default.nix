{ inputs, ... }: {
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./opts.nix
    ./autocmds.nix
    ./keymaps.nix
    ./plugins
  ];

  programs.nixvim = {
    nixpkgs.config.allowUnfree = true;
    enable = true;
    defaultEditor = true;

    enableMan = true;

    viAlias = true;
    vimAlias = true;
    waylandSupport = true;
    withNodeJs = true;
    withPython3 = true;

    colorschemes.tokyonight.enable = true;
  };

}

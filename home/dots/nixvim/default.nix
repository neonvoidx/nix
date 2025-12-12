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
  };

}

# TODO
# Install Required Packages - Add LSP servers, formatters, and linters via Nix packages (not Mason)

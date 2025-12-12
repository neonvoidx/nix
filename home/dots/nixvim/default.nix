{ inputs, ... }: {
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    enableMan = true;
    # colorscheme

    viAlias = true;
    vimAlias = true;

    inherit (import ./opts.nix) opts;
    inherit (import ./autocmds.nix) autoGroups autoCmd;
  };
}

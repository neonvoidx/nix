{ den, inputs, ... }:
{
  den.aspects.multiverse = {
    nixos =
      { ... }:
      {
        imports = [ inputs.multiverse.nixosModules.default ];

        multiverse = {
          enable = true;
          config.allowUnfree = true;

          # Pin a package to an exact version, resolved against whichever
          # nixpkgs revision last shipped it. Add entries like:
          # pins = {
          #   vscode = "1.107.0";
          #   ripgrep = "13.0.0";
          # };
          #
          # Then use them anywhere with `config.multiverse.pinned.<attr>`.
          # Keep in mind home manager actually picks up nix level pins
          # we user @overlays.nix to auto import these pins
          pins = {
            # TODO until https://github.com/cachix/devenv/issues/3183
            devenv = "2.2.2";
          };
        };
      };

    homeManager =
      { ... }:
      {
        imports = [ inputs.multiverse.homeManagerModules.default ];

        multiverse = {
          enable = true;
          config.allowUnfree = true;
        };
      };
  };
}

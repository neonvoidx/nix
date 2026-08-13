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
          pins = {
            # TODO remove after
            # https://github.com/NixOS/nixpkgs/pull/552211 — remove this pin once merged.
            ananicy-cpp = "1.1.1";
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
          pins = { };
        };
      };
  };
}

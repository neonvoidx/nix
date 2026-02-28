{ inputs, ... }:
{
  flake.modules.nixos.home-manager =
    { pkgs, config, ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        # spicetify-nix NixOS module: makes spicetify system-level packages available.
        # The homeManagerModules.default below separately provides the programs.spicetify HM option.
        inputs.spicetify-nix.nixosModules.default
      ];

      home-manager = {
        backupFileExtension = "backup";
        # backupCommand receives the target path as $1 via the `-- ` separator
        backupCommand = "${pkgs.bash}/bin/bash -c 'rm -f \"$1.backup\" && mv \"$1\" \"$1.backup\"' --";
        useGlobalPkgs = true;
        useUserPackages = true;

        sharedModules = [
          {
            _module.args = {
              inherit inputs;
              username = "neonvoid";
              hostname = config.networking.hostName;
              inherit (inputs) nix-index-database nix-versions;
              nixvimOptions =
                inputs.nixvim.packages.${pkgs.stdenv.hostPlatform.system}.options-json
                + /share/doc/nixos/options.json;
            };
          }
          inputs.spicetify-nix.homeManagerModules.default
          inputs.nix-index-database.homeModules.default
          inputs.noctalia.homeModules.default
        ];
      };
    };
}

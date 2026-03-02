{ den, inputs, ... }:
{
  den.default.includes = [
    den._.home-manager
    den._.define-user
    den._.primary-user
    den._.inputs'
    den._.self'
  ];

  den.ctx.hm-host.nixos.home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    sharedModules = [
      inputs.spicetify-nix.homeManagerModules.default
      inputs.nix-index-database.homeModules.default
      inputs.noctalia.homeModules.default
    ];
  };
}

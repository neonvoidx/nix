{ den, ... }:
{
  # Global state versions
  den.default.nixos.system.stateVersion = "25.11";
  den.default.homeManager.home.stateVersion = "25.11";

  # Set nix trusted/allowed-users per user from context
  den.ctx.user.includes = [
    (den.lib.take.atLeast ({ host, user, ... }: {
      nixos.nix.settings.trusted-users = [ "root" user.userName "@wheel" ];
      nixos.nix.settings.allowed-users = [ "root" user.userName "@wheel" ];
    }))
  ];

  # Home-Manager host-level settings (only fires when HM is detected)
  den.ctx.hm-host.nixos = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "backup";
  };
}

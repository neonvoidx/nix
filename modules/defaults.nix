{ inputs, den, ... }:
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

    # Pass inputs and nix-versions as HM special args
    home-manager.extraSpecialArgs = {
      inherit inputs;
      inherit (inputs) nix-versions;
    };
  };

  # Set hostname as HM extraSpecialArg per-host.
  # NOTE: Some HM modules still use `osConfig.networking.hostName` which is preferred.
  # This extraSpecialArg provides the hostname for any module that still uses `hostname` as
  # a function argument (check modules before removing this if migrating further).
  den.ctx.hm-host.includes = [
    (den.lib.take.exactly ({ host }: {
      nixos.home-manager.extraSpecialArgs.hostname = host.name;
    }))
  ];
}

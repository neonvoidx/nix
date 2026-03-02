{ inputs, den, ... }:
{
  # Global state versions
  den.default.nixos.system.stateVersion = "25.11";
  den.default.homeManager.home.stateVersion = "25.11";

  # Global includes: define user accounts and set zsh as default shell
  den.default.includes = [
    den._.define-user
    den._.primary-user
    (den._.user-shell "zsh")

    # Set nix trusted/allowed-users per user from context
    (den.lib.take.atLeast ({ user, ... }: {
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

  # Set hostname as HM extraSpecialArg per-host (for modules still using hostname arg)
  den.ctx.hm-host.includes = [
    (den.lib.take.exactly ({ host }: {
      nixos.home-manager.extraSpecialArgs.hostname = host.name;
    }))
  ];
}

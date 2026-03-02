{ den, inputs, ... }:
{
  den = {
    ctx.hm-host.nixos.home-manager = {
      # For hosts with home manager users, automatically make home manager use host's nixpkgs
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
      # Removes current backup file before backing up
      # to avoid home manager switch errors
      backupCommand = "bash -c 'rm -f \"$1.bak\" && mv \"$1\" \"$1.bak\"' --";
      # Home manager modules
      sharedModules = [
        inputs.spicetify-nix.homeManagerModules.default
        inputs.nix-index-database.homeModules.default
        inputs.noctalia.homeModules.default
      ];
    };
    default = {
      nixos.system.stateVersion = "25.11";
      homeManager.home.stateVersion = "25.11";
      includes = [
        den._.home-manager
        # Automatically sets home.username, home.homDirectory, users.users.<name>
        den._.define-user
        # Makes user admin (wheel and networkmanager)
        den._.primary-user
        # Sets shell for user at OS and HM level
        (den._.user-shell "zsh")
        # Provides per system inputs'
        # i.e environment.systemPackages = [ inputs'.nixpkgs.legacyPackages.hello ]
        den._.inputs'
        # Provides per system self'
        den._.self'
      ];
    };
  };
}

{
  den,
  inputs,
  lib,
  ...
}:
{
  # Setup for den
  flake-file.inputs.flake-file.url = lib.mkDefault "github:vic/flake-file";
  flake-file.inputs.den.url = lib.mkDefault "github:vic/den";
  imports = [
    (inputs.flake-file.flakeModules.dendritic or { })
    (inputs.den.flakeModules.dendritic or { })
  ];

  # den specific setup
  den = {
    schema.user.classes = [ "homeManager" ];
    default = {
      nixos = {
        system.stateVersion = "26.11";
        "home-manager" = {
          # For hosts with home manager users, automatically make home manager use host's nixpkgs
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "bak";
          # Removes current backup file before backing up
          # to avoid home manager switch errors
          backupCommand = ''
            bash -c 'rm -f "$0.bak" && mv "$0" "$0.bak"'
          '';
          # Home manager modules
          sharedModules = [
            inputs.spicetify-nix.homeManagerModules.default
            inputs.nix-index-database.homeModules.default
            inputs.noctalia.homeModules.default
          ];
        };
      };
      homeManager = {
        home.stateVersion = "26.11";
      };
      includes = [
        # Automatically sets home.username, home.homeDirectory, users.users.<name>
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
        # Automatically sets networking.hostName from host name
        den._.hostname
      ];
    };
  };
}

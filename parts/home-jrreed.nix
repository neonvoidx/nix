# Standalone home-manager configuration for macOS (jrreed user)
{ config, inputs, ... }:
let
  macUsername = config.macUsername;
in
{
  configurations.home.jrreed = {
    username = macUsername;
    system = "aarch64-darwin";
    module = {
      imports = [
        ../../home/common.nix
        ../../home/configs/mac
        inputs.sops-nix.homeManagerModules.sops
        inputs.stylix.homeManagerModules.stylix
        
        ({ lib, ... }: {
          home = {
            username = macUsername;
            homeDirectory = lib.mkForce "/Users/${macUsername}";
          };
          
          programs.git = {
            settings.user = {
              name = "jrreed";
              email = "jacob.reed@oracle.com";
            };
          };
          
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [ inputs.nur.overlays.default ];
        })
      ];
    };
  };
}

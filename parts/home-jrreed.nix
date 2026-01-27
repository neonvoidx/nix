# Standalone home-manager configuration for macOS (jrreed user)
{ config, inputs, ... }:
{
  configurations.home.jrreed = {
    username = config.macUsername;
    system = "aarch64-darwin";
    module = {
      imports = [
        ../../home/common.nix
        ../../home/configs/mac
        inputs.sops-nix.homeManagerModules.sops
        inputs.stylix.homeManagerModules.stylix
        
        ({ lib, ... }: {
          home = {
            username = config.macUsername;
            homeDirectory = lib.mkForce "/Users/${config.macUsername}";
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

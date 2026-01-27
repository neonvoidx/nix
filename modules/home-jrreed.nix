{ config, inputs, ... }:
let
  inherit (config.flake.modules) homeManager;
in
{
  configurations.homeManager.jrreed = {
    system = "aarch64-darwin";
    module = { pkgs, lib, ... }: {
      imports = [
        homeManager.common-base
        homeManager.packages
        homeManager.bat
        homeManager.btop
        homeManager.direnv
        homeManager.fastfetch
        homeManager.fzf
        homeManager.git
        homeManager.jq
        homeManager.just
        homeManager.kitty
        homeManager.lazygit
        homeManager.lsd
        homeManager.nixcats
        homeManager.nixvim-base
        homeManager.payrespects
        homeManager.stylix
        homeManager.tealdeer
        homeManager.tv
        homeManager.yazi
        homeManager.zoxide
        homeManager.zsh
        homeManager.mac-base
        inputs.spicetify-nix.homeManagerModules.default
        inputs.nix-index-database.homeModules.default
        inputs.sops-nix.homeManagerModules.sops
        inputs.stylix.homeManagerModules.stylix
      ];

      _module.args = {
        username = "jrreed";
        inherit inputs;
      };

      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = [ inputs.nur.overlays.default ];

      home = {
        username = "jrreed";
        homeDirectory = lib.mkForce "/Users/jrreed";
      };

      programs.git = {
        userName = "jrreed";
        userEmail = "jacob.reed@oracle.com";
      };
    };
  };
}

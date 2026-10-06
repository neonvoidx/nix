# Flake inputs and pre-build cache settings are declared here.
# Run `nix run .#write-flake` after changing either source.
{ lib, ... }:
let
  caches = import ../assets/nix/caches.nix;
in
{
  # Flake settings are applied before evaluation and the system build.
  flake-file.nixConfig = {
    inherit (caches) substituters trusted-public-keys;
  };

  flake-file.inputs = {
    den.url = "github:denful/den/refs/tags/v0.19.0";
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    betterfox = {
      url = "github:HeitorAugustoLN/betterfox-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    curseforge = {
      url = "github:spitfire05/curseforge-appimage-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-versions = {
      url = "github:vic/nix-versions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-config = {
      url = "github:neonvoidx/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
    };
    pear-desktop = {
      url = "github:h-banii/pear-desktop-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    scopebuddy = {
      url = "github:OpenGamingCollective/ScopeBuddy";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    eldritch-cursors = {
      url = "github:eldritch-theme/cursors";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # spicetify-nix = {
    #   url = "github:Gerg-L/spicetify-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:4evy/nixcord";
    };
    umbriel = {
      url = "github:noctalia-dev/umbriel/cachix";
    };
    multiverse = {
      url = "github:fzakaria/nixpkgs-multiverse";
    };
  };
}

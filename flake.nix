# DO-NOT-EDIT. This file was auto-generated using github:denful/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://neonvoidx.cachix.org"
      "https://noctalia.cachix.org"
      "https://umbriel.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "neonvoidx.cachix.org-1:nHFGhvzWqULuNWFbuPwTP0eUW+k7utl0chxXhUJhU1Y="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
    ];
  };

  inputs = {
    betterfox = {
      url = "github:HeitorAugustoLN/betterfox-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    curseforge = {
      url = "github:spitfire05/curseforge-appimage-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    den.url = "github:denful/den/refs/tags/v0.19.0";
    eldritch-cursors = {
      url = "github:eldritch-theme/cursors";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-file.url = "github:denful/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:denful/import-tree";
    multiverse.url = "github:fzakaria/nixpkgs-multiverse";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-versions = {
      url = "github:vic/nix-versions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord.url = "github:4evy/nixcord";
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    nvim-config = {
      url = "github:neonvoidx/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pear-desktop = {
      url = "github:h-banii/pear-desktop-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    scopebuddy = {
      url = "github:OpenGamingCollective/ScopeBuddy";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    umbriel.url = "github:noctalia-dev/umbriel/cachix";
  };
}

# All flake inputs are declared here so flake-file can regenerate flake.nix.
# Run `nix run .#write-flake` after adding or changing any input.
{ lib, ... }:
{
  flake-file.inputs = {
    den.url = "github:denful/den/refs/tags/v0.18.0";
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    # Temporary: nixos-unstable is broken for pkgsRocm/pkgsCuda in NixOS configs.
    # Fix PR: https://github.com/NixOS/nixpkgs/pull/550890
    # Issue:  https://github.com/NixOS/nixpkgs/issues/550852
    # Only used for blender-rocm; remove this input once the PR is merged.
    nixpkgs-blender.url = "github:qweered/nixpkgs/config-fix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
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
      url = "github:noctalia-dev/noctalia";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
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
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

{ inputs, ... }:
{
  # Base aspect: external NixOS module imports and shared nixpkgs config.
  # Included by both host aspects (void and voidframe).
  den.aspects.base.nixos = { ... }: {
    imports = [
      inputs.spicetify-nix.nixosModules.default
      inputs.sops-nix.nixosModules.sops
      inputs.stylix.nixosModules.stylix
    ];
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [
      inputs.nix-cachyos-kernel.overlays.pinned
    ];
  };
}

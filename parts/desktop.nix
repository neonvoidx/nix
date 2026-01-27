# Desktop environment and window manager configuration
{ config, ... }:
{
  flake.modules.nixos.desktop = { ... }: {
    imports = [
      ../../modules/desktop/fonts.nix
      ../../modules/desktop/environment.nix
      ../../modules/desktop/xdg.nix
      ../../modules/desktop/programs.nix
      ../../modules/packages/system.nix
      ../../modules/sops.nix
      ../../modules/stylix.nix
    ];
  };
}

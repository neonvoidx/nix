# Home-manager configuration for neonvoid user (Linux)
{ config, inputs, ... }:
{
  flake.modules.nixos.home-neonvoid = { ... }: {
    imports = [
      ../../home/common.nix
      ../../home/configs/linux
      ../../home/neonvoid/packages.nix
      ../../home/neonvoid/git.nix
      ../../home/neonvoid/files.nix
    ];
    
    programs.bash.enable = true;
    services = {
      udiskie.enable = true;
      playerctld.enable = true;
    };
  };
}

{ inputs, ... }:
{
  flake.modules.nixos.void = {
    imports = with inputs.self.modules.nixos; [
      desktop-base
      neonvoid
      network-drives
    ];

    system.stateVersion = "25.11";
  };
}

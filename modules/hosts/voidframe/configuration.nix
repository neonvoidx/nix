{ inputs, ... }:
{
  flake.modules.nixos.voidframe = {
    imports = with inputs.self.modules.nixos; [
      desktop-base
      neonvoid
    ];

    system.stateVersion = "25.11";
  };
}

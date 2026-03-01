{ inputs, ... }:
{
  flake.modules.nixos.voidframe = {
    imports = with inputs.self.modules.nixos; [
      base
      neonvoid
    ];

    system.stateVersion = "25.11";
  };
}

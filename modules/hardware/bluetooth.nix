{ ... }:
{
  flake.modules.nixos.bluetooth = {
    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          DisableSecurity = true;
        };
        LE = {
          MinConnectionInterval = 7;
          MaxConnectionInterval = 9;
          ConnectionLatency = 0;
        };
      };
    };
  };
}

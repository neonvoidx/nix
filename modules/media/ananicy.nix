{ den, ... }:
{
  den.aspects.ananicy.nixos =
    { pkgs, ... }:
    {
      services = {
        ananicy = {
          enable = true;
          package = pkgs.ananicy-cpp;
          rulesProvider = pkgs.ananicy-rules-cachyos;
          extraRules = [
            # Prevent Discord/Vesktop audio crackling during gaming
            {
              name = "vesktop";
              type = "LowLatency_RT";
            }
            {
              name = "Discord";
              type = "LowLatency_RT";
            }
            # PipeWire audio server needs RT priority
            {
              name = "pipewire";
              type = "LowLatency_RT";
            }
            {
              name = "pipewire-pulse";
              type = "LowLatency_RT";
            }
          ];
        };
      };
    };
}

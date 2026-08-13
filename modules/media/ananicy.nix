{ den, ... }:
{
  den.aspects.ananicy.nixos =
    { pkgs, config, ... }:
    {
      services = {
        ananicy = {
          enable = true;
          # TODO remove after
          # https://github.com/NixOS/nixpkgs/pull/552211 — remove this pin once merged.
          package = config.multiverse.pinned.ananicy-cpp;
          rulesProvider = pkgs.ananicy-rules-cachyos;
          extraRules = [
            # Prevent Discord audio crackling during gaming
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

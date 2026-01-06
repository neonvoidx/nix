{ ... }:
{
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    wireplumber = {
      enable = true;
    };
    pulse.enable = true;
    jack.enable = true;
    extraConfig.pipewire = {
      "10-low-latency.conf" = {
        "context.properties" = {
          "default.frags" = 8;
          "default.frag-size" = 4096;
        };
      };
      "10-max-buffers" = {
        "context.properties" = {
          "link.max-buffers" = 64;
        };
      };
      "11-clock-rates" = {
        "context-properties" = {
          "default.clock.rate" = 96000;
          "default.clock.allowed-rates" = [
            44100
            48000
            88200
            96000
            176400
            192000
          ];
          "default.clock.quantum" = 4096;
          "default.clock.min-quantum" = 1025;
          "default.clock.max-quantum" = 4096;
        };
      };
    };
  };

  security.rtkit.enable = true;
}

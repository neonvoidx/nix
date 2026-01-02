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
      extraConfig = {
        # TODO set https://wiki.archlinux.org/title/WirePlumber#Disable_a_device/node 2.6 node prio
      };
    };
    pulse.enable = true;
    jack.enable = true;
    extraConfig.pipewire = {
      "10-max-buffers" = {
        "context.properties" = {
          "link.max-buffers" = 64;
        };
      };
      "11-clock-rates" = {
        "context-properties" = {
          "default.clock.rate" = 48000;
          "default.clock.allowed-rates" = [
            44100
            48000
            88200
            96000
            176400
            192000
          ];
          "default.clock.quantum" = 256;
          "default.clock.min-quantum" = 64;
          "default.clock.max-quantum" = 2048;
        };
      };
    };
  };

  security.rtkit.enable = true;
}

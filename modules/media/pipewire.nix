{ lib, ... }:
{
  den.aspects.pipewire =
    { host, ... }:
    {
      nixos =
        { pkgs, ... }:
        {
          # Realtime priority
          security.rtkit.enable = true;
          services.pipewire = {
            enable = true;
            audio.enable = true;
            alsa = {
              enable = true;
              support32Bit = true;
            };
            wireplumber.enable = true;
            pulse.enable = true;
            jack.enable = true;

            extraLadspaPackages = [ pkgs.rnnoise-plugin.ladspa ];

            extraConfig.pipewire-pulse."99-silence-warnings" = {
              "context.properties" = {
                "log.level" = 1;
              };
            };

            # Good sane defaults for gaming and audio
            extraConfig.pipewire = {
              "10-low-latency.conf" = {
                "context.properties" = {
                  "default.frags" = 16;
                  "default.frag-size" = 1024;
                };
              };
              "10-max-buffers" = {
                "context.properties" = {
                  "link.max-buffers" = 128;
                  "mem.allow-mlock" = true;
                  "mem.mlock-all" = false;
                };
              };
              "11-clock-rates" = {
                "context-properties" = {
                  "default.clock.rate" = 48000;
                  "default.clock.allowed-rates" = [
                    44100
                    88200
                    176400
                    48000
                    96000
                    192000
                  ];
                  "default.clock.quantum" = 1024;
                  "default.clock.min-quantum" = 256;
                  "default.clock.max-quantum" = 8192;
                };
              };
              "10-rnnoise-source" = {
                "context.modules" = [
                  {
                    name = "libpipewire-module-filter-chain";
                    flags = [ "nofail" ];
                    args = {
                      "node.description" = "Noise Canceling source";
                      "media.name" = "Noise Canceling source";
                      "filter.graph" = {
                        nodes = [
                          {
                            type = "ladspa";
                            name = "rnnoise";
                            plugin = "librnnoise_ladspa";
                            label = "noise_suppressor_mono";
                            control = {
                              "VAD Threshold (%)" = 50.0;
                            };
                          }
                        ];
                      };
                      "audio.position" = [
                        "FL"
                        "FR"
                      ];
                      "capture.props" = {
                        "node.name" = "effect_input.rnnoise";
                        "node.passive" = true;
                      };
                      "playback.props" = {
                        "node.name" = "effect_output.rnnoise";
                        "media.class" = "Audio/Source";
                      };
                    };
                  }
                ];
              };
            };

            wireplumber.extraConfig = lib.mkMerge [
              {
                # Low latency for gaming
                "53-gaming-low-latency" = {
                  "monitor.alsa.rules" = [
                    {
                      matches = [
                        { "application.process.binary" = "~.*wine.*"; }
                        { "application.process.binary" = "~.*proton.*"; }
                        { "application.name" = "~.*\\.exe"; }
                        { "application.name" = "~.*steam_app.*"; }
                        { "application.name" = "~.*pressure-vessel.*"; }
                        { "application.process.binary" = "~.*reaper.*"; }
                        { "application.name" = "~.*World of Warcraft.*"; }
                        { "application.name" = "~.*Diablo.*"; }
                        { "application.name" = "~.*Overwatch.*"; }
                        { "application.name" = "~.*Counter-Strike.*"; }
                        { "application.name" = "~.*cs2.*"; }
                        { "application.name" = "~.*Dota.*"; }
                        { "application.name" = "~.*Apex.*"; }
                        { "application.name" = "~.*Fortnite.*"; }
                        { "application.name" = "~.*Unity.*"; }
                        { "application.name" = "~.*UnrealEngine.*"; }
                        { "application.name" = "~.*gameoverlayui.*"; }
                        { "application.process.binary" = "~.*retroarch.*"; }
                        { "application.process.binary" = "~.*dolphin-emu.*"; }
                        { "application.process.binary" = "~.*pcsx2.*"; }
                        { "application.process.binary" = "~.*rpcs3.*"; }
                        { "application.process.binary" = "~.*yuzu.*"; }
                        { "application.process.binary" = "~.*cemu.*"; }
                        { "application.process.binary" = "~.*ryujinx.*"; }
                      ];
                      actions = {
                        update-props = {
                          "node.latency" = "1024/48000";
                          "api.alsa.period-size" = 1024;
                          "api.alsa.headroom" = 4096;
                          "resample.quality" = 4;
                        };
                      };
                    }
                  ];
                };
                # Optimizes VOIP applications
                "54-voip-optimize" = {
                  "monitor.alsa.rules" = [
                    {
                      matches = [
                        { "application.process.binary" = "~.*vesktop.*"; }
                        { "application.process.binary" = "~.*discord.*"; }
                        { "application.process.binary" = "~.*Discord.*"; }
                        { "application.name" = "~.*Vesktop.*"; }
                        { "application.name" = "~.*Discord.*"; }
                        { "application.process.binary" = "~.*teamspeak.*"; }
                        { "application.process.binary" = "~.*mumble.*"; }
                        { "application.process.binary" = "~.*slack.*"; }
                      ];
                      actions = {
                        update-props = {
                          "node.latency" = "1024/48000";
                          "api.alsa.period-size" = 1024;
                          "api.alsa.headroom" = 4096;
                          "resample.quality" = 4;
                        };
                      };
                    }
                  ];
                };
              }
              # Device disabling
              # NOTE: Host specific
              # disables all random devices we don't use
              # like motherboard IO audio devices
              (lib.mkIf (host ? audio) {
                "51-disable-devices" = {
                  "monitor.alsa.rules" = [{
                    matches = map (n: { "node.name" = n; }) host.audio.disabledNodes;
                    actions.update-props."node.disabled" = true;
                  }];
                };
                "52-default-devices" = {
                  "monitor.alsa.rules" = [
                    {
                      matches = [{ "node.name" = host.audio.defaultMic; }];
                      actions.update-props."priority.session" = 2000;
                    }
                    {
                      matches = [{ "node.name" = host.audio.defaultSpeaker; }];
                      actions.update-props."priority.session" = 1000;
                    }
                  ];
                };
                "53-bluez-devices" = {
                  "monitor.bluez.rules" = [{
                    matches = [{ "device.name" = host.audio.bluetoothCard; }];
                    actions = {
                      update-props = {
                        "bluez5.auto-connect" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
                        "bluez5.hw-volume" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
                      };
                    };
                  }];
                };
              })
            ];
          };
        };

    };
}

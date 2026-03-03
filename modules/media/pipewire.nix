{ lib, ... }:
{
  den.aspects.pipewire =
    { host, ... }:
    {
      nixos =
        { ... }:
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
            };

            wireplumber.extraConfig = lib.mkMerge [
              {
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
              (lib.mkIf (host.hostName == "void") {
                "51-disable-devices" = {
                  "monitor.alsa.rules" = [
                    {
                      matches = [
                        { "node.name" = "alsa_input.usb-Generic_USB_Audio-00.HiFi__Mic2__source"; }
                        { "node.name" = "alsa_input.usb-Generic_USB_Audio-00.HiFi__Mic1__source"; }
                        { "node.name" = "alsa_output.pci-0000_03_00.1.hdmi-stereo-extra1"; }
                        { "node.name" = "alsa_output.usb-R__DE_Microphones_R__DE_NT-USB_Mini_F5DF5DCC-00.analog-stereo"; }
                        { "node.name" = "alsa_output.usb-Generic_USB_Audio-00.HiFi__SPDIF__sink"; }
                        { "node.name" = "alsa_output.usb-Generic_USB_Audio-00.HiFi__Headphones__sink"; }
                        { "node.name" = "alsa_output.usb-Generic_USB_Audio-00.HiFi__Speaker__sink"; }
                      ];
                      actions.update-props."node.disabled" = true;
                    }
                  ];
                };
                # Default devices
                "52-default-devices" = {
                  "monitor.alsa.rules" = [
                    {
                      matches = [
                        { "node.name" = "alsa_input.usb-R__DE_Microphones_R__DE_NT-USB_Mini_F5DF5DCC-00.mono-fallback"; }
                      ];
                      actions.update-props."priority.session" = 2000;
                    }
                    {
                      matches = [
                        { "node.name" = "alsa_output.usb-Schiit_Audio_Schiit_Unison_Modius_ES-00.analog-stereo"; }
                      ];
                      actions.update-props."priority.session" = 1000;
                    }
                  ];
                };
                # Bluetooth devices
                "53-bluez-devices" = {
                  "monitor.bluez.rules" = [
                    {
                      matches = [ { "device.name" = "bluez_card.D0_8C_68_6F_52_78"; } ];
                      actions = {
                        update-props = {
                          "bluez5.auto-connect" = [
                            "hfp_hf"
                            "hsp_hs"
                            "a2dp_sink"
                          ];
                          "bluez5.hw-volume" = [
                            "hfp_hf"
                            "hsp_hs"
                            "a2dp_sink"
                          ];
                        };
                      };
                    }
                  ];
                };
              })
            ];
          };

        };
    };
}

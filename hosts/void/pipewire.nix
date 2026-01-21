{ ... }:
{

  services.pipewire = {
    extraConfig.pipewire = {
      "10-low-latency.conf" = {
        "context.properties" = {
          "default.frags" = 16;
          "default.frag-size" = 1024;
        };
      };
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
          "default.clock.quantum" = 1024;
          "default.clock.min-quantum" = 256;
          "default.clock.max-quantum" = 8192;
        };
      };
    };
  };
  services.pipewire.wireplumber.extraConfig = {
    "51-disable-devices" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            # Disable USB Audio front microphone (Mic2)
            { "node.name" = "alsa_input.usb-Generic_USB_Audio-00.HiFi__Mic2__source"; }
            # Disable USB Audio rear input (Mic1)
            { "node.name" = "alsa_input.usb-Generic_USB_Audio-00.HiFi__Mic1__source"; }
            # Disable Navi 48 HDMI audio controller output
            { "node.name" = "alsa_output.pci-0000_03_00.1.hdmi-stereo-extra1"; }
            # Disable RØDE NT-USB Mini analog stereo output
            { "node.name" = "alsa_output.usb-R__DE_Microphones_R__DE_NT-USB_Mini_F5DF5DCC-00.analog-stereo"; }
            # Disable USB Audio S/PDIF output
            { "node.name" = "alsa_output.usb-Generic_USB_Audio-00.HiFi__SPDIF__sink"; }
            # Disable USB Audio front headphones
            { "node.name" = "alsa_output.usb-Generic_USB_Audio-00.HiFi__Headphones__sink"; }
            # Disable USB Audio speakers
            { "node.name" = "alsa_output.usb-Generic_USB_Audio-00.HiFi__Speaker__sink"; }
          ];
          actions = {
            update-props = {
              "node.disabled" = true;
            };
          };
        }
      ];
    };
    "52-default-devices" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            # Set RØDE NT-USB Mini as default input
            { "node.name" = "alsa_input.usb-R__DE_Microphones_R__DE_NT-USB_Mini_F5DF5DCC-00.mono-fallback"; }
          ];
          actions = {
            update-props = {
              "priority.session" = 2000;
            };
          };
        }
        {
          matches = [
            # Set Schiit Unison Modius ES as default output
            { "node.name" = "alsa_output.usb-Schiit_Audio_Schiit_Unison_Modius_ES-00.analog-stereo"; }
          ];
          actions = {
            update-props = {
              "priority.session" = 2000;
            };
          };
        }
      ];
    };
    "53-gaming-low-latency" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            # Force lower quantum for games to get rid of crackling
            # Wine/Proton games
            { "application.process.binary" = "~.*wine.*"; }
            { "application.process.binary" = "~.*proton.*"; }
            { "application.name" = "~.*\.exe"; }
            # Steam games
            { "application.name" = "~.*steam_app.*"; }
            { "application.name" = "~.*pressure-vessel.*"; }
            { "application.process.binary" = "~.*reaper.*"; }
            # Specific games
            { "application.name" = "~.*World of Warcraft.*"; }
            { "application.name" = "~.*Diablo.*"; }
            { "application.name" = "~.*Overwatch.*"; }
            { "application.name" = "~.*Counter-Strike.*"; }
            { "application.name" = "~.*cs2.*"; }
            { "application.name" = "~.*Dota.*"; }
            { "application.name" = "~.*Apex.*"; }
            { "application.name" = "~.*Fortnite.*"; }
            # Game engines/launchers
            { "application.name" = "~.*Unity.*"; }
            { "application.name" = "~.*UnrealEngine.*"; }
            { "application.name" = "~.*gameoverlayui.*"; }
            # Emulators
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
              "node.latency" = "512/48000";
              "api.alsa.period-size" = 512;
              "api.alsa.headroom" = 2048;
            };
          };
        }
      ];
    };
  };
}

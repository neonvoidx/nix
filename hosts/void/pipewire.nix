{ ... }:
{
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
  };
}

{ den, ... }:
let
  neonvoid = {
    gitName = "neonvoidx";
    gitEmail = "me@neonvoid.dev";
    emailName = "neonvoidx";
    emailAddress = "me@neonvoid.dev";
  };
  timezone = "America/New_York";
in
{
  den.hosts.x86_64-linux = {
    void = {
      users.neonvoid = neonvoid;

      monitors = {
        main = {
          name = "DP-2";
          mode = "3440x1440@143.92";
          scale = 1.0;
          bitdepth = 10;
          cm = "hdredid";
          supports_hdr = true;
          supports_wide_color = true;
          vrr = 1;
          sdrbrightness = 0.5;
          sdrsaturation = 1.0;
          sdr_max_luminance = 408;
          sdr_min_luminance = 0.2339;
          position = "4880x1440";
          primary = true;
        };
        secondary = {
          name = "DP-3";
          mode = "3440x1440@143.92";
          scale = 1.0;
          bitdepth = 10;
          cm = "hdredid";
          supports_hdr = true;
          supports_wide_color = true;
          vrr = 1;
          sdrbrightness = 0.5;
          sdrsaturation = 1.0;
          sdr_max_luminance = 408;
          sdr_min_luminance = 0.2339;
          position = "4880x0";
        };
        portrait = {
          name = "HDMI-A-1";
          mode = "2560x1440@59.95";
          scale = 1.0;
          transform = 1;
          position = "3440x727";
        };
      };

      isMultiMonitor = true;
      xRes = "3440";
      yRes = "1440";

      gpuPciDev = "0000:03:00.0"; # AMD RX 9070 XT
      gpuPciAudioDev = "0000:03:00.1";
      gpuVendorDeviceId = "1002:7550";

      audio = {
        disabledNodes = [
          "alsa_input.usb-Generic_USB_Audio-00.HiFi__Mic2__source"
          "alsa_input.usb-Generic_USB_Audio-00.HiFi__Mic1__source"
          "alsa_output.pci-0000_03_00.1.hdmi-stereo-extra1"
          "alsa_output.usb-R__DE_Microphones_R__DE_NT-USB_Mini_F5DF5DCC-00.analog-stereo"
          "alsa_output.usb-Generic_USB_Audio-00.HiFi__SPDIF__sink"
          "alsa_output.usb-Generic_USB_Audio-00.HiFi__Headphones__sink"
          "alsa_output.usb-Generic_USB_Audio-00.HiFi__Speaker__sink"
        ];
        defaultMic = "alsa_input.usb-R__DE_Microphones_R__DE_NT-USB_Mini_F5DF5DCC-00.mono-fallback";
        defaultSpeaker = "alsa_output.usb-Schiit_Audio_Schiit_Unison_Modius_ES-00.analog-stereo";
        bluetoothCard = "bluez_card.D0_8C_68_6F_52_78";
      };

      network = {
        dns = [ "192.168.86.7" "192.168.86.8" ];
        interface = "eth0";
        mac = "9c:6b:00:98:96:96";
        ip = "192.168.86.20";
        prefixLength = 24;
        gateway = "192.168.86.1";
      };

      nasIp = "192.168.86.6";
      printerUri = "ipps://192.168.86.186/ipp/print";

      greeting = "The Void";
      timezone = timezone;
      isGaming = true;
    };

    voidframe = {
      users.neonvoid = neonvoid;

      monitors = {
        builtin = {
          name = "eDP-1";
          mode = "2880x1920@120";
          scale = 1.33333;
          position = "0x0";
          primary = true;
        };
      };

      isLaptop = true;
      xRes = "2880";
      yRes = "1920";

      network = {
        wireless = true;
      };

      greeting = "Void Frame";
      timezone = timezone;
      isGaming = false;
    };
  };
}

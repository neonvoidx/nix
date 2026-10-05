{ den, ... }:
let
  neonvoid = {
    gitName = "neonvoidx";
    gitEmail = "me@neonvoid.dev";
    avatar = ../assets/.face;
    logo = ../assets/neonvoid.png;
    wallpaperRepository = "https://github.com/neonvoidx/pics";
    # Each account must provide address and userName, or addressSecret and userNameSecret.
    emailAccounts = {
      thundermail = {
        primary = true;
        realName = "neonvoidx";
        addressSecret = "email/neonvoid/thundermail/address-json";
        userNameSecret = "email/neonvoid/thundermail/user-name-json";
        imap = {
          host = "mail.thundermail.com";
          port = 993;
          tls.enable = true;
          authentication = "xoauth2";
        };
        smtp = {
          host = "mail.thundermail.com";
          port = 465;
          tls.enable = true;
          authentication = "xoauth2";
        };
      };
      gmail = {
        primary = false;
        realName = "Jacob Reed";
        addressSecret = "email/neonvoid/gmail/address-json";
        userNameSecret = "email/neonvoid/gmail/user-name-json";
        imap = {
          host = "imap.gmail.com";
          port = 993;
          tls.enable = true;
        };
        smtp = {
          host = "smtp.gmail.com";
          port = 587;
          tls = {
            enable = true;
            useStartTls = true;
          };
        };
      };
    };
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
          mode = "3440x1440@360.10";
          scale = 1.0;
          bitdepth = 10;
          cm = "hdredid";
          supports_hdr = true;
          supports_wide_color = true;
          vrr = 1;
          sdrbrightness = 0.3;
          sdrsaturation = 1.0;
          sdr_max_luminance = 1345;
          sdr_white = 1345;
          sdr_min_luminance = 0.0002;
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
          sdrbrightness = 0.8;
          sdrsaturation = 1.0;
          sdr_max_luminance = 408;
          sdr_white = 408;
          sdr_min_luminance = 0.2339;
          position = "4880x0";
        };
        portrait = {
          name = "HDMI-A-1";
          mode = "2560x1440@59.95";
          scale = 1.0;
          # Transform list:
          # 0 -> normal (no transforms)
          # 1 -> 90 degrees
          # 2 -> 180 degrees
          # 3 -> 270 degrees
          # 4 -> flipped
          # 5 -> flipped + 90 degrees
          # 6 -> flipped + 180 degrees
          # 7 -> flipped + 270 degrees
          transform = 1;
          position = "3440x727";
          # If monitor is rotated, i.e portrait mode
          #
          isRotated = true;
          sdr_white = 400;
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
        dns = [
          "192.168.86.7"
          "192.168.86.8"
        ];
        interface = "eth0";
        mac = "9c:6b:00:98:96:96";
        ip = "192.168.86.20";
        prefixLength = 24;
        gateway = "192.168.86.1";
      };

      printer = {
        name = "HP_Color_LaserJet_MFP_M182nw";
        location = "Home";
        deviceUri = "ipps://192.168.86.186/ipp/print";
        model = "everywhere";
        drivers = [
          "hplipWithPlugin"
          "cups-filters"
        ];
        ppdOptions = {
          PageSize = "Letter";
          ColorModel = "RGB";
        };
      };

      gamesLocation = "/games";
      gaming.environment = {
        PROTON_ENABLE_HDR = "1";
        PROTON_FSR4_UPGRADE = "1";
        PROTON_XESS_UPGRADE = "1";
        # RDNA4 workarounds for VKD3D ring timeouts and upload heaps.
        RADV_DEBUG = "nomeshshader";
        VKD3D_CONFIG = "no_upload_hvv";
      };

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
          sdr_white = 400;
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

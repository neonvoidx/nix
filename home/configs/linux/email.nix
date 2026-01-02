{ pkgs, ... }:
{
  services.protonmail-bridge = {
    enable = true;
    extraPackages = with pkgs; [ gnome-keyring ];
  };
  programs.thunderbird = {
    enable = true;
    settings = {
      "privacy.donottrackheader.enabled" = true;
    };

    profiles."default" = {
      isDefault = true;
      accountsOrder = [
        "proton"
        "gmail"
      ];
    };
  };

  accounts.email.accounts = {
    "proton" = {
      primary = true;
      realName = "neonvoidx";
      address = "me@neonvoid.dev";
      userName = "me@neonvoid.dev";

      # Proton Mail Bridge configuration
      imap = {
        host = "127.0.0.1";
        port = 1143;
        tls.enable = true;
        authentication = "login";
      };

      smtp = {
        host = "127.0.0.1";
        port = 1025;
        tls = {
          enable = true;
          useStartTls = true;
        };
        authentication = "login";
      };

      passwordCommand = "cat /run/secrets/proton-bridge-password";

      thunderbird = {
        enable = true;
        profiles = [ "default" ];
      };
    };

    "gmail" = {
      primary = false;
      realName = "Jacob Reed";
      address = "jacob.russell.reed@gmail.com";
      userName = "jacob.russell.reed@gmail.com";

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

      passwordCommand = "cat /run/secrets/gmail-app-password";

      thunderbird = {
        enable = true;
        profiles = [ "default" ];
      };
    };
  };
}

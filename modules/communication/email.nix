{ ... }:
{
  den.aspects.email.homeManager =
    { pkgs, ... }:
    {
      services.protonmail-bridge = {
        enable = true;
        extraPackages = with pkgs; [ gnome-keyring ];
      };

      systemd.user.services.protonmail-bridge = {
        Unit = {
          After = [
            "graphical-session.target"
            "gnome-keyring.service"
          ];
          Wants = [ "gnome-keyring.service" ];
        };
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
          extensions = [ ];
          settings = {
            extensions.autoDisableScopes = 0;
          };
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
            tls = {
              enable = true;
              useStartTls = true;
            };
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

          thunderbird = {
            enable = true;
            profiles = [ "default" ];
          };
        };
      };
    };
}

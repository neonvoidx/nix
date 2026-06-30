{ den, ... }:
{
  den.aspects.email.homeManager =
    { pkgs, ... }:
    {
      programs.thunderbird = {
        enable = true;
        settings = {
          "privacy.donottrackheader.enabled" = true;
        };

        profiles."default" = {
          isDefault = true;
          accountsOrder = [
            "thundermail"
            "gmail"
          ];
          extensions = [ ];
          settings = {
            extensions.autoDisableScopes = 0;
          };
        };
      };

      accounts.calendar.accounts = {
        "thundermail" = {
          primary = true;
          remote = {
            type = "caldav";
            url = "https://mail.thundermail.com";
            userName = "me@neonvoid.dev";
          };
          thunderbird = {
            enable = true;
            profiles = [ "default" ];
          };
        };
      };

      accounts.email.accounts = {
        "thundermail" = {
          primary = true;
          realName = "neonvoidx";
          address = "me@neonvoid.dev";
          userName = "me@neonvoid.dev";

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

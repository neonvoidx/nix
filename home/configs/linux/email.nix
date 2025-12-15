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
      # TODO secret these out
      realName = "neonvoidx";
      address = "me@neonvoid.dev";
      userName = "me@neonvoid.dev";

      # TODO protonmailbridge stuff
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

      # sops-nix pw:
      # passwordCommand = "cat ${hm-secrets.gmail_myname_smtp_pass}";

      thunderbird = {
        enable = true; # generate thunderbird config for this account
        profiles = [ "default" ]; # attach to that profile
      };
    };

    "gmail" = {
      primary = false;
      # TODO secret this out
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

      # sops-nix pw:
      # passwordCommand = "cat ${hm-secrets.gmail_myname_smtp_pass}";

      thunderbird = {
        enable = true; # generate thunderbird config for this account
        profiles = [ "default" ]; # attach to that profile
      };
    };
  };
}

{ config, ... }:
{
  flake.modules.homeManager.gnome-keyring = { pkgs, lib, config, ... }: {
    services.gnome-keyring = {
      enable = true;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };
  };
}

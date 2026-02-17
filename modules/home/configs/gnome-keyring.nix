{ ... }:
{
  flake.modules.homeManager.gnome-keyring =
    { pkgs, lib, ... }:
    {
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

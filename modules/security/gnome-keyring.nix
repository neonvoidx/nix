{ den, ... }:
{
  den.aspects.gnome-keyring = {
    nixos = {
      services.gnome.gnome-keyring.enable = true;
    };
    homeManager = {
      services.gnome-keyring = {
        enable = true;
        components = [
          "pkcs11"
          "secrets"
          "ssh"
        ];
      };
    };
  };
}

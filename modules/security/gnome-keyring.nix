{ den, ... }:
{
  den.aspects.gnome-keyring.nixos =
    { ... }:
    {
      services.gnome.gnome-keyring.enable = true;
    };

  den.aspects.gnome-keyring.homeManager =
    { ... }:
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

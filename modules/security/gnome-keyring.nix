{ ... }:
{
  flake.modules.nixos.gnome-keyring = { ... }: {
    services.gnome.gnome-keyring.enable = true;
  };

  flake.modules.homeManager.gnome-keyring =
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

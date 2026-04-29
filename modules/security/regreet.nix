{ den, ... }:
{
  den.aspects.regreet =
    { host, ... }:
    {
      nixos =
        { ... }:
        {
          services.greetd.enable = true;

          programs.regreet = {
            enable = true;
            settings = {
              appearance.greeting_msg = host.greeting or "Welcome back!";
              GTK.application_prefer_dark_theme = true;
            };
          };

          # Unlock gnome-keyring via greetd's PAM session
          security.pam.services.greetd.enableGnomeKeyring = true;
        };
    };
}

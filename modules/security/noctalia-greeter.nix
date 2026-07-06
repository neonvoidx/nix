{ den, inputs, ... }:
{
  den.aspects.noctalia-greeter =
    { host, user, ... }:
    {
      nixos =
        { pkgs, ... }:
        {
          imports = [
            (inputs.noctalia-greeter.nixosModules.default or inputs.noctalia-greeter)
          ];

          programs = {
            noctalia-greeter = {
              enable = true;
              package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
              greeter-args = "";
              settings = {
                user = {
                  default = user.userName;
                };
                output = {
                  layout = if host.isMultiMonitor or false then "DP-3:4880,0; DP-2:4880,1440" else "";
                };
                appearance = {
                  scheme = "Eldritch";
                };
                cursor = {
                  theme = "eldritch-great-old-green-cursors";
                  size = 32;
                };
              };
            };
          };

          security.pam.services.greetd.enableGnomeKeyring = true;
        };
    };
}

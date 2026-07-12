{ den, inputs, ... }:
{
  den.aspects.noctalia-greeter =
    { host, user, ... }:
    {
      nixos =
        { pkgs, lib, ... }:
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
                  layout = lib.concatStringsSep "; " (
                    lib.optionals (builtins.hasAttr "monitors" host) (
                      lib.optional (builtins.hasAttr "main" host.monitors) "${host.monitors.secondary.name}:${
                        builtins.replaceStrings [ "x" ] [ "," ] host.monitors.main.position
                      }"
                      ++ lib.optional (builtins.hasAttr "secondary" host.monitors) "${host.monitors.main.name}:${
                        builtins.replaceStrings [ "x" ] [ "," ] host.monitors.secondary.position
                      }"
                    )
                  );
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

{ ... }:
{
  den.aspects.greetd.nixos =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet -g 'The Void' --asterisks -t -r --theme text=green;time=cyan;container=gray;border=magenta;title=cyan;greet=magenta;prompt=green;input=red;action=red;button=magenta";
            user = "greeter";
          };
        };
      };

      systemd.services.greetd = lib.mkIf (config.networking.hostName == "void") {
        preStart = ''
          ${pkgs.fbset}/bin/fbset -xres 3440 -yres 1440
        '';
      };
    };
}

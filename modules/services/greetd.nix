{ ... }:
{
  flake.modules.nixos.greetd =
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

      # Suppress kernel messages on the TTY where greetd runs
      boot.kernelParams = [ "quiet" "loglevel=3" "systemd.show_status=auto" "rd.udev.log_level=3" ];

      systemd.services.greetd = lib.mkIf (config.networking.hostName == "void") {
        preStart = ''
          ${pkgs.fbset}/bin/fbset -xres 3440 -yres 1440
        '';
      };
    };
}

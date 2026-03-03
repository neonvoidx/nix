{ den, ... }:
{
  den.aspects.greetd =
    { host, ... }:
    {
      nixos =
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
                command = "${pkgs.tuigreet}/bin/tuigreet -g '${host.greeting}' --asterisks -t -r --theme text=green;time=cyan;container=gray;border=magenta;title=cyan;greet=magenta;prompt=green;input=red;action=red;button=magenta";
                user = "greeter";
              };
            };
          };

          # If multimonitor we add a pre exec to run fbset with our primary display resolution
          # this is so the main monitor TTY greetd for tuigreet isn't cropped
          systemd.services.greetd = lib.mkIf (host.isMultiMonitor or false) {
            preStart = ''
              ${pkgs.fbset}/bin/fbset -xres ${host.xRes} -yres ${host.yRes}
            '';
          };
        };
    };
}

{ pkgs, ... }:
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
}

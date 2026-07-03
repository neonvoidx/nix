{ den, ... }:
{
  den.aspects.polkit.nixos =
    { pkgs, ... }:
    {
      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.systemd1.manage-units" && 
              subject.isInGroup("wheel")) {
              polkit.log(action.lookup("unit"));
              return polkit.Result.YES;
          }
        });
      '';
    };
}

{ den, ... }:
{
  den.aspects.systemd.nixos = {
    systemd = {
      network.enable = true;
      sleep.extraConfig = ''
        AllowSuspend=yes
        AllowHibernation=yes
        SuspendState=mem
        SuspendMode=deep
      '';
      settings = {
        Manager = {
          DefaultTimeoutStopSec = "10s";
        };
      };
      services = {
        greetd.serviceConfig = {
          Type = "idle";
          StandardInput = "tty";
          StandardOutput = "tty";
          StandardError = "journal";
          TTYReset = true;
          TTYVHangup = true;
          TTYVTDisallocate = true;
        };
      };
    };
  };
}

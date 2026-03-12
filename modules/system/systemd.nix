{ den, ... }:
{
  den.aspects.systemd.nixos = {
    systemd = {
      network.enable = true;
      sleep.settings.Sleep = {
        AllowSuspend = "yes";
        AllowHibernation = "yes";
        SuspendState = "mem";
        SuspendMode = "deep";
      };
      settings = {
        Manager = {
          DefaultTimeoutStopSec = "10s";
        };
      };
    };
  };
}

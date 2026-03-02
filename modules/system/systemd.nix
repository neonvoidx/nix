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

    system.activationScripts.logRebuildTime = {
      text = ''
        LOG_FILE="/var/log/nixos-rebuild-log.json"
        TIMESTAMP=$(date "+%d/%m")
        GENERATION=$(readlink /nix/var/nix/profiles/system | grep -o '[0-9]\+')

        echo "{\"last_rebuild\": \"$TIMESTAMP\", \"generation\": $GENERATION}" > "$LOG_FILE"
        chmod 644 "$LOG_FILE"
      '';
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Enable automounting for network drives
  services.rpcbind.enable = true;

  # Helper to create mount configs for Synology shares
  systemd.mounts =
    map
      (share: {
        type = "nfs";
        mountConfig = {
          Options = "rw,noatime,vers=4,soft,timeo=30";
        };
        what = "192.168.86.6:/volume1/${share}";
        where = "/synology/${share}";
        wantedBy = lib.mkForce [ ];
      })
      [
        "Books"
        "Photos"
        "3D"
        "VMs"
        "Emulation"
        "Dracula Pro"
        "CloneHero"
        "Docker"
        "torrent"
        "TV"
        "Prerolls"
        "NZB"
        "Music"
        "Movies"
        "software"
        "Secure"
      ];

  systemd.automounts =
    map
      (share: {
        wantedBy = [ "multi-user.target" ];
        automountConfig = {
          TimeoutIdleSec = "600";
        };
        where = "/synology/${share}";
        unitConfig = {
          DefaultDependencies = "no";
        };
      })
      [
        "Books"
        "Photos"
        "3D"
        "VMs"
        "Emulation"
        "Dracula Pro"
        "CloneHero"
        "Docker"
        "torrent"
        "TV"
        "Prerolls"
        "NZB"
        "Music"
        "Movies"
        "software"
      ];

  # Ensure mount points exist
  systemd.tmpfiles.rules = map (share: "d /synology/${share} 0755 root root") [
    "Books"
    "Photos"
    "3D"
    "VMs"
    "Emulation"
    "Dracula Pro"
    "CloneHero"
    "Docker"
    "torrent"
    "TV"
    "Prerolls"
    "NZB"
    "Music"
    "Movies"
    "software"
    "Secure"
  ];

  # Install utilities for network file systems
  environment.systemPackages = with pkgs; [
    nfs-utils
    cifs-utils
  ];
}

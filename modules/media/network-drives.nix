{ den, ... }:
{
  den.aspects.networkdrives = {
    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        services.rpcbind.enable = true;

        systemd.mounts =
          map
            (share: {
              type = "nfs";
              what = "192.168.86.6:/volume1/${share}";
              where = "/synology/${share}";
              mountConfig.Options = "rw,noatime,vers=4,soft,timeo=30";
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
              "PixelArt"
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
              automountConfig.TimeoutIdleSec = "600";
              where = "/synology/${share}";
            })
            [
              "Books"
              "Photos"
              "3D"
              "VMs"
              "Emulation"
              "Dracula Pro"
              "PixelArt"
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

        systemd.tmpfiles.rules = map (share: "d '/synology/${share}' 0777 root root") [
          "Books"
          "Photos"
          "3D"
          "VMs"
          "Emulation"
          "Dracula Pro"
          "CloneHero"
          "PixelArt"
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

        environment.systemPackages = with pkgs; [
          nfs-utils
          cifs-utils
        ];
      };
  };
}

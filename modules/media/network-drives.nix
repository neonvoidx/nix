{ den, ... }:
{
  den.aspects.networkdrives =
    { host, user, ... }:
    {
      nixos =
        { config, lib, pkgs, ... }:
        {
          services.rpcbind.enable = true;

          systemd.mounts =
            map
              (share: {
                type = "nfs";
                what = "${host.nasIp}:/volume1/${share}";
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

          systemd.tmpfiles.rules = map (share: "d '/synology/${share}' 0777 root root") [
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

          environment.systemPackages = with pkgs; [
            nfs-utils
            cifs-utils
          ];
        };

      homeManager =
        { config, ... }:
        {
          home.activation.setupSynologyKeys = config.lib.dag.entryAfter [ "writeBoundary" ] ''
            if [ ! -e ~/.ssh/id_ed25519 ] && [ -e /synology/Secure/id_ed25519 ]; then
              $DRY_RUN_CMD ln -sf /synology/Secure/id_ed25519 ~/.ssh/id_ed25519
              $DRY_RUN_CMD chmod 600 ~/.ssh/id_ed25519
              echo "Linked SSH private key from Synology"
            fi

            if [ ! -e ~/.ssh/id_ed25519.pub ] && [ -e /synology/Secure/id_ed25519.pub ]; then
              $DRY_RUN_CMD ln -sf /synology/Secure/id_ed25519.pub ~/.ssh/id_ed25519.pub
              echo "Linked SSH public key from Synology"
            fi
          '';
        };
    };
}

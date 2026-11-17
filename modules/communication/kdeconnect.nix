{ den, ... }:
{
  den.aspects.kdeconnect = {
    # sshfs needs non-root FUSE mounts for phone file browsing.
    nixos = {
      programs.fuse.enable = true;
    };

    homeManager =
      { pkgs, ... }:
      {
        # Pulls in kdeconnect-kde, which provides kdeconnectd and kdeconnect-cli.
        services.kdeconnect.enable = true;

        home.packages = with pkgs; [
          glib # gdbus, used by the Noctalia phone-connect plugin
          sshfs # optional: phone file browsing / SFTP
        ];
      };
  };
}

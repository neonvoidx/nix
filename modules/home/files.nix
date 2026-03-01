{ ... }:
{
  flake.modules.homeManager.files =
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

      home.file.".face".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/.face";
      home.file."scripts".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/scripts";
      home.file.".config/scopebuddy".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/scopebuddy";
      home.file.".config/startupscripts".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/startupscripts";

      home.file.".config/electron-flags.conf".text = ''
        --enable-features=UseOzonePlatform
        --ozone-platform=wayland
      '';
    };
}

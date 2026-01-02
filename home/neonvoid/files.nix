{ config, lib, ... }:
{
  # SSH keys from Synology
  # Get from synology mount if available and they dont already exist
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

  # Dotfiles not managed via home manager yet
  home.file.".face".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/linux/.face";
  home.file."scripts".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/linux/scripts";
  home.file.".config/scopebuddy".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/linux/scopebuddy";
  home.file.".config/startupscripts".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/linux/startupscripts";
  # Hyprland configuration files
  home.file.".config/hypr/xdph.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/linux/hypr/xdph.conf";
  home.file.".config/hypr/scripts".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/linux/hypr/scripts";
  home.file.".config/hypr/hyprland/monitors".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/linux/hypr/hyprland/monitors";
  # MangoHud
  home.file.".config/MangoHud".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/linux/MangoHud";
  # electron flags
  home.file.".config/electron-flags.conf".text = ''
    --enable-features=UseOzonePlatform
    --ozone-platform=wayland
  '';
}

{ config, ... }:
{
  # SSH keys from Synology (with fallback handling)
  home.activation.checkSynologyKeys = config.lib.dag.entryBefore [ "writeBoundary" ] ''
    if [ ! -e /synology/Secure/id_ed25519 ]; then
      $DRY_RUN_CMD echo "Warning: Synology not mounted, SSH keys will not be available"
    fi
  '';
  
  home.file.".ssh/id_ed25519" = {
    source = config.lib.file.mkOutOfStoreSymlink "/synology/Secure/id_ed25519";
    onChange = ''
      if [ -e ~/.ssh/id_ed25519 ]; then
        chmod 600 ~/.ssh/id_ed25519
      fi
    '';
  };
  home.file.".ssh/id_ed25519.pub".source =
    config.lib.file.mkOutOfStoreSymlink "/synology/Secure/id_ed25519.pub";

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
}

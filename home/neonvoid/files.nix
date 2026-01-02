{ config, ... }:
{
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

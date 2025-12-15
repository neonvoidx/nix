{ config, ... }:
{
  # Dotfiles not managed via home manager yet
  # TODO
  home.file.".face".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/.face";
  home.file."scripts".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/scripts";
  home.file.".config/scopebuddy".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/scopebuddy";
  home.file.".config/hypr/scripts".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/hypr/scripts";
}

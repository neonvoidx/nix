{ config, ... }:
{
  flake.modules.homeManager.stylix = { lib, ... }: {
    stylix.targets = {
      cava.rainbow.enable = true;
      firefox.enable = false;
      hyprland.enable = false;
      kitty.enable = false;
      neovim.enable = false;
      nixvim.enable = false;
      noctalia-shell.enable = false;
      obsidian.enable = false;
      yazi.enable = false;
      spicetify.enable = false;
      qt = {
        platform = lib.mkForce "gnome";
        standardDialogs = "xdgdesktopportal";
      };
    };
  };
}

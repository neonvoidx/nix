{
  username,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./dots
    inputs.spicetify-nix.homeManagerModules.default
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      BROWSER = "firefox";
      TERMINAL = "kitty";
    };
  };

  xresources.properties = {
    "Xcursor.size" = 24;
  };
  programs.bash = {
    enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
    cursorTheme = {
      name = "catppuccin-mocha-sapphire-cursors";
      package = pkgs.catppuccin-cursors.mochaSapphire;
    };
    font = {
      name = "Roboto Bold";
      size = 13;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  home.packages = with pkgs; [
    home-manager
    kitty
    kitty-themes
    github-copilot-cli
    gh
    proton-pass
    lazygit
    zoxide
    ffmpeg
    pay-respects
    tealdeer
    cmatrix
    fastfetch
    gamescope
    nodejs_24
    steam
    vulkan-tools
    yarn
  ];

  programs.home-manager.enable = true;
}

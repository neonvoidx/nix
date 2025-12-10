{ username, pkgs, inputs, ... }: {
  imports = [ ./dots inputs.spicetify-nix.homeManagerModules.default ];
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      BROWSER = "firefox-developer-edition";
      TERMINAL = "kitty";
    };
  };

  xresources.properties = { "Xcursor.size" = 24; };
  programs.git = { enable = true; };
  programs.bash = { enable = true; };

  home.packages = with pkgs; [
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
  ];

  programs.home-manager.enable = true;

}

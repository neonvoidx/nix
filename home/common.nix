{ username, pkgs, ... }: {
  imports = [ ./dots ];
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

  xdg = { enable = true; };

  home.packages = with pkgs; [ kitty proton-pass ];

  programs.home-manager.enable = true;

}

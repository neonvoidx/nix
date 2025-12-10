{ username, pkgs, ... }: {
  imports = [ ./dots ];
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };

  home.packages = with pkgs; [ kitty proton-pass ];

  programs.home-manager.enable = true;

}
